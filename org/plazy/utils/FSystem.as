






// AIR only

package org.plazy.utils {
	
	import com.adobe.crypto.MD5;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	
	public class FSystem {
		
		public static var er:String;
		
		public function FSystem () { }
		
		public static function get dir_app ():File { return File.applicationDirectory; }
		public static function get dir_store ():File { return File.applicationStorageDirectory; }
		public static function file_app (_nm:String):File { return make(dir_app, _nm); }
		public static function file_store (_nm:String):File { return make(dir_store, _nm); }
		public static function exists (_f:File):Boolean { return _f != null ? _f.exists : false; }
		
		public static function make (_dir:File, _nm:String):File {
			var f:File; try { f = _dir.resolvePath(_nm); } catch (e:Error) { return null; } return f;
		}
		
		public static function read (_f:File, _dest:ByteArray):int {
			if (!exists(_f)) { return -1; }
			
			// open
			var s:FileStream = new FileStream();
			try { s.open(_f, FileMode.READ); }
			catch (e:Error) { er = 'file ' + _f.url + ' steram open failed: ' + e; return -2; }
			
			// read
			if (_dest != null) {
				try { s.readBytes(_dest); }
				catch (e:Error) { er = 'file ' + _f.url + ' read failed: ' + e; return -3; }
			}
			
			return 0;
		}
		
		public static function write (_f:File, _src:ByteArray):int {
			if (_f == null) { return -1; }
			
			// open
			var s:FileStream = new FileStream();
			try { s.open(_f, FileMode.WRITE); }
			catch (e:Error) { er = 'file ' + _f.url + ' steram open failed: ' + e; return -2; }
			
			// write
			if (_src != null && _src.length > 0) {
				try { s.writeBytes(_src); }
				catch (e:Error) { er = 'file ' + _f.url + ' write failed: ' + e; return -3; }
			}
			
			return 0;
		}
		
		public static function copy (_src:File, _dest:File):int {
			var tmp:ByteArray = new ByteArray();
			if (read(_src,tmp) != 0) { return -1; }
			if (write(_dest, tmp) != 0) { return -2; }
			return 0;
		}
		
		public static function md5 (_f:File):String {
			if (!exists(_f)) { return null; }
			var tmp:ByteArray = new ByteArray();
			if (read(_f, tmp) != 0) { return null; }
			var md5:String;
			try { md5 = com.adobe.crypto.MD5.hashBinary(tmp); } catch (e:Error) { er = 'MD5.hashBinary failed: ' + e; return null; }
			return md5;
		}
		
	}

}









