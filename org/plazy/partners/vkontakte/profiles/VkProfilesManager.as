








package org.plazy.partners.vkontakte.profiles {
	
	import flash.utils.Dictionary;
	import org.plazy.BaseObject;
	import org.plazy.Err;
	import org.plazy.partners.vkontakte.ApiVkontakte;
	import org.plazy.partners.vkontakte.profiles.DiVkProfileRequest;
	
	public class VkProfilesManager extends BaseObject {
		
		public static const me:VkProfilesManager = new VkProfilesManager();
		
		private const MAX_PROFILES_PER_REQUEST:int = 300;  // TODO: set 1000, 10 - its for test ;)
		
		private var cache:Dictionary = new Dictionary();  // key: uid(uint), value: DiVkProfileData
		private var uids_for_load:Vector.<uint> = new Vector.<uint>();
		private var requests_queue:Vector.<DiVkProfileRequest> = new Vector.<DiVkProfileRequest>();
		
		public function VkProfilesManager () {
			super();
			set_name(this);
			reset(true);
		}
		
		public function get_by_uid (_uid:uint):DiVkProfileData { return cache[_uid]; }
		
		public function reset (_clean_up:Boolean):Boolean {
			CONFIG::LLOG { log('reset ' + _clean_up); }
			if (_clean_up) { for (var uid:* in cache) { delete cache[uid]; } }  // clear
			uids_for_load.splice(0, uids_for_load.length);  // clear
			while (requests_queue.length > 0) { requests_queue.shift().on_done = null; }  // clear and unlink
			return true;
		}
		
		public function load (_req:DiVkProfileRequest):Boolean {
			CONFIG::LLOG { log('load ' + _req); }
			if (_req == null || _req.uids_list == null || _req.uids_list.length == 0 || _req.on_done == null) { return error_def_hr('invalid request'); }
			
			var put_to_queue:Boolean;
			for each (var uid:uint in _req.uids_list) {
				if (cache[uid] == null) {
					put_to_queue = true;
					if (uids_for_load.indexOf(uid) == -1) {
						uids_for_load.push(uid);
					}
				}
			}
			
			if (put_to_queue) {
				requests_queue.push(_req);
				return check_queue();
			}
			
			return _req.on_done();
		}
		
		public function cancel (_req:DiVkProfileRequest):Boolean {
			CONFIG::LLOG { log('cancel ' + _req); }
			for (var i:uint = 0; i < requests_queue.length; i++) {
				if (requests_queue[i] == _req) {
					requests_queue.splice(i, 1);
					return true;
				}
			}
			return true;
		}
		
		private function check_queue ():Boolean {
			CONFIG::LLOG { log('check_queue'); }
			
			if (uids_for_load == null || uids_for_load.length == 0) {
				CONFIG::LLOG { log(' nothing to load', 0x888888); }
				return true;
			}
			
			var uids:Vector.<uint> = uids_for_load.splice(0, MAX_PROFILES_PER_REQUEST);
			CONFIG::LLOG { log(' uids=[' + uids + ']', 0x888888); }
			
			var params:Vector.<String> = new Vector.<String>();
			params.push('uids=' + uids.join(','));
			params.push('fields=uid,first_name,last_name,nickname,sex,photo,photo_medium,photo_big');
			params.push('name_case=nom');
			
			return ApiVkontakte.me.request_send(ApiVkontakte.METHOD_GET_PROFILES, params, api_err_hr, api_complete_hr, false);
		}
		
		private function api_err_hr (_code:int, _msg:String):Boolean {
			CONFIG::LLOG { log('api_err_hr ' + _code + ' ' + _msg, 0xFF0000); }
			return check_queue();
		}
		
		private function api_complete_hr (_response:Object):Boolean {
			CONFIG::LLOG { log('api_complete_hr'); }
			if (_response == null) { return error_def_hr('response NULL'); }
			
			//	{
			//		"response": [
			//			{
			//				"uid": 1,
			//				"first_name": "FN1",
			//				"last_name": "LN1",
			//				"nickname": "Nick1",
			//				"photo_medium": "static/photos/photo4.jpg"
			//			},
			//			{
			//				"uid": 2,
			//				"first_name": "FN2",
			//				"last_name": "LN2",
			//				"nickname": "Nick2",
			//				"photo_medium": "static/photos/photo4.jpg"
			//			}
			//		]
			//	}
			
			var list:Array = _response as Array;
			if (list != null) {
				
				var user_di:DiVkProfileData;
				var users_list:Vector.<DiVkProfileData> = new Vector.<DiVkProfileData>();
				
				for each (var user:Object in list) {
					user_di               = new DiVkProfileData();
					user_di.uid           = user['uid'];
					user_di.first_name    = user['first_name'];
					user_di.last_name     = user['last_name'];
					user_di.nickname      = user['nickname'];
					user_di.sex           = user['sex'];
					user_di.photo         = user['photo'];
					user_di.photo_medium  = user['photo_medium'];
					user_di.photo_big     = user['photo_big'];
					users_list.push(user_di);
				}
				
				if (users_list.length == 0) { return error_def_hr('users_list is empty'); }
				
				for each (user_di in users_list) {
					cache[user_di.uid] = user_di;
				}
				
			}
			
			// dispatch ready requests
			
			for (var i:uint = 0; i < requests_queue.length; i++) {
				var req_di:DiVkProfileRequest = requests_queue[i];
				var req_ready:Boolean = true;
				for each (var req_uid:uint in req_di.uids_list) {
					if (cache[req_uid] == null) {
						req_ready = false;
						break;
					}
				}
				if (req_ready) {
					requests_queue.splice(i, 1);
					i--;
					if (!req_di.on_done()) { return false; }
				}
			}
			
			return check_queue();
		}
		
	}
	
}









