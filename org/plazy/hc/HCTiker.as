








package org.plazy.hc {
	
	import flash.utils.Timer;
	
	import flash.events.TimerEvent;
	
	//final public class HCTiker implements IHCTiker {
	final public class HCTiker {
		
		private var tik:Timer;
		
		private var handler:Function;
		
		public function HCTiker () { }
		
		public function set_tik (_hr:Function, _delay:int, _repeats:int):void {
			handler = _hr;
			
			if (tik != null) {
				tik.reset();
				tik.delay = _delay;
				tik.repeatCount = _repeats;
			} else {
				tik = new Timer(_delay, _repeats);
				tik.addEventListener(TimerEvent.TIMER, tik_hr);
			}
			
			if (handler != null) { tik.start(); }
		}
		
		public function kill ():void {
			if (tik != null) {
				tik.reset();
				tik.removeEventListener(TimerEvent.TIMER, tik_hr);
				tik = null;
			}
			handler = null;
		}
		
		public function rem_tik ():void {
			if (tik != null && tik.running) {
				tik.reset();
			}
		}
		
		public function set_dealy (_delay:int):void {
			tik.delay = _delay;
		}
		
		private function tik_hr (e:TimerEvent):void {
			if (handler != null) { handler(); }
		}
		
	}
	
}








