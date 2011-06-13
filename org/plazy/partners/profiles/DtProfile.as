








package org.plazy.partners.profiles {
	
	final public class DtProfile {
		
		public var id:String;
		public var nick:String;
		public var photo:String;
		
		public function DtProfile () { }
		
		public function create_nick (_fn:String, _ln:String, _nick:String, _id:String):String {
			var l:Array = [];
			if (not_empty(_fn)) { l.push(_fn); }
			if (not_empty(_ln)) { l.push(_ln); }
			if (l.length == 0 && not_empty(_nick)) { l.push(_nick); }
			if (l.length == 0) { l.push('u' + _id); }
			return l.join(' ');
		}
		
		private function not_empty (_t:String):Boolean {
			return _t != null && _t != '';
		}
		
		public function toString ():String {
			return '{DtProfile: id=' + id + ' nick=' + nick + ' photo=' + photo + '}';
		}
		
	}

}









