








package org.plazy.hc {
	
	public class HCFrameDlayer {
		
		// external
		
		private var on_passed:Function;
		private var self_kill:Boolean;
		
		// vars
		
		private var framer:HCFramer;
		private var frames_left:int;
		
		public function HCFrameDlayer () {
			framer = new HCFramer();
		}
		
		public function set onPassed (_f:Function):void { on_passed = _f; }
		public function set selfKill (_bool:Boolean):void { self_kill = _bool; }
		
		public function kill ():void {
			on_passed = null;
			if (framer != null) { framer.kill(); framer = null; }
		}
		
		public function start (_frames:int):void {
			frames_left = _frames;
			framer.set_frame(frame_hr, true);
		}
		
		private function frame_hr ():void {
			frames_left--;
			if (frames_left < 0) {
				framer.rem_frame();
				if (on_passed != null) { on_passed(); }
				if (self_kill) { kill(); }
			}
		}
		
	}
	
}









