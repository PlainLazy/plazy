








package org.plazy.modal {
	
	import org.plazy.BaseDisplayObject;
	
	public class DiQueuedObject {
		
		public var object:ISpaceObject;
		public var on_close:Function;
		public var alter_container:BaseDisplayObject;
		
		public function DiQueuedObject () { }
		
		public function toString ():String {
			return 'DiQueuedObject: object={' + object + '} on_close=' + on_close + ' alter_container=' + alter_container;
		}
		
	}
	
}









