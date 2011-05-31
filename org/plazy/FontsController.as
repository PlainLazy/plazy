








package org.plazy {
	
	import flash.text.Font;
	import flash.system.ApplicationDomain;
	
	CONFIG::LLOG { import org.plazy.Logger; }
	
	public class FontsController {
		
		public static const me:FontsController = new FontsController();
		
		public function FontsController () { }
		
		public function check_app_dom (_app_dom:ApplicationDomain, _full_font_class:String):Boolean {
			CONFIG::LLOG { log('check_app_dom ' + _app_dom + ' ' + _full_font_class) }
			if (_app_dom == null || _full_font_class == null) { return false; }
			
			if (_app_dom.hasDefinition(_full_font_class)) {
				var cls:Class = _app_dom.getDefinition(_full_font_class) as Class;
				if (cls != null) {
					Font.registerFont(cls);
					return true;  // may be ;)
				}
			}
			
			/*
			var fnts:Array = Font.enumerateFonts();
			log(' fonts length = ' + fnts.length);
			for each (var fnt:Font in fnts) {
				log(' * ' + fnt.fontName + ' ' + fnt.fontStyle + ' ' + fnt.fontType + ' ' + fnt.hasGlyphs('abcABC\u042F∙'));
			}
			*/
			
			return false;
		}
		
		CONFIG::LLOG {
			private function log (_t:String, _c:uint = 0x000000):void {
				Logger.me.add('FontsController ' + _t, _c);
			}
		}
		
	}
	
}









