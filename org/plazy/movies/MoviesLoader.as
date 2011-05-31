








package org.plazy.movies {
	
	import org.plazy.utils.io.StreamBIN;
	
	import flash.utils.ByteArray;
	
	CONFIG::LLOG { import org.plazy.Logger; }
	
	final public class MoviesLoader {
		
		// vars
		
		private var url:String;
		private var hr_list:Array = [];
		private var progress_hr_list:Array = [];
		private var bytes:ByteArray;
		
		// objects
		
		private var ldr:StreamBIN;
		
		// constructor
		
		public function MoviesLoader () {
			CONFIG::LLOG { log('new') }
		}
		
		public function init (_url:String):void {
			url = _url;
			ldr = new StreamBIN();
			ldr.set_timeout(10000);
			ldr.onError = ldr_error_hr;
			ldr.onProgress = ldr_progress_hr;
			ldr.onComplete = ldr_complete_hr;
			ldr.load(url, 'GET', null);
		}
		
		public function kill ():void {
			CONFIG::LLOG { log('kill') }
			bytes = null;
			ldr_rem();
			hr_list = [];
		}
		
		public function add_hr (_hr:Function, _progress_hr:Function):void {
			if (bytes == null) {
				hr_list.push(_hr);
				if (_progress_hr != null) {
					progress_hr_list.push(_progress_hr);
				}
				return;
			}
			_hr(bytes);
		}
		
		public function rem_hr (_hr:Function, _progress_hr:Function):void {
			var i:int;
			if (_hr != null) {
				for (i = 0; i < hr_list.length; i++) {
					if (hr_list[i] == _hr) {
						hr_list.splice(i, 1);
						i--;
					}
				}
			}
			if (_progress_hr != null) {
				for (i = 0; i < progress_hr_list.length; i++) {
					if (progress_hr_list[i] == _hr) {
						progress_hr_list.splice(i, 1);
						i--;
					}
				}
			}
		}
		
		public function fill (_url:String, _bytes:ByteArray):void {
			url = _url;
			bytes = _bytes;
		}
		
		public function is_ready ():Boolean { return bytes != null; }
		
		private function ldr_error_hr (_err:String):void {
			CONFIG::LLOG { log('ldr_error_hr "' + _err + '"', 0x990000) }
			dispatch_bytes();
		}
		
		private function ldr_progress_hr (_pc:Number):void {
			var progress_hr:Function;
			for each (progress_hr in progress_hr_list) {
				progress_hr(_pc);
			}
		}
		
		private function ldr_complete_hr ():void {
			CONFIG::LLOG { log('ldr_complete_hr', 0x009900) }
			dispatch_bytes();
		}
		
		private function dispatch_bytes ():void {
			bytes = ldr.get_bytes();
			for each (var hr:Function in hr_list) {
				hr(bytes);
			}
			ldr_rem();
			hr_list = [];
		}
		
		private function ldr_rem ():void {
			if (ldr != null) { ldr.kill(); ldr = null; }
		}
		
		CONFIG::LLOG {
			private function log (_t:String, _c:int = 0x000000):void {
				Logger.me.add('imgs:MoviesLoader ' + _t, _c);
			}
		}
		
	}
	
}









