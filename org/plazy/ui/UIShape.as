








package org.plazy.ui {
	
	import flash.display.Shape;
	
	final public class UIShape extends Shape {
		
		public var borders:Boolean;
		public var borders_thinkness:Number = 1;
		public var borders_color:int = 0x000000;
		public var borders_alpha:Number = 1;
		public var fill_color:int = 0xFFFFFF;
		public var fill_alpha:Number = 1;
		
		public function UIShape (_x:int, _y:int) {
			x = _x;
			y = _y;
		}
		
		public function rect (_w:int, _h:int):void {
			prep();
			graphics.beginFill(fill_color, fill_alpha);
			graphics.drawRect(0, 0, _w, _h);
			graphics.endFill();
		}
		
		public function figure (_points:Array):void {
			prep();
			if (_points.length < 4 || _points.length % 2 != 0) { return; }
			graphics.moveTo(_points[0], _points[1]);
			graphics.beginFill(fill_color, fill_alpha);
			var i:int;
			for (i = 2; i < _points.length; i += 2) {
				graphics.lineTo(_points[i], _points[i + 1]);
			}
		}
		
		private function prep ():void {
			graphics.clear();
			if (borders) {
				graphics.lineStyle(borders_thinkness, borders_color, borders_alpha);
			}
		}
		
		public function kill ():void {
			graphics.clear();
			if (parent != null) {
				parent.removeChild(this);
			}
		}
		
	}
	
}









