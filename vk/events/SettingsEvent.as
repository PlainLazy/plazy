package vk.events {
  import flash.events.Event;

  /**
   * @author Andrew Rogozov
   */
  public class SettingsEvent extends Event {
  	public static const CHANGED: String = "onSettingsChanged";
  	private var _settings: uint = 0;
    public function SettingsEvent(type : String, bubbles : Boolean = false, cancelable : Boolean = false) {
      super(type, bubbles, cancelable);
    }
    public function get settings():uint {
			return _settings;
		}
		public function set settings(value: uint):void {
			_settings = value;
		}
  }
}