








package org.plazy {
	
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.utils.getQualifiedClassName;
	import org.plazy.dt.DtErr;
	import org.plazy.Err;
	
	CONFIG::LLOG { import org.plazy.Logger; }
	
	public class BaseDisplayObject extends Sprite implements IBaseDisplayObject {
		
		private static var id:uint;
		
		private var on_error:Function;
		
		private var zid:String;
		private var pref:String;
		private var clname:String;
		
		public var log_enabled:Boolean = true;
		
		protected var killed:Boolean;
		protected var inited:Boolean;
		
		public function BaseDisplayObject () {
			zid = generate_zid();
		}
		
		protected function set_name (_instance:*):void {
			pref = getQualifiedClassName(_instance);
		}
		
		protected function set log_pref (_t:String):void {
			pref = _t;
			CONFIG::LLOG { log('new'); }
		}
		
		public function set onError (_f:Function):void { on_error = _f; }
		
		public function init ():Boolean {
			if (inited) { return error_def_hr('already inited'); }
			inited = true;
			return true;
		}
		
		public function kill ():void {
			on_error = null;
			if (killed) {
				error_x_hr('aready killed');
				return;
			}
			killed = true;
			filters = null;
			graphics.clear();
			kill_childens();
			if (parent != null) { parent.removeChild(this); }
			if (numChildren > 0) {
				error_x_hr('conatins ' + numChildren + ' childrens (must be 0)');
				var hi:int;
				CONFIG::LLOG { log(' // childrens list:', 0xFF0000); }
				while (numChildren > 0) {
					hi = numChildren - 1;
					CONFIG::LLOG { log(' // #' + hi + ' : ' + getChildAt(hi) + ' ' + getChildAt(hi).name, 0xFF0000); }
					removeChildAt(hi);
				}
			}
		}
		
		public function pos_center (_x:int, _y:int):void {
			if (_x != -1) { x = _x - int(width >> 1); }
			if (_y != -1) { y = _y - int(height >> 1); }
		}
		
		public function pos_center_b (_x:int, _y:int):void {
			var bounds:Rectangle = getBounds(null);
			if (_x != -1) { x = _x - (int(bounds.width >> 1) + bounds.x); }
			if (_y != -1) { y = _y - (int(bounds.height >> 1) + bounds.y); }
		}
		
		public function hor_line (_list:Array, _cx:int, _dx:int):void {
			
			var ww:int = -_dx;
			
			for each (var hc1:BaseDisplayObject in _list) {
				ww += _dx + hc1.width;
			}
			
			var hp:int = _cx - ww / 2;
			
			for each (var hc2:BaseDisplayObject in _list) {
				hc2.x = hp;
				hp += hc2.width + _dx;
			}
			
		}
		
		public function vert_line (_list:Array, _cy:int, _dy:int):void {
			
			var hh:int = -_dy;
			
			for each (var hc1:BaseDisplayObject in _list) {
				hh += _dy + hc1.height;
			}
			
			var hp:int = _cy - hh / 2;
			
			for each (var hc2:BaseDisplayObject in _list) {
				hc2.y = hp;
				hp += hc2.height + _dy;
			}
			
		}
		
		private function kill_childens ():void {
			
			var childrens:Array = [];
			for (var child_index:int = 0; child_index < numChildren; child_index++) {
				childrens.push(getChildAt(child_index));
			}
			
			while (childrens.length > 0) {
				var child:* = childrens.shift();
				if (child.hasOwnProperty('kill')) {
					try { child['kill'](); }
					catch (e:Error) { trace('ERR: kill failed: ' + e); }
				}
			}
			
		}
		
		private function generate_zid ():String {
			var new_id:String = id.toString(36).toUpperCase();
			while (new_id.length < 3) { new_id = '0' + new_id; }
			id++;
			return '*' + new_id;
		}
		
		private function error_x_hr (_t:String):void {
			CONFIG::LLOG { 
				CONFIG::LLOG { log('ERR: "' + _t + '" on', 0xFF0000) }
				log((new Error()).getStackTrace(), 0xFF0000);
			}
		}
		
		protected function class_name ():String {
			if (clname != null) { return clname; }
			if (pref == null) { return 'null'; }
			var l1:Array = pref.split('::');
			clname = l1.pop();
			return clname;
		}
		
		protected function error_ext_hr (_t:String, _e:Error):Boolean {
			return error_def_hr(Err.generate(_t + ': ', _e, true));
		}
		
		protected function error_def_hr (_t:String):Boolean {
			return error_hr(new DtErr(DtErr.DEFAULT_ERROR, _t));
		}
		
		protected function error_hr (_e:DtErr):Boolean {
			if (on_error != null) {
				_e.stack_push(class_name());
				on_error(_e);
			} else {
				CONFIG::LLOG { log(Err.generate('ERR: on_error NULL', new Error(), true), 0xFF0000); }
			}
			return false;
		}
		
		CONFIG::LLOG {
			protected function log (_t:String, _c:uint = 0x000000):void {
				if (!log_enabled) { return; }
				Logger.me.add(zid + ' ' + pref + ' ' + _t, _c);
			}
		}
		
		public override function toString ():String {
			return '{BaseDisplayObject: zid=' + zid + ' pref=' + pref + '}';
		}
		
	}
	
}








