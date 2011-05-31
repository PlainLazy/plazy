








package org.plazy.imgs {
	
	import org.plazy.Err;
	import org.plazy.utils.io.LoaderSWF;
	
	import flash.display.BitmapData;
	
	CONFIG::LLOG { import org.plazy.Logger; }
	
	final public class ImgsLoader {
		
		// vars
		
		private var url:String;
		private var hr_list:Array = [];
		private var progress_hr_list:Array = [];
		private var bmpd:BitmapData;
		
		// objects
		
		private var ldr:LoaderSWF;
		
		// constructor
		
		public function ImgsLoader () {
			CONFIG::LLOG { log('new'); }
		}
		
		public function init (_url:String):Boolean {
			url = _url;
			ldr = new LoaderSWF();
			ldr.set_timeout(8000);
			ldr.onError     = ldr_error_hr;
			ldr.onProgress  = ldr_progress_hr;
			ldr.onComplete  = ldr_complete_hr;
			return ldr.load(url, 'POST', null, null, false);
		}
		
		public function kill ():void {
			CONFIG::LLOG { log('kill'); }
			bmpd = null;
			ldr_rem();
			hr_list = [];
		}
		
		public function add_hr (_hr:Function, _progress_hr:Function):void {
			if (bmpd == null) {
				hr_list.push(_hr);
				if (_progress_hr != null) {
					progress_hr_list.push(_progress_hr);
				}
				return;
			}
			_hr(bmpd);
		}
		
		public function rem_hr (_hr:Function, _progress_hr:Function):void {
			var i:int;
			if (_hr != null) {
				for (i = 0; i < hr_list.length; i++) {
					if (hr_list[i] == _hr) {
						hr_list.splice(i, 1);
						if (i > 0) {
							i--;
						}
					}
				}
			}
			if (_progress_hr != null) {
				for (i = 0; i < progress_hr_list.length; i++) {
					if (progress_hr_list[i] == _progress_hr) {
						progress_hr_list.splice(i, 1);
						if (i > 0) {
							i--;
						}
					}
				}
			}
		}
		
		public function fill (_url:String, _bd:BitmapData):void {
			url = _url;
			bmpd = _bd;
		}
		
		public function is_ready ():Boolean { return bmpd != null; }
		
		private function ldr_error_hr (_err:String):void {
			CONFIG::LLOG { log('ldr_error_hr "' + _err + '"', 0x990000) }
			dispatch_bmpd();
		}
		
		private function ldr_progress_hr (_pc:Number):void {
			var progress_hr:Function;
			for each (progress_hr in progress_hr_list) {
				try { progress_hr(_pc); }
				catch (e:Error) { CONFIG::LLOG { log(Err.generate('progress_hr failed: ', e, true), 0xFF0000); } }
			}
		}
		
		private function ldr_complete_hr ():void {
			CONFIG::LLOG { log('ldr_complete_hr', 0x009900) }
			dispatch_bmpd();
		}
		
		private function dispatch_bmpd ():void {
			bmpd = ldr.get_bd();
			var hr:Function;
			for each (hr in hr_list) {
				try { hr(bmpd); }
				catch (e:Error) { CONFIG::LLOG { log(Err.generate('dispatch hr failed :', e, true), 0xFF0000); } }
			}
			ldr_rem();
			hr_list = [];
		}
		
		private function ldr_rem ():void {
			if (ldr != null) { ldr.kill(); ldr = null; }
		}
		
		CONFIG::LLOG {
			private function log (_t:String, _c:int = 0x000000):void {
				Logger.me.add('imgs.ImgsLoader ' + _t, _c);
			}
		}
		
	}
	
}









