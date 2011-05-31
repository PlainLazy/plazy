








package org.plazy.ui {
	
	import org.plazy.txt.UILabel;
	
	import flash.display.Stage;
	import flash.filters.GlowFilter;
	
	final public class UIButton extends UISen {
		
		// constructor
		
		public function UIButton (_t:String, _x:int, _y:int, _w:int, _stg:Stage = null) {
			
			var tf:UILabel = new UILabel(_t, 5, 1, _w > 0 ? _w : -4, -4, UILabel.frm(11, 0x004400, true, 'center'), true, false);
			
			var w2:int = _w != -1 ? _w : tf.width + 10;
			var h2:int = tf.height + 3;
			
			super(_x, _y, w2, h2, _stg);
			
			addChild(tf);
			
		}
		
		public override function set_size (_w:int, _h:int):void {
			
			graphics.beginFill(0x000000, 1);
			graphics.drawRoundRect(0, 0, _w, _h, 13, 13);
			graphics.beginFill(0xAAFFAA, 1);
			graphics.drawRoundRect(1, 1, _w - 2, _h - 2, 9, 9);
			graphics.endFill();
			
		}
		
		public function is_glow (_bool:Boolean):void {
			
			filters = _bool ? [new GlowFilter(0x009900, 0.5, 4, 4, 2)] : null;
			
		}
		
		public override function kill ():void {
			
			graphics.clear();
			
			super.kill();
			
		}
		
	}
	
}









