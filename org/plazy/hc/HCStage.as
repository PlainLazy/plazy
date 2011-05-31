








package org.plazy.hc {
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.display.DisplayObject;
	
	public class HCStage {
		
		private var obj:DisplayObject;
		private var is_listened:Boolean;
		private var is_mouse_up:Boolean;
		private var on_stage:Function;
		private var on_mouse_up:Function;
		
		public function HCStage (_obj:DisplayObject) {
			if (_obj == null) { return; }
			obj = _obj;
			if (obj.stage == null) {
				set_listen(true);
			}
		}
		
		public function kill ():void {
			on_stage = null;
			on_mouse_up = null;
			set_listen(false);
			set_mouse_up(false);
			obj = null;
		}
		
		public function set onStage (_f:Function):void {
			if (obj.stage != null) {
				_f(obj.stage);
			} else {
				on_stage = _f;
			}
		}
		
		public function set onMouseUp (_f:Function):void {
			on_mouse_up = _f;
			set_mouse_up(true);
		}
		
		private function set_listen (_bool:Boolean):void {
			if (is_listened == _bool) { return; }
			is_listened = _bool;
			if (is_listened) {
				obj.addEventListener(Event.ADDED_TO_STAGE, added_to_stage_hr);
			} else {
				obj.removeEventListener(Event.ADDED_TO_STAGE, added_to_stage_hr);
			}
		}
		
		private function set_mouse_up (_bool:Boolean):void {
			if (obj.stage == null) { return; }
			if (is_mouse_up == _bool) { return; }
			is_mouse_up = _bool;
			if (is_mouse_up) {
				obj.stage.addEventListener(MouseEvent.MOUSE_UP, stage_mouse_up_hr);
			} else {
				obj.stage.removeEventListener(MouseEvent.MOUSE_UP, stage_mouse_up_hr);
			}
		}
		
		private function added_to_stage_hr (e:Event):void {
			set_listen(false);
			if (on_stage != null) { on_stage(obj.stage); }
			if (on_mouse_up != null) { set_mouse_up(true); }
		}
		
		private function stage_mouse_up_hr (e:MouseEvent):void {
			if (on_mouse_up != null) { on_mouse_up(); }
		}
		
	}
	
}









