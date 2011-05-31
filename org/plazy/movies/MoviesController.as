








package org.plazy.movies {
	
	import flash.utils.ByteArray;
	
	CONFIG::LLOG { import org.plazy.Logger; }
	
	final public class MoviesController {
		
		// static
		
		public static var me:MoviesController = new MoviesController();
		
		// vars
		
		private var loaders:Object = {}; // key: url, value: MoviesLoader
		
		// constructor
		
		public function MoviesController () {
			CONFIG::LLOG { log('new'); }
		}
		
		public function load (_url:String, _hr:Function, _progress_hr:Function):void {
			CONFIG::LLOG { log('load ' + _url); }
			
			var ldr:MoviesLoader = loaders[_url];
			
			if (ldr == null) {
				ldr = new MoviesLoader();
				loaders[_url] = ldr;
				ldr.add_hr(_hr, _progress_hr);
				ldr.init(_url);
				return;
			}
			
			ldr.add_hr(_hr, _progress_hr);
		}
		
		public function kill ():void {
			CONFIG::LLOG { log('kill'); }
		}
		
		public function cancel (_hr:Function, _progress_hr:Function):void {
			CONFIG::LLOG { log('cancel'); }
			var loader:MoviesLoader;
			for each (loader in loaders) {
				loader.rem_hr(_hr, _progress_hr);
			}
		}
		
		public function cancel_url (_url:String, _hr:Function, _progress_hr:Function):void {
			CONFIG::LLOG { log('cancel_url ' + _url); }
			var ldr:MoviesLoader = loaders[_url];
			if (ldr != null) {
				ldr.rem_hr(_hr, _progress_hr);
			}
		}
		
		public function remove (_url:String):void {
			CONFIG::LLOG { log('remove ' + _url); }
			var ldr:MoviesLoader = loaders[_url];
			if (ldr != null) {
				ldr.kill();
				ldr = null;
				delete loaders[_url];
			}
		}
		
		public function add (_url:String, _bytes:ByteArray):void {
			CONFIG::LLOG { log('add ' + _url); }
			remove(_url);
			var ldr:MoviesLoader = new MoviesLoader();
			ldr.fill(_url, _bytes);
			loaders[_url] = ldr;
		}
		
		public function is_ready (_url:String):Boolean {
			var ldr:MoviesLoader = loaders[_url];
			if (ldr == null) { return false; }
			return ldr.is_ready();
		}
		
		CONFIG::LLOG {
			private function log (_t:String, _c:int = 0x000000):void {
				Logger.me.add('movies:MoviesController ' + _t, _c);
			}
		}
		
	}
	
}









