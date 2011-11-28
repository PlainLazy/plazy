








package org.plazy.partners.profiles {
	
	import org.plazy.BaseObject;
	import org.plazy.evs.Evs;
	import org.plazy.partners.ijet.IJetAPI;
	import org.plazy.partners.vkontakte.ApiVkontakte;
	
	public class PartnerAllFriendsProfilesManager extends BaseObject {
		
		// singleton
		
		public static const me:PartnerAllFriendsProfilesManager = new PartnerAllFriendsProfilesManager();
		
		// const
		
		public static const MD_VK:int = 1;
		public static const MD_IJ:int = 2;
		
		// events
		
		public static const EV_COMPLETE:String = 'complete';
		public const ev:Evs = new Evs();
		
		// vars
		
		public var mode:int;
		private var cache:Object;  // key: id(String), value: DtProfile
		private var in_progress:Boolean;
		
		public function PartnerAllFriendsProfilesManager () {
			set_name(this);
			super();
			reset();
		}
		
		public function get is_complete ():Boolean { return cache != null; }
		public function get_by_id (_id:String):DtProfile { return cache != null ? cache[_id] : null; }
		public function get_all_as_vector ():Vector.<DtProfile> {
			var l:Vector.<DtProfile> = new Vector.<DtProfile>();
			if (cache != null) { for each (var p:DtProfile in cache) { l.push(p); } }
			return l;
		}
		
		public function reset ():Boolean {
			CONFIG::LLOG { log('reset') }
			if (mode == MD_VK) {
				ApiVkontakte.me.request_cancel(vk_complete_hr);
			} else if (mode == MD_IJ) {
				IJetAPI.me.cancel(ijet_complete_hr);
			}
			cache = null;
			in_progress = false;
			//return mode == 0 ? true : load();
			return true;
		}
		
		public function load ():Boolean {
			CONFIG::LLOG { log('load'); }
			if (is_complete || in_progress) { return true; }
			in_progress = true;
			if (mode == MD_VK) {
				var p:Vector.<String> = new Vector.<String>();
				p.push('fields=uid,first_name,last_name,nickname,photo_medium');
				p.push('name_case=nom');
				return ApiVkontakte.me.request_send(ApiVkontakte.METHOD_GET_FRIENDS_2, p, vk_err_hr, vk_complete_hr, false);
			} else if (mode == MD_IJ) {
				return IJetAPI.me.send(IJetAPI.CMD_GET_ALL_FRIENDS, {}, ijet_complete_hr, false);
			}
			return error_def_hr('unhandled mode (' + mode + ') for get_all_friends request');
		}
		
		private function vk_err_hr (_code:int, _msg:String):Boolean {
			CONFIG::LLOG { log('vk_err_hr ' + _code + ' ' + _msg, 0xFF0000); }
			if (_code == 7) {
				CONFIG::LLOG { log('no access for friends', 0x990000); }
				cache = {};
				return ev.call(EV_COMPLETE);
			}
			return error_def_hr('METHOD_GET_FRIENDS_2 failed: code=' + _code + ' msg="' + _msg + '"');
		}
		
		private function vk_complete_hr (_response:Object):Boolean {
			CONFIG::LLOG { log('vk_complete_hr'); }
			if (_response == null) { return error_def_hr('response NULL'); }
			
			//	{"response":[
			//	 {"uid":"1","first_name":"Павел","last_name":"Дуров","photo":"http:\/\/cs109.vkontakte.ru\/u00001\/c_df2abf56.jpg","online":"1","lists":[2,3]},
			//	 {"uid":"6492","first_name":"Andrew","last_name":"Rogozov","photo":"http:\/\/cs537.vkontakte.ru\/u06492\/c_28629f1d.jpg","online":"1"},{"uid":"35828305","first_name":"Виталий","last_name":"Лагунов","photo":"http:\/\/cs9917.vkontakte.ru\/u35828305\/c_e2117d04.jpg","online":"1","lists":[1]}
			//	]}
			
			cache = {};
			
			var list1:Array = _response as Array;
			if (list1 != null) {
				var list2:Vector.<DtProfile> = new Vector.<DtProfile>();
				for each (var user1:Object in list1) {
					var user2:DtProfile = new DtProfile();
					user2.id = user1['uid'];
					user2.nick = user2.create_nick(user1['first_name'], user1['last_name'], user1['nickname'], user2.id);
					user2.photo = user1['photo_medium'];
					list2.push(user2);
				}
				if (list2.length > 0) {
					for each (var user3:DtProfile in list2) {
						cache[user3.id] = user3;
					}
				}
			}
			
			return ev.call(EV_COMPLETE);
		}
		
		private function ijet_complete_hr (_result:Object):Boolean {
			CONFIG::LLOG { log('ijet_complete_hr'); }
			if (_result == null) { return error_def_hr('result NULL'); }
			
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
			
			CONFIG::LLOG {
				log(' result dump:', 0x009999);
				function d1 (_pref:String, _obj:Object):void {
					if (_obj == null) { return; }
					for (var k:String in _obj) {
						if (typeof(_obj[k]) == 'object') {
							d1(_pref + k + '.', _obj[k]);
						} else {
							log(_pref + k + '=' + _obj[k], 0x009999);
						}
					}
				}
				d1('', _result);
			}
			
			cache = {};
			
			var list1:Array = _result as Array;
			if (list1 != null) {
				var list2:Vector.<DtProfile> = new Vector.<DtProfile>();
				for each (var user1:Object in list1) {
					var user2:DtProfile = new DtProfile();
					user2.id = user1['id'];
					user2.nick = user1['name'];
					user2.photo = user1['photoMedium'];
					list2.push(user2);
				}
				for each (var user3:DtProfile in list2) {
					cache[user3.id] = user3;
				}
			}
			
			return ev.call(EV_COMPLETE);
		}
		
		CONFIG::LLOG {
			protected override function log (_t:String, _c:uint = 0x000000):void {
				super.log('(' + is_complete + '/' + in_progress + ') ' + _t, _c);
			}
		}
		
	}
	
}









