








package org.plazy.hc {
	
	import org.plazy.BaseObject;
	
	import flash.net.SharedObject;
	
	public class HCLocalSO extends BaseObject {
		
		private var s:SharedObject;
		
		public function HCLocalSO (_name:String, _path:String = null) {
			try { s = SharedObject.getLocal(_name, _path); }
			catch (e:Error) { CONFIG::LLOG { log('SO "' + _name + '" failed: ' + e, 0x990000); } }
		}
		
		public override function kill ():void {
			s = null;
			super.kill();
		}
		
		public function so_set (_key:String, _val:Object, _flush:Boolean = true):void {
			if (s != null) {
				s.data[_key] = _val;
				if (_flush) {
					try { s.flush(); }
					catch (e:Error) { CONFIG::LLOG { log('SO flush failed', 0x990000); } }
				}
			}
		}
		
		public function so_get (_key:String, _not_null_value:* = null):Object {
			if (s != null) {
				return s.data[_key] != null ? s.data[_key] : _not_null_value;
			}
			return null;
		}
		
	}
	
}









