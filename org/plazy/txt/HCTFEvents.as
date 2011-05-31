








package org.plazy.txt {
	
	import org.plazy.Funcer;
	
	import flash.text.TextField;
	
	import flash.events.Event;
	import flash.events.FocusEvent;
	
	public class HCTFEvents {
		
		// static
		
		public static const TP_FOCUS_IN:int  = 1;
		public static const TP_FOCUS_OUT:int = 2;
		
		// vars
		
		private var events:Array = [];
		private var hash:Object = {};
		
		// objects
		
		private var tf:TextField;
		
		// constructor
		
		public function HCTFEvents (_tf:TextField) {
			
			tf = _tf;
			
			hash[TP_FOCUS_IN]  = FocusEvent.FOCUS_IN;
			hash[TP_FOCUS_OUT] = FocusEvent.FOCUS_OUT;
			
		}
		
		public function add_event (_type:int, _hr:Function):Boolean {
			
			var ev:String = hash[_type];
			
			if (ev == null) {
				return false;
			}
			
			var funcer:Funcer = new Funcer()
			var hr2:Function = funcer.gen_func(event_hr, _hr);
			tf.addEventListener(ev, hr2);
			
			var Di:DiEvent = new DiEvent();
			Di.type = _type;
			Di.hr = _hr;
			Di.hr2 = hr2
			
			events.push(Di);
			
			return true;
			
		}
		
		public function rem_event (_type:int, _hr:Function = null):void {
			
			var Di:DiEvent;
			var i:int;
			for (i = 0; i < events.length; i++) {
				Di = events[i];
				if (Di.type == _type && (_hr == null || Di.hr == _hr)) {
					tf.removeEventListener(hash[_type], Di.hr2);
					events.splice(i, 1);
					Di.kill();
					break;
				}
			}
			
		}
		
		public function rem_all_events ():void {
			
			var Di:DiEvent;
			for each (Di in events) {
				tf.removeEventListener(hash[Di.type], Di.hr2);
				Di.kill();
			}
			events = [];
			
		}
		
		private function event_hr (_hr:Function, _args:Array):void {
			
			if (_hr != null) {
				_hr();
			}
			
		}
		
		public function kill ():void {
			
			rem_all_events();
			
			events = null;
			
			tf = null;
			
		}
		
	}
	
}

class DiEvent {
	
	public var type:int;
	public var hr:Function;
	public var hr2:Function;
	
	public function DiEvent () { }
	
	public function kill ():void {
		hr = null;
		hr2 = null;
	}
	
}









