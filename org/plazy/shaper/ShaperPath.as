








package org.plazy.shaper {
	
	public class ShaperPath {
		
		public var path:Array;
		
		private var cx:int;
		private var cy:int;
		
		public function ShaperPath () {
			path = [];
		}
		
		public function a_move (_x:int, _y:int):void {
			cx = _x;
			cy = _y;
			path.push(Shaper.DO_MOVE, cx, cy);
		}
		
		public function d_line (_x:int, _y:int):void {
			cx += _x;
			cy += _y;
			path.push(Shaper.DO_LINE, cx, cy);
		}
		
		public function d_curve (_x:int, _y:int, _ax:int, _ay:int):void {
			cx += _x;
			cy += _y;
			path.push(Shaper.DO_CURVE, cx - _x + _ax, cy - _y + _ay, cx, cy);
		}
		
	}
	
}









