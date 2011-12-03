








package org.plazy.partners.profiles {
	
	public class DtProfileRequest {
		
		public var ids:Vector.<String>;
		public var hr:Function;
		
		public function DtProfileRequest () { }
		
		CONFIG::LLOG {
			public function toString ():String {
				return '{DtProfileRequest: ids=' + ids + ' hr=' + hr + '}';
			}
		}
		
	}
	
}









