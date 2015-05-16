








package org.plazy.partners.vkontakte {
	
	import flash.utils.Dictionary;
	import org.plazy.BaseObject;
	import org.plazy.hc.HCFramer;
	import org.plazy.Omni;
	
	final public class VkCountrysService extends BaseObject {
		
		// static
		
		public static const me:VkCountrysService = new VkCountrysService();
		
		// vars
		
		private var cache:Dictionary = new Dictionary();  // key: country_id:uint, name:String
		private var queue:Vector.<uint>;
		private var pending:Vector.<uint>;
		private var frm:HCFramer;
		
		// constructor
		
		public function VkCountrysService () {
			set_name(this);
			super();
		}
		
		public override function kill ():void {
			CONFIG::LLOG { log('kill'); }
			ApiVkontakte.me.request_cancel(api_complete_hr);
			clear();
			super.kill();
		}
		
		public function clear ():void {
			CONFIG::LLOG { log('clear'); }
			cache = new Dictionary();
			queue = null;
			pending = null;
			frm_rem();
		}
		
		public function request (_country_id:uint):void {
			CONFIG::LLOG { log('request ' + _country_id); }
			if (_country_id == 0) {
				Omni.me.call('VkCountryReady_' + _country_id, '');
				return;
			}
			if (cache[_country_id] != null) {
				Omni.me.call('VkCountryReady_' + _country_id, cache[_country_id]);
				return;
			}
			if (queue == null) { queue = new Vector.<uint>(); }
			if (queue.indexOf(_country_id) == -1) { queue.push(_country_id); }
			if (pending != null) { return; }
			if (frm == null) {
				frm = new HCFramer();
				frm.set_frame(frm_hr, false);
			}
		}
		
		private function frm_hr ():Boolean {
			CONFIG::LLOG { log('frm_hr'); }
			frm_rem();
			return queue_check();
		}
		private function frm_rem ():void {
			if (frm != null) { frm.kill(); frm = null; }
		}
		
		private function queue_check ():Boolean {
			if (queue == null || queue.length == 0 || pending != null) { return true; }
			pending = queue.concat();
			queue = null;
			var params:Vector.<String> = new Vector.<String>();
			params.push('cids=' + pending.join(','));
			return ApiVkontakte.me.request_send(ApiVkontakte.METHOD_GET_COUNTRY_BY_ID, params, api_err_hr, api_complete_hr, false);
		}
		
		private function api_err_hr (_code:int, _msg:String):Boolean {
			CONFIG::LLOG { log('api_err_hr ' + _code + ' ' + _msg, 0xFF0000); }
			pending = null;
			return queue_check();
		}
		private function api_complete_hr (_response:Object):Boolean {
			CONFIG::LLOG { log('api_complete_hr'); }
			
			//	response: [{
			//	cid: '1',
			//	name: 'Москва'
			//	}, {
			//	cid: '12',
			//	name: 'Пушкин'
			//	}, {
			//	cid: '73',
			//	name: 'Красноярск'
			//	}]
			
			var list:Array = _response as Array;
			if (list != null) {
				for each (var country:Object in list) {
					if (country['cid'] == null || country['cid'] == '') { continue; }
					var cid:uint = uint(country['cid']);
					var name:String = String(country['name']);
					cache[cid] = name;
					if (!Omni.me.call('VkCountryReady_' + cid, cache[cid])) { return false; }
				}
			}
			pending = null;
			return queue_check();
		}
		
		CONFIG::LLOG {
			protected override function log (_t:String, _c:uint = 0x000000):void {
				super.log('VkCountrysService ' + _t, _c);
			}
		}
		
	}
	
}









