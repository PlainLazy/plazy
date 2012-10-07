








package org.plazy.partners.ok {
	
	public class OKProfileRequest {
		
		public var uids:Vector.<String> = new Vector.<String>();
		public var hr:Function;
		
		public function OKProfileRequest () { }
		
		public function add_uid (_uid:String):void {
			if (uids.indexOf(_uid) == -1) {
				uids.push(_uid);
			}
		}
		
		CONFIG::LLOG {
			public function toString ():String {
				return '{OKProfileRequest: uids=' + (uids != null ? '(' + uids.length + ')[' + uids.join(',') + ']' : null) + ' hr=' + hr + '}';
			}
		}
		
	}
	
}









