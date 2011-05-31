








package org.plazy.utils.static_loader {
	
	final public class DiStaticLoaderQueueItem {
		
		public var is_movie:Boolean;
		public var url:String;
		public var size:uint;
		public var pc:Number = 0;
		
		public function DiStaticLoaderQueueItem () { }
		
		public function toString ():String {
			return 'DiQueueItem: is_movie=' + is_movie + ' url=' + url + ' size=' + size;
		}
		
	}
	
}









