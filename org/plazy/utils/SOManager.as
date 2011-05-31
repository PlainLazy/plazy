








package org.plazy.utils {
	
	import flash.net.SharedObject;
	import flash.events.SyncEvent;
	import flash.events.NetStatusEvent;
	import flash.events.AsyncErrorEvent;
	
	final public class SOManager {
		
		// vars
		
		private var so:SharedObject;
		
		// external
		
		private var on_log:Function;
		
		// constructor
		
		public function SOManager () { }
		
		public function set onLog (_f:Function):void { on_log = _f; }
		
		public function init (_name:String, _path:String = null):String {
			CONFIG::LLOG { log('init ' + _name + ' ' + _path) }
			
			if (so != null) {
				CONFIG::LLOG { log('ERR: already inited', 0xFF0000) }
				return 'alreay inited';
			}
			
			try {
				so = SharedObject.getLocal(_name, _path);
			} catch (e:Error) {
				CONFIG::LLOG { log('ERR: ' + e, 0xFF0000) }
				return 'getLocal filed: ' + e;
			}
			
			so.addEventListener(AsyncErrorEvent.ASYNC_ERROR, so_async_error_hr);
			so.addEventListener(NetStatusEvent.NET_STATUS, so_netstatus_hr);
			so.addEventListener(SyncEvent.SYNC, so_sync_hr);
			
			return null;
		}
		
		public function get_hash ():Object {
			if (so == null) { return null; }
			return so.data;
		}
		
		public function get_by_key (_key:String):Object {
			if (so == null) { return null; }
			return so.data[_key];
		}
		
		public function set_by_key (_key:String, _value:Object, _flush:Boolean = true):void {
			if (so == null) { return; }
			so.data[_key] = _value;
			if (_flush) { flush(); }
		}
		
		public function delete_by_key (_key:String, _flush:Boolean):void {
			if (so == null) { return; }
			delete so.data[_key];
			if (_flush) { flush(); }
		}
		
		public function flush ():void {
			if (so == null) { return; }
			try { so.flush(); }
			catch (e:Error) { CONFIG::LLOG { log('ERR: ' + e, 0xFF0000) } }
		}
		
		public function clear ():void {
			if (so == null) { return; }
			try { so.clear(); }
			catch (e:Error) { CONFIG::LLOG { log('ERR: ' + e, 0xFF0000) } }
		}
		
		private function so_async_error_hr (e:AsyncErrorEvent):void {
			log('ERR: so_async_error_hr: ' + e.toString(), 0xFF0000);
		}
		
		private function so_netstatus_hr (e:NetStatusEvent):void {
			log('TIP: so_netstatus_hr: ' + e.toString(), 0x000099);
		}
		
		private function so_sync_hr (e:SyncEvent):void {
			log('TIP: so_sync_hr: ' + e.toString(), 0x000099);
		}
		
		private function log (_t:String, _c:uint = 0x000000):void {
			if (on_log != null) {
				try {
					on_log('SOManager ' + _t, _c);
				} catch (e:Error) { }
			}
		}
		
		public function kill ():void {
			CONFIG::LLOG { log('kill') }
			if (so != null) {
				so.removeEventListener(AsyncErrorEvent.ASYNC_ERROR, so_async_error_hr);
				so.removeEventListener(NetStatusEvent.NET_STATUS, so_netstatus_hr);
				so.removeEventListener(SyncEvent.SYNC, so_sync_hr);
				so = null;
			}
			on_log = null;
		}
		
	}
	
}









