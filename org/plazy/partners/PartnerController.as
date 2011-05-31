








package org.plazy.partners {
	
	import org.plazy.Logger;
	import org.plazy.Locker;
	import org.plazy.BaseObject;
	import org.plazy.partners.mailru.ApiMailRu;
	import org.plazy.partners.vkontakte.ApiVkJs;
	import org.plazy.partners.vkontakte.ApiVkontakte;
	//import org.plazy.partners.vkontakte.ApiVkontakteLC;
	
	public class PartnerController extends BaseObject {
		
		public static const me:PartnerController = new PartnerController();
		
		public static const PARTNER_NONE:int  = 0;
		public static const PARTNER_INDEP:int = 1;
		public static const PARTNER_MAIL:int  = 2;
		public static const PARTNER_VK:int    = 3;
		
		private var current_partner_id:int;
		
		public function PartnerController () {
			set_name(this);
			super();
		}
		
		public function init_partner (_partner_id:int):Boolean {
			CONFIG::LLOG { log('init_partner ' + current_partner_id + ' to ' + _partner_id) }
			if (current_partner_id == _partner_id) { return true; }
			if (current_partner_id != PARTNER_NONE) { return error_def_hr('already inited'); }
			
			switch (current_partner_id) {
				case PARTNER_NONE:
				case PARTNER_INDEP:
					break;
				case PARTNER_MAIL:
					ApiMailRu.me.reset();
					break;
				case PARTNER_VK:
					ApiVkontakte.me.reset();
					break;
				default:
					return error_def_hr('unhandled old partner ' + current_partner_id);
			}
			
			current_partner_id = _partner_id;
			
			switch (current_partner_id) {
				case PARTNER_NONE:
				case PARTNER_INDEP:
					break;
				case PARTNER_MAIL:
					ApiMailRu.me.onError = mailru_err_hr;
					if (!ApiMailRu.me.init()) { return false; }
					break;
				case PARTNER_VK:
					ApiVkontakte.me.onError = vkontakte_err_hr;
					if (!ApiVkontakte.me.init()) { return false; }
					/*
					ApiVkontakteLC.me.onError = vkontakte_lc_err_hr;
					ApiVkontakteLC.me.onWinBlur = vk_blur_hr;
					ApiVkontakteLC.me.onWinFocus = vk_focus_hr;
					if (!ApiVkontakteLC.me.init()) { return false; }
					*/
					ApiVkJs.me.onError = error_hr;
					if (!ApiVkJs.me.start()) { return false; }
					ApiVkJs.me.onUnfocus = vk_blur_hr;
					ApiVkJs.me.onFocus = vk_focus_hr;
					break;
				default:
					return error_def_hr('unhandled new partner ' + current_partner_id);
			}
			
			return true;
		}
		
		public function get_partner_by_url (_url:String):int {
			if (_url == null) { return PARTNER_INDEP; }
			
			var matches:Array;
			
			matches = _url.match(/localhost/ig);
			if (matches.length > 0) {
				return PARTNER_INDEP;
			} else {
				matches = _url.match(/mail\.ru/ig);
				if (matches.length > 0) {
					return PARTNER_MAIL;
				} else {
					matches = _url.match(/(vkontakte\.ru)|(vk\.com)/ig);
					if (matches.length > 0) {
						return PARTNER_VK;
					}
				}
			}
			
			return PARTNER_INDEP;
			
		}
		
		public function reset ():Boolean {
			CONFIG::LLOG { log('reset') }
			
			switch (current_partner_id) {
				case PARTNER_NONE:
				case PARTNER_INDEP:
					break;
				case PARTNER_MAIL:
					ApiMailRu.me.reset();
				case PARTNER_VK:
					ApiVkontakte.me.reset();
					break;
				default:
					return error_def_hr('unhandled partner ' + current_partner_id);
			}
			
			return true;
		}
		
		private function vk_blur_hr ():void {
			CONFIG::LLOG { log('vk_blur_hr') }
			Locker.me.active = true;
		}
		
		private function vk_focus_hr ():void {
			CONFIG::LLOG { log('vk_focus_hr') }
			Locker.me.active = false;
		}
		
		private function mailru_err_hr (_t:String):void {
			CONFIG::LLOG { log('mailru_err_hr "' + _t + '"', 0xFF0000) }
			error_def_hr('mailru error: ' + _t);
		}
		
		private function vkontakte_err_hr (_t:String):void {
			CONFIG::LLOG { log('vkontakte_err_hr "' + _t + '"', 0xFF0000) }
			error_def_hr('vkontakte error: ' + _t);
		}
		
		/*
		private function vkontakte_lc_err_hr (_t:String):void {
			CONFIG::LLOG { log('vkontakte_lc_err_hr "' + _t + '"', 0xFF0000) }
			error_def_hr('vkontakte_lc error: ' + _t);
		}
		*/
		
	}
	
}









