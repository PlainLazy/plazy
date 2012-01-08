








package org.plazy.dialogs.instaces {
	
	import org.plazy.dialogs.DialogCon;
	import org.plazy.StageController;
	import org.plazy.txt.UILabel;
	import org.plazy.txt.UITxt;
	import org.plazy.ui.UIButton;
	
	final public class DialogNote extends DialogBase {
		
		// const
		
		private const WW:int = 420;
		
		// vars
		
		private var hr:Function;
		
		// views
		
		private var ui_label:UILabel;
		private var ui_btn:UIButton;
		
		// constructor
		
		public function DialogNote (_txt:String, _hr:Function = null) {
			set_name(this);
			super();
			
			CONFIG::LLOG { log(' ' + _txt, 0x888888); }
			
			hr = _hr;
			
			var he:int = 10;
			
			ui_label = new UILabel(_txt, 20, he, WW - 40, -6, UITxt.frm(12, 0x000000), false, true);
			addChild(ui_label);
			he += ui_label.height + 10;
			
			ui_btn = new UIButton('Okay', 0, he, -1);
			ui_btn.pos_center(WW >> 1, -1);
			ui_btn.onClick = click_hr;
			addChild(ui_btn);
			he += ui_btn.height + 10;
			
			graphics.lineStyle(1, 0x000000, 0.5);
			graphics.beginFill(0xFFFFFF, 0.9);
			graphics.drawRoundRect(0, 0, WW, he, 16, 16);
			graphics.endFill();
			
			StageController.me.add_resize_hr(pos_hr, true);
		}
		
		public override function kill ():void {
			CONFIG::LLOG { log('kill'); }
			StageController.me.rem_resize_hr(pos_hr);
			graphics.clear();
			super.kill();
			ui_label = null;
			ui_btn = null;
			hr = null;
		}
		
		private function click_hr ():void {
			CONFIG::LLOG { log('click_hr'); }
			var f:Function = hr;
			DialogCon.me.close(this);
			if (f != null) { f(); }
		}
		
		private function pos_hr (_sw:int, _sh:int):void {
			pos_center(_sw >> 1, _sh >> 1);
		}
		
	}
	
}









