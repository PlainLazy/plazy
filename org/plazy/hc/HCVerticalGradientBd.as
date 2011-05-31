








package org.plazy.hc {
	
	import org.plazy.hc.HCAnyToBD;
	
	import flash.geom.Point;
	import flash.geom.Matrix;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.GradientType;
	import flash.display.BitmapDataChannel;
	
	public class HCVerticalGradientBd {
		
		public function HCVerticalGradientBd () { }
		
		public function create (_bd:BitmapData, _colors:Array):BitmapData {
			if (_colors == null || _colors.length == 0) { _colors = [0xFFFFFF]; }
			if (_bd == null) { return new BitmapData(20, 20, true, 0x80FF0000); }
			
			var matr:Matrix = new Matrix();
			matr.createGradientBox(_bd.width, _bd.height, Math.PI / 2);
			
			var sp:Sprite = new Sprite();
			sp.graphics.beginGradientFill(GradientType.LINEAR, _colors, null, null, matr);
			sp.graphics.drawRect(0, 0, _bd.width, _bd.height);
			sp.graphics.endFill();
			var any2bd:HCAnyToBD = new HCAnyToBD();
			var bd_sp:BitmapData = any2bd.to_bd(sp, 0, 0, 0, 0);
			
			bd_sp.copyChannel(_bd, _bd.rect, new Point(0, 0), BitmapDataChannel.ALPHA, BitmapDataChannel.ALPHA);
			return bd_sp;
		}
		
	}
	
}









