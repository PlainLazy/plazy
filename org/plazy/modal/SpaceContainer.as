








package org.plazy.modal {
	
	import org.plazy.StageController;
	import org.plazy.BaseDisplayObject;
	import org.plazy.modal.ISpaceContainer;
	
	final public class SpaceContainer extends BaseDisplayObject implements ISpaceContainer {
		
		// objects
		
		private var modal_locker:BaseDisplayObject;
		
		// constructor
		
		public function SpaceContainer () {
			set_name(this);
			super();
		}
		
		public function lock_active_space ():void {
			CONFIG::LLOG { log('lock_active_space') }
			
			if (modal_locker == null) {
				modal_locker = new BaseDisplayObject();
				modal_locker.graphics.beginFill(0x000000, 0.2);
				modal_locker.graphics.drawRect(0, 0, 100, 100);
				modal_locker.graphics.endFill();
			}
			
			update_modal_locker(StageController.me.sw, StageController.me.sh);
			addChild(modal_locker);
			
		}
		
		public function unlock_active_space ():void {
			CONFIG::LLOG { log('unlock_active_space') }
			
			if (modal_locker != null) {
				modal_locker.graphics.clear();
				modal_locker.kill();
				modal_locker = null;
			}
			
		}
		
		public function update_modal_locker (_w:int, _h:int):void {
			
			if (modal_locker != null) {
				modal_locker.width = _w;
				modal_locker.height = _h;
			}
			
		}
		
//		public override function kill ():void {
//			CONFIG::LLOG { log('kill') }
//			super.kill();
//		}
		
	}
	
}









