








package org.plazy {
	
	import org.plazy.dt.DtErr;
	import org.plazy.dt.DtEvent;
	
	CONFIG::LLOG { import org.plazy.Logger; }
	
	final public class Eventer {
		
		public static const me:Eventer = new Eventer();
		
		private var events:Object;  // key: event_id(String), value: Vector(DtEvent)
		
		public function Eventer () {
			events = {};
		}
		
		public function kill ():void {
			CONFIG::LLOG { log('kill'); }
			events = null;
		}
		
		public function toString ():String {
			
			if (events != null) {
				
				var l:Vector.<String> = new Vector.<String>();
				
				var event_id:String;
				var list:Vector.<DtEvent>;
				var ev:DtEvent;
				for (event_id in events) {
					l.push('"' + event_id + '"=[' + events[event_id] + ']');
				}
				
				return '{Eventer: ' + l.join(' ') + '}';
				
			}
			
			return '{Eventer null}';
			
		}
		
		public function reg (event_id:String, handler:Function, priority:int = 0):void {
			CONFIG::LLOG { log('reg ' + event_id + ' ' + priority); }
			
			if (events == null) {
				return;
			}
			
			var list:Vector.<DtEvent> = events[event_id];
			if (list == null) {
				events[event_id] = new Vector.<DtEvent>();
				list = events[event_id];
			}
			
			var ev:DtEvent = new DtEvent();
			ev.handler = handler;
			ev.priority = priority;
			
			list.push(ev);
			list.sort(sorter);
			
		}
		
		public function unreg (event_id:String, handler:Function):void {
			CONFIG::LLOG { log('unreg ' + event_id); }
			
			if (events == null) {
				return;
			}
			
			var list:Vector.<DtEvent> = events[event_id];
			if (list == null) {
				return;
			}
			
			var changed:Boolean;
			var i:int;
			for (i = 0; i < list.length; i++) {
				if (list[i].handler == handler) {
					list.splice(i, 1);
					i--;
					changed = true;
				}
			}
			
			if (changed) {
				list.sort(sorter);
			}
			
		}
		
		//public function call (event_id:String, ... args:Array):Error {
		public function call (event_id:String, _params:Array = null):Error {
			//CONFIG::LLOG { log('call ' + event_id + ' [' + args + ']'); }
			
			if (events == null) {
				return null;
			}
			
			var list:Vector.<DtEvent> = events[event_id];
			if (list == null) {
				return null;
			}
			
			var ev:DtEvent;
			for each (ev in list) {
				//try {
				//	if (!ev.handler.apply(null, args)) {
				//		CONFIG::LLOG { log('event `' + event_id + '` handler apply failed by return status', 0x990000); }
				//		return new Error('failed by apply status');
				//	}
				//} catch (e:Error) {
				//	CONFIG::LLOG { log(String(e), 0x990000); }
				//	CONFIG::LLOG { log(e.getStackTrace(), 0x990000); }
				//	return e;
				//}
				//ev.calls++;
				ev.handler.apply(null, _params);
			}
			
			return null;
			
		}
		
		private function sorter (a:DtEvent, b:DtEvent):int {
			
			return (a.priority < b.priority) ? 1 : ((a.priority > b.priority) ? -1 : 0);
			
		}
		
		CONFIG::LLOG {
			private function log (_t:String, _c:uint = 0x000000):void {
				Logger.me.add('Eventer: ' + _t, _c);
			}
		}
		
	}

}









