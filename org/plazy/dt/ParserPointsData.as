








package org.plazy.dt {
	
	import org.plazy.Bytes;
	
	import flash.utils.ByteArray;
	
	public class ParserPointsData {
		
		public var points_data_di:DtPointsData;
		public var bytes:ByteArray;
		
		public function ParserPointsData () { }
		
		public function parse (_b:ByteArray, _check_tail:Boolean):String {
			if (_b == null) { return eh('input null'); }
			
			/*
			PointsData
			points_count (UI16)               // количество точек
			point_1 .. N [
			 dx (SI16)                        // координата точки по оси X
			 dy (SI16)                        // координата точки по оси Y
			]
			*/
			
			if (_b.bytesAvailable < 2) { return eh('point_count EOF'); }
			
			var points_count:int = _b.readUnsignedShort();
			
			if (_b.bytesAvailable < points_count * (2 + 2)) { return eh('point EOF'); }
			
			points_data_di = new DtPointsData();
			points_data_di.points = new Vector.<DtPointItem>();
			
			var point_item_di:DtPointItem;
			while (points_count > 0) {
				point_item_di = new DtPointItem();
				point_item_di.dx = _b.readShort();
				point_item_di.dy = _b.readShort();
				points_data_di.points.push(point_item_di);
				points_count--;
			}
			
			if (_check_tail && _b.bytesAvailable > 0) { return eh('TB ' + _b.bytesAvailable); }
			
			return null;
		}
		
		public function pack (_di:DtPointsData):String {
			if (_di == null || _di.points == null) { return eh('invalid params'); }
			
			bytes = Bytes.create_le();
			bytes.writeShort(_di.points.length);
			
			var point_di:DtPointItem;
			for each (point_di in _di.points) {
				bytes.writeShort(point_di.dx);
				bytes.writeShort(point_di.dy);
			}
			
			return null;
		}
		
		private function eh (_t:String):String {
			return '{ParserPointsData err: ' + _t + '}';
		}
		
	}
	
}









