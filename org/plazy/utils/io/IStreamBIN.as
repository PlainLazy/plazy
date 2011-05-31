








package org.plazy.utils.io {
	
	import flash.utils.ByteArray;
	
	public interface IStreamBIN extends ILoaderBase {
		
		function load (_src:String, _method:String, _params:Object):Boolean;
		function get_bytes ():ByteArray;
		
	}
	
}









