








package org.plazy.ui.list {
	
	import org.plazy.Funcer;
	
	import flash.geom.Rectangle;
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.display.Sprite;
	
	public class UIList extends Sprite {
		
		private var on_mouse_down:Function;
		private var on_focus:Function;
		private var on_pos:Function;
		
		private var style:UIListStyle;
		
		private var shift_step:int = 16;
		
		private var items_class:Class;
		private var data_list:Vector.<DiListItem>;
		
		private var items:Object = {};  // key: data_list.index, value: UIListItem
		
		private var visible_he:int;
		private var content_he:int;
		private var min_cont_y:int;
		
		private var cont:Sprite;
		
		private var item_in_focus:IUIListItem;
		
		public function UIList () { }
		
		public function set onMouseDown (_f:Function):void { on_mouse_down = _f; }
		public function set onFocus (_f:Function):void { on_focus = _f; }
		public function set onPos (_f:Function):void { on_pos = _f; }
		public function set shiftStep (_val:int):void { shift_step = _val; }
		
		public function kill ():void {
			
			rem_all_items();
			
			items_class = null;
			data_list = null;
			
			removeChild(cont);
			cont = null;
			
			on_mouse_down = null;
			on_focus = null;
			on_pos = null;
			
			style = null;
			
			if (parent != null) {
				parent.removeChild(this);
			}
			
		}
		
		public function init (_style:UIListStyle):void {
			style = _style;
			cont = new Sprite();
			addChild(cont);
		}
		
		public function set_height (_val:int, use_bg:Boolean=true):void {
			
			if ( use_bg ) {
				graphics.clear();
				graphics.beginFill(0x888888, 0.3);
				graphics.drawRect(0, 0, style.wi, _val);
				graphics.endFill();
			}
				
			scrollRect = new Rectangle(0, 0, style.wi, _val);
			
			visible_he = _val;
			
			if (data_list == null || data_list.length == 0) { return; }
			
			refresh();
			
		}
		
		public function get_vis ():Number {
			//trace('**** ' + visible_he  + ' / ' + content_he + ' = ' + (visible_he / content_he));
			return content_he > 0 ? Math.min(1, visible_he / content_he) : 1;
		}
		
		public function set_pos (_pc:Number):void {
			
			var new_y:int = int(min_cont_y * _pc);
			
			if (new_y > 0) { new_y = 0; }
			
			if (cont.y != new_y) {
				cont.y = new_y;
				refresh();
			}
			
		}
		
		public function get_pos ():Number {
			//trace('*** get_pos ' + min_cont_y + ' ' + cont.y);
			
			return min_cont_y != 0 ? cont.y / min_cont_y : 0;
			
		}
		
		public function shift (_d:int):void {
			
			var new_y:int = cont.y;
			
			if (_d < 0) {
				new_y += shift_step;
				if (new_y > 0) {
					new_y = 0;
				}
			} else {
				new_y -= shift_step;
				if (new_y < min_cont_y) {
					new_y = min_cont_y;
				}
			}
			
			if (new_y > 0) { new_y = 0; }
			if (cont.y == new_y) { return; }
			
			cont.y = new_y;
			refresh();
			
			if (on_pos != null) {
				on_pos(get_pos());
			}
			
		}
		
		public function set_list (_items_class:Class, _data_list:Vector.<DiListItem>):void {
			
			rem_all_items();
			
			if (_items_class == null || _data_list == null) { return; }
			
			items_class = _items_class;
			data_list = _data_list;
			
			content_he = 0;
			var item:IUIListItem;
			var data_item:DiListItem;
			var i:int;
			for (i = 0; i < data_list.length; i++) {
				data_item = data_list[i];
				data_item.width = style.wi;
				item = new items_class();
				item.set_data(data_item);
				item.onMouseDown = mouse_down_hr;
				item.onFocus = (new Funcer()).gen_func(focus_hr, i);
				items[i] = item;
				item.set_y(item.he * i);
				if (content_he < item.bottom_y) {
					content_he = item.bottom_y;
				}
			}
			
			min_cont_y = -content_he + visible_he;
			
			if (min_cont_y > 0) { min_cont_y = 0; }
			if (cont.y < min_cont_y) { cont.y = min_cont_y; }
			
			refresh();
		}
		
		public function set_focus (_index:int):void {
			focus_hr(_index);
		}
		
		private function refresh ():void {
			
			var obj:DisplayObject;
			var item:IUIListItem;
			for each (item in items) {
				obj = item as DisplayObject;
				if (item.bottom_y < -cont.y || item.top_y > -cont.y + visible_he) {
					// invisible
					if (cont.contains(obj)) {
						cont.removeChild(obj);
					}
				} else {
					// visible
					if (!cont.contains(obj)) {
						cont.addChild(obj);
					}
				}
			}
			
		}
		
		private function focus_hr (_index:int):void {
			if (item_in_focus != null) { item_in_focus.focus = false; }
			
			var new_focused_item:IUIListItem = items[_index];
			
			if (new_focused_item == null) { return; }
			
			item_in_focus = new_focused_item;
			item_in_focus.focus = true;
			
			if (on_focus != null) { on_focus(_index); }
			
		}
		
		private function rem_all_items ():void {
			var item:IUIListItem;
			for each (item in items) {
				item.kill();
			}
			items = [];
			item_in_focus = null;
		}
		
		private function mouse_down_hr ():void {
			if (on_mouse_down != null) { on_mouse_down(); }
		}
		
	}
	
}









