








package org.plazy.modal {
	
	import org.plazy.IBaseDisplayObject;
	
	public interface ISpaceObject extends IBaseDisplayObject {
		
		function set onClose (_f:Function):void;
		function init_on_space ():void;
		function force_close ():void;
		
	}
	
}









