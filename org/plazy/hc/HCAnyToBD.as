








package org.plazy.hc {
	
	import flash.geom.Point;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.filters.BitmapFilter;
	
	public class HCAnyToBD {
		
		public function HCAnyToBD () { }
		
		public function to_bd (_source:DisplayObject, _left_gap:int, _top_gap:int, _right_gap:int, _bottom_gap:int, _sx:Number = 1, _sy:Number = 1, _filtrs:Array = null):BitmapData {
			if (_source == null) { return new BitmapData(20, 20, true, 0x80FF0000); }
			
			if (_left_gap < 0) { _left_gap = 0; }
			if (_top_gap < 0) { _top_gap = 0; }
			if (_right_gap < 0) { _right_gap = 0; }
			if (_bottom_gap < 0) { _bottom_gap = 0; }
			
			var rect:Rectangle = _source.getRect(null);
			var bd:BitmapData = new BitmapData(Math.max(1, (_left_gap + rect.width + _right_gap) * _sx), Math.max(1, (_top_gap + rect.height + _bottom_gap) * _sy), true, 0x00FFFF00);
			bd.draw(_source, new Matrix(_sx, 0, 0, _sy, rect.x + _left_gap, rect.y + _top_gap));
			
			if (_filtrs != null && _filtrs.length > 0) {
				for each (var filter:BitmapFilter in _filtrs) {
					bd.applyFilter(bd, bd.rect, new Point(0, 0), filter);
				}
			}
			
			return bd;
		}
		
	}
	
}









