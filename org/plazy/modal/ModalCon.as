








package org.plazy.modal {
	
	import org.plazy.Funcer;
	import org.plazy.BaseDisplayObject;
	
	CONFIG::LLOG { import org.plazy.Logger; }
	
	public class ModalCon {
		
		// static
		
		public static const me:ModalCon = new ModalCon();
		
		// vars
		
		private var spaces:Object;  // key: space_id, value: DiSpace
		
		// contructor
		
		public function ModalCon () {
			spaces = {};
		}
		
		public function register_space (_space_id:String, _space_container:ISpaceContainer):void {
			
			unregister_space(_space_id);
			
			var space_di:DiSpace = new DiSpace();
			space_di.id = _space_id;
			space_di.container = _space_container;
			space_di.current_objects = new Vector.<DiQueuedObject>();
			
			spaces[_space_id] = space_di;
			
		}
		
		public function unregister_space (_space_id:String):void {
			
			var space_di:DiSpace = spaces[_space_id];
			if (space_di == null) {
				return;
			}
			
			space_di.container = null;
			space_di.current_objects = null;
			
			delete spaces[_space_id];
			
		}
		
		public function show (_space_id:String, _object:BaseDisplayObject, _on_close:Function = null, _alter_container:BaseDisplayObject = null):void {
			CONFIG::LLOG { log('show "' + _space_id + '"') }
			
			var space_di:DiSpace = spaces[_space_id];
			if (space_di == null) {
				CONFIG::LLOG { log('ERR: space is null', 0xFF0000) }
				return;
			}
			
			var space_object:ISpaceObject = _object as ISpaceObject;
			if (space_object == null) {
				CONFIG::LLOG { log('ERR: invalid space_object', 0xFF0000) }
				return;
			}
			
			var queued_object_di:DiQueuedObject = new DiQueuedObject();
			queued_object_di.object = space_object;
			queued_object_di.on_close = _on_close;
			queued_object_di.alter_container = _alter_container;
			
			var container:ISpaceContainer = space_di.container as ISpaceContainer;
			if (container == null) {
				CONFIG::LLOG { log('ERR: invalid container', 0xFF0000) }
				return;
			}
			
			space_di.current_objects.push(queued_object_di);
			
			container.lock_active_space();
			if (_alter_container == null) {
				container.addChild(space_object as BaseDisplayObject);
			} else {
				_alter_container.addChild(space_object as BaseDisplayObject);
			}
			
			space_object.onClose = (new Funcer()).gen_func(hide, _space_id);
			space_object.init_on_space();
			
		}
		
		public function hide (_space_id:String, _safe:Boolean = false):void {
			CONFIG::LLOG { log('hide "' + _space_id + '"') }
			
			var space_di:DiSpace = spaces[_space_id];
			if (space_di == null) {
				CONFIG::LLOG { log('ERR: space is null', 0xFF0000) }
				return;
			}
			
			var container:ISpaceContainer = space_di.container as ISpaceContainer;
			if (container == null) {
				CONFIG::LLOG { log('ERR: invalid container', 0xFF0000) }
				return;
			}
			
			if (space_di.current_objects.length == 0) {
				if (!_safe) {
					CONFIG::LLOG { log('ERR: current_objects is empty', 0xFF0000) }
				}
				return;
			}
			
			var current_object:DiQueuedObject = space_di.current_objects.pop();
			if (current_object == null) {
				if (!_safe) {
					CONFIG::LLOG { log('ERR: current_object is null', 0xFF0000) }
				}
				return;
			}
			
			current_object.object.kill();
			current_object.object = null;
			if (current_object.on_close != null) {
				current_object.on_close();
				current_object.on_close = null;
			}
			current_object.alter_container = null;
			current_object = null;
			
			if (space_di.current_objects.length == 0) {
				container.unlock_active_space();
			} else {
				var last_object:DiQueuedObject = space_di.current_objects[space_di.current_objects.length - 1];
				if (last_object.alter_container == null) {
					container.addChild(last_object.object as BaseDisplayObject);
				} else {
					last_object.alter_container.addChild(last_object.object as BaseDisplayObject);
				}
			}
			
		}
		
		public function clear_objects (_space_id:String):void {
			CONFIG::LLOG { log('clear_objects "' + _space_id + '"') }
			
			var space_di:DiSpace = spaces[_space_id];
			if (space_di == null) {
				CONFIG::LLOG { log('ERR: space is null', 0xFF0000) }
				return;
			}
			
			if (space_di.current_objects.length > 0) {
				space_di.container.unlock_active_space();
			}
			
			var current_object_di:DiQueuedObject;
			var on_close:Function;
			for each (current_object_di in space_di.current_objects) {
				current_object_di.object.kill();
				current_object_di.object = null;
				on_close = current_object_di.on_close;
				current_object_di.on_close = null;
				current_object_di.alter_container = null;
				if (on_close != null) {
					on_close();
				}
			}
			space_di.current_objects = new Vector.<DiQueuedObject>();
			
		}
		
		public function clear_spaces ():void {
			CONFIG::LLOG { log('clear_spaces') }
			
		}
		
		CONFIG::LLOG {
			private function log (_t:String, _c:uint = 0x000000):void {
				Logger.me.add('ModalCon ' + _t, _c);
			}
		}
		
	}
	
}









