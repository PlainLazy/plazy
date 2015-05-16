








package org.plazy.utils {
	
	public class Obj {
		
		public function Obj () { }
		
		public static function find (_src:Object, ... _way:Array):Object {
			if (_src == null || _way == null) { return null; }
			var src:Object = _src;
			var w:Array = _way.concat();
			while (w.length > 0) {
				src = src[w.shift()];
				if (src == null) { return null; }
			}
			return src;
		}
		
	}
	
}









