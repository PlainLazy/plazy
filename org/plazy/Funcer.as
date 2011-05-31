








package org.plazy {
	
	final public class Funcer {
		
		private var func:Function;
		private var params:Object;
		
		public function Funcer () { }
		
		public function gen_func (_func:Function, _params:Object = null):Function {
			func = _func;
			params = _params;
			return call_func;
		}
		
		private function call_func (... args:Array):void {
			if (func == null) { return; }
			var ar:Array = [];
			if (params != null) {
				ar.push(params);
			}
			ar = ar.concat(args);
			func.apply(this, ar.length > 0 ? ar : null);
		}
		
	}
	
}









