








package org.plazy.ui {
	
	import org.plazy.BaseDisplayObject;
	import org.plazy.imgs.ImgsController;
	
	import flash.display.BitmapData;
	
	final public class UIPicUrl extends BaseDisplayObject {
		
		// ext
		
		private var on_complete:Function;
		
		// vars
		
		private var url:String;
		
		// constructor
		
		public function UIPicUrl () {
			set_name(this);
			super();
		}
		
		public function set onComplete (_f:Function):void { on_complete = _f; }
		
		public function init2 (_url:String):Boolean {
			CONFIG::LLOG { log('init2 ' + _url); }
			if (!super.init()) { return false; }
			return ImgsController.me.load(_url, complete_hr, null);
		}
		
		public override function kill ():void {
			CONFIG::LLOG { log('kill'); }
			on_complete = null;
			if (url != null) {
				ImgsController.me.cancel_url(url, complete_hr, null);
			}
			super.kill();
		}
		
		private function complete_hr (_bd:BitmapData):Boolean {
			var img:UIPic = new UIPic(_bd);
			addChild(img);
			url = null;
			return on_complete != null ? on_complete() : true;
		}
		
	}
	
}









