








package org.plazy.dt {
	
	public class DtFileData {
		
		public var nm:String;
		public var ts:uint;
		public var size:uint;
		
		public function DtFileData () { }
		
		public function get_url ():String {
			return (nm != null && nm != '') ? nm + '?ts=' + ts : 'undef_file_name';
		}
		
		public function toString ():String {
			var l:Array = [];
			l.push('nm="' + nm + '"');
			if (nm != null && nm != '') {
				l.push('ts=' + ts);
				l.push('size=' + size);
			}
			return '{DtFileData: ' + l.join(' ') + '}';
		}
		
	}
	
}









