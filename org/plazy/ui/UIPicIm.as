








package org.plazy.ui {
	
	import org.plazy.StageController;
	import org.plazy.BaseDisplayObject;
	
	final public class UIPicIm extends BaseDisplayObject {
		
		// base
		
		private var ready_hr:Function;
		
		// object
		
		private var pic:UIPic;
		
		// vars
		
		private var src:String;
		private var num:int = -1;
		
		// constructor
		
		public function UIPicIm (_x:int = 0, _y:int = 0, _ready_hr:Function = null) {
			
			super('UIPicIm');
			
			ready_hr = _ready_hr;
			
			x = _x;
			y = _y;
			
			pic = new UIPic();
			addChild(pic);
			
		}
		
		public function init (_src:String, _cache:Boolean = true, _anti_cache:Boolean = false):void {
			
			rem_queue();
			
			src = _src;
			
			if (pic.bitmapData != null) {
				pic.bitmapData = null;
			}
			
			var ret:Object = StageController.me.im.set_bmd(src, pic, _cache, _anti_cache, load_pic_done_hr);
			
			if (!ret['ready']) {
				num = ret['num'];
			}
			
		}
		
		private function load_pic_done_hr (_pic_bd:*):void {
			CONFIG::LLOG { log('load_pic_done_hr') }
			
			num = -1;
			
			graphics.clear();
			
			if (ready_hr != null) {
				ready_hr();
			}
			
		}
		
		private function rem_queue ():void {
			
			if (num != -1) {
				StageController.me.im.remove_form_queue(src, num);
				num = -1;
			}
			
		}
		
		public override function kill ():void {
			CONFIG::LLOG { log('kill') }
			
			ready_hr = null;
			
			rem_queue();
			
			pic.kill();
			pic = null;
			
			super.kill();
			
		}
		
	}
	
}









