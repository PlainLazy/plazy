








package org.plazy.utils.io {
	
	public class myURL {
		
		private var base_url:String = '';
		public var params:Object = {};
		
		public function myURL (_url:String = null) {
			if (_url != null) {
				parse_url(_url);
			}
		}
		
		public function set url (_url:String):void {
			parse_url(_url);
		}
		
		public function get url ():String {
			return pack_url();
		}
		
		private function pack_url ():String {
			var suffix:Array = [];
			if (params != null) {
				var key:String;
				for (key in params) {
					suffix.push(key + '=' + params[key]);
				}
			}
			return base_url + (suffix.length > 0 ? '?' + suffix.join('&') : '');
		}
		
		private function parse_url (_str:String):void {
			var base_pair:Array = _str.split('?');
			base_url = base_pair.shift();
			params = {};
			if (base_pair.length > 0) {
				var param_pairs:Array = base_pair.join('?').split('&');
				var pair:Array;
				var key:String;
				for each (key in param_pairs) {
					pair = key.split('=');
					params[pair.shift()] = pair.join('=');
				}
			}
		}
		
	}
	
}









