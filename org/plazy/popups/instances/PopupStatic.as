








package org.plazy.popups.instances {
	
	import org.plazy.StageController;
	import org.plazy.BaseDisplayObject;
	import org.plazy.txt.UILabel;
	import org.plazy.txt.UITxt;
	import org.plazy.popups.PopupCon;
	
	final public class PopupStatic extends BaseDisplayObject {
		
		// const
		
		private const WW:int = 420;
		
		// objects
		
		private var ui_label:UILabel;
		
		// constructor
		
		public function PopupStatic (_txt:String) {
			set_name(this);
			super();
			
			CONFIG::LLOG { log(' ' + _txt, 0x888888) }
			
			var he:int = 10;
			
			ui_label = new UILabel(_txt, 20, he, WW - 40, -6, UITxt.frm(12, 0x000000, true, 'center'), false);
			addChild(ui_label);
			he += ui_label.height + 10;
			
			graphics.lineStyle(1, 0x000000, 0.5);
			graphics.beginFill(0xFFFFFF, 0.8);
			graphics.drawRoundRect(0, 0, WW, he, 16, 16);
			graphics.endFill();
			
			StageController.me.add_resize_hr(pos_hr, true);
		}
		
		private function click_hr ():void {
			CONFIG::LLOG { log('click_hr') }
			var hr_mem:Function = hr;
			PopupCon.me.close();
			if (hr_mem != null) { hr_mem(); }
		}
		
		private function pos_hr (_sw:int, _sh:int):void {
			pos_center(_sw >> 1, _sh >> 1);
		}
		
		public override function kill ():void {
			CONFIG::LLOG { log('kill') }
			StageController.me.rem_resize_hr(pos_hr);
			super.kill();
			ui_label = null;
		}
		
	}
	
}









