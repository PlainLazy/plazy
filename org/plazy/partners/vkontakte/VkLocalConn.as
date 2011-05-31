








package org.plazy.partners.vkontakte {
	
	import org.plazy.Err;
	import org.plazy.Logger;
	import org.plazy.BaseObject;
	
	import flash.net.LocalConnection;
	import flash.events.StatusEvent;
	
	final public class VkLocalConn extends BaseObject {
		
		// static
		
		public static const me:VkLocalConn = new VkLocalConn();
		
		// const
		
		private const STATE_IDLE:int                       = 0x00;
		private const STATE_INIT_WAITING:int               = 0x01;
		private const STATE_READY:int                      = 0x02;
		
		private const CMD_INIT_CONNECTION:String           = 'initConnection';
		private const CMD_BALANCE_CHANGED:String           = 'onBalanceChanged';
		private const CMD_SETTINGS_CHANGED:String          = 'onSettingsChanged';
		private const CMD_LOCATION_CHANGED:String          = 'onLocationChanged';
		private const CMD_WINDOW_RESIZED:String            = 'onWindowResized';
		private const CMD_APPLICATION_ADDED:String         = 'onApplicationAdded';
		private const CMD_WINDOW_BLUR:String               = 'onWindowBlur';
		private const CMD_WINDOW_FOCUS:String              = 'onWindowFocus';
		private const CMD_WALL_POST_SAVE:String            = 'onWallPostSave';
		private const CMD_WALL_POST_CANCEL:String          = 'onWallPostCancel';
		private const CMD_PROFILE_PHOTO_SAVE:String        = 'onProfilePhotoSave';
		private const CMD_PROFILE_PHOTO_CANCEL:String      = 'onProfilePhotoCancel';
		private const CMD_MERCHANT_PAYMENT_SUCCESS:String  = 'onMerchantPaymentSuccess';
		private const CMD_MERCHANT_PAYMENT_CANCEL:String   = 'onMerchantPaymentCancel';
		private const CMD_MERCHANT_PYMENY_FAIL:String      = 'onMerchantPaymentFail';
		private const CMD_CUSTOM_EVENT:String              = 'customEvent';
		
		private const CMD_SHOW_INSTALL_BOX:String          = 'showInstallBox';
		private const CMD_SHOW_SETTINGS_BOX:String         = 'showSettingsBox';
		
		// base
		
		// vars
		
		private var inited:Boolean;
		private var state:int;
		private var name:String;
		private var lc_snd:LocalConnection;
		private var lc_rcv:LocalConnection;
		
		// external
		
		private var on_ready:Function;
		private var on_win_blur:Function;
		private var on_win_focus:Function;
		private var on_app_added:Function;
		private var on_settings_changed:Function;
		
		// objects
		
		// constructor
		
		public function VkLocalConn () {
			
			super();
			set_name(this);
			
			queue = new Vector.<Vector.<String>>();
			
		}
		
		public function set onReady (_f:Function):void {
			on_ready = _f;
		}
		
		public function set onWinBlur (_f:Function):void {
			on_win_blur = _f;
		}
		
		public function set onWinFocus (_f:Function):void {
			on_win_focus = _f;
		}
		
		public function set onAppAdded (_f:Function):void {
			on_app_added = _f;
		}
		
		public function set onSettingsChanged (_f:Function):void {
			on_settings_changed = _f;
		}
		
		public function get is_inited ():Boolean {
			return inited;
		}
		
		public function get is_ready ():Boolean {
			return state == STATE_READY;
		}
		
		public function init (_name:String):Boolean {
			CONFIG::LLOG { log('init ' + _name) }
			
			if (inited) {
				return error_def_hr('inited');
			}
			
			inited = true;
			
			if (_name == null) {
				return error_def_hr('name is null');
			}
			
			name = _name
			
			lc_snd = new LocalConnection();
			lc_snd.allowDomain('*');
			
			lc_rcv = new LocalConnection();
			lc_rcv.allowDomain('*');
			lc_rcv.client = {};
			lc_rcv.client[CMD_INIT_CONNECTION]    = init_conn_hr;
			lc_rcv.client[CMD_WINDOW_BLUR]        = win_blur_hr;
			lc_rcv.client[CMD_WINDOW_FOCUS]       = win_focus_hr;
			lc_rcv.client[CMD_APPLICATION_ADDED]  = app_added_hr;
			lc_rcv.client[CMD_SETTINGS_CHANGED]   = settings_changed_hr;
			
			//lc_rcv.addEventListener(StatusEvent.STATUS, lc_rcv_status_hr);
			
			try {
				lc_rcv.connect('_out_' + name);
			} catch (e:Error) {
				return error_def_hr(Err.generate('lc_rcv connect failed: ', e, true));
			}
			
			lc_snd.addEventListener(StatusEvent.STATUS, lc_snd_status_hr);
			
			try {
				lc_snd.send('_in_' + name, CMD_INIT_CONNECTION);
			} catch (e:Error) {
				return error_def_hr(Err.generate('lc_snd send failed: ', e, true));
			}
			
			return true;
			
		}
		
		public function show_install_box ():Boolean {
			CONFIG::LLOG { log('show_install_box') }
			
			if (state != STATE_READY) {
				return error_def_hr('not ready');
			}
			
			try {
				lc_snd.send('_in_' + name, CMD_SHOW_INSTALL_BOX);
			} catch (e:Error) {
				return error_def_hr(Err.generate('lc_snd send failed: ', e, true));
			}
			
			return true;
			
		}
		
		public function show_settings_box (_mask:uint):Boolean {
			CONFIG::LLOG { log('show_settings_box') }
			
			if (state != STATE_READY) {
				return error_def_hr('not ready');
			}
			
			try {
				lc_snd.send('_in_' + name, CMD_SHOW_SETTINGS_BOX, _mask);
			} catch (e:Error) {
				return error_def_hr(Err.generate('lc_snd send failed: ', e, true));
			}
			
			return true;
			
		}
		
		/*
		private function lc_rcv_status_hr (_e:StatusEvent):void {
			CONFIG::LLOG { log('lc_rcv_status_hr ' + _e, 0xFF0000) }
			
		}
		*/
		
		private function lc_snd_status_hr (_e:StatusEvent):void {
			CONFIG::LLOG { log('lc_snd_status_hr ' + _e) }
			
			switch (_e.level) {
				case 'status':
					
					if (state == STATE_IDLE) {
						
						state = STATE_READY;
						
						try {
							on_ready();
						} catch (e:Error) {
							error_def_hr(Err.generate('on_ready failed: ', e, true));
						}
						
					}
					
					break;
				case 'error':
					error_def_hr('status is error');
					break;
				default:
					log('status: ' + _e.level);
					break;
			}
			
		}
		
		private function init_conn_hr ():void {
			CONFIG::LLOG { log('init_conn_hr') }
			
			switch (state) {
				case STATE_READY:
					break;
				default:
					error_def_hr('invalid state ' + state + ' for init');
					break;
			}
			
		}
		
		private function win_blur_hr ():void {
			CONFIG::LLOG { log('win_blur_hr') }
			
			if (on_win_blur != null) {
				try {
					on_win_blur();
				} catch (e:Error) {
					error_def_hr(Err.generate('on_win_blur failed: ', e, true));
				}
			}
			
		}
		
		private function win_focus_hr ():void {
			CONFIG::LLOG { log('win_focus_hr') }
			
			if (win_focus_hr != null) {
				try {
					win_focus_hr();
				} catch (e:Error) {
					error_def_hr(Err.generate('win_focus_hr failed: ', e, true));
				}
			}
			
		}
		
		private function app_added_hr ():void {
			CONFIG::LLOG { log('app_added_hr') }
			
			if (app_added_hr != null) {
				try {
					app_added_hr();
				} catch (e:Error) {
					error_def_hr(Err.generate('app_added_hr failed: ', e, true));
				}
			}
			
		}
		
		private function settings_changed_hr (_mask:String):void {
			CONFIG::LLOG { log('settings_changed_hr ' + _mask) }
			
			if (_mask == null) {
				error_def_hr('settings mask is null');
				return;
			}
			
			if (settings_changed_hr != null) {
				try {
					on_settings_changed(uint(parseInt(_mask)));
				} catch (e:Error) {
					error_def_hr(Err.generate('on_settings_changed failed: ', e, true));
				}
			}
			
		}
		
		public override function kill ():void {
			CONFIG::LLOG { log('kill') }
			
			try {
				lc_rcv.close();
			} catch (e:Error) {
				
			}
			
			lc_rcv = null;
			lc_snd = null;
			
			on_ready = null;
			on_win_blur = null;
			on_win_focus = null;
			on_app_added = null;
			on_settings_changed = null;
			
			super.kill();
			
		}
		
	}
	
}









