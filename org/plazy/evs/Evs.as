








package org.plazy.evs {
	
//	CONFIG::LLOG { import org.plazy.Logger; }
	
	public class Evs {
		
		public static const me:Evs = new Evs();  // global
		
		private var hash:Object;  // key: id(String), value: Vector.<EvItem>
		
//		private var on_error:Function;
		
		public function Evs () {
			hash = {};
		}
		
//		public function set onError (_f:Function):void { on_error = _f; }
		
		public function kill ():void {
			hash = null;
		}
		
		public function add (_id:String, _hr:Function, _priority:int = 0, _repeats:int = -1):void {
			if (_id == null || _hr == null || hash == null) { return; }
			
			var item:EvItem = new EvItem();
			item.hr = _hr;
			item.priority = _priority;
			item.repeats = _repeats;
			
			var v:Vector.<EvItem> = hash[_id];
			if (v == null) {
				v = new Vector.<EvItem>();
				hash[_id] = v;
			}
			v.push(item);
			
			if (v.length > 1) {
				function sorter (_a:EvItem, _b:EvItem):int {
					return _a.priority > _b.priority ? -1 : (_a.priority < _b.priority ? 1 : 0);
				}
				v.sort(sorter);
			}
		}
		
		public function rem (_id:String, _hr:Function):void {
			if (_id == null || _hr == null || hash == null) { return; }
			
			var v:Vector.<EvItem> = hash[_id];
			if (v != null) {
				var index:int;
				for (index = 0; index < v.length; index++) {
					if (v[index].hr == _hr) {
						v.splice(index, 1);
						break;
					}
				}
				if (v.length == 0) {
					delete hash[_id];
				}
			}
		}
		
		public function call (_id:String, ... _params:Array):Boolean {
			if (_id == null || hash == null) { return true; }
//			CONFIG::LLOG { log('call ' + _id + ' ' + _params); }
			
			var list:Vector.<EvItem> = hash[_id];
			if (list == null) { return true; }
			
			var f:Function;
			var index:int;
			var ev:EvItem;
			
			while (1) {
				ev = list[index];
//				CONFIG::LLOG { log(' <b>apply</b> ' + index + ' of ' + (list.length - 1) + ' ' + ev); }
				f = ev.hr;
				if (ev.repeats > -1) {
					ev.repeats--;
					if (ev.repeats <= 0) {
//						CONFIG::LLOG { log(' removed by repeats ' + ev.repeats, 0x000099); }
						list.splice(index, 1);
						index--;
					}
				}
				if (!f.apply(null, _params)) {
//					CONFIG::LLOG { log('  stop loop by return status', 0x990000); }
					return false;
				}
				if (index >= list.length - 1) {
//					CONFIG::LLOG { log(' break loop by ' + index + '>=' + (list.length - 1), 0x000099); }
					break;
				}
				index++;
			}
			
			return true;
		}
		
//		CONFIG::LLOG {
//			private function log (_t:String, _c:uint = 0x000000):void {
//				Logger.me.add(' *** Evs ' + _t, _c);
//			}
//		}
		
	}
	
}









