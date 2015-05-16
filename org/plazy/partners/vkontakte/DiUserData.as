








package org.plazy.partners.vkontakte {
	
	public class DiUserData {
		
		public var profile_xml_data:String;
		public var nickname:String;
		public var first_name:String;
		public var last_name:String;
		public var photo_medium:String;
		
		public function DiUserData () { }
		
		public function get_nick ():String {
			// ник часто бывает кривым или ниочем, так что берем имяи фамилию
			//if (nickname != null && nickname.length > 1) {
			//	return nickname;
			//}
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
			return '{DiUserData: nickname=' + nickname + ' first_name=' + first_name + ' last_name=' + last_name + ' photo_medium=' + photo_medium + '}';
		}
		
	}
	
}









