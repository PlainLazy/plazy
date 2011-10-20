package vk {
  import flash.net.LocalConnection;
  import flash.external.ExternalInterface;
  import flash.events.*;
  import flash.utils.setTimeout;

  import vk.events.*;


  /**
   * @author Andrew Rogozov
   */
  public class APIConnection extends EventDispatcher {
		
    private var sendingLC:LocalConnection;
    private var connectionName:String;
    private var receivingLC:LocalConnection;
    
    private var pendingRequests:Array;
    private var loaded:Boolean = false;
    
    public function APIConnection(connectionName: String) {
      pendingRequests = new Array();
      
      this.connectionName = connectionName;
      
      sendingLC = new LocalConnection();
      sendingLC.allowDomain('*');
      
      receivingLC = new LocalConnection();
      receivingLC.allowDomain('*');
      receivingLC.client = {
        initConnection: initConnection,
        onBalanceChanged: onBalanceChanged,
        onSettingsChanged: onSettingsChanged,
				onLocationChanged: onLocationChanged,
				onWindowResized: onWindowResized,
				onApplicationAdded: onApplicationAdded,
				onWindowBlur: onWindowBlur,
				onWindowFocus: onWindowFocus,
				onWallPostSave: onWallPostSave,
				onWallPostCancel: onWallPostCancel,
				onProfilePhotoSave: onProfilePhotoSave,
				onProfilePhotoCancel: onProfilePhotoCancel,
				onMerchantPaymentSuccess: onMerchantPaymentSuccess,
				onMerchantPaymentCancel: onMerchantPaymentCancel,
				onMerchantPaymentFail: onMerchantPaymentFail,
				customEvent: customEvent
      };
			
      try {
				receivingLC.connect("_out_" + connectionName);
			} catch (error:ArgumentError) {
				debug("Can't connect from App. The connection name is already being used by another SWF");
			}
			
      sendingLC.addEventListener(StatusEvent.STATUS, onInitStatus);
      sendingLC.send("_in_" + connectionName, "initConnection");
			
    }
    
		/*
		private function sendingLC_secu_err_hr (_e:SecurityErrorEvent):void {
			trace('VKontakte mudaki: sendingLC_secu_err_hr');
		}
		private function sendingLC_async_err_hr (_e:AsyncErrorEvent):void {
			trace('VKontakte mudaki: sendingLC_async_err_hr');
		}
		
		private function receivingLC_status_hr (_e:StatusEvent):void {
			trace('VKontakte mudaki: receivingLC_status_hr');
		}
		private function receivingLC_secu_err_hr (_e:SecurityErrorEvent):void {
			trace('VKontakte mudaki: receivingLC_secu_err_hr');
		}
		private function receivingLC_async_err_hr (_e:AsyncErrorEvent):void {
			trace('VKontakte mudaki: receivingLC_async_err_hr');
		}
		*/
		
    /*
     * Public methods
     */
	public function callMethod(...params):void {
	  var paramsArr: Array = params as Array;
	  paramsArr.unshift("callMethod");
	  sendData.apply(this, paramsArr);
	}
	
    public function debug(msg: *): void {
      if (!msg || !msg.toString) {
        return;
      }
      sendData("debug", msg.toString());
    }
	
	/* Obsolete methods */
    public function showSettingsBox(mask: uint = 0): void {
      sendData("showSettingsBox", mask.toString());
    }
    public function showInstallBox(): void {
      sendData("showInstallBox");
    }
    public function showInviteBox(): void {
      sendData("showInviteBox");
    }
    public function showPaymentBox(votes: uint = 0): void {
      sendData("showPaymentBox", votes.toString());
    }
    public function showProfilePhotoBox(hash: String): void {
      sendData("showProfilePhotoBox", hash);
    }
    public function saveWallPost(hash: String): void {
      sendData("saveWallPost", hash);
    }
    public function resizeWindow(width: int, height: int): void {
      sendData("resizeWindow", width.toString(), height.toString());
    }
    public function scrollWindow(top: int, speed: int): void {
      sendData("scrollWindow", top.toString(), speed.toString());
    }
    public function setTitle(title: String): void {
      sendData("setTitle", title);
    }
    public function setLocation(location: String): void {
      sendData("setLocation", location);
    }
    public function showMerchantPaymentBox(params: Object):void {
      var paramsArr: Array = [];
      for (var i: String in params) {
        paramsArr.unshift(i + '=' + params[i]);
      }
      paramsArr.unshift("showMerchantPaymentBox");
      sendData.apply(this, paramsArr);
	}
  
    /*
     * Callbacks
     */
    private function initConnection(): void {
      if (loaded) return;
      loaded = true;
      debug("Connection initialized.");
      dispatchEvent(new CustomEvent(CustomEvent.CONN_INIT));
      sendPendingRequests();
    }
    private function onBalanceChanged(balance: String): void {
      var e:BalanceEvent = new BalanceEvent(BalanceEvent.CHANGED);
      e.balance = parseInt(balance);
      dispatchEvent(e);
    }
    private function onSettingsChanged(settings: String): void {
      var e:SettingsEvent = new SettingsEvent(SettingsEvent.CHANGED);
      e.settings = parseInt(settings);
      dispatchEvent(e);
    }
    private function onWindowResized(width: String, height: String): void {
      var e:ResizeEvent = new ResizeEvent(ResizeEvent.RESIZED);
      e.width = parseInt(width);
      e.height = parseInt(height);
      dispatchEvent(e);
    }
    private function onLocationChanged(location: String): void {
      var e:LocationEvent = new LocationEvent(LocationEvent.CHANGED);
      e.location = location;
      dispatchEvent(e);
    }
    public function onApplicationAdded(): void {
      dispatchEvent(new CustomEvent(CustomEvent.APP_ADDED));
    }
    public function onWindowBlur(): void {
      dispatchEvent(new CustomEvent(CustomEvent.WINDOW_BLUR));
    }
    public function onWindowFocus(): void {
      dispatchEvent(new CustomEvent(CustomEvent.WINDOW_FOCUS));
    }
    public function onProfilePhotoSave(): void {
      dispatchEvent(new CustomEvent(CustomEvent.PHOTO_SAVE));
    }
    public function onProfilePhotoCancel(): void {
      dispatchEvent(new CustomEvent(CustomEvent.PHOTO_CANCEL));
    }
    public function onWallPostSave(): void {
      dispatchEvent(new CustomEvent(CustomEvent.WALL_SAVE));
    }
    public function onWallPostCancel(): void {
      dispatchEvent(new CustomEvent(CustomEvent.WALL_CANCEL));
    }
    public function onMerchantPaymentSuccess(orderId: String): void {
      var e:MerchantEvent = new MerchantEvent(MerchantEvent.PAYMENT_SUCCESS);
      e.orderId = orderId;
      dispatchEvent(e);
    }
    public function onMerchantPaymentCancel(): void {
      dispatchEvent(new MerchantEvent(MerchantEvent.PAYMENT_CANCEL));
    }
    public function onMerchantPaymentFail(): void {
      dispatchEvent(new MerchantEvent(MerchantEvent.PEYMENT_FAILURE));
    }
	public function customEvent(...params): void {
	  var paramsArr: Array = params as Array;
	  var eventName: String = paramsArr.shift();
	  var e:CustomEvent = new CustomEvent(eventName);
	  e.params = paramsArr;
	  dispatchEvent(e);
	}
     
    /*
     * Private methods
     */
    private function sendPendingRequests(): void {
      while (pendingRequests.length) {
        sendData.apply(this, pendingRequests.shift());
      }
    }
    
    private function sendData(...params):void {
      var paramsArr: Array = params as Array;
      if (loaded) {
        paramsArr.unshift("_in_" + connectionName);
        sendingLC.send.apply(null, paramsArr);
      } else {
        pendingRequests.push(paramsArr);
      }
    }
    private function onInitStatus(e:StatusEvent):void {
      debug("StatusEvent: "+e.level);
      e.target.removeEventListener(e.type, onInitStatus);
      if (e.level == "status") {
        receivingLC.client.initConnection();
      }
    }
  }
}
