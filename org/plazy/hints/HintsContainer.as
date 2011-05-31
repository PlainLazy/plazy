








package org.plazy.hints {
	
	import org.plazy.StageController;
	import org.plazy.BaseDisplayObject;
	import org.plazy.hc.HCFramer;
	
	final public class HintsContainer extends BaseDisplayObject implements IHintsContainer {
		
		// vars
		
		private var framer:HCFramer;
		
		private var lx:int;
		private var ly:int;
		
		private var dx:int;
		private var dy:int;
		
		// objects
		
		private var current_hint:BaseDisplayObject;
		
		// constructor
		
		public function HintsContainer () {
			set_name(this);
			super();
			mouseChildren = false;
			mouseEnabled = false;
			framer = new HCFramer();
		}
		
		public override function kill ():void {
			CONFIG::LLOG { log('kill') }
			if (killed) { return; }
			hide();
			framer.kill();
			framer = null;
			super.kill();
		}
		
		public function show (_cont:BaseDisplayObject, _dx:int = 0, _dy:int = 0):void {
			hide();
			CONFIG::LLOG { log('show') }
			if (_cont == null) { return; }
			
			current_hint = _cont;
			addChild(current_hint);
			
			dx = _dx;
			dy = _dy;
			
			lx = -1;
			ly = -1;
			
			framer.set_frame(frame_hr, true);
		}
		
		public function hide ():void {
			CONFIG::LLOG { log('hide') }
			if (framer != null) { framer.rem_frame(); }
			if (current_hint != null) { current_hint.kill(); current_hint = null; }
		}
		
		private function frame_hr ():void {
			
			var cx:int = int(mouseX);
			var cy:int = int(mouseY);
			
			if (lx == cx && ly == cy) { return; }
			
			lx = cx;
			ly = cy;
			
			var x1:int = lx + dx;
			var x2:int = lx + dx + current_hint.width;
			var y1:int = ly + dy;
			var y2:int = ly + dy + current_hint.height;
			
			if (x2 > StageController.me.sw) {
				x1 = lx - current_hint.width;
				if (x1 < 0) { x1 = 0; }
			}
			
			if (y2 > StageController.me.sh) {
				y1 = ly - current_hint.height;
				if (y1 < 0) { y1 = 0; }
			}
			
			current_hint.x = x1;
			current_hint.y = y1;
		}
		
	}
	
}









