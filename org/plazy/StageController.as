








package org.plazy {
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.display.Stage;
	
	final public class StageController extends BaseObject {
		
		public static const me:StageController = new StageController();
		
		private var stg:Stage;
		private var min_wi:uint;
		private var min_he:uint;
		private var resize_hrs:Vector.<Function>;
		private var lsw:uint;
		private var lsh:uint;
		private var mmove_hrs:Vector.<Function>;
		private var mwheel_hrs:Vector.<Function>;
		private var mup_hrs:Vector.<Function>;
		private var mleave_hrs:Vector.<Function>;
		private var lmx:int;
		private var lmy:int;
		
		public function StageController () {
			set_name(this);
			super();
			reset();
		}
		
		public function get stage ():Stage { return stg; }
		
		public function init (_stage:Stage, _min_wi:uint, _min_he:uint):void {
			stg = _stage;
			min_wi = _min_wi;
			min_he = _min_he;
			
			resize_apply();
			mmove_apply();
			
			stg.addEventListener(Event.RESIZE, stage_resize_hr);
			stg.addEventListener(MouseEvent.MOUSE_MOVE, mouse_move_hr);
			stg.addEventListener(MouseEvent.MOUSE_WHEEL, mouse_wheel_hr);
			stg.addEventListener(MouseEvent.MOUSE_UP, mouse_up_hr);
			stg.addEventListener(Event.MOUSE_LEAVE, mouse_leave_hr);
		}
		
		public function unfocus ():void {
			if (stg != null) {
				stg.focus = null;
			}
		}
		
		public function reset ():void {
			resize_hrs  = new Vector.<Function>();
			mmove_hrs   = new Vector.<Function>();
			mwheel_hrs  = new Vector.<Function>();
			mup_hrs     = new Vector.<Function>();
			mleave_hrs  = new Vector.<Function>();
		}
		
		public function get sw ():uint { return lsw; }
		public function get sh ():uint { return lsh; }
		public function get mx ():uint { return lmx; }
		public function get my ():uint { return lmy; }
		
		public function add_resize_hr (_f:Function, _apply:Boolean = false):void {
			rem_resize_hr(_f);
			resize_hrs.push(_f);
			if (_apply) {
				resize_apply();
				try { _f(lsw, lsh); }
				catch (e:Error) { error_def_hr(Err.generate('resize hr failed: ', e, true)); }
			}
		}
		
		public function rem_resize_hr (_f:Function):void {
			var i:int;
			for (i = 0; i < resize_hrs.length; i++) {
				if (resize_hrs[i] == _f) {
					resize_hrs.splice(i, 1);
					return;
				}
			}
		}
		
		public function add_mmove_hr (_f:Function, _apply:Boolean):void {
			rem_mmove_hr(_f);
			mmove_hrs.push(_f);
			if (_apply) {
				mmove_apply();
				try { if (!_f(lmx, lmy)) { return; } }
				catch (e:Error) { error_def_hr(Err.generate('mmove hr failed: ', e, true)); }
			}
		}
		
		public function rem_mmove_hr (_f:Function):void {
			var i:int;
			for (i = 0; i < mmove_hrs.length; i++) {
				if (mmove_hrs[i] == _f) {
					mmove_hrs.splice(i, 1);
					return;
				}
			}
		}
		
		public function add_mwheel_hr (_f:Function):void {
			rem_mwheel_hr(_f);
			mwheel_hrs.push(_f);
		}
		
		public function rem_mwheel_hr (_f:Function):void {
			var i:int;
			for (i = 0; i < mwheel_hrs.length; i++) {
				if (mwheel_hrs[i] == _f) {
					mwheel_hrs.splice(i, 1);
					return;
				}
			}
		}
		
		public function add_mup_hr (_f:Function):void {
			rem_mup_hr(_f);
			mup_hrs.push(_f);
		}
		
		public function rem_mup_hr (_f:Function):void {
			var i:int;
			for (i = 0; i < mup_hrs.length; i++) {
				if (mup_hrs[i] == _f) {
					mup_hrs.splice(i, 1);
					return;
				}
			}
		}
		
		public function add_mleave_hr (_f:Function):void {
			rem_mleave_hr(_f);
			mleave_hrs.push(_f);
		}
		
		public function rem_mleave_hr (_f:Function):void {
			var i:int;
			for (i = 0; i < mleave_hrs.length; i++) {
				if (mleave_hrs[i] == _f) {
					mleave_hrs.splice(i, 1);
					return;
				}
			}
		}
		
		private function resize_apply ():void {
			lsw = stg.stageWidth;
			lsh = stg.stageHeight;
			if (lsw < min_wi) { lsw = min_wi; }
			if (lsh < min_he) { lsh = min_he; }
		}
		
		private function mmove_apply ():void {
			lmx = stg.mouseX;
			lmy = stg.mouseY;
		}
		
		private function stage_resize_hr (_e:Event):void {
			resize_apply();
			var hr:Function;
			for each (hr in resize_hrs) {
				try { hr(lsw, lsh); }
				catch (e:Error) { error_def_hr(Err.generate('resize hr failed: ', e, true)); return; }
			}
		}
		
		private function mouse_move_hr (_e:MouseEvent):void {
			mmove_apply();
			var hr:Function;
			for each (hr in mmove_hrs) {
				try {
					if (!hr(lmx, lmy)) {
						CONFIG::LLOG { log('mouse move hr failed by return status', 0x990000) }
						return;
					}
				} catch (e:Error) { error_def_hr(Err.generate('mmove hr failed: ', e, true)); return; }
			}
		}
		
		private function mouse_wheel_hr (_e:MouseEvent):void {
			var hr:Function;
			for each (hr in mwheel_hrs) {
				try {
					if (!hr(_e.delta)) {
						CONFIG::LLOG { log('mouse wheel hr failed by return status', 0x990000) }
						return;
					}
				} catch (e:Error) { error_def_hr(Err.generate('mwheel hr failed: ', e, true)); return; }
			}
		}
		
		private function mouse_up_hr (_e:MouseEvent):void {
			var hr:Function;
			for each (hr in mup_hrs) {
				try {
					if (!hr()) {
						CONFIG::LLOG { log('mouse up hr failed by return status', 0x990000) }
						return;
					}
				} catch (e:Error) { error_def_hr(Err.generate('mup hr failed: ', e, true)); return; }
			}
		}
		
		private function mouse_leave_hr (_e:Event):void {
			var hr:Function;
			for each (hr in mleave_hrs) {
				try {
					if (!hr()) {
						CONFIG::LLOG { log('mouse leave hr failed by return status', 0x990000) }
						return;
					}
				} catch (e:Error) { error_def_hr(Err.generate('mleave hr failed: ', e, true)); return; }
			}
		}
		
	}
	
}









