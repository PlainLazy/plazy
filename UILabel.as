








package org.plazy.txt {
	
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.AntiAliasType;
	
	final public class UILabel extends UITxt {
		
		// static
		
		// base
		
		// vars
		
		// objects
		
		// constructor
		
		public function UILabel (_t:String, _x:int = 0, _y:int = 0, _w:int = -6, _h:int = -6, _format:TextFormat = null, _single_line:Boolean = true, _html:Boolean = false, _embed:Boolean = false) {
			
			mouseEnabled = false;
			
			super();
			
			iw = _w;
			ih = _h;
			
			tf.selectable = false;
			tf.mouseEnabled = false;
			tf.defaultTextFormat = _format != null ? _format : frm();
			
			if (_embed) {
				tf.embedFonts = true;
			}
			
			x = _x;
			y = _y;
			
			if (!_single_line) {
				tf.width = 800;
				tf.multiline = true;
				tf.wordWrap = true;
			}
			
			as_html = _html;
			
			update_text(_t);
			
		}
		
		public static function frm (_size:int = 12, _color:uint = 0x000000, _bold:Boolean = false, _align:String = null, _leading:int = 0):TextFormat {
			
			return format(_size, _color, _bold, false, _align, _leading);
			
		}
		
		public function style (_thickness:int, _sharpness:int):void {
			// thickness [-200 .. 200]
			// sharpness [-400 .. 400]
			
			if (_thickness != 0 && _sharpness != 0) {
				tf.antiAliasType = AntiAliasType.ADVANCED;
				tf.thickness = _thickness;
				tf.sharpness = _sharpness;
			} else {
				tf.antiAliasType = AntiAliasType.NORMAL;
				tf.thickness = 0;
				tf.sharpness = 0;
			}
			
		}
		
		public override function kill ():void {
			super.kill();
		}
		
	}
	
}








