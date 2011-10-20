








package org.plazy.ui {
	
	import flash.geom.Rectangle;
	import flash.display.BitmapData;
	
	public class UICheckBoxStyle {
		
		public var bg:BitmapData;
		public var mark:BitmapData;
		
		public function UICheckBoxStyle () { }
		
		public function make_defaults ():void {
			
			bg = new BitmapData(18, 18, true, 0x00000000);
			bg.fillRect(new Rectangle(0, 0, 18, 18), 0xFF000000);
			bg.fillRect(new Rectangle(1, 1, 16, 16), 0x00000000);
			
			mark = bg.clone();
			mark.fillRect(new Rectangle(4, 4, 10, 10), 0xFF000000);
			
		}
		
	}
	
}









