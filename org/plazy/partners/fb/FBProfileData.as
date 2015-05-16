








package org.plazy.partners.fb {
	
	public class FBProfileData {
		
		public var id:String;
		public var fname:String;
		public var lname:String;
		//public var nick:String;
		public var gender:int;  // 1-woman, 0-man
		public var pic:String;
		//public var link:String;
		
		public function FBProfileData () { }
		
		public function is_male ():Boolean { return gender == 0; }
		//public function get_biggest_photo ():String { return !empty(ava_600px) ? ava_600px : (!empty(ava) ? ava : ava_45px); }
		public function text_by_sex (_male:String, _female:String):String { return !is_male() ? _female : _male; }
		private function empty (_t:String):Boolean { return _t == null || _t == ''; }
		
		CONFIG::LLOG {
			public function toString ():String {
				//return '{FBProfileData: uid=' + uid + ' fname=' + fname + ' lname=' + lname + ' nick=' + nick + ' sex=' + sex + ' ava=' + ava_45px + ',' + ava + ',' + ava_600px + ' link=' + link + '}';
				return '{FBProfileData: id=' + id + ' fname=' + fname + ' lname=' + lname + ' gender=' + gender + ' pic=' + pic + '}';
			}
		}
		
	}
	
}









