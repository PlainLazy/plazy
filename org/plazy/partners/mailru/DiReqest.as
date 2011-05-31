








package org.plazy.partners.mailru {
	
	public class DiReqest {
		
		public var method:String;
		public var params:Vector.<String>;
		public var on_error:Function;
		public var on_comlete:Function;
		public var lock:Boolean;
		
		public function DiReqest () {
			
		}
		
		public function clr ():void {
			
			params = null;
			on_error = null;
			on_comlete = null;
			
		}
		
		public function toString ():String {
			
			return '{DiReqest: method=' + method + ' params=' + params + ' on_error=' + on_error + ' on_complete=' + on_comlete + ' lock=' + lock + '}';
			
		}
		
	}
	
}









