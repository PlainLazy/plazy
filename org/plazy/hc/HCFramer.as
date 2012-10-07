








package org.plazy.hc {
	
	import flash.events.Event;
	import org.plazy.StageController;
	
	//final public class HCFramer implements IHCFramer {
	final public class HCFramer {
		
		private var on_frame:Function;
		private var in_frame:Boolean;
		
		public function HCFramer () { }
		
		public function kill ():void {
			on_frame = null;
			rem_frame();
		}
		
		public function get inFrame ():Boolean { return in_frame; }
		
		public function set_frame (_handler:Function, _apply:Boolean = false):void {
			rem_frame();
			on_frame = _handler;
			in_frame = true;
			StageController.me.stage.addEventListener(Event.ENTER_FRAME, frame_hr);
			if (_apply && on_frame != null) { on_frame(); }
		}
		
		public function rem_frame ():void {
			if (in_frame) {
				in_frame = false;
				StageController.me.stage.removeEventListener(Event.ENTER_FRAME, frame_hr);
			}
		}
		
		private function frame_hr (e:Event):void {
			if (in_frame && on_frame != null) { on_frame(); }
		}
		
	}
	
}









