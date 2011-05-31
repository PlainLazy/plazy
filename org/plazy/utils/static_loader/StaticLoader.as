








package org.plazy.utils.static_loader {
	
	import org.plazy.Err;
	import org.plazy.BaseObject;
	import org.plazy.imgs.ImgsController;
	import org.plazy.movies.MoviesController;
	
	import flash.utils.ByteArray;
	import flash.display.BitmapData;
	
	final public class StaticLoader extends BaseObject {
		
		// vars
		
		private var started:Boolean;
		private var total_bytes:uint;
		
		private var queue:Array;  // array of DiStaticLoaderQueueItem
		private var queue_caret:int;
		private var queue_item:DiStaticLoaderQueueItem;
		
		// external
		
		private var on_error:Function;
		private var on_progress:Function;
		private var on_complete:Function;
		
		// constructor
		
		public function StaticLoader () {
			set_name(this);
			super();
		}
		
		public function set onError (_f:Function):void { on_error = _f; }
		public function set onProgress (_f:Function):void { on_progress = _f; }
		public function set onComplete (_f:Function):void { on_complete = _f; }
		
		public function start (_files_list:Array):void {
			CONFIG::LLOG { log('start') }
			
			var log_file:Array;
			for each (log_file in _files_list) {
				log(' // file: ' + log_file, 0x888888);
			}
			
			if (_files_list == null) {
				error_def_hr('invalid files_list');
				return;
			}
			
			if (started) {
				error_def_hr('alreay sarted');
				return;
			}
			
			started = true;
			
			queue = [];
			
			var files_list_item:*;
			var file:Array;
			var queue_item_di:DiStaticLoaderQueueItem;
			for each (files_list_item in _files_list) {
				file = files_list_item as Array;
				if (file == null || file.length != 2) {
					error_def_hr('invalid file "' + files_list_item + '"');
					return;
				}
				queue_item_di = create_queue_item(file[0], file[1]);
				if (queue_item_di != null) {
					queue.push(queue_item_di);
				}
			}
			
			if (queue.length == 0) {
				CONFIG::LLOG { log('queue is empty') }
				complete_hr();
				return;
			}
			
			total_bytes = 0;
			for each (queue_item_di in queue) {
				total_bytes += queue_item_di.size;
			}
			
			queue_caret = -1;
			queue_next();
			
		}
		
		public function kill ():void {
			CONFIG::LLOG { log('kill') }
			
			on_error = null;
			on_progress = null;
			on_complete = null;
			
			if (queue_item != null) {
				if (queue_item.is_movie) {
					MoviesController.me.cancel_url(queue_item.url, movie_complete_hr, progress_hr);
				} else {
					ImgsController.me.cancel_url(queue_item.url, image_complete_hr, progress_hr);
				}
				queue_item = null;
			}
			
		}
		
		private function create_queue_item (_url:String, _size:uint):DiStaticLoaderQueueItem {
			
			var queue_item_di:DiStaticLoaderQueueItem = new DiStaticLoaderQueueItem();
			queue_item_di.is_movie = _url.indexOf('.swf') != -1;
			queue_item_di.url = _url;
			queue_item_di.size = _size;
			
			if (queue_item_di.is_movie) {
				if (MoviesController.me.is_ready(_url)) {
					return null;
				}
			} else {
				if (ImgsController.me.is_ready(_url)) {
					return null;
				}
			}
			
			return queue_item_di;
			
		}
		
		private function queue_next ():void {
			CONFIG::LLOG { log('queue_next ' + queue_caret) }
			
			queue_caret++;
			
			queue_item = queue[queue_caret];
			log(' // ' + queue_item, 0x888888);
			
			if (queue_item == null) {
				complete_hr();
				return;
			}
			
			if (queue_item.is_movie) {
				MoviesController.me.load(queue_item.url, movie_complete_hr, progress_hr);
			} else {
				ImgsController.me.load(queue_item.url, image_complete_hr, progress_hr);
			}
			
		}
		
		//
		// loader handlers
		//
		
		private function movie_complete_hr (_bytes:ByteArray):void {
			CONFIG::LLOG { log('movie_complete_hr') }
			
			queue_next();
			
		}
		
		private function image_complete_hr (_bd:BitmapData):void {
			CONFIG::LLOG { log('image_complete_hr') }
			
			queue_next();
			
		}
		
		private function progress_hr (_pc:Number):void {
			CONFIG::LLOG { log('progress_hr ' + _pc) }
			
			queue_item.pc = _pc;
			
			var total_pc:Number = 0;
			var queue_item_di:DiStaticLoaderQueueItem;
			for each (queue_item_di in queue) {
				total_pc += queue_item_di.pc * (queue_item_di.size / total_bytes);
			}
			
			log(' // total_pc=' + total_pc, 0x888888);
			
			if (on_progress != null) {
				try {
					on_progress(total_pc);
				} catch (e:Error) {
					error_def_hr(Err.generate('on_progress failed: ', e, true));
				}
			}
			
		}
		
		//
		// tail
		//
		
		private function error_hr (_t:String):void {
			CONFIG::LLOG { log('error_hr ' + _t, 0xFF0000) }
			if (on_error != null) { on_error(_t); }
		}
		
		private function complete_hr ():void {
			CONFIG::LLOG { log('complete_hr') }
			if (on_complete != null) { on_complete(); }
		}
		
	}
	
}









