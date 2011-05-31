








package org.plazy.dt {
	
	public class DtErr {
		
		public var code:int;
		public var stack:Vector.<String>;
		
		public static const NO_ERROR:int             = 0x0000;  // выполнено без ошибок
		public static const DEFAULT_ERROR:int        = 0x0001;  // стандартная ошибка
		
		public function DtErr (_code:int, _text:String) {
			
			code = _code;
			
			stack = new Vector.<String>();
			stack.push(_text);
			
		}
		
		public function stack_push (_t:String):void {
			if (stack != null) {
				stack.push(_t);
			}
		}
		
		public function is_success ():Boolean {
			return code == NO_ERROR;
		}
		
		public function get stack_trace ():String {
			return stack != null ? stack.join(', ') : 'null';
		}
		
		public function error_name ():String {
			if (code == NO_ERROR) { return 'NO_ERROR'; }
			return 'UNHANDLED ERROR CODE: ' + code;
		}
		
		public function toString ():String {
			var l:Vector.<String> = new Vector.<String>();
			l.push('code=' + code);
			if (code != NO_ERROR) {
				l.push('stack=[' + stack.join(', ') + ']');
			}
			return '{DtErr: ' + l.join(' ') + '}';
		}
		
	}
	
}









