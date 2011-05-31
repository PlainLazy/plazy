








package org.plazy.hc {
	
	import flash.geom.ColorTransform;
	import flash.display.DisplayObject;
	
	public class HCLighter {
		
		// var
		
		private var low:Number;
		private var hi:Number;
		private var to_low:Number;
		private var to_hi:Number;
		private var is_active:Boolean;
		private var framer1:HCFramer;
		private var target:DisplayObject;
		
		// constructor
		
		public function HCLighter () {
			
			low = 1;
			hi = 1.2;
			
			to_low  = 0.2 / 5;
			to_hi   = 0.2 / 5;
			
			framer1 = new HCFramer();
			
		}
		
		public function kill ():void {
			framer1.kill();
			framer1 = null;
			target = null;
		}
		
		public function set_target (_target:DisplayObject):void {
			target = _target;
		}
		
		public function set_range (_low_factor:Number, _hi_factor:Number, _fr_low:int, _fr_hi:int):void {
			if (_low_factor != -1) { low = _low_factor; }
			if (_hi_factor != -1) { hi = _hi_factor; }
			var h:Number = _hi_factor - _low_factor;
			to_low = h / _fr_low;
			to_hi = h / _fr_hi;
		}
		
		public function set active (_bool:Boolean):void {
			if (is_active != _bool) {
				is_active = _bool;
				framer1.set_frame(frame_hr, true);
			}
		}
		
		private function frame_hr ():void {
			
			var val:Number = target.transform.colorTransform.redMultiplier;
			var new_val:Number = val;
			
			if (is_active) {
				new_val += to_hi;
				if (new_val > hi) {
					new_val = hi;
					framer1.rem_frame();
				}
			} else {
				new_val -= to_low;
				if (new_val < low) {
					new_val = low;
					framer1.rem_frame();
				}
			}
			
			if (target != null) {
				target.transform.colorTransform = new ColorTransform(new_val, new_val, new_val, 1, 0, 0, 0, 0);
			}
			
		}
		
	}
	
}









