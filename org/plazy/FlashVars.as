








package org.plazy {
	
	final public class FlashVars {
		
		public static const me:FlashVars = new FlashVars();
		
		private var params:Object;  // key: flashvars_key, value: flashvars_value
		
		public function FlashVars () { }
		
		public function init (_params:Object):void {
			CONFIG::LLOG { log('init') }
			
			var key:String;
			var keys:Array = [];
			for (key in _params) {
				keys.push(key);
			}
			keys.sort();
			
			params = {};
			for each (key in keys) {
				params[key] = _params[key];
				CONFIG::LLOG { log(' ' + key + ' = ' + params[key], 0x888888); }
			}
			
		}
		
		public function rem (k:String):void {
			delete params[k];
		}
		
		public function add (_obj:Object, _rewrite:Boolean):void {
			if (_obj == null) { return; }
			if (params == null) { params = {}; }
			for (var k:String in _obj) {
				if (_rewrite || params[k] == null) {
					params[k] = String(_obj[k]);
				}
			}
		}
		
		public function get_value (_key:String, _default_value:String = null, _no_warn:Boolean = false):String {
			if (params[_key] != null) { return params[_key]; }
			
			CONFIG::LLOG {
				if (!_no_warn) {
					CONFIG::LLOG { log('ERR: flashvar "' + _key + '" is null', 0xFF0000) }
				}
			}
			
			return _default_value;
		}
		
		CONFIG::LLOG {
			private function log (_t:String, _c:uint = 0x000000):void {
				Logger.me.add('FlashVars ' + _t, _c);
			}
		}
		
	}
	
}









