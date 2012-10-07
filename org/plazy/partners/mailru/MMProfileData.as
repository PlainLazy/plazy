








package org.plazy.partners.mailru {
	
	public class MMProfileData {
		
		public var uid:String;
		public var fname:String;
		public var lname:String;
		public var nick:String;
		public var sex:int;  // 1-woman, 0-man
		public var ava:String;
		public var ava_45px:String;
		public var ava_600px:String;
		public var link:String;
		
		public function MMProfileData () { }
		
		public function is_male ():Boolean { return sex == 0; }
		public function get_biggest_photo ():String { return !empty(ava_600px) ? ava_600px : (!empty(ava) ? ava : ava_45px); }
		public function text_by_sex (_male:String, _female:String):String { return !is_male() ? _female : _male; }
		private function empty (_t:String):Boolean { return _t == null || _t == ''; }
		
		CONFIG::LLOG {
			public function toString ():String {
				return '{MMProfileData: uid=' + uid + ' fname=' + fname + ' lname=' + lname + ' nick=' + nick + ' sex=' + sex + ' ava=' + ava_45px + ',' + ava + ',' + ava_600px + ' link=' + link + '}';
			}
		}
		
	}
	
}









