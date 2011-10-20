package vk.events {
  import flash.events.Event;

  /**
   * @author Andrew Rogozov
   */
  public class BalanceEvent extends Event {
  	public static const CHANGED: String = "onBalanceChanged";
  	private var _balance: uint = 0;
    public function BalanceEvent(type : String, bubbles : Boolean = false, cancelable : Boolean = false) {
      super(type, bubbles, cancelable);
    }
    public function get balance():uint {
			return _balance;
		}
		public function set balance(value: uint):void {
			_balance = value;
		}
  }
}