








package org.plazy.utils {
	
	public class Nums {
		
		public function Nums () { }
		
		public static function tt_val (_val_test:uint, _val_insert:String, _t1:String, _t2:String, _t3:String):String {
			var h10:int   = _val_test % 10;
			var h100:int  = _val_test % 100;
			
			if (_val_insert == null) { _val_insert = String(_val_test); }
			if (h10 == 1 && h100 != 11) { return _val_insert + ' ' + _t1; } // рубин, голос
			if (h10 >= 2 && h10 <= 4 && (h100 < 10 || h100 > 20)) { return _val_insert + ' ' + _t2; } // рубина, голоса
			
			return _val_insert + ' ' + _t3;  // рубинов, голосов
		}
		
	}
	
}









