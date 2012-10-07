








package org.plazy.partners.vkontakte {
	
	public class DiReqest {
		
		public var method:String;
		public var params:Vector.<String>;
		public var on_error:Function;
		public var on_comlete:Function;
		public var lock:Boolean;
		public var cancelled:Boolean;
		
		public function DiReqest () { }
		
		public function clr ():void {
			params = null;
			on_error = null;
			on_comlete = null;
		}
		
		public function clone ():DiReqest {
			var r:DiReqest = new DiReqest();
			r.method = method;
			r.params = params.concat();
			r.on_error = on_error;
			r.on_comlete = on_comlete;
			r.lock = lock;
			r.cancelled = cancelled;
			return r;
		}
		
		public function toString ():String {
			return '{DiReqest: method=' + method + ' params=' + params + ' on_error=' + on_error + ' on_complete=' + on_comlete + ' lock=' + lock + ' cancelled=' + cancelled + '}';
		}
		
	}
	
}









