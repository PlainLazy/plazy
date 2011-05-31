








package org.plazy.ui {
	
	import org.plazy.IBaseDisplayObject;
	
	public interface IUILocker extends IBaseDisplayObject {
		
		function set_size (_w:int, _h:int):void;
		function set active (_bool:Boolean):void;
		function set onClick (_f:Function):void;
		function reset ():void;
		
	}
	
}









