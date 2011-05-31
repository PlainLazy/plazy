








package org.plazy.utils {
	
	final public class TimeUtils {
		
		public function TimeUtils () { }
		
		public static function now ():int {
			return int(now_ms() / 1000);
		}
		
		public static function now_ms ():Number {
			var d:Date = new Date();
			return d.getTime();
		}
		
		public static function zf02 (_val:int):String {
			return _val >= 10 ? String(_val) : '0' + _val;
		}
		
		public static function time2string (_sec:int, _hours:Boolean = true, _minutes:Boolean = true):String {
			if (_sec < 0) { _sec = 0; };
			var result:Array = [];
			if (_hours) {
				var hh:int = int(_sec / 60 / 60);
				if (hh > 0) { _sec -= hh * 60 * 60; }
				result.push(zf02(hh));
			}
			if (_minutes || _hours) {
				var mm:int = int(_sec / 60);
				if (mm > 0) { _sec -= mm * 60; }
				result.push(zf02(mm));
			}
			result.push(zf02(_sec));
			return result.join(':');
		}
		
	}

}









