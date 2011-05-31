








package org.plazy.ui.select {
	
	import org.plazy.StageController;
	import org.plazy.ui.UIScroller;
	import org.plazy.ui.UIScrollerStyle;
	import org.plazy.ui.list.DiListItem;
	import org.plazy.ui.list.UIList;
	import org.plazy.ui.list.UIListStyle;
	
	import flash.display.Sprite;
	
	public class UiSelectTail extends Sprite {
		
		private var on_mouse_down:Function;
		private var on_select:Function;
		
		private var ui_list:UIList;
		private var ui_scroller:UIScroller;
		
		public function UiSelectTail () { }
		
		public function set onMouseDown (_f:Function):void { on_mouse_down = _f; }
		public function set onSelect (_f:Function):void { on_select = _f; }
		
		public function init (_style:UISelectStyle):void {
			CONFIG::LLOG { log('init') }
			
			var ls:UIListStyle = new UIListStyle();
			ls.wi = _style.wi - 20;
			
			ui_list = new UIList();
			ui_list.init(ls);
			ui_list.set_height(_style.wi);
			ui_list.onMouseDown = mouse_down_hr;
			ui_list.onFocus = focus_hr;
			addChild(ui_list);
			
			ui_scroller = new UIScroller();
			ui_scroller.init(_style.scroller_style, StageController.me.stage, _style.wi, 0);
			ui_scroller.x = _style.wi - ui_scroller.height;
			ui_scroller.set_length(200);
			ui_scroller.set_vis(ui_list.get_vis());
			ui_scroller.set_pos(0);
			ui_scroller.onMouseDown = mouse_down_hr;
			addChild(ui_scroller);
			
			ui_scroller.onPos = ui_list.set_pos;
			ui_scroller.onShift = ui_list.shift;
			ui_list.onPos = ui_scroller.set_pos;
			ui_list.onFocus = focus_hr;
			
		}
		
		public function kill ():void {
			CONFIG::LLOG { log('kill') }
			
			ui_list.kill();
			ui_list = null;
			
			ui_scroller.kill();
			ui_scroller = null;
			
			on_mouse_down = null;
			on_select = null;
			
			if (parent != null) {
				parent.removeChild(this);
			}
			
		}
		
		public function set_list (_items_class:Class, _data_list:Vector.<DiListItem>):void {
			CONFIG::LLOG { log('set_list') }
			
			ui_list.set_list(_items_class, _data_list);
			ui_scroller.set_vis(ui_list.get_vis());
			
		}
		
		private function focus_hr (_index:int):void {
			CONFIG::LLOG { log('focus_hr ' + _index) }
			if (on_select != null) { on_select(_index); }
		}
		
		private function mouse_down_hr ():void {
			if (on_mouse_down != null) { on_mouse_down(); }
		}
		
		private function log (_t:String):void {
			trace('> UiSelectTail ' + _t);
		}
		
	}
	
}









