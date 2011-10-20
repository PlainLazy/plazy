








package org.plazy.ui {
	
	import org.plazy.txt.UILabel;
	import org.plazy.txt.UITxt;
	
	import flash.display.Sprite;
	
	public class UICheckBox extends Sprite {
		
		private var style:UICheckBoxStyle;
		
		private var is_checked:Boolean;
		
		private var bg:UIPic;
		private var label:UILabel;
		private var sen:UISen;
		
		private var on_change:Function;
		
		public function set onChange (_f:Function):void { on_change = _f; }
		
		public function UICheckBox (_label:String, _x:int, _y:int, _style:UICheckBoxStyle = null) {
			x = _x;
			y = _y;
			
			if (_style == null) {
				style = new UICheckBoxStyle();
				style.make_defaults();
			} else {
				style = _style;
			}
			
			bg = new UIPic();
			addChild(bg);
			
			refresh();
			
			if (_label != null) {
				label = new UILabel(_label, bg.width + 3, 0, -6, -6, UITxt.frm(12, 0x000000));
				addChild(label);
			}
			
			sen = new UISen(0, 0, bg.width, bg.height);
			sen.onClick = switch_hr;
			addChild(sen);
			
		}
		
		public function kill ():void {
			on_change = null;
			if (bg != null) { bg.kill(); bg = null; }
			if (sen != null) { sen.kill(); sen = null; }
			if (label != null) { label.kill(); label = null; }
			if (parent != null) { parent.removeChild(this); }
		}
		
		public function get checked ():Boolean { return is_checked; }
		
		public function set checked (_bool:Boolean):void {
			if (is_checked == _bool) { return; }
			is_checked = _bool;
			refresh();
		}
		
		private function switch_hr ():void {
			is_checked = !is_checked;
			refresh();
			if (on_change != null) { on_change(is_checked); }
		}
		
		private function refresh ():void {
			bg.bitmapData = checked ? style.mark : style.bg;
		}
		
	}
	
}









