








package org.plazy.ui {
	
	import org.plazy.BaseDisplayObject;
	import org.plazy.hc.HCFramer;
	import org.plazy.txt.UITxt;
	import org.plazy.txt.UIInput;
	
	final public class UIInputInt extends BaseDisplayObject {
		
		// vars
		
		private var on_change:Function;
		
		private var framer:HCFramer;
		
		// objects
		
		private var tf:UIInput;
		
		// constructor
		
		public function UIInputInt () {
			
			super();
			set_name(this);
			
			tf = new UIInput('0', 0, 1, 68, 20, UITxt.frm(12, 0x000000, false, 'center'));
			tf.tf.restrict = '-0123456789';
			tf.onFocus = tf_focus_hr;
			tf.onUnfocus = tf_unfocus_hr;
			tf.onConfirm = tf_confirm_hr;
			addChild(tf);
			
			framer = new HCFramer();
			
			graphics.beginFill(0x000000, 1);
			graphics.drawRect(0, 0, 68, 20);
			graphics.beginFill(0xCCCCCC, 1);
			graphics.drawRect(1, 1, 66, 18);
			graphics.endFill();
			
		}
		
		public function set onChange (_f:Function):void {
			on_change = _f;
		}
		
		public function set_value (_val:int):void {
			
			tf.update_text(String(_val));
			
		}
		
		private function tf_focus_hr ():void {
			
			framer.set_frame(frame_hr);
			
		}
		
		private function tf_unfocus_hr ():void {
			
			tf_confirm_hr(tf.tf.text);
			
		}
		
		private function tf_confirm_hr (_t:String):void {
			
			var num:int = int(_t);
			
			if (_t != String(num)) {
				tf.update_text(String(num));
			}
			
			if (on_change != null) {
				on_change(num);
			}
			
		}
		
		private function frame_hr ():void {
			
			tf.tf.setSelection(0, tf.tf.text.length);
			
			framer.rem_frame();
			
		}
		
		public override function kill ():void {
			CONFIG::LLOG { log('kill') }
			
			framer.kill();
			framer = null;
			
			graphics.clear();
			
			super.kill();
			
			tf = null;
			
			on_change = null;
			
		}
		
	}
	
}









