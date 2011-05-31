








package org.plazy.ui {
	
	import flash.display.BitmapData;
	
	public class UIScrollerStyle {
		
		public var vertical:Boolean;
		
		public var background_bd:BitmapData;
		public var button_up_bd:BitmapData;
		public var button_down_bd:BitmapData;
		public var dragger_p1_bd:BitmapData;
		public var dragger_p2_bd:BitmapData;
		public var dragger_p3_bd:BitmapData;
		
		public function UIScrollerStyle () { }
		
		public function make_default ():void {
			vertical = true;
			background_bd   = new BitmapData(20, 20, true, 0x80FFFF00);
			button_down_bd  = new BitmapData(20, 20, true, 0x80FF0000);
			button_up_bd    = new BitmapData(20, 20, true, 0x80888888);
			dragger_p1_bd   = new BitmapData(20, 5, true, 0x800000FF);
			dragger_p2_bd   = new BitmapData(20, 5, true, 0x8000FFFF);
			dragger_p3_bd   = new BitmapData(20, 5, true, 0x80FF00FF);
		}
		
		public function get_bd (_w:int, _h:int):BitmapData {
			return new BitmapData(_w, _h, true, 0x00000000);
		}
		
		public function get thickness ():int {
			var ff:Function = vertical ? bdw : bdh;
			return Math.max(ff(background_bd), ff(button_up_bd), ff(button_down_bd), ff(dragger_p1_bd), ff(dragger_p2_bd), ff(dragger_p3_bd));
		}
		
		private function bdw (_bd:BitmapData):int {
			return (_bd != null) ? _bd.width : 0;
		}
		
		private function bdh (_bd:BitmapData):int {
			return (_bd != null) ? _bd.height: 0;
		}
		
	}
	
}









