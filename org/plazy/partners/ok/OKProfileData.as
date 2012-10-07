








package org.plazy.partners.ok {
	
	public class OKProfileData {
		
		public var uid:String;
		public var first_name:String;
		public var last_name:String;
		public var name:String;
		public var gender:String;  // male/female
		public var pic_1:String;
		public var pic_2:String;
		public var pic_3:String;
		public var pic_4:String;
		public var url_profile:String;
		
		public function OKProfileData () { }
		
		public function is_male ():Boolean { return gender == 'male'; }
		public function get_biggest_photo ():String { return !empty(pic_4) ? pic_4 : (!empty(pic_3) ? pic_3 : (!empty(pic_2) ? pic_2 : pic_1)); }
		public function text_by_sex (_male:String, _female:String):String { return !is_male() ? _female : _male; }
		private function empty (_t:String):Boolean { return _t == null || _t == ''; }
		
		CONFIG::LLOG {
			public function toString ():String {
				return '{OKProfileData: uid=' + uid + ' first_name=' + first_name + ' last_name=' + last_name + ' name=' + name + ' gender=' + gender + ' pics=' + pic_1 + ',' + pic_2 + ',' + pic_3 + ',' + pic_4 + ' url_profile=' + url_profile + '}';
			}
		}
		
	}
	
}









