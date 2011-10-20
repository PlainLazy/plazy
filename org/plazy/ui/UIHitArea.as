








package org.plazy.ui {
	
	import org.plazy.BaseDisplayObject;
	import org.plazy.dt.DtPointsData;
	
	import flash.geom.Rectangle;
	import flash.display.Graphics;
	
	final public class UIHitArea extends BaseDisplayObject {
		
		// ext
		
		private var on_click:Function;
		private var on_over:Function;
		private var on_out:Function;
		
		// vars
		
		private var hit_area_dt:DtPointsData;
		
		public var x1:int;
		public var y1:int;
		public var x2:int;
		public var y2:int;
		
		// obs
		
		private var cont:BaseDisplayObject;
		private var sen:UISen;
		
		// constructor
		
		public function UIHitArea () {
			set_name(this);
			super();
		}
		
		public function set onClick (_f:Function):void { on_click = _f; }
		public function set onOver (_f:Function):void { on_over = _f; }
		public function set onOut (_f:Function):void { on_out = _f; }
		
		public function init2 (_dt:DtPointsData, _is_visible:Boolean):Boolean {
			CONFIG::LLOG { log('init2'); }
			if (!super.init()) { return false; }
			if (hit_area_dt != null) { return error_def_hr('input NULL'); }
			
			CONFIG::LLOG { log(' ' + _dt, 0x888888) }
			
			hit_area_dt = _dt;
			
			cont = new BaseDisplayObject();
			cont.buttonMode = true;
			cont.tabEnabled = false;
			addChild(cont);
			
			draw_perimeter(_is_visible);
			
			sen = new UISen(0, 0, 0, 0);
			sen.target = cont;
			sen.onOver = sen_over_hr;
			sen.onOut = sen_out_hr;
			sen.onClick = sen_click_hr;
			addChild(sen);
			
			var rect:Rectangle = getRect(null);
			x1 = x + rect.x;
			y1 = y + rect.y;
			x2 = x1 + rect.width;
			y2 = y1 + rect.height;
			
			return true;
		}
		
		public override function kill ():void {
			CONFIG::LLOG { log('kill'); }
			on_click = null;
			on_over = null;
			on_out = null;
			hit_area_dt = null;
			if (cont != null) { cont.graphics.clear(); }
			super.kill();
			cont = null;
			sen = null;
		}
		
		private function draw_perimeter (_is_visible:Boolean):void {
			
			if (hit_area_dt.points == null || hit_area_dt.points.length == 0) {
				CONFIG::LLOG { log('ERR: invalid points', 0xFF0000) }
				return;
			}
			
			if (hit_area_dt.points.length > 2) {
				
				var gr:Graphics = cont.graphics;
				gr.clear();
				gr.moveTo(hit_area_dt.points[0].dx, hit_area_dt.points[0].dy);
				
				if (_is_visible) {
					gr.lineStyle(0.1, 0x000088, 0.8);
					gr.beginFill(0xFFFF00, 0.2);
				} else {
					gr.lineStyle(0.1, 0x000088, 0);
					gr.beginFill(0x000088, 0);
				}
				
				var point_index:int;
				for (point_index = 1; point_index < hit_area_dt.points.length; point_index++) {
					gr.lineTo(hit_area_dt.points[point_index].dx, hit_area_dt.points[point_index].dy);
				}
				
				gr.endFill();
				
			}
			
		}
		
		private function sen_over_hr ():void {
			if (on_over != null) { on_over(); }
		}
		
		private function sen_out_hr ():void {
			if (on_out != null) { on_out(); }
		}
		
		private function sen_click_hr ():void {
			if (on_click != null) { on_click(); }
		}
		
	}
	
}









