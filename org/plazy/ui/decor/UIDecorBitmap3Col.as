








package org.plazy.ui.decor {
	
	import org.plazy.BaseDisplayObject;
	import org.plazy.ui.UIPic;
	import org.plazy.hc.HCMatr;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.display.BitmapData;
	
	final public class UIDecorBitmap3Col extends BaseDisplayObject {
		
		// constructor
		
		public function UIDecorBitmap3Col (_T:BitmapData, _M:BitmapData, _B:BitmapData, _h:int = -1, _w:int = -1) {
			set_name(this);
			super();
			mouseEnabled = false;
			mouseChildren = false;
			
			if (_T == null || _M == null || _B == null) {
				CONFIG::LLOG { log('ERR: invalid parameters', 0xFF0000) }
				return;
			}
			
			var he:int = _h > 0 ? _h : _T.height + _M.height + _B.height;
			var wi:int = _w > 0 ? _w : Math.max(_T.width, _M.width, _B.width);
			
			graphics.beginBitmapFill(_M);
			graphics.drawRect(0, 0, wi, he - _T.height - _B.height);
			graphics.endFill();
			
			var result_bd:BitmapData = new BitmapData(wi, he, true, 0x00000000);
			result_bd.copyPixels(_T, _T.rect, new Point(0, 0));
			result_bd.draw(this, new HCMatr(0, _T.height));
			result_bd.copyPixels(_B, _B.rect, new Point(0, he - _B.height));
			
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









