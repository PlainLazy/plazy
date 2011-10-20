package vk.events {
  import flash.events.Event;

  /**
   * @author Andrew Rogozov
   */
  public class ResizeEvent extends Event {
    public static const RESIZED: String = "onWindowResized";
  	private var _width: uint = 0;
 	  private var _height: uint = 0;
  	
    public function ResizeEvent(type: String, bubbles : Boolean = false, cancelable : Boolean = false) {
      super(type, bubbles, cancelable);
    }
    public function get height():uint {
			return _height;
		}
		public function set height(value: uint):void {
			_height = value;
		}
		public function get width():uint {
			return _width;
		}
		public function set width(value:uint):void {
			_width = value;
		}
  }
}