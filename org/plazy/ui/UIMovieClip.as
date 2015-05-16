








package org.plazy.ui {
	
	import flash.display.MovieClip;
	import org.plazy.BaseDisplayObject;
	import org.plazy.Err;
	import org.plazy.hc.HCFramer;
	
	final public class UIMovieClip extends BaseDisplayObject {
		
		// ext
		
		private var on_finish:Function;
		private var self_kill:Boolean;
		
		// vars
		
		private var framer:HCFramer;
		private var repeats_allowed:int;
		private var repeats_passed:int;
		private var on_air:Boolean;
		
		// objects
		
		private var mc:MovieClip;
		
		// constructor
		
		public function UIMovieClip () {
			//log('UIMovieClip: ' + (new Error()).getStackTrace(), 0x888888);
			set_name(this);
			super();
			framer = new HCFramer();
		}
		
		public function set onFinish (_f:Function):void { on_finish = _f; }
		public function set seflKill (_bool:Boolean):void { self_kill = _bool; }
		public function get in_play ():Boolean { return on_air; }
		
		public override function kill ():void {
			CONFIG::LLOG { log('kill') }
			//log(' /// ' + (new Error()).getStackTrace());
			on_finish = null;
			if (framer != null) { framer.kill(); framer = null; }
			rem_mc();
			super.kill();
		}
		
		public function init2 (_mc:MovieClip):void {
			if (!super.init()) { return; }
			
			rem_mc();
			framer.rem_frame();
			
			if (_mc == null) {
				CONFIG::LLOG { log('ERR: mc is null', 0xFF0000) }
				return;
			}
			
			mc = _mc;
			mc.gotoAndStop(1);
			addChild(mc);
		}
		
		public function start (_start_frame:int = 2, _repeats:int = 1):void {
			framer.set_frame(frame_hr);
			repeats_allowed = _repeats;
			repeats_passed = 0;
			on_air = true;
			
			if (mc == null) {
				stop();
				return;
			}
			
			mc.gotoAndPlay(_start_frame);
		}
		
		public function stop (_stop_frame:int = 1):void {
			if (!on_air) { return; }
			
			framer.rem_frame();
			on_air = false;
			
			if (mc != null) { mc.gotoAndStop(_stop_frame); }
			
			var finish_hr:Function = on_finish;
			
			if (self_kill) { kill(); }
			
			if (finish_hr != null) {
				try { finish_hr(); }
				catch (e:Error) { error_def_hr(Err.generate('on_finish failed: ', e, true)); }
			}
			
		}
		
		private function frame_hr ():void {
			
			if (mc == null) {
				stop();
				return;
			}
			
			if (mc.currentFrame == mc.totalFrames - 1) {
				repeats_passed++;
				if (repeats_allowed == 0 || repeats_passed < repeats_allowed) {
					mc.gotoAndPlay(2);
				} else {
					stop();
				}
			}
			
		}
		
		private function rem_mc ():void {
			if (mc != null) {
				removeChild(mc);
				mc.gotoAndStop(1);
				mc = null;
			}
		}
		
	}
	
}









