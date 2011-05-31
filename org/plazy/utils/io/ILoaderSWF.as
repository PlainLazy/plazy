








package org.plazy.utils.io {
	
	import flash.system.ApplicationDomain;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	
	public interface ILoaderSWF extends ILoaderBase {
		
		function load (_src:String, _method:String, _params:Object, _domain:ApplicationDomain, _check_policy:Boolean):void;
		function get_bd ():BitmapData;
		function get_content ():DisplayObject;
		function get_app_dom ():ApplicationDomain;
		
	}
	
}









