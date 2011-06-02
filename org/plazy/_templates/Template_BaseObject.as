








package org.plazy._templates {
	
	import org.plazy.BaseObject;
	
	final public class Template_BaseObject extends BaseObject {
		
		// constructor
		
		public function Template_BaseObject () {
			set_name(this);
			super();
		}
		
		public override function kill ():void {
			CONFIG::LLOG { log('kill'); }
			super.kill();
		}
		
		CONFIG::LLOG {
			protected override function log (_t:String, _c:uint = 0x000000):void {
				super.log('SomePrefix ' + _t, _c);
			}
		}
		
	}
	
}









