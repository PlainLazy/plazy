








package org.plazy.ui {
	
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import org.plazy.BaseDisplayObject;
	
	public class UISen extends BaseDisplayObject {
		
		// static
		
		private const TP_DOWN:int      = 1;
		private const TP_UP:int        = 2;
		private const TP_UP_STAGE:int  = 3;
		private const TP_CLICK:int     = 4;
		private const TP_OVER:int      = 5;
		private const TP_OUT:int       = 6;
		private const TP_MOVE:int      = 7;
		private const TP_DOUBLE:int    = 8;
		
		// const
		
		private const DBL_CLICK_EVENT:String = 'double_click';
		
		// vars
		
		private var hash:Object = {};
		private var events:Object = {};
		private var current_target:DisplayObject;
		private var dbl_click_interval:int = 250;
		
		// constructor
		
		public function UISen (_x:int, _y:int, _w:int, _h:int, _stg:Stage = null) {
			super();
			
			x = _x;
			y = _y;
			
			set_size(_w, _h);
			
			buttonMode = true;
			tabEnabled = false;
			
			hash[TP_DOWN]     = [this, MouseEvent.MOUSE_DOWN];
			hash[TP_UP]       = [this, MouseEvent.MOUSE_UP];
			hash[TP_UP_STAGE] = [_stg, MouseEvent.MOUSE_UP];
			hash[TP_CLICK]    = [this, MouseEvent.CLICK];
			hash[TP_OVER]     = [this, MouseEvent.MOUSE_OVER];
			hash[TP_OUT]      = [this, MouseEvent.MOUSE_OUT];
			hash[TP_MOVE]     = [this, MouseEvent.MOUSE_MOVE];
			hash[TP_DOUBLE]   = [this, DBL_CLICK_EVENT];
			
			current_target = this;
		}
		
		public function set target (_tar:DisplayObject):void {
			if (current_target == _tar) { return; }
			
			current_target = _tar;
			
			var type:String;
			for (type in hash) {
				if (int(type) == TP_UP_STAGE) {
					// dont change target for stage_mouse_up_handler (target is stage allways)
					continue;
				}
				hash[type][0] = _tar;
			}
			
			visible = current_target == this;
		}
		
		public function set enabled (_bool:Boolean):void {
			try {
				var sen:InteractiveObject = current_target as InteractiveObject;
				sen.mouseEnabled = _bool;
			} catch (e:Error) { }
		}
		
		public function set_dbl_interval (_ms:int):void {
			dbl_click_interval = Math.max(100, _ms);
		}
		
		public function set_size (_w:int, _h:int):void {
			graphics.clear();
			if (_w <= 0 || _h <= 0) { return; }
			graphics.beginFill(0xFFFF00, 0);
			//CONFIG::LLOG { graphics.beginFill(0xFFFF00, 0.2); }
			graphics.drawRect(0, 0, _w, _h);
			graphics.endFill();
		}
		
		public function set onOver (_f:Function):void {
			update_event(TP_OVER, _f);
		}
		
		public function set onOut (_f:Function):void {
			update_event(TP_OUT, _f);
		}
		
		public function set onClick (_f:Function):void {
			update_event(TP_CLICK, _f);
		}
		
		public function set onDown (_f:Function):void {
			update_event(TP_DOWN, _f);
		}
		
		public function set onUp (_f:Function):void {
			update_event(TP_UP, _f);
		}
		
		public function set onUpStage (_f:Function):void {
			update_event(TP_UP_STAGE, _f);
		}
		
		public function set onDoubleClick (_f:Function):void {
			update_event(TP_DOUBLE, _f);
		}
		
		public function set onMove (_f:Function):void {
			update_event(TP_MOVE, _f);
		}
		
		private function update_event (_type:int, _f:Function):void {
			if (_f != null) {
				add_event(_type, _f);
			} else {
				rem_event(_type);
			}
		}
		
		private function add_event (_type:int, _handler:Function):void {
			
			var events_data:Array = hash[_type];
			
			if (events_data == null) {
				rem_event(_type);
			}
			
			var target:DisplayObject = events_data[0];
			var event:String = events_data[1];
			
			rem_event(_type);
			
			if (target == null) { return; }
			
			if (event == DBL_CLICK_EVENT) {
				events[_type] = new EventManagerDouble(target, event, _handler, dbl_click_interval);
			} else {
				events[_type] = new EventManagerStandart(target, event, _handler);
			}
			
		}
		
		private function rem_event (_type:int):void {
			
			var Di:EventManager = events[_type];
			if (Di == null) { return; }
			
			Di.kill();
			delete events[_type];
			
		}
		
		public override function kill ():void {
			
			graphics.clear();
			
			var Di:EventManager;
			for each (Di in events) {
				Di.kill();
			}
			
			super.kill();
			
			events = null;
			hash = null;
			
		}
		
	}
	
}

import flash.display.DisplayObject;
import flash.events.MouseEvent;
import org.plazy.StageController;

class EventManager {
	
	public var target:DisplayObject;
	public var event:String;
	public var handler:Function;
	
	public function EventManager (_target:DisplayObject, _event:String, _handler:Function):void {
		target = _target;
		event = _event;
		handler = _handler;
	}
	
	protected function event_hr (e:MouseEvent):void {
		if (handler != null) { handler(); }
	}
	
	public function kill ():void {
		target = null;
		handler = null;
	}
	
}

class EventManagerStandart extends EventManager {
	
	public function EventManagerStandart (_target:DisplayObject, _event:String, _handler:Function) {
		super(_target, _event, _handler);
		target.addEventListener(_event, event_hr);
	}
	
	public override function kill ():void {
		target.removeEventListener(event, handler);
		super.kill();
	}
	
}

class EventManagerDouble extends EventManager {
	
	private var interval:int;
	private var last_click:Number = 0;
	
	public function EventManagerDouble (_target:DisplayObject, _event:String, _handler:Function, _interval:int) {
		super(_target, _event, _handler);
		interval = _interval;
		target.addEventListener(MouseEvent.CLICK, click_hr);
		StageController.me.add_mup_hr(mup_hr);
	}
	
	public function click_hr (e:MouseEvent):void {
		
		var now:Number = get_now();
		
		if (now - last_click < interval) {
			// double click applyed
			last_click = 0;
			event_hr(e);
		} else {
			last_click = now;
		}
		
	}
	
	private function get_now ():Number {
		var d:Date = new Date();
		return d.getTime();
	}
	
	private function mup_hr ():Boolean {
		if (!target.getRect(null).contains(target.mouseX, target.mouseY)) {
			last_click = 0;
		}
		return true;
	}
	
	public override function kill ():void {
		target.removeEventListener(MouseEvent.CLICK, click_hr);
		StageController.me.rem_mup_hr(mup_hr);
		super.kill();
	}
	
}










