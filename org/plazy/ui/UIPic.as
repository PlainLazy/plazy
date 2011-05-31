








package org.plazy.ui {
	
	import org.plazy.BaseDisplayObject;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	final public class UIPic extends BaseDisplayObject {
		
		// vars
		
		private var on_kill:Function;
		
		// objects
		
		private var img:Bitmap;
		
		// constructor
		
		public function UIPic (_bd:BitmapData = null, _x:int = 0, _y:int = 0) {
			mouseEnabled = false;
			mouseChildren = false;
			
			img = new Bitmap(_bd);
			addChild(img);
			
			x = _x;
			y = _y;
		}
		
		public function set bitmapData (_bd:BitmapData):void { img.bitmapData = _bd; }
		public function set smoothing (_bool:Boolean):void { img.smoothing = _bool; }
		public function set pixelSnapping (_val:String):void { img.pixelSnapping = _val; }
		public function set onKill (_f:Function):void { on_kill = _f; }
		
		public override function kill ():void {
			if (img != null) {
				img.bitmapData = null;
				removeChild(img);
				img = null;
			}
			if (parent != null) { parent.removeChild(this); }
			if (on_kill != null) { on_kill(); on_kill = null; }
		}
		
	}
	
}








