








package org.plazy {
	
	import org.plazy.hc.HCKeyCather;
	
	import flash.ui.Keyboard;
	import flash.display.Stage;
	
	public class PressEnterManager {
		
		public static const me:PressEnterManager = new PressEnterManager();
		
		private var handlers:Vector.<Function> = new Vector.<Function>();
		private var current_hanler:Function;
		
		private var key_catcher_down:HCKeyCather;
		private var key_catcher_up:HCKeyCather;
		
		private var down_passed:Boolean;
		
		public function PressEnterManager () { }
		
		public function init (_stage:Stage):void {
			rem_key_handlers();
			
			key_catcher_down = new HCKeyCather(_stage);
			key_catcher_down.set_catch (Keyboard.ENTER, catch_down_hr, true);
			key_catcher_down.ignore_tf = true;
			
			key_catcher_up = new HCKeyCather(_stage);
			key_catcher_up.set_catch (Keyboard.ENTER, catch_up_hr, false);
			key_catcher_up.ignore_tf = true;
		}
		
		public function kill ():void {
			rem_key_handlers();
			current_hanler = null;
			handlers = null;
		}
		
		public function register_handler (_f:Function):void {
			handlers.push(_f);
			if (current_hanler == null) {
				current_hanler = _f;
				down_passed = false;
			}
		}
		
		public function unregister_handler (_f:Function):void {
			
			var index:int;
			for (index = 0; index < handlers.length; index++) {
				if (handlers[index] == _f) {
					handlers.splice(index, 1);
					return;
				}
			}
			
			if (current_hanler == _f) {
				if (handlers.length > 0) {
					current_hanler = handlers.pop();
				} else {
					current_hanler = null;
				}
				down_passed = false;
			}
			
		}
		
		private function catch_down_hr ():void {
			if (current_hanler == null) { return; }
			down_passed = true;
		}
		
		private function catch_up_hr ():void {
			if (current_hanler == null || !down_passed) { return; }
			
			var func:Function = current_hanler;
			current_hanler = null;
			func();
			
			if (handlers.length == 0) { return; }
			
			current_hanler = handlers.pop();
			down_passed = false;
		}
		
		private function rem_key_handlers ():void {
			if (key_catcher_down != null) { key_catcher_down.kill(); key_catcher_down = null; }
			if (key_catcher_up != null) { key_catcher_up.kill(); key_catcher_up = null; }
		}
		
	}
	
}









