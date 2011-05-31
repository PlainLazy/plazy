








package org.plazy.modal {
	
	import org.plazy.BaseDisplayObject;
	
	public class DiSpace {
		
		public var id:String;
		public var container:ISpaceContainer;
		public var current_objects:Vector.<DiQueuedObject>;
		
		public function DiSpace () { }
		
		public function toString ():String {
			// todo: use some Vector dumper
			return 'DiSpace: id="' + id + '" container={' + container + '}  current_objects=' + current_objects;
		}
		
	}
	
}









