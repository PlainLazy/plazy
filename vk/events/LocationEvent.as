package vk.events {
  import flash.events.Event;

  /**
   * @author Andrew Rogozov
   */
  public class LocationEvent extends Event {
    public static const CHANGED: String = "onLocationChanged";
    private var _location: String = new String();
    public function LocationEvent(type : String, bubbles : Boolean = false, cancelable : Boolean = false) {
      super(type, bubbles, cancelable);
    }
    public function get location():String {
			return _location;
		}
		public function set location(value: String):void {
			_location = value;
		}
  }
}

