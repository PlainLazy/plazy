








package org.plazy.popups {
	
	import org.plazy.Logger;
	import org.plazy.Locker;
	import org.plazy.BaseObject;
	import org.plazy.StageController;
	import org.plazy.BaseDisplayObject;
	
	public class PopupCon extends BaseObject {
		
		public static const me:PopupCon = new PopupCon();
		
		private var cont:BaseDisplayObject;
		
		private var current_popup:BaseDisplayObject;
		
		public function PopupCon () {
			set_name(this);
			super();
		}
		
		public function set popups_container (_cont:BaseDisplayObject):void {
			cont = _cont;
			if (cont == null) { close(); }
		}
		
		public function close ():void {
			if (current_popup != null) {
				Locker.me.active = false;
				current_popup.kill();
				current_popup = null;
			}
		}
		
		public function show (_popup:BaseDisplayObject):Boolean {
			
			close();
			
			if (cont == null) { return error_def_hr('cont is null'); }
			if (_popup == null) { return error_def_hr('popup is null'); }
			
			current_popup = _popup;
			current_popup.onError = popup_err_hr;
			
			Locker.me.active = true;
			
			StageController.me.unfocus();
			
			cont.addChild(current_popup);
			
			return true;
		}
		
		private function popup_err_hr (_t:String):void {
			CONFIG::LLOG { log('popup_err_hr "' + _t + '"', 0xFF0000) }
			
			error_def_hr('current_popup error: ' + _t);
			
		}
		
	}
	
}









