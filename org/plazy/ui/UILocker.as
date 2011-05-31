








package org.plazy.ui {
	
	import org.plazy.Err;
	import org.plazy.BaseDisplayObject;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class UILocker extends BaseDisplayObject implements IUILocker {
		
		// ext
		
		private var on_click:Function;
		
		// vars
		
		private var locks:int;
		
		private var is_active:Boolean;
		
		private var wi:int;
		private var he:int;
		
		private var in_frame:Boolean;
		private var delta:Number;
		
		private var delta_in:Number;
		private var delta_out:Number;
		
		private var delay:int;
		private var delay_frames:int;
		
		private var fade_color:int = 0x000000;
		private var fade_alpha:Number = 0.6;
		
		// objects
		
		private var cont:BaseDisplayObject;
		
		// constructor
		
		public function UILocker (_x:int, _y:int, _w:int, _h:int, _cont:BaseDisplayObject) {
			set_name(this);
			super();
			
			x = _x;
			y = _y;
			
			set_size(_w, _h);
			
			cont = _cont;
			
			alpha = 0;
			
			delta_in = 1/32;
			delta_out = -1/3;
			
			addEventListener(MouseEvent.CLICK, mouse_click_hr);
			
		}
		
		public function set onClick (_f:Function):void { on_click = _f; }
		
		public override function kill ():void {
			on_click = null;
			removeEventListener(MouseEvent.CLICK, mouse_click_hr);
			in_cont(false);
			rem_frame();
			super.kill();
		}
		
		public function set_delay (_delay:int):void {
			delay = _delay;
		}
		
		public function set_fade (_color:int, _alpha:Number):void {
			fade_color = _color;
			fade_alpha = isNaN(_alpha) ? 0.6 : _alpha;
			set_size(wi, he);
		}
		
		public function set_size (_w:int, _h:int):void {
			
			wi = _w;
			he = _h;
			
			graphics.clear();
			graphics.beginFill(fade_color, fade_alpha);
			graphics.drawRect(0, 0, wi, he);
			graphics.endFill();
			
		}
		
		public function set active (_bool:Boolean):void {
			CONFIG::LLOG { log('active=' + _bool); }
			
			locks += _bool ? 1 : -1;
			
			if (locks < 0) {
				CONFIG::LLOG {
					log('ERR: locks less then 0', 0xFF0000);
					log(' ' + (new Error()).getStackTrace(), 0xFF0000);
				}
				locks = 0;
			}
			
			var new_active:Boolean = locks > 0;
			
			if (is_active == new_active) {
				return;
			}
			
			is_active = new_active;
			
			if (is_active) {
				
				if (delta > 0) { return; }
				
				delay_frames = delay;
				
				in_cont(true);
				set_frame(delta_in);
				
			} else {
				
				if (delta < 0) { return; }
				
				set_frame(delta_out);
				
			}
			
		}
		
		public function reset ():void {
			CONFIG::LLOG { log('reset'); }
			if (locks > 0) {
				locks = 1;
				active = false;
			}
		}
		
		private function in_cont (_bool:Boolean):void {
			if (_bool) {
				//CONFIG::LLOG { log('addChild to ' + cont); }
				cont.addChild(this);
			} else {
				if (cont.contains(this)) {
					cont.removeChild(this);
				}
			}
		}
		
		private function set_frame (_delta:Number):void {
			delta = _delta;
			if (!in_frame) {
				in_frame = true;
				addEventListener(Event.ENTER_FRAME, frame_hr);
			}
		}
		
		private function rem_frame ():void {
			if (in_frame) {
				in_frame = false;
				removeEventListener(Event.ENTER_FRAME, frame_hr);
			}
		}
		
		private function frame_hr (e:Event):void {
			frame_apply();
		}
		
		private function frame_apply ():void {
			
			var new_alpha:Number = alpha + delta;
			
			if (delta > 0) {
				if (delay_frames > 0) {
					delay_frames--;
				} else {
					if (new_alpha < 1) {
						alpha = new_alpha;
					} else {
						alpha = 1;
						rem_frame();
					}
				}
			} else {
				if (new_alpha > 0) {
					alpha = new_alpha;
				} else {
					alpha = 0;
					rem_frame();
					in_cont(false);
				}
			}
			
		}
		
		private function mouse_click_hr (_e:MouseEvent):void {
			CONFIG::LLOG { log('mouse_click_hr'); }
			if (on_click != null) { on_click(); }
		}
		
	}
	
}








