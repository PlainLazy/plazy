








package org.plazy.utils.io {
	
	import org.plazy.Err;
	
	import flash.net.URLStream;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.net.URLRequestHeader;
	import flash.utils.Endian;
	import flash.utils.ByteArray;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.HTTPStatusEvent;
	import flash.events.SecurityErrorEvent;
	
	final public class StreamBIN extends LoaderBase {
		
		// vars
		
		private var ldr:URLStream;
		private var result_bytes:ByteArray;
		
		// constructor
		
		public function StreamBIN () {
			pref = 'StreamBIN';
			super();
		}
		
		public function load (_src:String, _method:String, _params:Object, _headers:Vector.<URLRequestHeader> = null):Boolean {
			CONFIG::LLOG { log('load src="' + _src + '"', 0x009900) }
			if (ldr != null) { return error_def_hr('loader busy'); }
			
			var req:URLRequest;
			try {
				req = new URLRequest(_src);
				req.method = _method;
			} catch (e:Error) {
				CONFIG::LLOG { log('ERR: ' + e, 0xFF0000) }
				return error_def_hr('invalid request params');
			}
			
			if (_headers != null && _headers.length > 0) {
				var header:URLRequestHeader;
				try {
					for each (header in _headers) {
						req.requestHeaders.push(header);
					}
				} catch (e:Error) {
					CONFIG::LLOG { log('ERR: ' + e, 0xFF0000) }
					return error_def_hr('invalid request headers');
				}
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
				ldr.load(req);
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
		
		public function get_bytes ():ByteArray {
			CONFIG::LLOG { log('get_bytes') }
			return result_bytes;
		}
		
		private function ldr_active (_bool:Boolean):void {
			
			var is_ldr_active:Boolean = ldr != null;
			
			if (is_ldr_active == _bool) { return; }
			
			CONFIG::LLOG { log('ldr_active ' + _bool) }
			
			if (_bool) {
				ldr = new URLStream();
				ldr.addEventListener(Event.COMPLETE, ldr_complete_hr);
				ldr.addEventListener(ProgressEvent.PROGRESS, ldr_progress_hr);
				ldr.addEventListener(HTTPStatusEvent.HTTP_STATUS, ldr_http_status_hr);
				ldr.addEventListener(IOErrorEvent.IO_ERROR, ldr_IO_error_hr);
				ldr.addEventListener(SecurityErrorEvent.SECURITY_ERROR, ldr_security_error_hr);
			} else {
				ldr.removeEventListener(Event.COMPLETE, ldr_complete_hr);
				ldr.removeEventListener(ProgressEvent.PROGRESS, ldr_progress_hr);
				ldr.removeEventListener(HTTPStatusEvent.HTTP_STATUS, ldr_http_status_hr);
				ldr.removeEventListener(IOErrorEvent.IO_ERROR, ldr_IO_error_hr);
				ldr.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, ldr_security_error_hr);
				try {
					ldr.close();
				} catch (e:Error) {
				}
				ldr = null;
			}
			
		}
		
		private function ldr_complete_hr (e:Event):void {
			CONFIG::LLOG { log('ldr_complete_hr', 0x009900) }
			
			t_stop();
			in_progress = false;
			
			result_bytes = new ByteArray();
			result_bytes.endian = Endian.LITTLE_ENDIAN;
			
			ldr.readBytes(result_bytes);
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
			result_bytes = null;
		}
		
	}
	
}









