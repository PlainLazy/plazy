








package org.plazy.partners.mailru {
	
	import org.plazy.Err;
	import org.plazy.Locker;
	import org.plazy.Logger;
	import org.plazy.FlashVars;
	import org.plazy.BaseObject;
	import org.plazy.hc.HCFramer;
	import org.plazy.utils.io.LoaderData;
	
	import com.adobe.crypto.MD5;
	import com.adobe.serialization.json.JSON;
	
	public class ApiMailRu extends BaseObject {
		
		public static const me:ApiMailRu = new ApiMailRu();
		
		public static const METHOD_USERS_GET_INFO:String         = 'users.getInfo';
		public static const METHOD_FRIENDS_GET_APP_USERS:String  = 'friends.getAppUsers';
		public static const METHOD_PAYMENTS_OPEN_DIALOG:String   = 'payments.openDialog';
		public static const METHOD_STREAM_POST:String            = 'stream.post';
		
		public var app_data:DiApplicationData;
		public var user_data:DiUserData;
		
		private var last_request_id:uint;
		private var requests_queue:Vector.<DiReqest>;
		private var current_request:DiReqest;
		private var ldr:LoaderData;
		private var framer:HCFramer;
		
		public function ApiMailRu () {
			CONFIG::LLOG { log('new') }
			set_name(this);
			super();
		}
		
		public function init ():Boolean {
			CONFIG::LLOG { log('init') }
			
			app_data = new DiApplicationData();
			app_data.update();
			
			user_data = new DiUserData();
			
			reset();
			
			return true;
		}
		
		public function reset ():void {
			CONFIG::LLOG { log('reset') }
			
			if (requests_queue != null) {
				var request_di:DiReqest;
				for each (request_di in requests_queue) {
					request_di.clr();
				}
			}
			requests_queue = new Vector.<DiReqest>();
			
			if (current_request != null) { current_request.clr(); current_request = null; }
			
			if (ldr != null) { ldr.kill(); }
			
			ldr = new LoaderData();
			ldr.set_timeout(10000);
			ldr.onError     = ldr_error_hr;
			ldr.onComplete  = ldr_complete_hr;
			
			if (framer != null) { framer.kill(); }
			
			framer = new HCFramer();
			
		}
		
		public function request_send (_method:String, _params:Vector.<String>, _on_error:Function, _on_complete:Function, _lock:Boolean):Boolean {
			CONFIG::LLOG { log('request_send ' + _method + ' ' + _params) }
			if (requests_queue == null || framer == null) { return error_def_hr('invalid state for send request'); }
			
			var new_request_di:DiReqest = new DiReqest();
			new_request_di.method      = _method;
			new_request_di.params      = _params;
			new_request_di.on_error    = _on_error;
			new_request_di.on_comlete  = _on_complete;
			new_request_di.lock        = _lock;
			
			requests_queue.push(new_request_di);
			framer.set_frame(check_queue);
			
			return true;
		}
		
		public function request_cancel (_hr:Function):void {
			CONFIG::LLOG { log('request_cancel') }
			
			if (current_request != null && current_request.on_comlete == _hr) {
				current_request.clr();
				current_request = null;
				check_queue();
				return;
			}
			
			if (requests_queue != null) {
				var request_di:DiReqest;
				var request_index:uint;
				for (request_index = 0; request_index < requests_queue.length; request_index++) {
					request_di = requests_queue[request_index];
					if (request_di.on_comlete == _hr) {
						request_di.clr();
						requests_queue.splice(request_index, 1);
						return;
					}
				}
			}
			
		}
		
		private function check_queue ():Boolean {
			
			framer.rem_frame();
			
			if (current_request != null) {
				// some request in progress
				return true;
			}
			
			if (requests_queue.length == 0) {
				// no requests in queue
				return true;
			}
			
			current_request = requests_queue.shift();
			
			if (current_request.lock) {
				Locker.me.active = true;
			}
			
			var params_list:Vector.<String> = current_request.params.concat();
			params_list.push('method=' + current_request.method);
			params_list.push('app_id=' + app_data.app_id);
			params_list.push('session_key=' + app_data.session_key);
			params_list.sort(hf_params_sorter);
			
			//log('md5(' + app_data.vid.toString() + '|||' + params_list.join('') + '|||' + app_data.secret_key + ')', 0x990000);
			params_list.push('sig=' + MD5.hash(app_data.vid + params_list.join('') + app_data.secret_key));
			
			var params_hash:Object = {};
			var param_value:String;
			var param_pair:Array;
			for each (param_value in params_list) {
				param_pair = param_value.split('=', 2);
				if (param_pair.length != 2) {
					return error_def_hr('invalid param "' + param_value + '"');
				}
				params_hash[param_pair[0]] = param_pair[1];
			}
			
			return ldr.load(app_data.api_uri, 'GET', params_hash);
		}
		
		private function hf_params_sorter (_a:String, _b:String):int {
			return _a > _b ? 1 : (_a < _b ? -1 : 0);
		}
		
		private function ldr_error_hr (_err:String):void {
			CONFIG::LLOG { log('ldr_error_hr "' + _err + '"') }
			
			if (current_request != null && current_request.lock) {
				Locker.me.active = false;
			}
			
			error_def_hr('ldr error: ' + _err);
		}
		
		private function ldr_complete_hr ():Boolean {
			CONFIG::LLOG { log('ldr_complete_hr', 0x009900) }
			
			if (current_request != null && current_request.lock) {
				Locker.me.active = false;
			}
			
			var loaded_data:String = ldr.get_data();
			if (loaded_data == null) { return error_def_hr('loaded data is null'); }
			
			log(' loaded_data: ' + Logger.me.quote(loaded_data), 0x888888);
			
			if (current_request == null) { return error_def_hr('current_request is null, unwaited ldr data'); }
			
			var dat:Object;
			try { dat = com.adobe.serialization.json.JSON.decode(loaded_data); }
			catch (e:Error) { return error_def_hr('JSON decode failed: ' + e); }
			
			var current_error_hr:Function = current_request.on_error;
			var current_complete_hr:Function = current_request.on_comlete;
			
			current_request.clr();
			current_request = null;
			
			// {"error":{"error_msg":"One of the parameters specified is missing or invalid.","error_code":100}}
			
			var dat_error:Object = dat['error'];
			
			if (dat_error != null) {
				if (!current_error_hr(int(not_null(dat_error['error_code'], '0')), not_null(dat_error['error_msg'], 'NULL'))) { return false; }
			} else {
				if (!current_complete_hr(dat)) { return false; }
			}
			
			return check_queue();
		}
		
		private function not_null (_value:String, _not_null_value:String):String {
			return (_value != null) ? _value : _not_null_value;
		}
		
	}
	
}









