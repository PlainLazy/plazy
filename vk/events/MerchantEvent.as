package vk.events {
  import flash.events.Event;

  /**
   * @author Andrew Rogozov
   */
  public class MerchantEvent extends Event {
    public static const PAYMENT_SUCCESS: String = "onMerchantPaymentSuccess";
    public static const PAYMENT_CANCEL: String = "onMerchantPaymentCancel";
    public static const PEYMENT_FAILURE: String = "onMerchantPaymentFail";
    
  	private var _orderId: String = "";
    public function MerchantEvent(type : String, bubbles : Boolean = false, cancelable : Boolean = false) {
      super(type, bubbles, cancelable);
    }
    public function get orderId():String {
			return _orderId;
		}
		public function set orderId(value: String):void {
			_orderId = value;
		}
  }
}