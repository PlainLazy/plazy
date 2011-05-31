








package org.plazy.hc {
	
	import org.plazy.Err;
	import org.plazy.ui.UISen;
	
	import flash.display.Stage;
	import flash.display.DisplayObject;
	
	CONFIG::LLOG { import org.plazy.Logger; }
	
	final public class HCDragger {
		
		// base
		
		private var hit_area:DisplayObject;
		private var target:DisplayObject;
		private var stg:Stage;
		
		// vars
		
		public var restricted_area:Boolean;
		
		private var x1:int;
		private var y1:int;
		private var x2:int;
		private var y2:int;
		
		private var framer:HCFramer;
		
		private var lmx:int;
		private var lmy:int;
		
		private var dragged:Boolean;
		
		private var is_disabled:Boolean;
		
		// external
		
		public var on_drag_start:Function;
		public var on_drag_progress:Function;
		public var on_drag_end:Function;
		
		// objects
		
		private var sen:UISen;
		
		// constructor
		
		public function HCDragger (_hit_area:DisplayObject, _target:DisplayObject, _stg:Stage) {
			
			hit_area = _hit_area;
			target = _target;
			stg = _stg;
			
			sen = new UISen(0, 0, 0, 0, stg);
			sen.target = hit_area;
			sen.onDown = down_hr;
			
			framer = new HCFramer();
			
		}
		
		public function set onDragStart (_f:Function):void { on_drag_start = _f; }
		public function set onDragProgress (_f:Function):void { on_drag_progress = _f; }
		public function set onDragEnd (_f:Function):void { on_drag_end = _f; }
		public function set area_x1 (_val:int):void { x1 = _val; }
		public function set area_y1 (_val:int):void { y1 = _val; }
		public function set area_x2 (_val:int):void { x2 = _val; }
		public function set area_y2 (_val:int):void { y2 = _val; }
		
		public function kill ():void {
			
			framer.kill();
			framer = null;
			
			sen.kill();
			sen = null;
			
			hit_area = null;
			target = null;
			stg = null;
			
			on_drag_start = null;
			on_drag_progress = null;
			on_drag_end = null;
			
		}
		
		public function set_area (_x1:int, _y1:int, _x2:int, _y2:int):void {
			area_x1 = _x1;
			area_y1 = _y1;
			area_x2 = _x2;
			area_y2 = _y2;
		}
		
		public function cancel ():void {
			sen.rem_event(UISen.TP_UP_STAGE);
			framer.rem_frame();
		}
		
		public function set enabled (_bool:Boolean):void {
			if (!_bool) { cancel(); }
			is_disabled = !_bool;
			sen.enabled = _bool;
		}
		
		private function down_hr ():void {
			if (is_disabled) { return; }
			
			sen.onUpStage = up_hr;
			
			lmx = int(stg.mouseX);
			lmy = int(stg.mouseY);
			
			dragged = false;
			
			framer.set_frame(frame_hr);
			
			if (on_drag_start != null) {
				try {
					on_drag_start();
				} catch (e:Error) {
					log('ERR: ' + Err.generate('on_drag_start failed: ', e, true), 0xFF0000);
				}
			}
			
		}
		
		private function up_hr ():void {
			
			sen.rem_event(UISen.TP_UP_STAGE);
			
			framer.rem_frame();
			
			if (dragged && on_drag_end != null) {
				try { on_drag_end(); }
				catch (e:Error) { log('ERR: ' + Err.generate('on_drag_end failed: ', e, true), 0xFF0000); }
			}
			
		}
		
		private function frame_hr ():void {
			
			var mx:int = int(stg.mouseX);
			var my:int = int(stg.mouseY);
			
			if (lmx == mx && lmy == my) { return; }
			
			var dx:int = mx - lmx;
			var dy:int = my - lmy;
			
			var new_target_x:int = target.x + dx;
			var new_target_y:int = target.y + dy;
			
			if (restricted_area) {
				if (new_target_x < x1) {
					dx = x1 - target.x;
				} else if (new_target_x > x2) {
					dx = x2 - target.x;
				}
				if (new_target_y < y1) {
					dy = y1 - target.y;
				} else if (new_target_y > y2) {
					dy = y2 - target.y;
				}
			}
			
			lmx += dx;
			lmy += dy;
			
			dragged = true;
			
			target.x += dx;
			target.y += dy;
			
			if (on_drag_progress != null) {
				try {
					on_drag_progress();
				} catch (e:Error) {
					log('ERR: ' + Err.generate('on_drag_progress failed: ', e, true), 0xFF0000);
				}
			}
			
		}
		
		CONFIG::LLOG {
			private function log (_t:String, _c:uint = 0x000000):void {
				Logger.me.add('HCDragger ' + _t, _c);
			}
		}
		
	}
	
}









