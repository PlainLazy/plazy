








package org.plazy.utils {
	
	public class StringUtils {
		
		public function StringUtils () { }
		
		public static function trim (_t:String):String {
			return _t != null ? _t.replace(/^\s+/, '').replace(/\s+$/, '') : '';
		}
		
		public static function html_safe (_t:String):String {
			return _t != null ? _t.split('&').join('&amp;').split('<').join('&lt;') : '';
		}
		
	}
	
}









