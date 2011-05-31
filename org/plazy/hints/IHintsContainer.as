








package org.plazy.hints {
	
	import org.plazy.BaseDisplayObject;
	import org.plazy.IBaseDisplayObject;
	
	public interface IHintsContainer extends IBaseDisplayObject {
		
		function show (_cont:BaseDisplayObject, _dx:int = 0, _dy:int = 0):void;
		function hide ():void;
		
	}
	
}









