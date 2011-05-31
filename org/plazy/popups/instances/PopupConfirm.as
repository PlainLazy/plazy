








package org.plazy.popups.instances {
	
	import org.plazy.Err;
	import org.plazy.StageController;
	import org.plazy.BaseDisplayObject;
	import org.plazy.ui.UISen;
	import org.plazy.ui.UIButton;
	import org.plazy.txt.UITxt;
	import org.plazy.txt.UILabel;
	import org.plazy.popups.PopupCon;
	
	final public class PopupConfirm extends BaseDisplayObject {
		
		// const
		
		private const WW:int = 420;
		
		// vars
		
		private var on_confirm:Function;
		private var on_cancel:Function;
		
		// constructor
		
		public function PopupConfirm (_t:String, _confirm_hr:Function, _cancel_hr:Function) {
			set_name(this);
			super();
			
			CONFIG::LLOG { log(' ' + _t, 0x888888) }
			
			on_confirm = _confirm_hr;
			on_cancel = _cancel_hr;
			
			var he:int = 15;
			
			var label:UILabel = new UILabel(_t, 20, he, WW - 40, -6, UITxt.frm(12, 0x000000), false, true);
			addChild(label);
			
			he += label.height + 10;
			
			var bt_confirm:UIButton = new UIButton('Confirm', 0, he, -1);
			bt_confirm.pos_center(WW >> 1, -1);
			bt_confirm.onClick = confirm_click_hr;
			addChild(bt_confirm);
			
			var bt_cancel:UIButton = new UIButton('Cancel', 0, he, -1);
			bt_cancel.pos_center(WW >> 1, -1);
			bt_cancel.onClick = cancel_click_hr;
			addChild(bt_cancel);
			
			hor_line([bt_confirm, bt_cancel], WW >> 1, 10);
			
			he += Math.max(bt_confirm.height, bt_cancel.height) + 15;
			
			graphics.lineStyle(1, 0x000000, 0.5);
			graphics.beginFill(0xFFFFFF, 0.9);
			graphics.drawRoundRect(0, 0, WW, he, 16, 16);
			graphics.endFill();
			
			StageController.me.add_resize_hr(pos_hr, true);
		}
		
		public override function kill ():void {
			CONFIG::LLOG { log('kill') }
			on_confirm = null;
			on_cancel = null;
			StageController.me.rem_resize_hr(pos_hr);
			super.kill();
		}
		
		private function confirm_click_hr ():void {
			CONFIG::LLOG { log('confirm_click_hr') }
			
			callback_apply(on_confirm);
			
		}
		
		private function cancel_click_hr ():void {
			CONFIG::LLOG { log('cancel_click_hr') }
			
			callback_apply(on_cancel);
			
		}
		
		private function callback_apply (_f:Function):Boolean {
			
			if (_f != null) {
				try {
					if (!_f()) { return false; }
				} catch (e:Error) {
					return error_def_hr(Err.generate('callback apply failed: ', e, true));
				}
			}
			
			PopupCon.me.close();
			return true;
		}
		
		private function pos_hr (_sw:int, _sh:int):void {
			pos_center(_sw >> 1, _sh >> 1);
		}
		
	}
	
}









