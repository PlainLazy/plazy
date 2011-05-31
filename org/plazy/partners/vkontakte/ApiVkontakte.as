








package org.plazy.partners.vkontakte {
	
	import org.plazy.Err;
	import org.plazy.Omni;
	import org.plazy.Locker;
	import org.plazy.FlashVars;
	import org.plazy.BaseObject;
	import org.plazy.hc.HCTiker;
	import org.plazy.hc.HCFramer;
	import org.plazy.utils.Nums;
	import org.plazy.utils.StringUtils;
	import org.plazy.utils.io.LoaderData;
	import org.plazy.partners.vkontakte.profiles.VkProfilesManager;
	
	import com.adobe.crypto.MD5;
	import com.adobe.serialization.json.JSON;
	
	CONFIG::LLOG { import org.plazy.Logger; }
	
	public class ApiVkontakte extends BaseObject {
		
		public static const me:ApiVkontakte = new ApiVkontakte();
		
		public static const METHOD_GET_PROFILES:String                     = 'getProfiles';
		public static const METHOD_GET_FRIENDS:String                      = 'getFriends';     // depricated
		public static const METHOD_GET_APP_FRIENDS:String                  = 'getAppFriends';  // depricated
		public static const METHOD_GET_GROUPS:String                       = 'getGroups';
		
		public static const METHOD_GET_FRIENDS_2:String                    = 'friends.get';          // new
		public static const METHOD_GET_APP_FRIENDS_2:String                = 'friends.getAppUsers';  // new
		
		public static const METHOD_GET_USER_SETTINGS:String                = 'getUserSettings';
		public static const METHOD_GET_USER_BALANCE:String                 = 'getUserBalance';
		public static const METHOD_WALL_GET_GET_PHOTO_UPLOAD_SERVER:String = 'wall.getPhotoUploadServer';
		public static const METHOD_WALL_SAVE_POST:String                   = 'wall.savePost';
		public static const METHOD_GET_ADS:String                          = 'getAds';
		
		//	+1	Пользователь разрешил отправлять ему уведомления.
		//	+2	Доступ к друзьям.
		//	+4	Доступ к фотографиям.
		//	+8	Доступ к аудиозаписям.
		//	+16	Доступ к видеозаписям.
		//	+32	Доступ к предложениям.
		//	+64	Доступ к вопросам.
		//	+128	Доступ к wiki-страницам.
		//	+256	Добавление ссылки на приложение в меню слева.
		//	+512	Добавление ссылки на приложение для быстрой публикации на стенах пользователей.
		//	+1024	Доступ к статусам пользователя.
		//	+2048	Доступ заметкам пользователя.
		//	+4096	(для Desktop-приложений) Доступ к расширенным методам работы с сообщениями.
		//	+8192	(для Desktop-приложений) Доступ к расширенным методам работы со стеной.
		
		public static const USER_SETTING_NOTICE:uint              = 0x0001;
		public static const USER_SETTING_FRIENDS:uint             = 0x0002;
		public static const USER_SETTING_PHOTOS:uint              = 0x0004;
		public static const USER_SETTING_AUDIOS:uint              = 0x0008;
		public static const USER_SETTING_VIDEOS:uint              = 0x0010;
		public static const USER_SETTING_OFFERS:uint              = 0x0020;
		public static const USER_SETTING_QUESTIONS:uint           = 0x0040;
		public static const USER_SETTING_WIKI_PAGES:uint          = 0x0080;
		public static const USER_SETTING_APP_LINK_MENU:uint       = 0x0100;
		public static const USER_SETTING_APP_LINK_POST_WALL:uint  = 0x0200;
		public static const USER_SETTING_STATUS:uint              = 0x0400;
		public static const USER_SETTING_NOTES:uint               = 0x0800;
		
		private const RESTRICTION_REQUESTS_IN_SEQUENCE:int   = 3;
		private const RESTRICTION_TIME_FOR_SEQUESNCE_MS:int  = 1600;
		
		public var app_data:DiApplicationData;
		public var user_data:DiUserData;
		
		private var requests_queue:Vector.<DiReqest>;
		private var current_request:DiReqest;
		private var ldr:LoaderData;
		private var requests_log:Vector.<Number>;
		private var tiker:HCTiker;
		private var framer:HCFramer;
		
		public function ApiVkontakte () {
			set_name(this);
			super();
		}
		
		public function init ():Boolean {
			CONFIG::LLOG { log('init'); }
			app_data = new DiApplicationData();
			app_data.update();
			user_data = new DiUserData();
			VkProfilesManager.me.onError = profile_manager_err_hr;
			reset();
			return true;
		}
		
//		public override function kill ():void {
//			CONFIG::LLOG { log('kill'); }
//			super.kill();
//		}
		
		public function votes (_votes:uint):String {
			return Nums.tt_val(_votes, null, 'голос', 'голоса', 'голосов');
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
			
			if (requests_log == null) { requests_log = new Vector.<Number>(); }
			if (tiker != null) { tiker.kill(); tiker = null; }
			if (framer != null) { framer.kill(); }
			framer = new HCFramer();
		}
		
		public function handler_in_progress (_hr:Function):Boolean {
			if (requests_queue != null) {
				var request_di:DiReqest;
				var request_index:uint;
				for (request_index = 0; request_index < requests_queue.length; request_index++) {
					request_di = requests_queue[request_index];
					if (request_di.on_comlete == _hr) {
						return true;
					}
				}
			}
			return false;
		}
		
		public function request_send (_method:String, _params:Vector.<String>, _on_error:Function, _on_complete:Function, _lock:Boolean):Boolean {
			CONFIG::LLOG { log('request_send ' + _method + ' ' + _params); }
			
			if (requests_queue == null || framer == null) { return error_def_hr('invalid state for send request'); }
			
			var new_request_di:DiReqest = new DiReqest();
			new_request_di.method      = _method;
			new_request_di.params      = _params != null ? _params : new Vector.<String>();
			new_request_di.on_error    = _on_error;
			new_request_di.on_comlete  = _on_complete;
			new_request_di.lock        = _lock;
			
			requests_queue.push(new_request_di);
			framer.set_frame(check_queue);
			
			return true;
		}
		
		public function request_cancel (_hr:Function):void {
			CONFIG::LLOG { log('request_cancel ' + _hr); }
			
			if (current_request != null && current_request.on_comlete == _hr) {
				current_request.cancelled = true;
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
			
			if (tiker != null) { return true; } // delaying in progress
			
			if (requests_log.length >= RESTRICTION_REQUESTS_IN_SEQUENCE) {
				var d:Date = new Date();
				var dt:int = d.getTime() - requests_log[0];
				//log(' dt=' + dt, 0x990000);
				if (dt < RESTRICTION_TIME_FOR_SEQUESNCE_MS) {
					//log(' delay=' + (RESTRICTION_TIME_FOR_SEQUESNCE_MS - dt), 0x990000);
					tiker = new HCTiker();
					tiker.set_tik(tik_hr, RESTRICTION_TIME_FOR_SEQUESNCE_MS - dt, 1);
					return true;
				}
			}
			
			if (current_request != null) { return true; } // some request in progress
			if (requests_queue.length == 0) { return true; } // no requests in queue
			
			current_request = requests_queue.shift();
			
			if (current_request.lock) { Locker.me.active = true; }
			
			var params_list:Vector.<String> = current_request.params.concat();
			params_list.push('api_id=' + app_data.api_id);
			params_list.push('v=3.0');
			params_list.push('method=' + current_request.method);
			params_list.push('format=JSON');
			params_list.sort(hf_params_sorter);
			
			CONFIG::LLOG { log('sig=MD5.hash(' + app_data.viewer_id + ' + ' + params_list.join('') + ' + ' + app_data.secret + ')', 0x888888); }
			
			params_list.push('sig=' + MD5.hash(app_data.viewer_id + params_list.join('') + app_data.secret));
			params_list.push('sid=' + app_data.sid);
			
			var params_hash:Object = {};
			var param_value:String;
			var param_pair:Array;
			for each (param_value in params_list) {
				param_pair = param_value.split('=', 2);
				if (param_pair.length != 2) { return error_def_hr('invalid param "' + param_value + '"'); }
				params_hash[param_pair[0]] = param_pair[1];
			}
			
			return ldr.load(app_data.api_url, 'GET', params_hash);
		}
		
		private function hf_params_sorter (_a:String, _b:String):int {
			return _a > _b ? 1 : (_a < _b ? -1 : 0);
		}
		
		private function tik_hr ():void {
			CONFIG::LLOG { log('tik_hr'); }
			tiker.kill();
			tiker = null;
			check_queue();
		}
		
		private function ldr_error_hr (_err:String):Boolean {
			CONFIG::LLOG { log('ldr_error_hr "' + _err + '"', 0x990000); }
			if (current_request != null && current_request.lock) { Locker.me.active = false; }
			current_request.clr();
			current_request = null;
			return error_def_hr('ldr error: ' + _err);
		}
		
		private function ldr_complete_hr ():Boolean {
			CONFIG::LLOG { log('ldr_complete_hr', 0x009900); }
			if (current_request != null && current_request.lock) { Locker.me.active = false; }
			
			var loaded_data:String = ldr.get_data();
			CONFIG::LLOG { log('loaded_data: ' + Logger.me.quote(loaded_data), 0x888888); }
			
			if (current_request == null) { return error_def_hr('unwaited ldr data'); }
			
			var d:Date = new Date();
			requests_log.push(d.getTime());
			
			while (requests_log.length > 0 && requests_log.length > RESTRICTION_REQUESTS_IN_SEQUENCE) {
				requests_log.shift();
			}
			//log(' requests_log=[' + requests_log + ']', 0x990000);
			
			if (current_request.cancelled) {
				CONFIG::LLOG { log(' cencelled', 0x888888); }
				current_request.clr();
				current_request = null;
				return check_queue();
			}
			
			var current_error_hr:Function = current_request.on_error;
			var current_complete_hr:Function = current_request.on_comlete;
			
			current_request.clr();
			current_request = null;
			
			var obj:Object;
			try { obj = JSON.decode(loaded_data); }
			catch (e:Error) { return error_def_hr('invalid api JSON format: ' + StringUtils.html_safe(String(e))); }
			if (obj['error'] != null) {
				if (!current_error_hr(int(obj['error']['error_code']), String(obj['error']['error_msg']))) { return true; }
				return check_queue();
			}
			if (obj['response'] != null) {
				if (!current_complete_hr(obj['response'])) { return false; }
				return check_queue();
			}
			return error_def_hr('invalid response content');
			
		}
		
		private function profile_manager_err_hr (_t:String):void {
			CONFIG::LLOG { log('profile_manager_err_hr "' + _t + '"', 0xFF0000); }
			error_def_hr('profile_manager error: ' + _t);
		}
		
	}
	
}









