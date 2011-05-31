








package org.plazy.utils {
	
	import flash.utils.ByteArray;
	
	public class Bytes {
		
		public function Bytes () { }
		
		/// return true if byte arrays is not equal
		public static function is_different (_b1:ByteArray, _b2:ByteArray):Boolean {
			if (_b1.length != _b2.length) { return true; }
			
			var p1:uint = _b1.position;
			var p2:uint = _b2.position;
			
			_b1.position = 0;
			_b2.position = 0;
			
			var full_match:Boolean = true;
			
			var hi:uint;
			for (hi = 0; hi < _b1.length; hi++) {
				if (_b1[hi] != _b2[hi]) {
					full_match = false;
					break;
				}
			}
			
			_b1.position = p1;
			_b2.position = p2;
			
			return !full_match;
		}
		
		/// invert all bytes
		public static function invert (_b:ByteArray):void {
			var i:int;
			for (i = 0; i < _b.length; i++) {
				_b[i] = 0xFF - _b[i];
			}
		}
		
	}
	
}









