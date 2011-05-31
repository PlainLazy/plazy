








package org.plazy.ui.select {
	
	import org.plazy.ui.UIScrollerStyle;
	
	import flash.display.BitmapData;
	
	public class UISelectStyle {
		
		public var wi:int;
		public var bd_btn_open:BitmapData;
		public var scroller_style:UIScrollerStyle;
		
		public function UISelectStyle () { }
		
		public function make_defaults ():void {
			wi = 200;
			bd_btn_open = new BitmapData(30, 20, true, 0x80FF0000);
		}
		
	}
	
}









