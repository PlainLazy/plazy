








package org.plazy.utils.io {
	
	public interface ILoaderBase {
		
		function set onLog (_f:Function):void;
		function set onComplete (_f:Function):void;
		function set onProgress (_f:Function):void;
		function set onError (_f:Function):void;
		
		function set_timeout (_val:int):void;
		
		function close ():void;
		function kill ():void;
		
	}
	
}









