








package org.plazy.partners.fb {
	
	import com.facebook.graph.Facebook;
	import flash.utils.Dictionary;
	import org.plazy.BaseObject;
	import org.plazy.Err;
	
	public class FBProfilesManager extends BaseObject {
		
		public static const me:FBProfilesManager = new FBProfilesManager();
		
		private const MAX_PROFILES_PER_REQUEST:int = 200;
		
		private var cache:Dictionary = new Dictionary();  // key: uid(uint), value: DiVkProfileData
		private var uids_for_load:Vector.<String> = new Vector.<String>();
		private var requests_queue:Vector.<FBProfileRequest> = new Vector.<FBProfileRequest>();
		private var requests_active:Vector.<FBProfileRequest> = new Vector.<FBProfileRequest>();
		private var busy:Boolean;
		
		public function FBProfilesManager () {
			super();
			set_name(this);
			reset(true);
		}
		
		public function get_by_uid (_uid:String):FBProfileData { return cache[_uid]; }
		
		public function reset (_clean_up:Boolean):Boolean {
			CONFIG::LLOG { log('reset ' + _clean_up); }
			if (_clean_up) { for (var uid:* in cache) { delete cache[uid]; } }  // clear
			uids_for_load.splice(0, uids_for_load.length);  // clear
			while (requests_queue.length > 0) { requests_queue.shift().hr = null; }  // clear and unlink
			return true;
		}
		
		public function load (_req:FBProfileRequest):Boolean {
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
		
		public function cancel (_req:FBProfileRequest):Boolean {
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
			
			Facebook.fqlQuery('select uid, first_name, last_name, sex, pic from user where uid in (' + uids.join(',') + ')', api_hr);
			
			return true;
		}
		
		private function api_hr (_resp:Object, _fail:Object):Boolean {
			CONFIG::LLOG { log('api_hr ' + _resp + ' ' + _fail); }
			busy = false;
			
			if (_fail != null) { for (var fail_key:String in _fail) { log(' fail.' + fail_key + '=' + _fail[fail_key], 0x990000); } }
			
			/*
				[{"uid":100001204901410,"first_name":"Andrey","last_name":"Yakovlev","sex":"male","pic":"http:\/\/profile.ak.fbcdn.net\/hprofile-ak-ash3\/27420_100001204901410_2249_s.jpg"}]
			*/
			
			var list:Array = _resp as Array;
			if (list != null) {
				
				var user:FBProfileData;
				var users_list:Vector.<FBProfileData> = new Vector.<FBProfileData>();
				
				for each (var u:Object in list) {
					user               = new FBProfileData();
					user.id            = u['uid'];
					user.fname         = u['first_name'];
					user.lname         = u['last_name'];
					user.gender        = u['sex'] == 'female' ? 1 : 0;
					user.pic           = u['pic'];
					users_list.push(user);
				}
				
				for each (user in users_list) {
					cache[user.id] = user;
				}
				
			}
			
			// dispatch ready requests
			
			while (requests_active.length > 0) {
				var rr:FBProfileRequest = requests_active.shift();
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









