








package org.plazy.txt {
	
	import org.plazy.Err;
	
	import flash.ui.Keyboard;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	
	final public class UIInput extends UITxt {
		
		// static
		
		// const
		
		// base
		
		// vars
		
		private var on_change:Function;
		private var on_confirm:Function;
		private var on_focus:Function;
		private var on_unfocus:Function;
		
		// objects
		
		// constructor
		
		public function UIInput (_t:String, _x:int, _y:int, _w:int, _h:int, _format:TextFormat = null, _single_line:Boolean = true, _password:Boolean = false) {
			
			super();
			
			iw = _w;
			ih = _h;
			
			tf.type = 'input';
			tf.displayAsPassword = _password;
			tf.defaultTextFormat = _format != null ? _format : UITxt.format();
			
			x = _x;
			y = _y;
			
			if (!_single_line) {
				tf.width = 800;
				tf.multiline = true;
				tf.wordWrap = true;
			}
			
			update_text(_t);
			
		}
		
		public function get_text ():String {
			
			return tf.text;
			
		}
		
		public function set onChange (_f:Function):void {
			
			if (_f == null) {
				
				if (on_change != null) {
					removeEventListener(Event.CHANGE, change_apply_hr);
					on_change = null;
				}
				
			} else {
				
				onChange = null;
				on_change = _f;
				addEventListener(Event.CHANGE, change_apply_hr);
				
			}
			
		}
		
		public function set onConfirm (_f:Function):void {
			
			if (_f == null) {
				
				if (on_confirm != null) {
					removeEventListener(KeyboardEvent.KEY_UP, test_confirm);
					on_confirm = null;
				}
				
			} else {
				
				onConfirm = null;
				on_confirm = _f;
				addEventListener(KeyboardEvent.KEY_UP, test_confirm);
				
			}
			
		}
		
		public function set onFocus (_f:Function):void {
			
			if (_f == null) {
				
				if (on_focus != null) {
					removeEventListener(FocusEvent.FOCUS_IN, focus_in_hr);
					on_focus = null;
				}
				
			} else {
				
				onFocus = null;
				on_focus = _f;
				addEventListener(FocusEvent.FOCUS_IN, focus_in_hr);
				
			}
			
		}
		
		public function set onUnfocus (_f:Function):void {
			
			if (_f == null) {
				
				if (on_unfocus != null) {
					removeEventListener(FocusEvent.FOCUS_OUT, focus_out_hr);
					on_unfocus = null;
				}
				
			} else {
				
				onUnfocus = null;
				on_unfocus = _f;
				addEventListener(FocusEvent.FOCUS_OUT, focus_out_hr);
				
			}
			
		}
		
		private function change_apply_hr (e:Event):void {
			
			if (on_change != null) {
				on_change(tf.text);
			}
			
		}
		
		private function focus_in_hr (e:FocusEvent):void {
			
			if (on_focus != null) {
				on_focus();
			}
			
		}
		
		private function focus_out_hr (e:FocusEvent):void {
			
			if (on_unfocus != null) {
				on_unfocus();
			}
			
		}
		
		private function test_confirm (e:KeyboardEvent):void {
			
			if (e.keyCode == Keyboard.ENTER) {
				if (on_confirm != null) {
					try {
						on_confirm(tf.text);
					} catch (e:Error) {
						error_def_hr(Err.generate('on_confirm failed: ', e, true));
					}
				}
			}
			
		}
		
		public override function kill ():void {
			
			on_change = null;
			on_confirm = null;
			on_focus = null;
			on_unfocus = null;
			
			super.kill();
			
		}
		
	}
	
}









