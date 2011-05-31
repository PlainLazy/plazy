








package org.plazy {
	
	import flash.display.DisplayObject;
	
	public interface IBaseDisplayObject {
		
		function addChild (child:DisplayObject):DisplayObject;
		
		function set onError (_f:Function):void;
		
		function pos_center (_x:int, _y:int):void;
		function pos_center_b (_x:int, _y:int):void;
		function hor_line (_list:Array, _cx:int, _dx:int):void;
		function vert_line (_list:Array, _cy:int, _dy:int):void;
		function toString ():String;
		function kill ():void;
		
	}
	
}









