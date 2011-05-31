








package org.plazy.utils.io {
	
	import org.plazy.Err;
	import org.plazy.Omni;
	import org.plazy.Bytes;
	import org.plazy.hc.HCTiker;
	
	import flash.net.Socket;
	import flash.utils.ByteArray;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.ProgressEvent;
	
	final public class SocketController {
		
		// vars
		
		private var soc:Socket;
		private var is_active:Boolean;
		private var in_connection:Boolean;
		private var is_connected:Boolean;
		private var tik:HCTiker;
		
		// external
		
		private var timeout:int;
		private var on_error:Function;
		private var on_close:Function;
		private var on_connect:Function;
		private var on_data:Function;
		private var on_log:Function;
		
		// constructor
		
		public function SocketController () { }
		
		public function init ():void {
			soc = new Socket();
			soc_active(true);
		}
		
		public function set_connection_timeout (_msec:int):void { timeout = _msec; }
		public function set onError (_f:Function):void { on_error = _f; }
		public function set onClose (_f:Function):void { on_close = _f; }
		public function set onConnect (_f:Function):void { on_connect = _f; }
		public function set onData (_f:Function):void { on_data = _f; }
		public function set onLog (_lg:Function):void { on_log = _lg; }
		
		private function soc_active (_bool:Boolean):void {
			if (is_active == _bool) { return; }
			
			is_active = _bool;
			
			if (is_active) {
				soc.addEventListener(Event.CLOSE, soc_close_hr);
				soc.addEventListener(Event.CONNECT, soc_connect_hr);
				soc.addEventListener(IOErrorEvent.IO_ERROR, soc_io_error_hr);
				soc.addEventListener(SecurityErrorEvent.SECURITY_ERROR, soc_security_error_hr);
				soc.addEventListener(ProgressEvent.SOCKET_DATA, soc_data_hr);
			} else {
				soc.removeEventListener(Event.CLOSE, soc_close_hr);
				soc.removeEventListener(Event.CONNECT, soc_connect_hr);
				soc.removeEventListener(IOErrorEvent.IO_ERROR, soc_io_error_hr);
				soc.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, soc_security_error_hr);
				soc.removeEventListener(ProgressEvent.SOCKET_DATA, soc_data_hr);
			}
			
		}
		
		public function connect (_host:String, _port:int):void {
			CONFIG::LLOG { log('connect ' + _host + ':' + _port) }
			
			if (in_connection) {
				CONFIG::LLOG { log('ERR: socket connection in progress', 0xFF0000) }
				error_def_hr('connection in progress');
				return;
			}
			
			if (is_connected || soc.connected) {
				CONFIG::LLOG { log('ERR: socket already connected', 0xFF0000) }
				error_def_hr('already connected');
				return;
			}
			
			in_connection = true;
			is_connected = false;
			
			set_tik();
			
			try {
				soc.connect(_host, _port);
			} catch (e:Error) {
				CONFIG::LLOG { log('ERR: socket connect failed: ' + e, 0xFF0000) }
				force_close();
				error_def_hr('connection failed');
				return;
			}
			
		}
		
		public function close ():void {
			CONFIG::LLOG { log('close') }
			
			force_close();
			
		}
		
		public function send (_bytes:ByteArray):void {
			log('send ' + Bytes.dump_to_str(_bytes));
			
			if (!is_connected || !soc.connected) {
				CONFIG::LLOG { log('ERR: socket not conected', 0xFF0000) }
				error_def_hr('not connected');
				return;
			}
			
			try {
				soc.writeBytes(_bytes);
				soc.flush();
			} catch (e:Error) {
				CONFIG::LLOG { log('ERR: sending failed: ' + e, 0xFF0000) }
				error_def_hr('sending failed');
				return;
			}
			
		}
		
		private function soc_close_hr (e:Event):void {
			CONFIG::LLOG { log('soc_close_hr ' + e, 0xFF0000) }
			
			is_connected = false;
			
			if (on_close != null) {
				force_close();
				try {
					on_close();
				} catch (e:Error) {
					error_def_hr(Err.generate('on_close failed: ', e, true));
				}
			} else {
				error_def_hr('on_close is null');
			}
			
		}
		
		private function soc_connect_hr (e:Event):void {
			CONFIG::LLOG { log('soc_connect_hr ' + e, 0x009900) }
			
			is_connected = true;
			
			if (on_connect != null) {
				in_connection = false;
				rem_tik();
				try {
					on_connect();
				} catch (e:Error) {
					error_def_hr(Err.generate('on_connect failed: ', e, true));
				}
			} else {
				error_def_hr('on_connect is null');
			}
			
		}
		
		private function soc_io_error_hr (e:IOErrorEvent):void {
			CONFIG::LLOG { log('soc_io_error_hr ' + e, 0xFF0000) }
			
			if (in_connection || is_connected) {
				error_def_hr('Network problems (IOErr)');
			}
			
		}
		
		private function soc_security_error_hr (e:SecurityErrorEvent):void {
			CONFIG::LLOG { log('soc_security_error_hr ' + e, 0xFF0000) }
			
			if (in_connection || is_connected) {
				error_def_hr('Network problems (SecuErr)');
			}
			
		}
		
		private function soc_data_hr (e:ProgressEvent):void {
			CONFIG::LLOG { log('soc_data_hr', 0x009900) }
			
			var bytes:ByteArray = Bytes.create_le();
			soc.readBytes(bytes);
			
			if (on_data != null) {
				try {
					on_data(bytes);
				} catch (e:Error) {
					error_def_hr(Err.generate('on_data failed: ', e, true));
				}
			} else {
				error_def_hr('on_data is null');
			}
			
		}
		
		private function soc_connect_timeout_hr ():void {
			CONFIG::LLOG { log('soc_connect_timeout_hr', 0xFF0000) }
			
			in_connection = false;
			is_connected = false;
			
			error_def_hr('Connection failed by timeout');
			
		}
		
		private function force_close ():void {
			CONFIG::LLOG { log('force_close') }
			
			in_connection = false;
			is_connected = false;
			rem_tik();
			
			try {
				soc.close();
			} catch (e:Error) {
				// omg
			}
			
		}
		
		private function error_hr (_t:String):void {
			CONFIG::LLOG { log('error_hr "' + _t + '"', 0xFF0000) }
			
			force_close();
			
			if (on_error != null) {
				try {
					on_error(_t);
				} catch (e:Error) {
					log(Err.generate('ERR: on_error failed: ', e, true), 0xFF0000);
				}
			} else {
				CONFIG::LLOG { log('ERR: on_error is null', 0xFF0000) }
			}
			
		}
		
		private function set_tik ():void {
			
			tik = new HCTiker;
			tik.set_tik(soc_connect_timeout_hr, timeout, 1);
			
		}
		
		private function rem_tik ():void {
			if (tik != null) { tik.kill(); tik = null; }
		}
		
		//
		// tail
		//
		
		private function log (_t:String, _c:int = 0x000000):void {
			if (on_log != null) { on_log('com.utils.io.SocketController ' + _t, _c); }
		}
		
		public function kill ():void {
			CONFIG::LLOG { log('kill') }
			
			in_connection = false;
			is_connected = false;
			
			force_close();
			soc_active(false);
			
			on_error = null;
			on_close = null;
			on_connect = null;
			on_data = null;
			
			rem_tik();
			
			on_log = null;
			
		}
		
	}
	
}









