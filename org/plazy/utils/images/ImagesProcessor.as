








package org.plazy.utils.images {
	
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import flash.utils.ByteArray;
	
	public class ImagesProcessor {
		
		public function ImagesProcessor () { }
		
		/// return array[x1,y1,x2,y3] of non tranparent area or null when bd is transparent completely
		public static function get_bounds (_bd:BitmapData):Array {
			
			var ba:ByteArray = _bd.getPixels(_bd.rect);
			
			var empty:Boolean = true;
			
			var max_x:int = 0;
			var min_x:int = _bd.width-1;
			
			var max_y:int = 0;
			var min_y:int = _bd.height-1;
			
			var hi:int;
			var px:int;
			var py:int;
			
			for (hi = 0; hi < ba.length; hi += 4) {
				if (ba[hi] > 0) {
					py = int(hi/4 / _bd.height);
					px = (hi/4) - py*_bd.height;
					if (max_x < px) { max_x = px; }
					if (min_x > px) { min_x = px; }
					if (max_y < py) { max_y = py; }
					if (min_y > py) { min_y = py; }
					empty = false;
				}
			}
			
			return empty ? null : [min_x, min_y, max_x-min_x+1, max_y-min_y+1];
		}
		
		/// return cropped BitmapData
		public static function crop (_bd:BitmapData, _x:int, _y:int, _w:int, _h:int):BitmapData {
			var out:BitmapData = new BitmapData(_w, _h, true, 0x00000000);
			out.copyPixels(_bd, new Rectangle(_x, _y, _w, _h), new Point(0, 0));
			return out;
		}
		
		/// return ByteArray of alphas
		public static function get_alpha_bytes (_bd:BitmapData):ByteArray {
			
			var bytes_original:ByteArray = _bd.getPixels(_bd.rect);
			
			var bytes_alpha:ByteArray = new ByteArray();
			bytes_alpha.endian = 'littleEndian';
			
			var hi1:int;
			var hi2:int;
			
			for (hi1 = 0; hi1 < bytes_original.length; hi1 += 4) {
				bytes_alpha[hi2] = bytes_original[hi1];
				hi2++;
			}
			
			return bytes_alpha;
		}
		
	}
	
}









