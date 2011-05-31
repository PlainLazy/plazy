








package org.plazy.shaper {
	
	import flash.display.Graphics;
	
	public class Shaper {
		
		public static const DO_MOVE:int  = 1;
		public static const DO_LINE:int  = 2;
		public static const DO_CURVE:int = 3;
		
		public function Shaper () { }
		
		public function draw (_gr:Graphics, _path:Array):void {
			if (_gr == null || _path == null) { return; }
			
			while (_path.length > 0) {
				switch (_path.shift()) {
					case DO_MOVE: {
						if (_path.length < 2) { return; }
						_gr.moveTo(_path.shift(), _path.shift());
						break;
					}
					case DO_LINE: {
						if (_path.length < 2) { return; }
						_gr.lineTo(_path.shift(), _path.shift());
						break;
					}
					case DO_CURVE: {
						if (_path.length < 4) { return; }
						_gr.curveTo(_path.shift(), _path.shift(), _path.shift(), _path.shift());
						break;
					}
					default: { return; }
				}
			}
		}
		
	}
	
}









