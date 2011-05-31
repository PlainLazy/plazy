








package org.plazy.ui.decor {
	
	import org.plazy.BaseDisplayObject;
	import org.plazy.ui.UIPic;
	import org.plazy.hc.HCMatr;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.display.BitmapData;
	
	final public class UIDecorBitmap3Line extends BaseDisplayObject {
		
		// constructor
		
		public function UIDecorBitmap3Line (_L:BitmapData, _M:BitmapData, _R:BitmapData, _w:int = -1, _h:int = -1) {
			set_name(this);
			super();
			mouseEnabled = false;
			mouseChildren = false;
			
			if (_L == null || _M == null || _R == null) {
				CONFIG::LLOG { log('ERR: invalid parameters', 0xFF0000) }
				return;
			}
			
			var wi:int = _w > 0 ? _w : _L.width + _M.width + _R.width;
			var he:int = _h > 0 ? _h : Math.max(_L.height, _M.height, _R.height);
			
			graphics.beginBitmapFill(_M);
			graphics.drawRect(0, 0, wi - _L.width - _R.width, he);
			graphics.endFill();
			
			var result_bd:BitmapData = new BitmapData(wi, he, true, 0x00000000);
			result_bd.copyPixels(_L, _L.rect, new Point(0, 0));
			result_bd.draw(this, new HCMatr(_L.width, 0));
			result_bd.copyPixels(_R, _R.rect, new Point(wi - _R.width, 0));
			
			graphics.clear();
			
			var img:UIPic = new UIPic(result_bd);
			addChild(img);
		}
		
//		public override function kill ():void {
//			CONFIG::LLOG { log('kill') }
//			super.kill();
//		}
		
	}
	
}









