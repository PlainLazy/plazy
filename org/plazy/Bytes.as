








package org.plazy {
	
	import flash.utils.Endian;
	import flash.utils.ByteArray;
	
	public class Bytes {
		
		public function Bytes () { }
		
		public static function create_le ():ByteArray {
			var ba:ByteArray = new ByteArray();
			ba.endian = Endian.LITTLE_ENDIAN;
			return ba;
		}
		
		public static function to_le (_bytes:ByteArray):void {
			if (_bytes != null && _bytes.endian != Endian.LITTLE_ENDIAN) {
				_bytes.endian = Endian.LITTLE_ENDIAN;
			}
		}
		
		public static function read_str (_bytes:ByteArray):String {
			if (_bytes == null || _bytes.bytesAvailable < 2) { return null; }
			var len:int = _bytes.readUnsignedShort();
			if (_bytes.bytesAvailable < len) { return null; }
			return _bytes.readUTFBytes(len);
		}
		
		public static function read_bigint_bytes (_bytes:ByteArray):ByteArray {
			if (_bytes.bytesAvailable < 8) { return null; }
			var b:ByteArray = create_le();
			_bytes.readBytes(b, 0, 8);
			b.position = 0;
			return b;
		}
		
		public static function invert (_bytes:ByteArray):ByteArray {
			if (_bytes.length > 0) {
				var copy:ByteArray = new ByteArray();
				copy.writeBytes(_bytes);
				for (var i:int = 0; i < copy.length; i++) {
					_bytes[i] = copy[copy.length - 1 - i];
				}
			}
			return _bytes;
		}
		
		public static function read (_pattern:String, _bytes:ByteArray):Array {
			if (_pattern == null || _pattern == '' || _bytes == null) { return null; }
			
			var results:Array = [];
			
			for (var index:int = 0; index < _pattern.length; index++) {
				
				switch (_pattern.charAt(index)) {
					case 'c':
					case 'b': {
						if (_bytes.bytesAvailable < 1) { return null; }
						results.push(_bytes.readByte());
						break;
					}
					case 'C':
					case 'B': {
						if (_bytes.bytesAvailable < 1) { return null; }
						results.push(_bytes.readUnsignedByte());
						break;
					}
					case 's': {
						if (_bytes.bytesAvailable < 2) { return null; }
						results.push(_bytes.readShort());
						break;
					}
					case 'S': {
						if (_bytes.bytesAvailable < 2) { return null; }
						results.push(_bytes.readUnsignedShort());
						break;
					}
					case 'i': {
						if (_bytes.bytesAvailable < 4) { return null; }
						results.push(_bytes.readInt());
						break;
					}
					case 'I': {
						if (_bytes.bytesAvailable < 4) { return null; }
						results.push(_bytes.readUnsignedInt());
						break;
					}
					case 't': case 'T': {
						var str:String = read_str(_bytes);
						if (str == null) { return null; }
						results.push(str);
						break;
					}
					default: { return null; }
				}
				
			}
			
			return results;
		}
		
		public static function write (_pattern:String, _bytes:ByteArray, _values:Array):void {
			
			if (_pattern == null || _pattern == '') {
				error('invalid pattern');
				return;
			}
			
			if (_values == null || _values.length != _pattern.length) {
				error('invalid values');
				return;
			}
			
			for (var index:int = 0; index < _pattern.length; index++) {
				
				switch (_pattern.charAt(index)) {
					case 'c': case 'C': {
						_bytes.writeByte(int(_values[index]));
						break;
					}
					case 's': case 'S': {
						_bytes.writeShort(int(_values[index]));
						break;
					}
					case 'i': {
						_bytes.writeInt(int(_values[index]));
						break;
					}
					case 'I': {
						_bytes.writeInt(uint(_values[index]));
						break;
					}
					case 't': case 'T': {
						_bytes.writeUTF(String(_values[index]));
						break;
					}
					default: {
						error('unhandled type');
					}
				}
				
			}
			
		}
		
		public static function dump (_bytes:ByteArray, _pref:String = ''):String {
			var out:String = _pref;
			for (var hi:int = 0; hi < _bytes.length; hi++) {
				//out += byte_to_str(_bytes[hi]) + (hi % 4 == 3 ? (hi % 16 == 15 ? '\n' + _pref : '  ') : ' ');
				//out += byte_to_str(_bytes[hi]) + (hi % 4 == 3 ? (hi % 48 == 47 ? '\n' + _pref : '  ') : ' ');
				out += byte_to_str(_bytes[hi]) + (hi % 2 == 1 ? (hi % 92 == 91 ? '\n' + _pref : ' ') : '');
			}
			return out;
		}
		
		public static function dump_to_str (_bytes:ByteArray):String {
			return dump_from_position_to_str(_bytes, 0);
		}
		
		public static function dump_tail_to_str (_bytes:ByteArray):String {
			if (_bytes == null) { return 'null'; }
			return dump_from_position_to_str(_bytes, _bytes.position);
		}
		
		public static function dump_from_position_to_str (_bytes:ByteArray, _position:uint):String {
			if (_bytes == null) { return 'null'; }
			var out:String = '';
			for (var hi:uint = _position; hi < _bytes.length; hi++) {
				out += byte_to_str(_bytes[hi]) + (hi % 2 == 1 ? ' ' : '');
			}
			return out;
		}
		
		private static function byte_to_str (_byte:int):String {
			return (_byte > 0xF ? '' : '0') + _byte.toString(16).toUpperCase();
		}
		
		private static function error (_t:String):String {
			trace('Bytes.error: ' + _t);
			return _t;
		}
		
	}
	
}