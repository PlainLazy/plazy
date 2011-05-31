








package org.plazy.partners.vkontakte {
	
	import org.plazy.Omni;
	import org.plazy.BaseObject;
	import org.plazy.hc.HCTiker;
	
	import com.adobe.serialization.json.JSON;
	
	import flash.external.ExternalInterface;
	
	final public class ApiVkJs extends BaseObject {
		
		// static
		
		public static const me:ApiVkJs = new ApiVkJs();
		
		// external
		
		private var on_focus:Function;
		private var on_unfocus:Function;
		
		// vars
		
		private var started:Boolean;
		private var ready_tiker:HCTiker;
		private var events_tiker:HCTiker;
		
		// constructor
		
		public function ApiVkJs () {
			set_name(this);
			super();
		}
		
		public function set onFocus (_f:Function):void { on_focus = _f; }
		public function set onUnfocus (_f:Function):void { on_unfocus = _f; }
		
		public function start ():Boolean {
			CONFIG::LLOG { log('start'); }
			if (started) { return false; }
			if (!ExternalInterface.available) { return error_def_hr('ExternalInterface not available'); }
			started = true;
			ready_tiker_set();
			ready_tiker_hr();
			return true;
		}
		
		public override function kill ():void {
			CONFIG::LLOG { log('kill'); }
			on_focus = null;
			on_unfocus = null;
			reday_tiker_rem();
			events_tiker_rem();
			started = false;
			super.kill();
		}
		
		public function show_install_box ():void {
			CONFIG::LLOG { log('show_install_box'); }
			ExternalInterface.call('showInstallBox');
			ready_tiker_hr();
		}
		
		public function show_settings_box (_mask:int):void {
			CONFIG::LLOG { log('show_settings_box'); }
			ExternalInterface.call('showSettingsBox', _mask);
			ready_tiker_hr();
		}
		
		public function show_invite_box ():void {
			CONFIG::LLOG { log('show_invite_box'); }
			ExternalInterface.call('showInviteBox');
			ready_tiker_hr();
		}
		
		public function show_payment_box (_votes:int):void {
			CONFIG::LLOG { log('show_payment_box ' + _votes); }
			ExternalInterface.call('showPaymentBox', _votes);
			ready_tiker_hr();
		}
		
		public function save_wall_post (_hash:String):Boolean {
			CONFIG::LLOG { log('save_wall_post ' + _hash); }
			ExternalInterface.call('saveWallPost', _hash);
			ready_tiker_hr();
			return true;
		}
		
		private function ready_tiker_set ():void {
			if (ready_tiker == null) {
				ready_tiker = new HCTiker();
				ready_tiker.set_tik(ready_tiker_hr, 200, int.MAX_VALUE);
			}
		}
		
		private function reday_tiker_rem ():void {
			if (ready_tiker != null) { ready_tiker.kill(); ready_tiker = null; }
		}
		
		private function ready_tiker_hr ():void {
			var is_vk_ready:String = ExternalInterface.call('is_vk_ready');
			if (is_vk_ready == '1') {
				reday_tiker_rem();
				events_tiker_set();
			}
		}
		
		private function events_tiker_set ():void {
			if (events_tiker == null) {
				events_tiker = new HCTiker();
				events_tiker.set_tik(events_tiker_hr, 500, int.MAX_VALUE);
			}
		}
		
		private function events_tiker_rem ():void {
			if (events_tiker != null) { events_tiker.kill(); events_tiker = null; }
		}
		
		private function events_tiker_hr ():void {
			var ev:String;
			try { ev = ExternalInterface.call('shift_event'); }
			catch (e:Error) { }
			if (ev == null || ev == '') { return; }
			CONFIG::LLOG { log('/// ev: ' + ev, 0x990000); }
			
			var obj:Object;
			try { obj = JSON.decode(ev); }
			catch (e:Error) {
				CONFIG::LLOG { log('JSON decode failed: ' + e, 0x990000); }
				return;
			}
			
			for (var id:String in obj) {
				switch (id) {
					case 'onAppAdded': {
						Omni.me.call('VkAppAdded');
						break;
					}
					case 'onSettingsChanged': {
						Omni.me.call('onSettingsChanged', int(obj[id]));
						break;
					}
					case 'onWindowBlur': {
						if (on_unfocus != null) { on_unfocus(); }
						break;
					}
					case 'onWindowFocus': {
						if (on_focus != null) { on_focus(); }
						break;
					}
					case 'onBalanceChanged': {
						Omni.me.call('VkUserBalanceChanged', int(obj[id]));
						break;
					}
					case 'onWallPostSave': {
						Omni.me.call('VkWallPostSave');
						break;
					}
					case 'onWallPostCancel': {
						Omni.me.call('VkWallPostCancel');
						break;
					}
					default: {
						CONFIG::LLOG { log('unhandled event ' + id, 0x990000); }
					}
				}
				return;
			}
			
		}
		
	}
	
}









