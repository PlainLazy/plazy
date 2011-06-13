








package org.plazy.partners.ijet {
	
	final public class DtIJetCmd {
		
		public var cmd:String;
		public var params:Object;
		public var handler:Function;
		public var lock:Boolean;
		
		public function DtIJetCmd () { }
		
		public function toString ():String {
			return '{DtIJetCmd: cmd=' + cmd + ' params=' + params + ' + handler=' + handler + ' lock=' + lock + '}';
		}
		
	}

}









