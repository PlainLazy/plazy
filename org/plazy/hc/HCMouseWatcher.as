








package org.plazy.hc {
	
	import org.plazy.StageController;
	
	import flash.events.MouseEvent;
	import flash.display.Stage;
	
	public class HCMouseWatcher {
		
		// external
		
		private var on_pos_ch:Function;
		
		// vars
		
		private var stg:Stage;
		private var px:int;  // point x
		private var py:int;  // point y
		private var lx:int;  // last mouse x
		private var ly:int;  // last mouse y
		private var is_run:Boolean;
		private var is_free:Boolean;  // free or point mode
		
		// constructor
		
		public function HCMouseWatcher () {
			stg = StageController.me.stage;
		}
		
		public function set onPositionChange (_f:Function):void { on_pos_ch = _f; }
		
		public function kill ():void {
			on_pos_ch = null;
			stop();
			stg = null;
		}
		
		public function start_free ():void {
			if (is_run) { stop(); }
			lx = StageController.me.mx;
			ly = StageController.me.my;
			is_run = true;
			is_free = true;
			set_lis();
		}
		
		public function start_point ():void {
			if (is_run) { stop(); }
			px = StageController.me.mx;
			py = StageController.me.my;
			lx = StageController.me.mx;
			ly = StageController.me.my;
			is_run = true;
			is_free = false;
			set_lis();
		}
		
		public function stop ():void {
			if (!is_run) { return; }
			is_run = false;
			StageController.me.rem_mmove_hr(move_hr);
		}
		
		private function set_lis ():void {
			StageController.me.add_mmove_hr(move_hr, false);
		}
		
		private function move_hr (_dx:int, _dy:int):Boolean {
			var dx:int = _dx - lx;
			var dy:int = _dy - ly;
			if (dx != 0 || dy != 0) {
				lx = _dx;
				ly = _dy;
				if (is_free) {
					ch_apply(dx, dy);
				} else {
					ch_apply(lx - px, ly - py);
				}
			}
			return true;
		}
		
		private function ch_apply (_dx:int, _dy:int):void {
			
			try {
				on_pos_ch(_dx, _dy);
			} catch (e:Error) {
				// omg
			}
			
		}
		
	}
	
}









