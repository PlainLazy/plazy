








package org.plazy.ui.select {
	
	import org.plazy.hc.HCStage;
	import org.plazy.ui.UIPic;
	import org.plazy.ui.UISen;
	import org.plazy.ui.list.DiListItem;
	
	import flash.events.MouseEvent;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	public class UISelect extends Sprite {
		
		private var style:UISelectStyle;
		
		private var data_list:Vector.<DiListItem>;
		
		private var on_open:Function;
		private var on_select:Function;
		
		private var tail:UiSelectTail;
		
		private var current_item:IUISelectItem;
		
		private var bt_open_img:UIPic;
		private var bt_open:UISen;
		
		private var is_opened:Boolean;
		
		private var stager:HCStage;
		
		public function UISelect () {
			
			stager = new HCStage(this);
			
//			graphics.beginFill(0xFFFF00, 0.5);
//			graphics.drawRect(-100, 100, 200, 200);
//			graphics.endFill();
			
		}
		
		public function set onOpen (_f:Function):void { on_open = _f; }
		public function set onSelect (_f:Function):void { on_select = _f; }
		
		public function init (_style:UISelectStyle):void {
			
			style = _style;
			
			bt_open_img = new UIPic(style.bd_btn_open, style.wi - style.bd_btn_open.width, 0);
			addChild(bt_open_img);
			
			bt_open = new UISen(bt_open_img.x, 0, bt_open_img.width, bt_open_img.height);
			bt_open.onClick = open_hr;
			addChild(bt_open);
			
		}
		
		public function kill ():void {
			
			rem_current_item();
			
			style = null;
			
			on_open = null;
			on_select = null;
			
			bt_open_img.kill();
			bt_open_img = null;
			
			bt_open.kill();
			bt_open = null;
			
			if (tail != null) { tail.kill(); tail = null; }
			
			stager.kill();
			stager = null;
			
			if (parent != null) { parent.removeChild(this); }
			
		}
		
		public function set_list (_items_class:Class, _data_list:Vector.<DiListItem>):void {
			
			rem_current_item();
			
			current_item = new _items_class();
			current_item.mouse_active = false;
			addChild(current_item as DisplayObject);
			
			if (is_opened) {
				open_hr();
			}
			
			if (_items_class == null || _data_list == null) {
				return;
			}
			
			check_tail();
			
			data_list = _data_list;
			tail.set_list(_items_class, data_list);
			
		}
		
		public function set_current (_data_key:String, _data_value:*):void {
			CONFIG::LLOG { log('set_current ' + _data_key + '=' + _data_value) }
			
			var data:Object;
			var index:int;
			for (index = 0; index < data_list.length; index++) {
				data = data_list[index];
				log(' // ' + data[_data_key] + ' ? ' + _data_value);
				if (data[_data_key] == _data_value) {
					log(' // found');
					current_item.set_data(data_list[index]);
					return;
				}
			}
			
			log(' // not found');
			
			current_item.set_data(data_list[0]);
			
		}
		
		private function open_hr ():void {
			CONFIG::LLOG { log('open_hr ' + is_opened) }
			
			is_opened = !is_opened;
			
			if (is_opened) {
				tail_open();
			} else {
				tail_close();
			}
			
		}
		
		private function tail_open ():void {
			CONFIG::LLOG { log('tail_open') }
			
			stager.onMouseUp = stage_mouse_up_hr;
			
			check_tail();
			
			if (on_open != null) {
				on_open();
			}
			
			if (!contains(tail)) {
				addChild(tail);
			}
			
			if (parent != null) {
				parent.addChild(this);
			}
			
		}
		
		private function tail_close ():void {
			CONFIG::LLOG { log('tail_close') }
			
			if (tail != null && contains(tail)) {
				removeChild(tail);
			}
			
		}
		
		private function select_hr (_index:int):void {
			CONFIG::LLOG { log('select_hr ' + _index) }
			
			stager.onMouseUp = null;
			
			open_hr();
			
			current_item.set_data(data_list[_index]);
			
			if (on_select != null) {
				on_select(_index);
			}
			
		}
		
		private function check_tail ():void {
			
			if (tail == null) {
				
				tail = new UiSelectTail();
				tail.init(style);
				tail.y = 20;
				tail.onMouseDown = mouse_down_hr;
				tail.onSelect = select_hr;
				
			}
			
		}
		
		private function rem_current_item ():void {
			
			if (current_item != null) {
				current_item.kill();
				current_item = null;
			}
			
		}
		
		private function mouse_down_hr ():void {
			CONFIG::LLOG { log('mouse_down_hr') }
			//log('  ' + (new Error()).getStackTrace());
			
			stager.onMouseUp = function ():void {
				stager.onMouseUp = stage_mouse_up_hr;
			};
			
		}
		
		private function stage_mouse_up_hr ():void {
			CONFIG::LLOG { log('stage_mouse_up_hr') }
			
			stager.onMouseUp = null;
			open_hr();
			
		}
		
		private function log (_t:String):void {
			trace('> UiSelect ' + _t);
		}
		
	}
	
}









