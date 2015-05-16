








package org.plazy.partners.mailru {
	
	import flash.utils.Dictionary;
	import org.plazy.BaseObject;
	import org.plazy.Err;
	import org.plazy.partners.mailru.ApiMailRu;
	
	public class MMProfilesManager extends BaseObject {
		
		public static const me:MMProfilesManager = new MMProfilesManager();
		
		private const MAX_PROFILES_PER_REQUEST:int = 200;
		
		private var cache:Dictionary = new Dictionary();  // key: uid(uint), value: DiVkProfileData
		private var uids_for_load:Vector.<String> = new Vector.<String>();
		private var requests_queue:Vector.<MMProfileRequest> = new Vector.<MMProfileRequest>();
		private var requests_active:Vector.<MMProfileRequest> = new Vector.<MMProfileRequest>();
		private var busy:Boolean;
		
		public function MMProfilesManager () {
			super();
			set_name(this);
			reset(true);
		}
		
		public function get_by_uid (_uid:String):MMProfileData { return cache[_uid]; }
		
		public function reset (_clean_up:Boolean):Boolean {
			CONFIG::LLOG { log('reset ' + _clean_up); }
			if (_clean_up) { for (var uid:* in cache) { delete cache[uid]; } }  // clear
			uids_for_load.splice(0, uids_for_load.length);  // clear
			while (requests_queue.length > 0) { requests_queue.shift().hr = null; }  // clear and unlink
			return true;
		}
		
		public function load (_req:MMProfileRequest):Boolean {
			CONFIG::LLOG { log('load ' + _req); }
			if (_req == null) { return true; }
			
			var have_new_uids:Boolean;
			if (_req.uids != null) {
				for each (var uid:String in _req.uids) {
					if (uid != null && uid.length < 1) {
						CONFIG::LLOG { log('warn: wrong uid', 0x990000); }
						continue;
					}
					if (cache[uid] == null) {
						have_new_uids = true;
						if (uids_for_load.indexOf(uid) == -1) {
							uids_for_load.push(uid);
						}
					}
				}
			}
			
			if (have_new_uids) {
				requests_queue.push(_req);
				return check_queue();
			}
			
			return _req.hr != null ? _req.hr() : true;
		}
		
		public function cancel (_req:MMProfileRequest):Boolean {
			CONFIG::LLOG { log('cancel ' + _req); }
			for (var i:uint = 0; i < requests_queue.length; i++) {
				if (requests_queue[i] == _req) {
					requests_queue[i].hr = null;
					requests_queue.splice(i, 1);
					return true;
				}
			}
			for (var k:uint = 0; k < requests_active.length; k++) {
				if (requests_active[k] == _req) {
					requests_active[k].hr = null;
					requests_active.splice(k, 1);
					return true;
				}
			}
			return true;
		}
		
		private function check_queue ():Boolean {
			CONFIG::LLOG { log('check_queue'); }
			
			if (busy) {
				CONFIG::LLOG { log(' busy', 0x888888); }
				return true;
			}
			
			if (uids_for_load == null || uids_for_load.length == 0) {
				CONFIG::LLOG { log(' nothing to load', 0x888888); }
				return true;
			}
			
			// move all request from queue to active
			while (requests_queue.length > 0) { requests_active.push(requests_queue.shift()); }
			
			var uids:Vector.<String> = uids_for_load.splice(0, MAX_PROFILES_PER_REQUEST);
			CONFIG::LLOG { log(' uids=[' + uids + ']', 0x888888); }
			
			busy = true;
			
			var params:Vector.<String> = new Vector.<String>();
			params.push('uids=' + uids.join(','));
			
			return ApiMailRu.me.request_send(ApiMailRu.METHOD_USERS_GET_INFO, params, api_err_hr, api_complete_hr, false);
		}
		
		private function api_err_hr (_code:int, _msg:String):Boolean {
			CONFIG::LLOG { log('api_err_hr ' + _code + ' ' + _msg, 0xFF0000); }
			busy = false;
			return check_queue();
		}
		
		private function api_complete_hr (_dat:Object):Boolean {
			CONFIG::LLOG { log('api_complete_hr'); }
			busy = false;
			
			/*
				[
						{
								"uid": "15410773191172635989",
								"first_name": "Евгений",
								"last_name": "Маслов",
								"nick": "maslov",
								"sex": 0,
								"birthday": "15.02.1980",
								"pic": "http://avt.appsmail.ru/mail/emaslov/_avatar",
								"pic_small": "http://avt.appsmail.ru/mail/emaslov/_avatarsmall",
								"pic_big": "http://avt.appsmail.ru/mail/emaslov/_avatarbig",
								"link": "http://my.mail.ru/mail/emaslov/",
								"referer_type": "",
								"referer_id": "",
								"is_online": 1,
								"location": {
										"country": {
												"name": "Россия",
												"id": "24"
										},
										"city": {
												"name": "Москва",
												"id": "25"
										},
										"region": {
												"name": "Москва",
												"id": "999999"
										}
								}
						},
						{
								"uid": "11425330190814458227",
								"first_name": "Наташа",
								"last_name": "Ласточкина",
								"nick": "lastochka",
								"sex": 1,
								"birthday": "21.10.1989",
								"pic": "http://avt.appsmail.ru/mail/natashka/_avatar",
								"pic_small": "http://avt.appsmail.ru/mail/emaslov/_avatarsmall",
								"pic_big": "http://avt.appsmail.ru/mail/emaslov/_avatarbig",
								"link": "http://my.mail.ru/mail/natashka/",
								"referer_type": "",
								"referer_id": "",
								"is_online": 0,
								"location": {
										"country": {
												"name": "Россия",
												"id": "24" 
										},
										"city": {
												"name": "Жуковский",
												"id": "1719" 
										},
										"region": {
												"name": "Московская обл.",
												"id": "293" 
										} 
								}
						} 
				]
			*/
			
			var list:Array = _dat as Array;
			if (list != null) {
				
				var user:MMProfileData;
				var users_list:Vector.<MMProfileData> = new Vector.<MMProfileData>();
				
				for each (var u:Object in list) {
					user               = new MMProfileData();
					user.uid           = u['uid'];
					user.fname         = u['first_name'];
					user.lname         = u['last_name'];
					user.nick          = u['nick'];
					user.sex           = int(u['sex']);
					user.ava           = u['pic'];
					user.ava_45px      = u['pic_small'];
					user.ava_600px     = u['pic_big'];
					user.link          = u['link'];
					if (u['location'] != null) {
						user.city          = u['location']['city'] != null ? u['location']['city']['name'] : null;
						user.country       = u['location']['country'] != null ? u['location']['country']['name'] : null;
					}
					users_list.push(user);
				}
				
				for each (user in users_list) {
					cache[user.uid] = user;
				}
				
			}
			
			// dispatch ready requests
			
			while (requests_active.length > 0) {
				var rr:MMProfileRequest = requests_active.shift();
				if (rr.hr != null) {
					CONFIG::LLOG { log(' dispatch ready to ' + rr, 0x888888); }
					var f:Function = rr.hr;
					rr.hr = null;
					if (!f()) { return false; }
				}
			}
			
			return check_queue();
		}
		
	}
	
}









