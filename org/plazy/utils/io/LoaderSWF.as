








package org.plazy.utils.io {
	
	import org.plazy.Err;
	
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.net.URLRequestHeader;
	import flash.utils.ByteArray;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.HTTPStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.system.LoaderContext;
	import flash.system.SecurityDomain;
	import flash.system.ApplicationDomain;
	import flash.display.Loader;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	
	final public class LoaderSWF extends LoaderBase {
		
		// vars
		
		private var ldr:Loader;
		private var is_active:Boolean;
		
		// constructor
		
		public function LoaderSWF () {
			pref = 'LoaderSWF';
			ldr = new Loader();
			super();
		}
		
		public function load (_src:String, _method:String, _params:Object, _domain:ApplicationDomain, _check_policy:Boolean):Boolean {
			CONFIG::LLOG { log('load src="' + _src + '"', 0x009900) }
			if (in_progress) { return error_def_hr('loader busy'); }
			
			var req:URLRequest;
			try {
				req = new URLRequest(_src);
				req.method = _method;
			} catch (e:Error) {
				CONFIG::LLOG { log('ERR: ' + e, 0xFF0000) }
				return error_def_hr('invalid request params');
			}
			
			if (_params != null) {
				if (_params is ByteArray) {
					if (_method == 'POST') {
						req.data = _params;
					} else {
						return error_def_hr('invalid method for bytes sending');
					}
				} else {
					try {
						req.data = new URLVariables();
						var param_key:String
						for (param_key in _params) {
							req.data[param_key] = _params[param_key];
						}
					} catch (e:Error) {
						CONFIG::LLOG { log('ERR: ' + e, 0xFF0000) }
						return error_def_hr('request params failed');
					}
				}
			}
			
			src = _src;
			ldr_active(true);
			in_progress = true;
			t_start();
			
			try {
				ldr.load(req, new LoaderContext(_check_policy, _domain == null ? new ApplicationDomain() : _domain, SecurityDomain.currentDomain));
			} catch (e:Error) {
				ldr_active(false);
				CONFIG::LLOG { log('ERR: ' + e, 0xFF0000) }
				return error_def_hr('loading failed');
			}
			
			return true;
		}
		
		public override function close ():void {
			CONFIG::LLOG { log('close') }
			ldr_active(false);
			super.close();
		}
		
		public function get_bd ():BitmapData {
			CONFIG::LLOG { log('get_bd') }
			
			if (ldr == null) { return generate_error_bd(); }
			
			var bmp:Bitmap;
			try {
				bmp = ldr.content as Bitmap;
			} catch (e:Error) {
				CONFIG::LLOG { log('ERR: ' + e, 0xFF0000) }
			}
			
			if (bmp != null && bmp.bitmapData != null) {
				return bmp.bitmapData;
			}
			
			return generate_error_bd();
		}
		
		public function get_content ():DisplayObject {
			if (ldr != null) { return ldr.content; }
			return null;
		}
		
		public function get_app_dom ():ApplicationDomain {
			if (ldr != null) {
				try {
					var appdom:ApplicationDomain = ldr.contentLoaderInfo.applicationDomain;
					return appdom;
				} catch (e:Error) {
					CONFIG::LLOG { log('ERR: ' + e, 0xFF0000) }
				}
			}
			return null;
		}
		
		private function generate_error_bd ():BitmapData {
			
			return new BitmapData(20, 20, true, 0x80FF0000);
			
		}
		
		private function ldr_active (_bool:Boolean):void {
			if (is_active == _bool) { return; }
			is_active = _bool;
			
			CONFIG::LLOG { log('ldr_active ' + is_active) }
			
			if (is_active) {
				ldr.contentLoaderInfo.addEventListener(Event.INIT, ldr_init_hr);
				ldr.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, ldr_progress_hr);
				ldr.contentLoaderInfo.addEventListener(HTTPStatusEvent.HTTP_STATUS, ldr_http_status_hr);
				ldr.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ldr_IO_error_hr);
				ldr.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, ldr_security_error_hr);
			} else {
				ldr.contentLoaderInfo.removeEventListener(Event.INIT, ldr_init_hr);
				ldr.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, ldr_progress_hr);
				ldr.contentLoaderInfo.removeEventListener(HTTPStatusEvent.HTTP_STATUS, ldr_http_status_hr);
				ldr.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, ldr_IO_error_hr);
				ldr.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, ldr_security_error_hr);
				try { ldr.close(); } catch (e:Error) { }
			}
			
		}
		
		private function ldr_init_hr (_e:Event):void {
			CONFIG::LLOG { log('ldr_init_hr', 0x009900) }
			
			t_stop();
			in_progress = false;
			
			ldr_active(false);
			
			if (on_complete != null) { on_complete(); }
			
		}
		
		private function ldr_progress_hr (_e:ProgressEvent):void {
			CONFIG::LLOG { log('ldr_progress_hr', 0x009900) }
			
			if (_e.bytesTotal > 0) {
				
				var pc:Number = _e.bytesLoaded / _e.bytesTotal;
				
				if (pc < 1) {
					t_stop();
					
					if (pc < 1) {
						t_start();
					}
					
					if (on_progress != null) { on_progress(pc); }
				}
				
			}
			
		}
		
		private function ldr_http_status_hr (_e:HTTPStatusEvent):void {
			
			CONFIG::LLOG {
				if (_e.status > 200) {
					log('ldr_http_status_hr ' + _e, 0xFF0000);
				}
			}
			
		}
		
		private function ldr_IO_error_hr (_e:IOErrorEvent):void {
			CONFIG::LLOG { log('ldr_IO_error_hr ' + _e, 0xFF0000); }
			
			ldr_active(false);
			error_def_hr('IOError');
			
		}
		
		private function ldr_security_error_hr (_e:SecurityErrorEvent):void {
			CONFIG::LLOG { log('ldr_security_error_hr ' + _e, 0xFF0000); }
			
			ldr_active(false);
			error_def_hr('SecuError');
			
		}
		
		public override function kill ():void {
			CONFIG::LLOG { log('kill') }
			
			close();
			
			super.kill();
			
			ldr = null;
			
		}
		
	}
	
}









