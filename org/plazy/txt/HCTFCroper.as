








package org.plazy.txt {
	
	public class HCTFCroper {
		
		public function HCTFCroper () { }
		
		public function crop (_t:String, _tf:UILabel, _width:uint, _suffix:String):String {
			
			if (_t == null || _tf == null || _suffix == null) { return ''; }
			
			_tf.update_text(_t);
			
			if (_tf.tf.textWidth <= _width) { return _t; }
			
			while (1) {
				if (_t.length == 0) { break; }
				_tf.update_text(_t + _suffix);
				if (_tf.tf.textWidth <= _width) { break; }
				_t = _t.substr(0, -1);
			}
			
			return _t + _suffix;
		}
		
	}
	
}









