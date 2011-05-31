








package org.plazy.utils.io {
	
	import org.plazy.BaseObject;
	import org.plazy.dt.DtErr;
	import org.plazy.hc.HCTiker;
	
	public class LoaderBase extends BaseObject {
		
		// static
		
		private static var static_id:uint = 3000;
		
		// base
		
		protected var pref:String;
		
		// vars
		
		private var instance_id:uint;
		protected var in_progress:Boolean;
		protected var src:String;
		private var timer:HCTiker;
		
		// external
		
		protected var on_progress:Function;
		protected var on_complete:Function;
		
		private var timeout_value:int = 5000;
		
		// constructor
		
		public function LoaderBase () {
			instance_id = static_id;
			static_id++;
			set_name(this);
			super();
			timer = new HCTiker();
		}
		
		public function set onProgress (_f:Function):void { on_progress = _f; }
		public function set onComplete (_f:Function):void { on_complete = _f; }
		public function set_timeout (_val:int):void { timeout_value = _val; }
		
		public override function kill ():void {
			CONFIG::LLOG { log('kill'); }
			on_progress = null;
			on_complete = null;
			timer.kill();
			timer = null;
			super.kill();
		}
		
		public function close ():void {
			in_progress = false;
			t_stop();
		}
		
		protected function t_start ():void {
			timer.set_tik(timer_hr, timeout_value, 1);
		}
		
		protected function t_stop ():void {
			timer.rem_tik();
		}
		
		private function timer_hr ():void {
			CONFIG::LLOG { log('timer_hr', 0xFF0000); }
			close();
			error_def_hr('TimeoutError');
		}
		
		protected override function error_hr (_e:DtErr, _rf:Function = null):Boolean {
			CONFIG::LLOG { log('error_hr ' + _e, 0xFF0000); }
			in_progress = false;
			t_stop();
			return super.error_hr(_e, _rf);
		}
		
		CONFIG::LLOG {
			protected override function log (_t:String, _c:uint = 0x000000):void {
				super.log(pref + ' [' + instance_id + '] ' + _t, _c);
			}
		}
		
	}
	
}









