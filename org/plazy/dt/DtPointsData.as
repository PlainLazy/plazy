








package org.plazy.dt {
	
	public class DtPointsData {
		
		public var points:Vector.<DtPointItem>;
		
		public function DtPointsData () { }
		
		public function create_rect (_dx:int, _dy:int, _w:int, _h:int):void {
			points = new Vector.<DtPointItem>();
			points.push(create_point(_dx, _dy));
			points.push(create_point(_dx + _w, _dy));
			points.push(create_point(_dx + _w, _dy + _h));
			points.push(create_point(_dx, _dy + _h));
		}
		
		private function create_point (_x:int, _y:int):DtPointItem {
			var point_di:DtPointItem = new DtPointItem();
			point_di.dx = _x;
			point_di.dy = _y;
			return point_di;
		}
		
		public function toString ():String {
			var l:Array = [];
			if (points == null) {
				l.push('ERROR');
			} else {
				l.push('count=' + points.length);
				if (points.length > 0) {
					var pts:Array = [];
					var point_item:DtPointItem;
					for each (point_item in points) {
						pts.push('(' + point_item.dx + ',' + point_item.dy + ')');
					}
					l.push(pts.join(','));
				}
			}
			return '{DtPointsData: ' + l.join(' ') + '}';
		}
		
	}
	
}









