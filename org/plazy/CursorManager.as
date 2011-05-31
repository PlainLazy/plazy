








package org.plazy {
	
	import org.plazy.Err;
	import org.plazy.Logger;
	import org.plazy.StageController;
	
	import flash.ui.Mouse;
	
	public class CursorManager extends BaseObject {
		
		public static const me:CursorManager = new CursorManager();
		
		private var cont:BaseDisplayObject;
		private var current_cursor:BaseDisplayObject;
		
		private var on_reset:Function;
		
		public function CursorManager () { }
		
		public function set_container (_cont:BaseDisplayObject):void {
			cont = _cont;
		}
		
		public function cursor_set (_cursor:BaseDisplayObject, _on_reset:Function):Boolean {
			CONFIG::LLOG { log('cursor_set') }
			if (!cursor_reset(false, false)) { return false; }
			if (_cursor == null) { return error_def_hr('cursor is null'); }
			if (_on_reset == null) { return error_def_hr('on_reset is null'); }
			if (cont == null) { return error_def_hr('cont is null'); }
			
			Mouse.hide();
			
			current_cursor = _cursor;
			current_cursor.mouseEnabled = false;
			current_cursor.mouseChildren = false;
			cont.addChild(current_cursor);
			
			on_reset = _on_reset;
			
			StageController.me.add_mmove_hr(mmove_hr, true);
			
			return true;
		}
		
		public function cursor_reset (_safe:Boolean, _no_reset:Boolean):Boolean {
			CONFIG::LLOG { log('cursor_reset ' + _safe + ' ' + _no_reset) }
			
			Mouse.show();
			
			if (current_cursor == null) { return true; }
			
			try {
				cont.removeChild(current_cursor);
			} catch (e:Error) {
				if (_safe) {
					CONFIG::LLOG { log(Err.generate('cursor remove failed: ', e, true), 0xFF0000); }
				} else {
					return error_def_hr(Err.generate('cursor remove failed: ', e, true));
				}
			}
			
			if (!_no_reset) {
				try {
					if (!on_reset()) { return false; }
				} catch (e:Error) {
					if (_safe) {
						CONFIG::LLOG { log(Err.generate('on_reset failed: ', e, true), 0xFF0000); }
					} else {
						return error_def_hr(Err.generate('on_reset failed: ', e, true));
					}
				}
			}
			
			StageController.me.rem_mmove_hr(mmove_hr);
			
			current_cursor = null;  // current_cursor must be killed in `on_reset`
			on_reset = null;
			
			return true;
		}
		
		private function mmove_hr (_x:int, _y:int):Boolean {
			if (current_cursor == null) { return error_def_hr('current_cursor is null'); }
			
			current_cursor.x = _x;
			current_cursor.y = _y;
			
			return true;
		}
		
	}
	
}









