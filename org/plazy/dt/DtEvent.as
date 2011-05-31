








package org.plazy.dt {
	
	final public class DtEvent {
		
		public var handler:Function;
		public var priority:int;
		
		public var calls:int;
		
		public function DtEvent () { }
		
		public function toString ():String {
			return '{DtEvent: handler=' + handler + ' priority=' + priority + ' calls=' + calls + '}';
		}
		
	}

}









