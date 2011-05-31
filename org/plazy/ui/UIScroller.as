








package org.plazy.ui {
	
	import org.plazy.StageController;
	import org.plazy.hc.HCTiker;
	import org.plazy.hc.HCFramer;
	
	import flash.geom.Point;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.display.Stage;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	final public class UIScroller extends Sprite {
		
		// base
		
		private var stg:Stage;
		private var style:UIScrollerStyle;
		
		private var on_mouse_down:Function;
		private var on_pos:Function;
		private var on_lock:Function;
		private var on_shift:Function;
		private var on_hide:Function;
		private var on_glue_bottom:Function;
		
		// vars
		
		private var can_be_hidden:Boolean;
		private var can_be_glue_bottom:Boolean;
		
		private var is_glue_bottom:Boolean;
		private var is_locked_by_dragger:Boolean;
		
		private var he:uint;
		private var pos_pc:Number;
		private var vis_pc:Number;
		
		private var vis_he:int;
		private var invis_he:int
		
		private var min_dragger_h:int;
		private var cur_dragger_w:int;
		
		private var bg:Shape;
		
		private var up_bmp:UIPic;
		private var down_bmp:UIPic;
		
		private var bt_up:UISen;
		private var bt_down:UISen;
		
		private var down_timer:HCTiker;
		private var down_delta:int;
		
		private var dragger:Sprite;
		private var dr_i1:BitmapData;
		private var dr_i2:BitmapData;
		private var dr_i3:BitmapData;
		private var dr_i_spr:UISen;
		private var dr_i_bmp:UIPic;
		private var dr_i_bmpd:BitmapData;
		
		private var ly:int;
		
		private var framer:HCFramer;
		private var stage_up_sen:StageUpSensor;
		
		// external
		
		// constructor
		
		public function UIScroller () {
			mouseEnabled = false;
		}
		
		public function set onMouseDown (_f:Function):void { on_mouse_down = _f; }
		public function set onPos (_f:Function):void { on_pos = _f; }
		public function set onLock (_f:Function):void { on_lock = _f; }
		public function set onShift (_f:Function):void { on_shift = _f; }
		public function set onHide (_f:Function):void { on_hide = _f; }
		public function set onGlueBottom (_f:Function):void { on_glue_bottom = _f; }
		
		public function set canBeHidden (_bool:Boolean):void {
			if (can_be_hidden == _bool) { return; }
			can_be_hidden = _bool;
			if (vis_pc == 1) {
				set_visible(false);
			} else if (!dragger.visible) {
				set_visible(true);
			}
		}
		
		public function set canGlueBottom (_bool:Boolean):void {
			if (can_be_glue_bottom == _bool) { return; }
			can_be_glue_bottom = _bool;
			is_glue_bottom = can_be_glue_bottom && pos_pc == 1;
		}
		
		public function get is_glued_bottom ():Boolean { return is_glue_bottom; }
		public function get is_locked ():Boolean { return is_locked_by_dragger; }
		
		public function init (_style:UIScrollerStyle):void {
			
			stg = StageController.me.stage;
			style = _style;
			
			framer = new HCFramer();
			stage_up_sen = new StageUpSensor(stg);
			
			bg = new Shape();
			addChild(bg);
			
			// buttons
			
			bt_up = new UISen(0, 0, 0, 0);
			bt_down = new UISen(0, 0, 0, 0);
			
			up_bmp = new UIPic(style.button_up_bd);
			down_bmp = new UIPic(style.button_down_bd);
			
			bt_up.addChild(up_bmp);
			bt_down.addChild(down_bmp);
			
			bt_up.onDown = bt_up_mouse_down_hr;
			bt_down.onDown = bt_down_mouse_down_hr;
			
			addChild(bt_up);
			addChild(bt_down);
			
			down_timer = new HCTiker();
			
			// dragger
			
			dragger = new Sprite();
			
			if (style.vertical) {
				dragger.y = bt_up.height;
			} else {
				dragger.x = bt_up.width;
			}
			
			addChild(dragger);
			
			dr_i1 = style.dragger_p1_bd;
			dr_i2 = style.dragger_p2_bd;
			dr_i3 = style.dragger_p3_bd;
			
			dr_i_spr = new UISen(0, 0, 0, 0);
			dr_i_bmp = new UIPic();
			
			dr_i_spr.addChild(dr_i_bmp);
			dr_i_spr.onDown = dragger_mouse_down_hr;
			
			dragger.addChild(dr_i_spr);
			
			ly = -1;
			
			if (style.vertical) {
				//min_dragger_h = Math.max(1, dr_i1.height + dr_i2.height + dr_i3.height);
				min_dragger_h = Math.max(1, dr_i1.height + 1 + dr_i3.height);
				cur_dragger_w = Math.max(1, dr_i1.width, dr_i2.width, dr_i3.width);
			} else {
				//min_dragger_h = Math.max(1, dr_i1.width + dr_i2.width + dr_i3.width);
				min_dragger_h = Math.max(1, dr_i1.width + 1 + dr_i3.width);
				cur_dragger_w = Math.max(1, dr_i1.height, dr_i2.height, dr_i3.height);
			}
			
		}
		
		public function set_length (val:uint):void {
			
			if (style.vertical) {
				he = val - (bt_up.height + bt_down.height);
			} else {
				he = val - (bt_up.width + bt_down.width);
			}
			
			bg.graphics.clear();
			bg.graphics.beginBitmapFill(style.background_bd);
			
			if (style.vertical) {
				bg.graphics.drawRect(0, bt_up.height, style.background_bd.width, he);
			} else {
				bg.graphics.drawRect(bt_up.height, 0, he, bt_up.height);
			}
			
			bg.graphics.endFill();
			
			if (style.vertical) {
				bt_down.y = he + bt_up.height;
			} else {
				bt_down.x = he + bt_up.height;
			}
			
		}
		
		public function set_vis (_vis:Number, _force:Boolean = false):void {
			
			if (_vis > 1) {
				_vis = 1;
			} else if (_vis < 0) {
				_vis = 0;
			}
			
			if (vis_pc != _vis || _force) {
				vis_pc = _vis;
				
				vis_he = Math.max(min_dragger_h, Math.round(he * vis_pc));
				invis_he = he - vis_he;
				
				if (style.vertical) {
					dr_i_bmpd = new BitmapData(cur_dragger_w, vis_he, true, 0x00000000);
					dr_i_bmpd.copyPixels(dr_i1, dr_i1.rect, new Point(0, 0));
					//dr_i_bmpd.draw(dr_i2, new Matrix(1, 0, 0, vis_he - (dr_i1.height + dr_i3.height), 0, dr_i1.height), null, null, new Rectangle(0, dr_i1.height, dr_i2.width, vis_he - (dr_i1.height + dr_i3.height)));
					var sh:Shape = new Shape();
					sh.graphics.beginBitmapFill(dr_i2);
					sh.graphics.drawRect(0, 0, dr_i1.width, vis_he - (dr_i1.height + dr_i3.height));
					sh.graphics.endFill();
					dr_i_bmpd.draw(sh, new Matrix(1, 0, 0, 1, 0, dr_i1.height), null, null, new Rectangle(0, dr_i1.height, dr_i2.width, vis_he - (dr_i1.height + dr_i3.height)));
					sh.graphics.clear();
					dr_i_bmpd.copyPixels(dr_i3, dr_i3.rect, new Point(0, vis_he - dr_i3.height));
				} else {
					dr_i_bmpd = new BitmapData(vis_he, cur_dragger_w, true, 0x00000000);
					dr_i_bmpd.copyPixels(dr_i1, dr_i1.rect, new Point(0, 0));
					// todo: fix dr_i2 drawing...
					dr_i_bmpd.draw(dr_i2, new Matrix(vis_he - (dr_i1.width + dr_i3.width), 0, 0, 1, dr_i1.width, 0), null, null, new Rectangle(dr_i1.width, 0, vis_he - (dr_i1.width + dr_i3.width), dr_i3.height));
					dr_i_bmpd.copyPixels(dr_i3, dr_i3.rect, new Point(vis_he - dr_i3.width, 0));
				}
				
				dr_i_bmp.bitmapData = dr_i_bmpd;
				
				if (_vis == 1) {
					dragger.visible = false;
					set_visible(false);
				} else if (!dragger.visible) {
					dragger.visible = true;
					set_visible(true);
				}
				
			}
			
		}
		
		public function set_pos (_pos:Number, _force:Boolean = false):void {
			//trace('**** set_pos ' + _pos + ' ' + pos_pc);
			
			if (pos_pc != _pos || _force) {
				
				pos_pc = _pos;
				check_glue();
				
				if (style.vertical) {
					dr_i_spr.y = Math.round(invis_he * pos_pc);
					ly = dr_i_spr.y;
				} else {
					dr_i_spr.x = Math.round(invis_he * pos_pc);
					ly = dr_i_spr.x;
				}
				
			}
			
		}
		
		public function set_visible (_bool:Boolean):void {
			if (can_be_hidden) {
				if (on_hide != null) { on_hide(!_bool); }
				visible = _bool;
				dragger.visible = _bool;
			}
		}
		
		private function dragger_mouse_down_hr ():void {
			
			if (on_mouse_down != null) { on_mouse_down(); }
			
			locked(true);
			
			if (style.vertical) {
				dr_i_spr.startDrag(false, new Rectangle(0, 0, 0, invis_he));
			} else {
				dr_i_spr.startDrag(false, new Rectangle(0, 0, invis_he, 0));
			}
			
			stage_up_sen.onUp = dragger_mouse_up_hr;
			framer.set_frame(dragger_frame_hr);
			
		}
		
		private function dragger_frame_hr ():void {
			
			if (style.vertical) {
				if (ly != dr_i_spr.y) {
					ly = dr_i_spr.y;
					pos_pc = ly / invis_he;
					check_glue();
					if (on_pos != null) { on_pos(pos_pc); }
				}
			} else {
				if (ly != dr_i_spr.x) {
					ly = dr_i_spr.x;
					pos_pc = ly / invis_he;
					check_glue();
					if (on_pos != null) { on_pos(pos_pc); }
				}
			}
			
		}
		
		private function check_glue ():void {
			
			if (can_be_glue_bottom) {
				is_glue_bottom = pos_pc == 1;
				if (is_glue_bottom && on_glue_bottom != null) { on_glue_bottom(); }
			}
			
		}
		
		private function dragger_mouse_up_hr ():void {
			
			locked(false);
			
			framer.rem_frame();
			stage_up_sen.onUp = null;
			dr_i_spr.stopDrag();
			
		}
		
		private function bt_up_mouse_down_hr ():void {
			
			if (on_mouse_down != null) { on_mouse_down(); }
			
			locked(true);
			
			down_delta = -1;
			down_timer.set_tik(down_timer_hr, 800, 1);
			
			if (on_shift != null) { on_shift(down_delta); }
			
			stage_up_sen.onUp = btUpMouseUpHr;
			
		}
		
		private function btUpMouseUpHr ():void {
			
			locked(false);
			down_timer.rem_tik();
			stage_up_sen.onUp = null;
			
		}
		
		private function bt_down_mouse_down_hr ():void {
			
			if (on_mouse_down != null) { on_mouse_down(); }
			
			locked(true);
			
			down_delta = 1;
			
			down_timer.set_tik(down_timer_hr, 800, 1);
			
			if (on_shift != null) { on_shift(down_delta); }
			
			stage_up_sen.onUp = bt_down_mouse_up_hr;
			
		}
		
		private function bt_down_mouse_up_hr ():void {
			
			locked(false);
			down_timer.rem_tik();
			stage_up_sen.onUp = null;
			
		}
		
		public function get_pos_pc ():Number {
			return pos_pc;
		}
		
		private function down_timer_hr ():void {
			
			down_timer.set_tik(down_timer_hr, 100, 0);
			if (on_shift != null) { on_shift(down_delta); }
			
		}
		
		private function locked (_bool:Boolean):void {
			is_locked_by_dragger = _bool;
			if (on_lock != null) { on_lock(_bool); }
		}
		
		public function kill ():void {
			
			on_mouse_down = null;
			on_pos = null;
			on_lock = null;
			on_shift = null;
			on_lock = null;
			on_glue_bottom = null;
			
			removeChild(bg);
			bg = null;
			
			up_bmp.kill();
			up_bmp = null;
			
			down_bmp.kill();
			down_bmp = null;
			
			bt_up.kill();
			bt_up = null;
			
			bt_down.kill();
			bt_down = null;
			
			down_timer.kill();
			down_timer = null;
			
			removeChild(dragger);
			dragger = null;
			
			dr_i1 = null;
			dr_i2 = null;
			dr_i3 = null;
			
			dr_i_bmpd = null;
			
			dr_i_bmp.kill();
			dr_i_bmp = null;
			
			dr_i_spr.kill();
			dr_i_spr = null;
			
			framer.kill();
			framer = null;
			
			stage_up_sen.kill();
			stage_up_sen = null;
			
			stg = null;
			style = null;
			
			if (parent != null) { parent.removeChild(this); }
			
		}
		
	}
	
}

import flash.display.Stage;

import flash.events.MouseEvent;

class StageUpSensor {
	
	private var stg:Stage;
	private var have_up_stage:Boolean;
	private var up_stage_hr:Function;
	
	public function StageUpSensor (_stg:Stage) {
		stg = _stg;
	}
	
	public function set onUp (_hr:Function):void {
		rem_up_stage_hr();
		if (_hr != null) {
			have_up_stage = true;
			up_stage_hr = _hr;
			stg.addEventListener(MouseEvent.MOUSE_UP, sen_up_stage_hr);
		}
	}
	
	private function rem_up_stage_hr ():void {
		if (have_up_stage) {
			have_up_stage = false;
			stg.removeEventListener(MouseEvent.MOUSE_UP, sen_up_stage_hr);
			up_stage_hr = null;
		}
	}
	
	private function sen_up_stage_hr (e:MouseEvent):void {
		up_stage_hr();
	}
	
	public function kill ():void {
		rem_up_stage_hr();
		stg = null;
	}
	
}









