








package org.plazy.partners.vkontakte.profiles {
	
	public class DiVkProfileData {
		
		public var uid:uint;
		public var first_name:String;
		public var last_name:String;
		public var nickname:String;
		public var sex:int;  // 1-woman, 2-man
		public var photo:String;
		public var photo_medium:String;
		public var photo_big:String;
		public var city_id:uint;
		public var city_name:String;
		public var country_id:uint;
		public var country_name:String;
		
		public function DiVkProfileData () { }
		
		public function is_male ():Boolean { return sex == 2; }
		public function get_biggest_photo ():String { return !empty(photo_big) ? photo_big : (!empty(photo_medium) ? photo_medium : photo); }
		public function text_by_sex (_male:String, _female:String):String { return sex == 1 ? _female : _male; }
		private function empty (_t:String):Boolean { return _t == null || _t == ''; }
		
		CONFIG::LLOG {
			public function toString ():String {
				return '{DiVkProfileData: uid=' + uid + ' first_name=' + first_name + ' last_name=' + last_name + ' nickname=' + nickname + ' sex=' + sex + ' photo=' + photo + ' photo_medium=' + photo_medium + ' photo_big=' + photo_big + ' city=' + city_id + ',' + city_name + ' country=' + country_id + ',' + country_name + '}';
			}
		}
		
	}
	
}









