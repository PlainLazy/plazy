








package org.plazy.ui.list {
	
	public interface IUIListItem {
		
		function set onMouseDown (_f:Function):void;
		function set onFocus (_f:Function):void;
		function set_y (_y:int):void;
		function get top_y ():int;
		function get bottom_y ():int;
		function get he ():int;
		function set_data (_list_item:DiListItem):void;
		function set focus (_bool:Boolean):void;
		function kill ():void;
		
	}
	
}









