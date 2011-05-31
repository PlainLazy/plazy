








package org.plazy.hc {
	
	import org.plazy.Logger;
	
	public class HCFrameCounter {
		
		private var framer:HCFramer;
		
		private var on_frame_apply:Function;
		private var self_kill:Boolean;
		
		private var frame_current:int;
		private var frame_finish:int;
		
		private var killed:Boolean;
		
		public function HCFrameCounter () {
			framer = new HCFramer();
		}
		
		public function set onFrameApply (_f:Function):void { on_frame_apply = _f; }
		public function set selfKill (_bool:Boolean):void { self_kill = _bool; }
		
		public function kill ():void {
			//log('kill');
			if (killed) { return; }
			killed = true;
			on_frame_apply = null;
			framer.kill();
			framer = null;
		}
		
		public function start (_start_index:int, _finish_index:int, _apply_first:Boolean = false):void {
			//log('start ' + _start_index + ' ' + _finish_index + ' ' + _apply_first);
			
			frame_current = _start_index;
			frame_finish = _finish_index;
			
			if (frame_current > frame_finish) {
				frame_current = frame_finish;
			}
			
			framer.set_frame(frame_hr, _apply_first);
			
		}
		
		public function stop ():void {
			//log('stop');
			framer.rem_frame();
		}
		
		private function frame_hr ():void {
			//log('frame_hr ' + frame_current);
			
			if (on_frame_apply != null) { on_frame_apply(frame_current); }
			
			frame_current++;
			
			if (frame_current > frame_finish) {
				if (!killed) {
					framer.rem_frame();
					if (self_kill) { kill(); }
				}
			}
			
		}
		
		//private function log (_t:String):void {
		//	
		//	Logger.me.add('HCFrameCounter: ' + _t);
		//	
		//}
		
	}
	
}









