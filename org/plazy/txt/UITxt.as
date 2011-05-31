








package org.plazy.txt {
	
	import org.plazy.BaseDisplayObject;
	
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class UITxt extends BaseDisplayObject {
		
		// vars
		
		protected var iw:int;
		protected var ih:int;
		
		protected var as_html:Boolean;
		
		// objects
		
		public var tf:TextField;
		
		// constructor
		
		public function UITxt () {
			tf = new TextField();
			addChild(tf);
		}
		
		public override function kill():void {
			if (tf != null) { removeChild(tf); tf = null; }
			super.kill();
		}
		
		public static function frm (_size:int = 12, _color:uint = 0x000000, _bold:Boolean = false, _align:String = null, _leading:int = 0):TextFormat {
			return format(_size, _color, _bold, false, _align, _leading);
		}
		
		public static function frm1 (_face:String, _size:int = 12, _color:uint = 0x000000, _bold:Boolean = false, _italic:Boolean = false, _align:String = null, _leading:int = 0):TextFormat {
			return format(_size, _color, _bold, _italic, _align, _leading, _face);
		}
		
		public function update_text (_t:String):void {
			if (_t == null) { _t = ''; }
			if (as_html) { tf.htmlText = _t; } else { tf.text = _t; }
			if (iw > 0) { tf.width = iw; } else { tf.width = tf.textWidth - iw; }
			if (ih > 0) { tf.height = ih; } else { tf.height = tf.textHeight - ih; }
		}
		
		protected static function format (_size:int = 12, _color:uint = 0x000000, _bold:Boolean = false, _italic:Boolean = false, _align:String = null, _leading:int = 0, _face:String = 'Tahoma'):TextFormat {
			return new TextFormat(_face, _size, _color, _bold, _italic, null, null, null, _align, null, null, null, _leading);
		}
		
	}
	
}









