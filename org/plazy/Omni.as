








package org.plazy {
	
	final public class Omni {
		
		public static const me:Omni = new Omni();
		
		private var hash:Object = {};  // key: event_id(String), value: Vector.<OmniHandler>
		private var on_error:Function;
		
		public function Omni () { }
		
		public function set onError (_f:Function):void { on_error = _f; }
		
		public function call (_ev:String, ... _params:Array):Boolean {
			//CONFIG::LLOG { log('call ' + _ev); }
			var ar:Vector.<OmniHandler> = hash[_ev];
			if (ar == null) { return true; }
			
			var handler:OmniHandler;
			for each (handler in ar) {
				//CONFIG::LLOG { log(' // handler ' + handler, 0x888888); }
				if (!handler.hr.apply(null, _params)) { return false; }
			}
			
			return true;
		}
		
		public function callex (_ev:String, ... _params:Array):Array {
			var out:Array = [];
			var ar:Vector.<OmniHandler> = hash[_ev];
			if (ar == null) { return out; }
			var handler_result:Object;
			for each (var handler:OmniHandler in ar) {
				handler_result = handler.hr.apply(null, _params);
				if (handler_result is Boolean && handler_result == false) { return null; }
				out.push(handler_result);
			}
			return out;
		}
		
		public function add (_ev:String, _hr:Function, _priority:int = 0):void {
			var handler:OmniHandler = new OmniHandler();
			handler.hr = _hr;
			handler.prority = _priority;
			
			var ar:Vector.<OmniHandler> = hash[_ev];
			
			if (ar == null) {
				ar = new Vector.<OmniHandler>();
				ar.push(handler);
				hash[_ev] = ar;
			} else {
				ar.push(handler);
				ar.sort(sorter);
			}
		}
		
		public function rem (_ev:String, _hr:Function = null, _once:Boolean = true):int {
			var ar:Vector.<OmniHandler> = hash[_ev];
			if (ar == null) { return -1; }
			
			var removed:int;
			var handler:OmniHandler;
			var i:int;
			for (i = 0; i < ar.length; i++) {
				handler = ar[i];
				if (_hr == null || handler.hr == _hr) {
					removed++;
					ar.splice(i, 1);
					if (_once) { break; }
					i--;
				}
			}
			
			return removed;
		}
		
		public function rem_all ():int {
			var removed:int;
			var ev:String;
			for (ev in hash) {
				removed += rem(ev, null, false);
			}
			return removed;
		}
		
		private function sorter (_h1:OmniHandler, _h2:OmniHandler):int {
			return (_h1.prority < _h2.prority) ? 1 : ((_h1.prority > _h2.prority) ? -1 : 0);
		}
		
		private function error_hr (_t:String):Boolean {
			CONFIG::LLOG { log('error_hr "' + _t + '"', 0xFF0000); }
			if (on_error != null) { on_error('{Omni: ' + _t + '}'); }
			return false;
		}
		
		CONFIG::LLOG {
			private function log (_t:String, _c:uint = 0x000000):void {
				Logger.me.add('Omni ' + _t, _c);
			}
		}
		
	}
	
}


	






