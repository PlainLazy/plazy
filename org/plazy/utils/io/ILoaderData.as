








package org.plazy.utils.io {
	
	public interface ILoaderData extends ILoaderBase {
		
		function load (_src:String, _method:String, _params:Object):Boolean;
		function get_data ():String;
		
	}
	
}









