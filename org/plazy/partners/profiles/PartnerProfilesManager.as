








package org.plazy.partners.profiles {
	
	import org.plazy.Err;
	import org.plazy.Logger;
	import org.plazy.BaseObject;
	import org.plazy.partners.ijet.IJetAPI;
	import org.plazy.partners.vkontakte.ApiVkontakte;
	
	public class PartnerProfilesManager extends BaseObject {
		
		public static const me:PartnerProfilesManager = new PartnerProfilesManager();
		
		public static const MD_VK:int = 1;
		public static const MD_IJ:int = 2;
		
		private const MAX_PROFILES_PER_REQUEST:int = 200;  // TODO: set 1000, 10 - its for test ;)
		
		public var mode:int;
		private var cache:Object;  // key: id(String), value: DtProfile
		private var job:Vector.<String>;
		private var cur_req:DtProfileRequest;
		private var queue:Vector.<DtProfileRequest>;
		
		public function PartnerProfilesManager () {
			super();
			set_name(this);
			reset(true);
		}
		
		public function get_by_id (_id:String):DtProfile {
			//CONFIG::LLOG { Logger.me.add(' ||| get_by_id(' + _id + ') = ' + (cache != null ? cache[_id] : '!cahe_is_null')); }
			if (cache == null) { return null; }
			return cache[_id];
		}
		
		public function reset (_clean_up:Boolean):Boolean {
			CONFIG::LLOG { log('reset ' + _clean_up); }
			if (_clean_up) { cache = {}; }
			if (queue != null) {
				for each (var req:DtProfileRequest in queue) { req.hr = null; }
			}
			queue = new Vector.<DtProfileRequest>();
			if (cur_req != null) {
				cur_req.hr = null;
				cur_req = null;
			}
			if (mode == MD_VK) {
				ApiVkontakte.me.request_cancel(vk_complete_hr);
			} else if (mode == MD_IJ) {
				IJetAPI.me.cancel(ijet_complete_hr);
			}
			return true;
		}
		
		public function job_add (_id:String):void {
			if (cache[_id] != null) { return; }  // already in cache
			if (job == null) { job = new Vector.<String>(); }
			if (job.indexOf(_id) == -1) { job.push(_id); }  // push to job
		}
		
		public function job_exists ():Boolean {
			return job != null && job.length > 0;
		}
		
		public function job_do (_hr:Function):Boolean {
			if (job == null || job.length == 0) { return _hr(); }
			var req:DtProfileRequest = new DtProfileRequest();
			req.ids = job.concat();
			req.hr = _hr;
			queue.push(req);
			return check_queue(false);
		}
		
		public function cancel (_hr:Function):void {
			if (queue != null && queue.length > 0) {
				for (var i:int = 0; i < queue.length; i++) {
					if (queue[i].hr == _hr) {
						queue.splice(i, 1);
						break;
					}
				}
			}
			if (cur_req != null && cur_req.hr == _hr) {
				cur_req.hr = null;
				cur_req = null;
				check_queue(false);
			}
		}
		
		private function check_queue (_continue:Boolean):Boolean {
			CONFIG::LLOG { log('check_queue ' + _continue); }
			
			if (cur_req == null) {
				if (queue == null || queue.length == 0) { return true; }
				cur_req = queue.shift();
			} else {
				if (!_continue) { return true; }
			}
			
			if (cache != null) {
				for (var i:int = 0; i < cur_req.ids.length; i++) {
					if (cache[cur_req.ids[i]] != null) {
						cur_req.ids.splice(i, 1);
						i--;
					}
				}
				if (cur_req.ids.length == 0) {
					return done();
				}
			}
			
			var actual_ids:Vector.<String> = cur_req.ids.splice(0, MAX_PROFILES_PER_REQUEST);
			CONFIG::LLOG { log(' actual_ids=' + actual_ids, 0x888888); }
			
			switch (mode) {
				case MD_VK: {
					var params:Vector.<String> = new Vector.<String>();
					params.push('uids=' + actual_ids.join(','));
					params.push('fields=uid,first_name,last_name,nickname,sex,photo,photo_medium,photo_big');
					params.push('name_case=nom');
					//return ApiVkontakte.me.request_send(ApiVkontakte.METHOD_GET_PROFILES, params, vk_err_hr, vk_complete_hr, false);
					return ApiVkontakte.me.request_send(ApiVkontakte.METHOD_USERS_GET, params, vk_err_hr, vk_complete_hr, false);
				}
				case MD_IJ: {
					return IJetAPI.me.send(IJetAPI.CMD_GET_USERS_PROFILES, {'ids': actual_ids.join(',')}, ijet_complete_hr, true);
				}
			}
			
			return error_def_hr('unhandled mode (' + mode + ') for send profiles request');
		}
		
		private function vk_err_hr (_code:int, _msg:String):Boolean {
			CONFIG::LLOG { log('vk_err_hr ' + _code + ' ' + _msg, 0x990000); }
			return check_queue(true);
		}
		
		private function vk_complete_hr (_response:Object):Boolean {
			CONFIG::LLOG { log('vk_complete_hr'); }
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
				var users_list:Vector.<DtProfile> = new Vector.<DtProfile>();
				for each (var user:Object in list) {
					var user1:DtProfile = new DtProfile();
					user1.id = user['uid'];
					user1.nick = user['nickname'];
					user1.photo = user['photo_medium'];
					users_list.push(user1);
				}
				for each (var user2:DtProfile in users_list) {
					cache[user2.id] = user2;
				}
			}
			
			return cur_req.ids.length == 0 ? done() : check_queue(true);
		}
		
		private function ijet_complete_hr (_result:Object):Boolean {
			CONFIG::LLOG { log('ijet_complete_hr'); }
			
			//
			//	Response
			//	Array of user profile information is an object containing following properties:
			//
			//	id : String – unique user id in social network.
			//	name : String – user name in social network.
			//	sex: String – user sex. May take the following values:
			//	0 - no information;
			//	1 - male;
			//	2 - female;
			//	city: String – user city.
			//	birthDate: Date– user birth date.
			//	url: String – user profile URL.
			//	photoSmall: String – small size user photo URL.
			//	photoMedium: String – medium size user photo URL.
			//	photoBig: String – big size user photo URL.
			//
			
			var list1:Array = _result as Array;
			if (list1 != null) {
				var list2:Vector.<DtProfile> = new Vector.<DtProfile>();
				for each (var user1:Object in list1) {
					var user2:DtProfile = new DtProfile();
					user2.id = user1['id'];
					user2.nick = user1['nick'];
					user2.photo = user1['photoMedium'];
					list2.push(user2);
				}
				for each (var user3:DtProfile in list2) {
					cache[user3.id] = user3;
					//CONFIG::LLOG { Logger.me.add(' ||| put cache[' + user3.id + ']=' + cache[user3.id], 0x990099); }
				}
			}
			
			return cur_req.ids.length == 0 ? done() : check_queue(true);
		}
		
		private function done ():Boolean {
			CONFIG::LLOG { log('done'); }
			if (cur_req == null) { true; }
			var hr:Function = cur_req.hr;
			cur_req.hr = null;
			cur_req = null;
			if (!hr()) { return false; }
			return check_queue(false);
		}
		
	}
	
}









