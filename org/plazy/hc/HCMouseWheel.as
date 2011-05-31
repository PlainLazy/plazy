








package org.plazy.hc {
	
	import org.plazy.StageController;
	
	import flash.events.MouseEvent;
	import flash.display.Stage;
	import flash.display.DisplayObject;
	
	final public class HCMouseWheel {
		
		// base
		
		private var target:DisplayObject;
		
		// vars
		
		private var x1:int;
		private var y1:int;
		private var x2:int;
		private var y2:int;
		
		private var in_roll:Boolean;
		
		// external
		
		private var on_wheel:Function;
		
		// constructor
		
		public function HCMouseWheel () { }
		
		public function set onWheel (_f:Function):void { on_wheel = _f; }
		
		public function kill ():void {
			on_wheel = null;
			stop();
			target = null;
		}
		
		public function set_rect (_x:int, _y:int, _w:int, _h:int):void {
			x1 = _x;
			y1 = _y;
			x2 = _x + _w;
			y2 = _y + _h;
		}
		
		public function set_target (_target:DisplayObject):void {
			target = _target;
		}
		
		public function start ():void {
			stop();
			in_roll = true;
			StageController.me.add_mwheel_hr(wheel_hr);
		}
		
		public function stop ():void {
			if (in_roll) {
				in_roll = false;
				StageController.me.rem_mwheel_hr(wheel_hr);
			}
		}
		
		private function wheel_hr (_d:int):Boolean {
			if (on_wheel == null || target == null) { return true; }
			if (not_contains(target.mouseX, target.mouseY)) { return true; }
			try { return on_wheel(-_d); }
			catch (e:Error) { }
			return false;
		}
		
		private function not_contains (_x:int, _y:int):Boolean {
			return _x < x1 || _y < y1 || _x > x2 || _y > y2;
		}
		
	}
	
}








