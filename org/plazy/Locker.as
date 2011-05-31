








package org.plazy {
	
	import org.plazy.ui.UILocker;
	import org.plazy.ui.IUILocker;
	
	public class Locker {
		
		public static var me:Locker = new Locker();
		
		private var list:Object = {};  // id:String -> val:IUILocker
		
		public function Locker () { }
		
		public function register_lock (_id:String, _locker:IUILocker):Boolean {
			if (_locker == null) { return false; }
			unregister_lock(_id);
			list[_id] = _locker;
			return true;
		}
		
		public function unregister_lock (_id:String):void {
			if (list[_id] != null) {
				delete list[_id];
			}
		}
		
		public function set active (_id:Object):void {
			
			if (_id is Boolean) {
				if (_id) {
					active = 'main';
				} else {
					deactive = 'main';
				}
				return;
			}
			
			trace('Locker active ' + _id);
			//trace(' ' + (new Error()).getStackTrace());
			
			var locker:UILocker = list[_id] as UILocker;
			
			if (locker != null) {
				if (locker.stage != null) {
					locker.stage.focus = null;
				}
				locker.active = true;
			}
			
		}
		
		public function set deactive (_id:String):void {
			trace('Locker deactive ' + _id);
			//trace(' ' + (new Error()).getStackTrace());
			
			var locker:UILocker = list[_id] as UILocker;
			
			if (locker != null) {
				locker.active = false;
			}
			
		}
		
	}
	
}









