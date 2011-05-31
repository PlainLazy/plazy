








package org.plazy.partners.vkontakte.profiles {
	
	import org.plazy.BaseObject;
	import org.plazy.evs.Evs;
	import org.plazy.partners.vkontakte.ApiVkontakte;
	
	public class VkProfilesManager2 extends BaseObject {
		
		public static const EV_COMPLETE:String = 'complete';
		public const ev:Evs = new Evs();
		
		public static const me:VkProfilesManager2 = new VkProfilesManager2();
		private var cache:Object;  // key: uid(uint), value: DiVkProfileData
		private var in_progress:Boolean;
		
		public function VkProfilesManager2 () {
			set_name(this);
			super();
			reset();
		}
		
		public function get is_complete ():Boolean { return cache != null; }
		public function get_by_uid (_uid:uint):DiVkProfileData { return cache != null ? cache[_uid] : null; }
		public function get_all_as_vector ():Vector.<DiVkProfileData> {
			var l:Vector.<DiVkProfileData> = new Vector.<DiVkProfileData>();
			if (cache != null) { for each (var p:DiVkProfileData in cache) { l.push(p); } }
			return l;
		}
		
		public function reset ():Boolean {
			CONFIG::LLOG { log('reset') }
			ApiVkontakte.me.request_cancel(get_friends_complete_hr);
			cache = null;
			in_progress = false;
			return load();
		}
		
		public function load ():Boolean {
			CONFIG::LLOG { log('load'); }
			if (is_complete || in_progress) { return true; }
			in_progress = true;
			var p:Vector.<String> = new Vector.<String>();
			//p.push('uid=1720545');
			p.push('fields=uid,first_name,last_name,nickname,sex,photo,photo_medium,photo_big');
			p.push('name_case=nom');
			return ApiVkontakte.me.request_send(ApiVkontakte.METHOD_GET_FRIENDS_2, p, get_friends_err_hr, get_friends_complete_hr, false);
		}
		
		private function get_friends_err_hr (_code:int, _msg:String):Boolean {
			CONFIG::LLOG { log('get_friends_err_hr ' + _code + ' ' + _msg, 0xFF0000); }
			return error_def_hr('METHOD_GET_FRIENDS_2 failed: code=' + _code + ' msg="' + _msg + '"');
		}
		
		private function get_friends_complete_hr (_response:Object):Boolean {
			CONFIG::LLOG { log('get_friends_complete_hr'); }
			if (_response == null) { return error_def_hr('response null'); }
			
			//	{"response":[
			//	 {"uid":"1","first_name":"Павел","last_name":"Дуров","photo":"http:\/\/cs109.vkontakte.ru\/u00001\/c_df2abf56.jpg","online":"1","lists":[2,3]},
			//	 {"uid":"6492","first_name":"Andrew","last_name":"Rogozov","photo":"http:\/\/cs537.vkontakte.ru\/u06492\/c_28629f1d.jpg","online":"1"},{"uid":"35828305","first_name":"Виталий","last_name":"Лагунов","photo":"http:\/\/cs9917.vkontakte.ru\/u35828305\/c_e2117d04.jpg","online":"1","lists":[1]}
			//	]}
			
			cache = {};
			
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
				
				if (users_list.length > 0) {
					for each (user_di in users_list) { cache[user_di.uid] = user_di; }
				}
				
			}
			
			return ev.call(EV_COMPLETE);
		}
		
	}
	
}









