








package org.plazy.partners.fb {
	
	import org.plazy.BaseObject;
	
	final public class FBWrapper extends BaseObject {
		
		// constructor
		
		public function FBWrapper () {
			set_name(this);
			super();
		}
		
		public override function kill ():void {
			CONFIG::LLOG { log('kill'); }
			super.kill();
		}
		
		
		
		
		
		private function isAuthenticated():Boolean {
			return fbSession == null || !fbook.is_connected ? false : true;
		}
		
		CONFIG::LLOG {
			protected override function log (_t:String, _c:uint = 0x000000):void {
				super.log('SomePrefix ' + _t, _c);
			}
		}
		
	}
	
}









