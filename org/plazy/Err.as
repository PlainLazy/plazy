








package org.plazy {
	
	public class Err {
		
		public function Err () { }
		
		public static function generate (_prefix:String, _err:Error, _stack_trace:Boolean):String {
			var l:Array = [];
			
			if (_prefix != null && _prefix != '') {
				l.push(_prefix);
			}
			
			if (_err != null) {
				l.push(String(_err));
				if (_stack_trace) {
					l.push('{StackTrace: ' + (_err != null ? _err.getStackTrace() : 'err_is_null') + '}');
				}
			}
			
			// branch test 1
			// branch test 1 commit 1
			// trunk update 1
			
			return '{Err: ' + l.join(' ') + '}';
		}
		
	}
	
}









