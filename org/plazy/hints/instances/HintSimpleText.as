








package org.plazy.hints.instances {
	
	import org.plazy.BaseDisplayObject;
	import org.plazy.txt.UITxt;
	import org.plazy.txt.UILabel;
	
	final public class HintSimpleText extends BaseDisplayObject {
		
		// objects
		
		private var tf:UILabel;
		
		// constructor
		
		public function HintSimpleText () {
			set_name(this);
			super();
			mouseEnabled = false;
		}
		
		public function init2 (_t:String):Boolean {
			CONFIG::LLOG { log('init ' + _t) }
			
			rem_tf();
			
			tf = new UILabel(_t, 0, 0, -6, -6, UITxt.frm(12, 0x000000, false));
			addChild(tf);
			
			graphics.beginFill(0xFFFF00, 0.9);
			graphics.drawRect(0, 0, tf.width, tf.height);
			graphics.endFill();
			
			return true;
		}
		
		public override function kill ():void {
			CONFIG::LLOG { log('kill') }
			super.kill();
			tf = null;
		}
		
		private function rem_tf ():void {
			if (tf != null) { tf.kill(); tf = null; }
		}
		
	}
	
}









