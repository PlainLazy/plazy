








package org.plazy.hc {
	
	import org.plazy.StageController;
	
	import flash.events.MouseEvent;
	import flash.display.DisplayObject;
	
	final public class HCMouseRect {
		
		// var
		
		private var cont:DisplayObject;
		private var rx1:int;
		private var ry1:int;
		private var rx2:int;
		private var ry2:int;
		
		private var is_up_listened:Boolean;
		
		// external
		
		private var on_down:Function;
		private var on_up:Function;
		private var on_click:Function;
		
		// constructor
		
		public function HCMouseRect () {
			StageController.me.stage.addEventListener(MouseEvent.MOUSE_DOWN, cont_down_hr);
			StageController.me.stage.addEventListener(MouseEvent.CLICK, cont_click_hr);
		}
		
		public function kill ():void {
			on_down = null;
			on_up = null;
			on_click = null;
			StageController.me.stage.removeEventListener(MouseEvent.MOUSE_DOWN, cont_down_hr);
			StageController.me.stage.removeEventListener(MouseEvent.CLICK, cont_click_hr);
			if (is_up_listened) {
				is_up_listened = false;
				StageController.me.stage.removeEventListener(MouseEvent.MOUSE_UP, stage_up_hr);
			}
			cont = null;
		}
		
		public function set_container (_cont:DisplayObject):void { cont = _cont; }
		
		public function set_rest (_x:int, _y:int, _w:int, _h:int):void {
			rx1 = _x;
			ry1 = _y;
			rx2 = _x + _w;
			ry2 = _y + _h;
		}
		
		public function set onDown (_f:Function):void { on_down = _f; }
		public function set onUp (_f:Function):void { on_up = _f; }
		public function set onClick (_f:Function):void { on_click = _f; }
		
		private function cont_down_hr (e:MouseEvent):void {
			if (on_down == null && on_up == null) { return; }
			if (is_in_rect()) {
				if (on_up != null) {
					is_up_listened = true;
					StageController.me.stage.addEventListener(MouseEvent.MOUSE_UP, stage_up_hr);
				}
				if (on_down != null) {
					on_down();
				}
			}
		}
		
		private function stage_up_hr (e:MouseEvent):void {
			is_up_listened = false;
			StageController.me.stage.removeEventListener(MouseEvent.MOUSE_UP, stage_up_hr);
			if (on_up != null) { on_up(); }
		}
		
		private function cont_click_hr (e:MouseEvent):void {
			if (on_click == null) { return; }
			if (is_in_rect()) { on_click(); }
		}
		
		private function is_in_rect ():Boolean {
			if (cont == null) { return false; }
			var tx:int = Math.round(cont.mouseX);
			var ty:int = Math.round(cont.mouseY);
			return rx1 <= tx && ry1 <= ty && tx <= rx2 && ty <= ry2;
		}
		
	}
	
}









