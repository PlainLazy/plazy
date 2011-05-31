








package org.plazy.dialogs.instaces {
	
	import org.plazy.BaseDisplayObject;
	
	public class DialogBase extends BaseDisplayObject {
		
		// external
		
		protected var on_dialog_closed:Function;
		
		// constructor
		
		public function DialogBase () {
			set_name(this);
			super();
		}
		
		public function set onDialogClosed (_f:Function):void { on_dialog_closed = _f; }
		
		public override function kill ():void {
			CONFIG::LLOG { log('kill') }
			on_dialog_closed = null;
			super.kill();
		}
		
		public function closed ():Boolean {
			if (on_dialog_closed == null) { return error_def_hr('on_dialog_closed null'); }
			
			try {
				if (!on_dialog_closed()) { return false; }
			} catch (e:Error) {
				return error_ext_hr('on_dialog_closed failed', e);
			}
			
			return true;
		}
		
	}
	
}









