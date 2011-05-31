








package org.plazy.partners.mailru {
	
	public class DiUserData {
		
		public var nickname:String;
		public var first_name:String;
		public var last_name:String;
		public var profile_raw_data:String;
		public var pic:String;
		
		public function DiUserData () { }
		
		public function get_nick ():String {
			if (nickname != null && nickname.length > 1) {
				return nickname;
			}
			return get_name();
		}
		
		public function get_name ():String {
			
			var a:Array = [];
			
			if (first_name != null && first_name.length > 0) {
				a.push(first_name);
			}
			
			if (last_name != null && last_name.length > 0) {
				a.push(last_name);
			}
			
			return a.length > 0 ? a.join(' ') : '';
			
		}
		
		public function toString ():String {
			return '{DiUserData: nickname=' + nickname + ' first_name=' + first_name + ' last_name=' + last_name + ' pic=' + pic + '}';
		}
		
	}
	
}









