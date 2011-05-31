








package org.plazy.dt {
	
	import org.plazy.Bytes;
	
	import flash.utils.ByteArray;
	
	public class ParserFileData {
		
		public var file_data_di:DtFileData;
		
		public function ParserFileData () { }
		
		public function parse (_b:ByteArray, _check_tail:Boolean):String {
			if (_b == null) { return eh('input null'); }
			
			/*
			DiFileData
			filename STR                      // имя файла
			if (filename != '') {
			 timestamp UI32                   // время изменения файла
			 size UI32                        // размер файла
			}
			*/
			
			file_data_di = new DtFileData();
			file_data_di.nm = Bytes.read_str(_b);
			if (file_data_di.nm == null) { return eh('filename EOF'); }
			if (file_data_di.nm != '') {
				if (_b.bytesAvailable < 4 + 4) { return eh('file data EOF'); }
				file_data_di.ts    = _b.readUnsignedInt();
				file_data_di.size  = _b.readUnsignedInt();
			}
			if (_check_tail && _b.bytesAvailable > 0) { return eh('TB ' + _b.bytesAvailable); }
			
			return null;
		}
		
		private function eh (_t:String):String {
			return '{ParserFileData err: ' + _t + '}';
		}
		
	}
	
}









