








package org.plazy.partners.vkontakte {
	
	import vk.APIConnection;
	import vk.events.CustomEvent;
	import vk.events.BalanceEvent;
	import vk.events.SettingsEvent;
	
	import org.plazy.Err;
	import org.plazy.Logger;
	import org.plazy.FlashVars;
	import org.plazy.BaseObject;
	
	public class ApiVkontakteLC extends BaseObject {
		
		public static const me:ApiVkontakteLC = new ApiVkontakteLC();
		
		private var lc:APIConnection;
		
		private var on_win_blur:Function;
		private var on_win_focus:Function;
		private var on_app_added:Function;
		private var on_settings_changed:Function;
		private var on_balance_changed:Function;
		private var on_wall_saved:Function;
		private var on_wall_cancelled:Function;
		
		public function ApiVkontakteLC () {
			super();
			set_name(this);
		}
		
		public function init ():Boolean {
			CONFIG::LLOG { log('init') }
			if (lc != null) { return true; }
			
			var lc_name:String = FlashVars.me.get_value('lc_name', null, false);
			if (lc_name == null) {
				CONFIG::LLOG { log('lc_name null', 0x990000); }
				return true;
			}
			
			try {
				lc = new APIConnection(lc_name);
				lc.addEventListener(CustomEvent.WINDOW_BLUR, win_blur_hr);
				lc.addEventListener(CustomEvent.WINDOW_FOCUS, win_focus_hr);
				lc.addEventListener(CustomEvent.APP_ADDED, app_added_hr);
				lc.addEventListener(SettingsEvent.CHANGED, settings_changed_hr);
				lc.addEventListener(BalanceEvent.CHANGED, balance_changed_hr);
				lc.addEventListener(CustomEvent.WALL_SAVE, wall_save_hr);
				lc.addEventListener(CustomEvent.WALL_CANCEL, wall_cancel_hr);
			} catch (e:Error) {
				return error_def_hr(Err.generate('APIConnection failed: ', e, true));
			}
			
			return true;
		}
		
		public function set onWinBlur (_f:Function):void { on_win_blur = _f; }
		public function set onWinFocus (_f:Function):void { on_win_focus = _f; }
		public function set onAppAdded (_f:Function):void { on_app_added = _f; }
		public function set onSettingsChanged (_f:Function):void { on_settings_changed = _f; }
		public function set onBalanceChanged (_f:Function):void { on_balance_changed = _f; }
		public function set onWallSaved (_f:Function):void { on_wall_saved = _f; }
		public function set onWallCancelled (_f:Function):void { on_wall_cancelled = _f; }
		
		public function show_install_box ():Boolean {
			CONFIG::LLOG { log('show_install_box') }
			if (lc == null) { return error_def_hr('lc is null'); }
			lc.showInstallBox();
			return true;
		}
		
		public function show_settings_box (_mask:uint):Boolean {
			CONFIG::LLOG { log('show_settings_box') }
			if (lc == null) { return error_def_hr('lc is null'); }
			lc.callMethod('showSettingsBox', _mask);
			return true;
		}
		
		public function show_invite_box ():Boolean {
			CONFIG::LLOG { log('show_invite_box') }
			if (lc == null) { return error_def_hr('lc is null'); }
			lc.callMethod('showInviteBox');
			return true;
		}
		
		public function show_paymeny_box (_votes:uint):Boolean {
			CONFIG::LLOG { log('show_paymeny_box ' + _votes) }
			if (lc == null) { return error_def_hr('lc is null'); }
			lc.callMethod('showPaymentBox', _votes);
			return true;
		}
		
		public function save_wall_post (_hash:String):Boolean {
			if (lc == null) { return error_def_hr('lc is null'); }
			lc.saveWallPost(_hash);
			return true;
		}
		
		private function win_blur_hr (_e:CustomEvent):void {
			CONFIG::LLOG { log('win_blur_hr') }
			if (on_win_blur == null) { return; }
			try { on_win_blur(); }
			catch (e:Error) { error_def_hr(Err.generate('on_win_blur failed: ', e, true)); }
		}
		
		private function win_focus_hr (_e:CustomEvent):void {
			CONFIG::LLOG { log('win_focus_hr') }
			if (on_win_focus == null) { return; }
			try { on_win_focus(); }
			catch (e:Error) { error_def_hr(Err.generate('on_win_focus failed: ', e, true)); }
		}
		
		private function app_added_hr (_e:CustomEvent):void {
			CONFIG::LLOG { log('app_added_hr') }
			if (on_app_added == null) { return; }
			try { on_app_added(); }
			catch (e:Error) { error_def_hr(Err.generate('on_app_added failed: ', e, true)); }
		}
		
		private function settings_changed_hr (_e:SettingsEvent):void {
			CONFIG::LLOG { log('settings_changed_hr ' + _e) }
			if (_e == null) {
				error_def_hr('SettingsEvent is null');
				return;
			}
			if (on_settings_changed == null) { return; }
			try { on_settings_changed(_e.settings); }
			catch (e:Error) { error_def_hr(Err.generate('on_settings_changed failed: ', e, true)); }
		}
		
		private function balance_changed_hr (_e:BalanceEvent):void {
			CONFIG::LLOG { log('balance_changed_hr ' + _e) }
			if (_e == null) {
				error_def_hr('SettingsEvent is null');
				return;
			}
			if (on_balance_changed == null) { return; }
			try { on_balance_changed(_e.balance); }
			catch (e:Error) { error_def_hr(Err.generate('on_balance_changed failed: ', e, true)); }
		}
		
		private function wall_save_hr (_e:CustomEvent):void {
			CONFIG::LLOG { log('wall_save_hr ' + _e) }
			if (on_wall_saved == null) { return; }
			try { on_wall_saved(); }
			catch (e:Error) { error_def_hr(Err.generate('on_wall_saved failed: ', e, true)); }
		}
		
		private function wall_cancel_hr (_e:CustomEvent):void {
			CONFIG::LLOG { log('wall_cancel_hr ' + _e) }
			if (on_wall_cancelled == null) { return; }
			try { on_wall_cancelled(); }
			catch (e:Error) { error_def_hr(Err.generate('on_wall_cancelled failed: ', e, true)); }
		}
		
	}
	
}









