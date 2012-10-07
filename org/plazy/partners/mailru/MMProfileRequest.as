








package org.plazy.partners.mailru {
	
	public class MMProfileRequest {
		
		public var uids:Vector.<String> = new Vector.<String>();
		public var hr:Function;
		
		public function MMProfileRequest () { }
		
		public function add_uid (_uid:String):void {
			if (uids.indexOf(_uid) == -1) {
				uids.push(_uid);
			}
		}
		
		CONFIG::LLOG {
			public function toString ():String {
				return '{MMProfileRequest: uids=' + (uids != null ? '(' + uids.length + ')[' + uids.join(',') + ']' : null) + ' hr=' + hr + '}';
			}
		}
		
	}
	
}









