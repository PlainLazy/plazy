








package org.plazy.dialogs {
	
	import org.plazy.Locker;
	import org.plazy.BaseObject;
	import org.plazy.Omni;
	import org.plazy.StageController;
	import org.plazy.BaseDisplayObject;
	import org.plazy.dialogs.instaces.DialogBase;
	
	CONFIG::LLOG { import org.plazy.Logger; }
	
	final public class DialogCon extends BaseObject {
		
		public static const me:DialogCon = new DialogCon();
		
		public static const SHOW_NOW:int   = 1;
		public static const SHOW_NEXT:int  = 2;
		public static const SHOW_LAST:int  = 3;
		
		private var cont:BaseDisplayObject;
		private var queue:Vector.<DialogBase>;
		private var current:DialogBase;
		
		public function DialogCon () {
			set_name(this);
			super();
			reset();
		}
		
		public function init (_cont:BaseDisplayObject):void {
			cont = _cont;
		}
		
		public function is_empty ():Boolean {
			return current == null;
		}
		
		public function reset ():void {
			CONFIG::LLOG { log('reset'); }
			
			if (current != null) {
				current.kill();
				current = null;
				Locker.me.active = false;
			}
			
			if (queue != null && queue.length > 0) {
				var dialog:DialogBase;
				for each (dialog in queue) {
					dialog.kill();
				}
			}
			
			queue = new Vector.<DialogBase>();
			
		}
		
		public function show (_dialog:DialogBase, _show:int = SHOW_NOW, _handle_errors:Boolean = true):Boolean {
			CONFIG::LLOG { log('show ' + _dialog + ' ' + _show + ' ' + _handle_errors); }
			if (cont == null) { return error_def_hr('cont null'); }
			if (_dialog == null) { return error_def_hr('dialog null'); }
			
			if (_handle_errors) {
				_dialog.onError = error_hr;
			}
			
			switch (_show) {
				case SHOW_NOW: {
					
					if (current != null) {
						Locker.me.active = false;
						cont.removeChild(current);
						queue.unshift(current);
						current = null;
					}
					
					if (!set_current(_dialog)) { return false; }
					
					break;
				}
				case SHOW_NEXT: {
					
					if (current != null) {
						queue.unshift(_dialog);
					} else {
						if (!set_current(_dialog)) { return false; }
					}
					
					break;
				}
				case SHOW_LAST: {
					
					if (current != null) {
						queue.push(_dialog);
					} else {
						if (!set_current(_dialog)) { return false; }
					}
					
					break;
				}
				default: {
					return error_def_hr('unhanled show ' + _show);
				}
			}
			
			Omni.me.call('DialogConChanged');
			
			return true;
		}
		
		public function close (_dialog:DialogBase):Boolean {
			CONFIG::LLOG { log('close ' + _dialog); }
			
			var founded:Boolean;
			
			if (current != null && current == _dialog) {
				CONFIG::LLOG { log(' is current', 0x888888); }
				
				founded = true;
				
				var cd1:DialogBase = current;
				
				Locker.me.active = false;
				current = null;
				
				if (!cd1.closed()) {
					cd1.kill();
					cd1 = null;
					return false;
				}
				
				cd1.kill();
				cd1 = null;
				
			}
				
			if (!founded && queue != null && queue.length > 0) {
				
				var i:int;
				var d:DialogBase;
				
				for (i = 0; i < queue.length; i++) {
					if (queue[i] == _dialog) {
						
						queue.splice(i, 1);
						founded = true;
						
						if (!_dialog.closed()) {
							_dialog.kill();
							return false;
						}
						
						_dialog.kill();
						
						break;
					}
				}
				
			}
			
			if (founded) {
				if (!check_queue()) { return false; }
			} else {
				CONFIG::LLOG { log('dialog not founded for close', 0x990000); }
			}
			
			Omni.me.call('DialogConChanged');
			
			return true;
		}
		
		private function set_current (_dialog:DialogBase):Boolean {
			CONFIG::LLOG { log('set_current'); }
			
			Locker.me.active = true;
			
			current = _dialog;
			current.onDialogClosed = check_queue;
			cont.addChild(current);
			
			StageController.me.unfocus();
			
			return true;
		}
		
		private function check_queue ():Boolean {
			CONFIG::LLOG { log('check_queue'); }
			
			if (current == null && cont != null && queue != null && queue.length > 0) {
				return set_current(queue.shift());
			}
			
			return true;
		}
		
	}

}









