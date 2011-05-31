








package org.plazy.utils.io {
	
	public class FlashURL {
		
		public var src:String;
		public var time:uint;
		public var size:uint;
		
		/// example url: http://domain.com?some=params$timestamp$size
		public function FlashURL (_url:String) {
			
			if (_url == null) {
				src = '{invalid_url}';
				return;
			}
			
			var url_params:Array = [];
			var url_body:Array = _url.split('$');
			
			var head:String = url_body.shift();
			var head_parts:Array = head.split('?');
			
			src = head_parts.shift();
			
			if (head_parts.length > 0) {
				// parameters
				
				var params_list:Array = head_parts.join('?').split('&');
				var param:String;
				for each (param in params_list) {
					url_params.push(param);
				}
				
			}
			
			if (url_body.length > 0) {
				time = int(url_body.shift());
				url_params.push('ts=' + time);
			}
			
			if (url_body.length > 0) {
				size = int(url_body.shift());
			}
			
			if (url_params.length > 0) {
				src += '?' + url_params.join('&');
			}
			
		}
		
		private function date ():String {
			if (time == 0) { return ''; }
			var d:Date = new Date(time * 1000);
			return '(' + s02(d.getDate()) + '.' + s02(d.getMonth()+1) + '.' + d.getFullYear() + ' ' + d.toString().split(' ')[3] + ')';
		}
		
		private function s02 (_v:int):String {
			return (_v > 9 ? '' : '0') + String(_v);
		}
		
		public function toString ():String {
			return '{FlashURL: src=' + src + ' time=' + time + date() + ' size=' + size + '}';
		}
		
	}
	
}









