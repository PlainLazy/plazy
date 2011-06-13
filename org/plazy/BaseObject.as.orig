








package org.plazy {
	
	import org.plazy.dt.DtErr;
	
	import flash.utils.getQualifiedClassName;
	
	CONFIG::LLOG { import org.plazy.Logger; }
	
	public class BaseObject implements IBaseObject {
		
		// static
		
		private static var id:uint;
		
		// base
		
		private var zid:String;
		private var pref:String;
		private var clname:String;
		
		// external
		
		protected var on_error:Function;
		
		// constructor
		
		public function BaseObject () {
			zid = generate_zid();
			CONFIG::LLOG { log('new'); }
		}
		
		public function set onError (_f:Function):void { on_error = _f; }
		
		protected function set_name (_instance:*):void {
			if (pref == null) {
				pref = getQualifiedClassName(_instance);
			}
		}
		
		protected function class_name ():String {
			if (clname != null) { return clname; }
			if (pref == null) { return 'null'; }
			var l1:Array = pref.split('::');
			clname = l1.pop();
			return clname;
		}
		
		protected function error_ext_hr (_t:String, _e:Error, _rf:Function = null):Boolean {
			var f:Function = _rf != null ? _rf : on_error;
			var et:String = Err.generate(_t + ': ', _e, true);
			try { f(new DtErr(DtErr.DEFAULT_ERROR, et)); }
			catch (e:Error) { CONFIG::LLOG { log('ERR: error hr failed: ' + et, 0xFF0000); } }
			return false;
		}
		
		protected function error_def_hr (_t:String):Boolean {
			return error_hr(new DtErr(DtErr.DEFAULT_ERROR, _t));
		}
		
		protected function error_hr (_e:DtErr, _rf:Function = null):Boolean {
			var f:Function = _rf != null ? _rf : on_error;
			_e.stack_push(class_name());
			if (f != null) {
				try { f(_e); }
				catch (e:Error) { CONFIG::LLOG { log(Err.generate('ERR: on_error failed: ', e, true), 0xFF0000); } }
			} else { CONFIG::LLOG { log('on_error null', 0x990000); } }
			return false;
		}
		
		private function generate_zid ():String {
			var new_id:String = id.toString(36);
			while (new_id.length < 3) { new_id = '0' + new_id; }
			id++;
			return ' ' + new_id;
		}
		
		CONFIG::LLOG {
			protected function log (_t:String, _c:uint = 0x000000):void {
				Logger.me.add(zid + ' ' +pref + ' ' + _t, _c);
			}
		}
		
		public function kill ():void {
			CONFIG::LLOG { log('kill'); }
			on_error = null;
		}
		
	}
	
}









