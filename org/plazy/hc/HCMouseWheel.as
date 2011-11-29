








package org.plazy.hc {
	
	import flash.display.DisplayObject;
	import org.plazy.StageController;
	import ru.etcs.ui.MouseWheel;
	
	final public class HCMouseWheel {
		
		// ext
		
		private var on_wheel:Function;
		public function set onWheel (_f:Function):void { on_wheel = _f; }
		
		// vars
		
		private var target:DisplayObject;
		private var x1:int;
		private var y1:int;
		private var x2:int;
		private var y2:int;
		
		private var in_roll:Boolean;
		private var is_capture_enabled:Boolean;
		private var is_captured:Boolean;
		
		// constructor
		
		public function HCMouseWheel () { }
		
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
		
		public function set_capture (_bool:Boolean):void {
			if (is_capture_enabled != _bool) {
				is_capture_enabled = _bool;
				if (!is_capture_enabled && is_captured) {
					is_captured = false;
					MouseWheel.release();
				}
			}
		}
		
		public function start ():void {
			stop();
			in_roll = true;
			StageController.me.add_mwheel_hr(wheel_hr);
			StageController.me.add_mmove_hr(move_hr, false);
		}
		
		public function stop ():void {
			if (in_roll) {
				in_roll = false;
				StageController.me.rem_mwheel_hr(wheel_hr);
				StageController.me.rem_mmove_hr(move_hr);
			}
			if (is_captured) {
				is_captured = false;
				MouseWheel.release();
			}
		}
		
		private function wheel_hr (_d:int):Boolean {
			if (on_wheel == null || target == null) { return true; }
			if (not_contains(target.mouseX, target.mouseY)) { return true; }
			try { return on_wheel(-_d); }
			catch (e:Error) { }
			return false;
		}
		
		private function move_hr (_x:int, _y:int):Boolean {
			if (not_contains(target.mouseX, target.mouseY)) {
				if (is_captured) {
					is_captured = false;
					MouseWheel.release();
				}
			} else {
				if (is_capture_enabled && !is_captured) {
					is_captured = true;
					MouseWheel.capture();
				}
			}
			return true;
		}
		
		private function not_contains (_x:int, _y:int):Boolean {
			return _x < x1 || _y < y1 || _x > x2 || _y > y2;
		}
		
	}
	
}








