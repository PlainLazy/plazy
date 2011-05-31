








package org.plazy.ui.select {
	
	import org.plazy.ui.list.DiListItem;
	
	public interface IUISelectItem {
		
		function set_data (_list_item:DiListItem):void;
		function set mouse_active (_bool:Boolean):void;
		function kill ():void;
		
	}
	
}









