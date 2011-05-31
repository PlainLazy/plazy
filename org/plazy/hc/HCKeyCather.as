








package org.plazy.hc {
	
	import org.plazy.BaseObject;
	import org.plazy.StageController;
	
	import flash.utils.getQualifiedClassName;
	import flash.utils.getQualifiedSuperclassName;
	import flash.events.KeyboardEvent;
	import flash.display.Stage;
	import flash.display.InteractiveObject;
	
	CONFIG::LLOG { import org.plazy.Logger; }
	
	final public class HCKeyCather extends BaseObject {
		
		// base
		
		private var stg:Stage;
		
		// vars
		
		private var key:int;
		private var handler:Function;
		
		private var is_set:Boolean;
		private var catch_down:Boolean;
		private var event:String;
		
		public var with_shift:Boolean;
		public var ignore_tf:Boolean;
		
		// constructor
		
		public function HCKeyCather (_stage:Stage = null) {
			set_name(this);
			super();
			stg = _stage != null ? _stage : StageController.me.stage;
		}
		
		public override function kill ():void {
			rem_catch();
			stg = null;
			super.kill();
		}
		
		public function set_catch (_key:int, _handler:Function, _catch_down:Boolean = true):void {
			CONFIG::LLOG { log('set_catch ' + _key + ' ' + _catch_down); }
			if (stg == null) { return; }
			rem_catch();
			key = _key;
			handler = _handler;
			catch_down = _catch_down;
			event = catch_down ? KeyboardEvent.KEY_DOWN : KeyboardEvent.KEY_UP;
			stg.addEventListener(event, key_hr);
			is_set = true;
		}
		
		public function rem_catch ():void {
			CONFIG::LLOG { log('rem_catch'); }
			handler = null;
			if (!is_set) { return; }
			is_set = false;
			if (stg == null) { return; }
			stg.removeEventListener(event, key_hr);
		}
		
		private function key_hr (_e:KeyboardEvent):void {
			//CONFIG::LLOG { log('key_hr'); }
			if (handler == null) { return; }
			if (_e.keyCode != key) { return; }
			if (with_shift && !_e.shiftKey) { return; }
			var tc:String = 'flash.text::TextField';
			if (ignore_tf && (getQualifiedClassName(stg.focus) == tc || getQualifiedSuperclassName(stg.focus) == tc)) { return; }
			try { handler(); }
			catch (e:Error) { CONFIG::LLOG { log('handler failed: ' + e, 0x990000); } }
		}
		
	}
	
}









