








package org.plazy {
	
	import org.plazy.BaseDisplayObject;
	import org.plazy.hc.HCTiker;
	import org.plazy.hints.IHintsContainer;
	
	public class HintsController {
		
		public static const me:HintsController = new HintsController();
		
		public var current_container:IHintsContainer;
		
		private var tiker:HCTiker;
		private var cur_obj:BaseDisplayObject;
		private var cur_dx:int;
		private var cur_dy:int;
		
		public function HintsController () {
			tiker = new HCTiker();
		}
		
		public function set_container (_cont:IHintsContainer):void {
			if (current_container != null) {
				current_container.hide();
			}
			current_container = _cont;
		}
		
		public function show (_cont:BaseDisplayObject, _dx:int, _dy:int, _delay:int = 300):void {
			if (current_container == null || _cont == null) { return; }
			
			//current_container.show(_cont, _dx, _dy);
			cur_obj = _cont;
			cur_dx = _dx;
			cur_dy = _dy;
			
			if (_delay > 0) {
				tiker.set_tik(tik_hr, _delay, 1);
			} else {
				tik_hr();
			}
		}
		
		private function tik_hr ():void {
			if (current_container == null || cur_obj == null) { return; }
			current_container.show(cur_obj, cur_dx, cur_dy);
		}
		
		public function hide ():void {
			if (current_container == null || cur_obj == null) { return; }
			current_container.hide();
			cur_obj = null;
		}
		
	}
	
}









