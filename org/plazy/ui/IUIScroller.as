








package org.plazy.ui {
	
	import flash.display.Stage;
	
	public interface IUIScroller {
		
		function set onPos (_f:Function):void;
		function set onLock (_f:Function):void;
		function set onShift (_f:Function):void;
		function set onHide (_f:Function):void;
		function set onGlueBottom (_f:Function):void;
		function set canBeHidden (_bool:Boolean):void;
		function set canGlueBottom (_bool:Boolean):void;
		function init (_style:UIScrollerStyle, _stg:Stage, _x:int, _y:int):void;
		
	}
	
}









