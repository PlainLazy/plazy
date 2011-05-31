








package org.plazy._templates {
	
	import org.plazy.BaseDisplayObject;
	
	final public class Template_BaseDisplayObject extends BaseDisplayObject {
		
		// constructor
		
		public function Template_BaseDisplayObject () {
			set_name(this);
			super();
		}
		
		public function init2 ():Boolean {
			CONFIG::LLOG { log('init2'); }
			if (!super.init()) { return false; }
			
			return true;
		}
		
		public override function kill ():void {
			CONFIG::LLOG { log('kill'); }
			super.kill();
		}
		
	}
	
}









