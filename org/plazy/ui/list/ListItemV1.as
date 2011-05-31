








package org.plazy.ui.list {
	
	import org.plazy.BaseDisplayObject;
	import org.plazy.ui.UISen;
	import org.plazy.ui.select.IUISelectItem;
	import org.plazy.txt.UITxt;
	import org.plazy.txt.UILabel;
	
	final public class ListItemV1 extends BaseDisplayObject implements IUIListItem, IUISelectItem {
		
		// const
		
		private const hh:int = 20;
		
		// vars
		
		private var on_mouse_down:Function;
		private var on_focus:Function;
		
		private var in_focus:Boolean;
		private var in_over:Boolean;
		
		private var ww:int;
		
		// objects
		
		private var label:UILabel;
		private var sen:UISen;
		
		// constructor
		
		public function ListItemV1 () {
			set_name(this);
			super();
		}
		
		public function set onMouseDown (_f:Function):void { on_mouse_down = _f; }
		public function set onFocus (_f:Function):void { on_focus = _f; }
		public function set_y (_y:int):void { y = _y; }
		public function get top_y ():int { return y; }
		public function get bottom_y ():int { return y + he; }
		public function get he ():int { return hh; }
		
		public override function kill ():void {
			CONFIG::LLOG { log('kill') }
			on_mouse_down = null;
			on_focus = null;
			super.kill();
			label = null;
			sen = null;
		}
		
		public function set_data (_list_item:DiListItem):void {
			var txt:String = _list_item.label;
			
			if (label == null) {
				label = new UILabel(txt, 0, 1, -6, -6, UITxt.frm());
				addChild(label);
			} else {
				label.update_text(txt);
			}
			
			ww = _list_item.width;
			
			if (ww < 30) { ww = 30; }
			
			if (sen == null) {
				sen = new UISen(0, 0, ww, hh);
				sen.onOver = sen_over_hr;
				sen.onOut = sen_out_hr;
				sen.onDown = sen_down_hr;
				sen.onClick = sen_click_hr;
				addChild(sen);
			}
			
			update_bg();
		}
		
		public function set mouse_active (_bool:Boolean):void {
			mouseEnabled = _bool;
			mouseChildren = _bool;
		}
		
		public function set focus (_bool:Boolean):void {
			if (in_focus == _bool) { return; }
			in_focus = _bool;
			update_bg();
		}
		
		private function update_bg ():void {
			graphics.clear();
			graphics.beginFill(0x888888, 1);
			graphics.drawRect(0, 0, ww, hh + 1);
			graphics.beginFill(in_focus ? (in_over ?  0x66FF66 : 0xAAFFAA) : (in_over ? 0xEEEEAA : 0xFFFFFF), 1);
			graphics.drawRect(1, 1, ww - 2, hh - 1);
			graphics.endFill();
		}
		
		private function sen_over_hr ():void {
			in_over = true;
			update_bg();
		}
		
		private function sen_out_hr ():void {
			in_over = false;
			update_bg();
		}
		
		private function sen_down_hr ():void {
			if (on_mouse_down != null) { on_mouse_down(); }
		}
		
		private function sen_click_hr ():void {
			if (in_focus) { return; }
			if (on_focus != null) { on_focus(); }
		}
		
	}
	
}









