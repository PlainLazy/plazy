








package org.plazy.partners.ok {
	
	import api.com.odnoklassniki.sdk.users.Users;
	import flash.utils.Dictionary;
	import org.plazy.BaseObject;
	import org.plazy.Logger;
	
	public class OKProfilesManager extends BaseObject {
		
		public static const me:OKProfilesManager = new OKProfilesManager();
		
		private const MAX_PROFILES_PER_REQUEST:int = 100;
		
		private var cache:Dictionary = new Dictionary();  // key: uid(uint), value: DiVkProfileData
		private var uids_for_load:Vector.<String> = new Vector.<String>();
		private var requests_queue:Vector.<OKProfileRequest> = new Vector.<OKProfileRequest>();
		private var requests_active:Vector.<OKProfileRequest> = new Vector.<OKProfileRequest>();
		private var busy:Boolean;
		
		public function OKProfilesManager () {
			super();
			set_name(this);
			reset(true);
		}
		
		public function get_by_uid (_uid:String):OKProfileData { return cache[_uid]; }
		
		public function reset (_clean_up:Boolean):Boolean {
			CONFIG::LLOG { log('reset ' + _clean_up); }
			if (_clean_up) { for (var uid:* in cache) { delete cache[uid]; } }  // clear
			uids_for_load.splice(0, uids_for_load.length);  // clear
			while (requests_queue.length > 0) { requests_queue.shift().hr = null; }  // clear and unlink
			return true;
		}
		
		public function load (_req:OKProfileRequest):Boolean {
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
		
		public function cancel (_req:OKProfileRequest):Boolean {
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
			
			var uids1:Array = []; for each (var uid1:String in uids) { uids1.push(uid1); }
			//Users.getInfo(uids1, ['uid', 'first_name', 'last_name', 'name', 'gender', 'pic_1', 'pic_2', 'pic_3', 'pic_4', 'url_profile'], api_complete_hr);
			Users.getInfo(uids1, ['uid', 'first_name', 'last_name', 'name', 'gender', 'pic_1', 'pic_2', 'pic_3', 'pic_4', 'url_profile', 'location'], api_complete_hr);
			return true;
		}
		
		private function api_complete_hr (_list:Object):Boolean {
			CONFIG::LLOG { log('api_complete_hr'); }
			busy = false;
			
			/*
				[
					{"uid":"AAA","first_name":"First name","last_name":"Last name","gender":"male","location":{"country":"latvia","city":"Riga"},
					"current_location":{"latitude":45.0,"longitude":-45.0},"current_status":"My Status ","pic_1":"photo 1","pic_2":"photo 2"},
					{"uid":"BBB","first_name":"First name","last_name":"Last name"}
				]
			*/
			
			CONFIG::LLOG { log(' is_array = ' + (_list is Array)); }
			
			for (var k:String in _list) {
				CONFIG::LLOG { log(' ' + k + ' ' + _list[k], 0x888888); }
			}
			
			var list:Array = _list as Array;
			if (list != null) {
				
				var user:OKProfileData;
				var users_list:Vector.<OKProfileData> = new Vector.<OKProfileData>();
				
				for (var i:int = 0; i < list.length; i++) {
					var u:Object = list[i] as Object;
					if (u != null) {
						user               = new OKProfileData();
						user.uid           = u['uid'];
						user.first_name    = u['first_name'];
						user.last_name     = u['last_name'];
						user.name          = u['name'];
						user.gender        = u['gender'];
						user.pic_1         = u['pic_1'];
						user.pic_2         = u['pic_2'];
						user.pic_3         = u['pic_3'];
						user.pic_4         = u['pic_4'];
						user.url_profile   = u['url_profile'];
						
						var location:Object = u['location'];
						if (location != null) {
							user.city        = location['city'];
							user.country     = location['country'];
						}
						
						users_list.push(user);
					}
				}
				
				for each (user in users_list) {
					cache[user.uid] = user;
				}
				
			}
			
			// dispatch ready requests
			
			while (requests_active.length > 0) {
				var rr:OKProfileRequest = requests_active.shift();
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









