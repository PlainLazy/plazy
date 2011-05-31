








package org.plazy.imgs {
	
	import flash.display.BitmapData;
	
	CONFIG::LLOG { import org.plazy.Logger; }
	
	final public class ImgsController {
		
		// static
		
		public static var me:ImgsController = new ImgsController();
		
		// vars
		
		private var loaders:Object = {}; // key: url, value: ImgsLoader
		
		// constructor
		
		public function ImgsController () {
			CONFIG::LLOG { log('new'); }
		}
		
		public function kill ():void {
			CONFIG::LLOG { log('kill'); }
		}
		
		public function load (_url:String, _complete_hr:Function, _progress_hr:Function):Boolean {
			CONFIG::LLOG { log('load ' + _url); }
			var ldr:ImgsLoader = loaders[_url];
			if (ldr == null) {
				ldr = new ImgsLoader();
				loaders[_url] = ldr;
				ldr.add_hr(_complete_hr, _progress_hr);
				return ldr.init(_url);
			}
			ldr.add_hr(_complete_hr, _progress_hr);
			return true;
		}
		
		public function cancel (_hr:Function, _progress_hr:Function):void {
			CONFIG::LLOG { log('cancel'); }
			for each (var loader:ImgsLoader in loaders) {
				loader.rem_hr(_hr, _progress_hr);
			}
		}
		
		public function cancel_url (_url:String, _hr:Function, _progress_hr:Function):void {
			CONFIG::LLOG { log('cancel_url ' + _url); }
			var ldr:ImgsLoader = loaders[_url];
			if (ldr != null) {
				ldr.rem_hr(_hr, _progress_hr);
			}
		}
		
		public function remove (_url:String):void {
			CONFIG::LLOG { log('remove ' + _url); }
			var ldr:ImgsLoader = loaders[_url];
			if (ldr != null) {
				ldr.kill();
				ldr = null;
				delete loaders[_url];
			}
		}
		
		public function add (_url:String, _bd:BitmapData):void {
			CONFIG::LLOG { log('add ' + _url); }
			remove(_url);
			var ldr:ImgsLoader = new ImgsLoader();
			ldr.fill(_url, _bd);
			loaders[_url] = ldr;
		}
		
		public function is_ready (_url:String):Boolean {
			var ldr:ImgsLoader = loaders[_url];
			if (ldr == null) { return false; }
			return ldr.is_ready();
		}
		
		CONFIG::LLOG {
			private function log (_t:String, _c:int = 0x000000):void {
				Logger.me.add('imgs.ImgsController ' + _t, _c);
			}
		}
		
	}
	
}

class DiQueueImageItem {
	
	public var url:String;
	public var hrs:Array = []; // array of Functions
	
	public function DiQueueImageItem () { }
	
}









