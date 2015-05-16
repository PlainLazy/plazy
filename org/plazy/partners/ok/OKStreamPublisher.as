








package org.plazy.partners.ok {
	
	import api.com.odnoklassniki.events.ApiCallbackEvent;
	import api.com.odnoklassniki.Odnoklassniki;
	import com.adobe.serialization.json.JSON;
	import org.plazy.BaseObject;
	
	final public class OKStreamPublisher extends BaseObject {
		
		// ext
		
		private var on_complete:Function;
		public function set onComplete (_f:Function):void { on_complete = _f; }
		
		// vars
		
		private var req:Object;
		private var listen:Boolean;
		
		// constructor
		
		public function OKStreamPublisher () {
			set_name(this);
			super();
		}
		
		public function start (_confirm:String, _title:String, _message:String, _img:String, _lnk1t:String, _lnk1h:String, _lnk2t:String, _lnk2h:String):int {
			CONFIG::LLOG { log('start'); }
			CONFIG::LLOG { log(' confirm=' + _confirm, 0x888888); }
			CONFIG::LLOG { log(' message=' + _message, 0x888888); }
			CONFIG::LLOG { log(' img=' + _img, 0x888888); }
			CONFIG::LLOG { log(' link1=' + _lnk1t + '(' + _lnk1h + ')', 0x888888); }
			CONFIG::LLOG { log(' link2=' + _lnk2t + '(' + _lnk2h + ')', 0x888888); }
			
			if (_message != null && _message.length > 128) {
				CONFIG::LLOG { log('WARN: message crop to 128 chars', 0x990000); }
				_message = _message.substr(0, 128 - 3) + '...';
			}
			
			listen = true;
			Odnoklassniki.addEventListener(ApiCallbackEvent.CALL_BACK, callback_hr, false, 0, true);
			
			var att:Object = {"caption":_message, "media":[{"href":"link","src":_img,"type":"image"}]};
			var att_str:String = _img != null ? com.adobe.serialization.json.JSON.encode(att) : null;
			
			var links:Array = [];
			if (_lnk1t != null && _lnk1h != null) { links.push({'text':_lnk1t,'href':_lnk1h}); }
			if (_lnk2t != null && _lnk2h != null) { links.push({'text':_lnk2t,'href':_lnk2h}); }
			var links_str:String = links.length > 0 ? JSON.encode(links) : null;
			
			req = {'method': 'stream.publish', 'message': _title, 'attachment': att_str, 'action_links': links_str};
			req = Odnoklassniki.getSignature(req, true);
			Odnoklassniki.showConfirmation('stream.publish', _confirm, req['sig']);
			
			return 0;
		}
		
		public override function kill ():void {
			CONFIG::LLOG { log('kill'); }
			on_complete = null;
			super.kill();
		}
		
		private function callback_hr (_e:ApiCallbackEvent):void {
			CONFIG::LLOG { log('callback_hr', 0x009900); }
			CONFIG::LLOG { log(' method=' + _e.method, 0x888888);  }
			CONFIG::LLOG { log(' data=' + _e.data, 0x888888); }
			CONFIG::LLOG { log(' result=' + _e.result, 0x888888); }
			if (!listen) {
				CONFIG::LLOG { log('  ignore by "listen" flag', 0x990000); }
				return;
			}
			
			if (_e.method == 'showConfirmation') {
				listen = false;
				if (_e.result == 'ok') {
					req['resig'] = _e.data;
					Odnoklassniki.callRestApi('stream.publish', stream_publish_hr, req);
				} else {
					complete(-1);
				}
			}
			
		}
		
		private function stream_publish_hr (_obj:Object):void {
			CONFIG::LLOG { log('stream_publish_hr', 0x009900); }
			CONFIG::LLOG {
				if (_obj != null) {
					for (var k:String in _obj) {
						log(' _obj[' + k + ']=' + _obj[k], 0x888888);
					}
				}
			}
			
			complete(0);
		}
		
		private function complete (_status:int):void {
			if (on_complete != null) { on_complete(_status); }
		}
		
		CONFIG::LLOG {
			protected override function log (_t:String, _c:uint = 0x000000):void {
				super.log('org.plazy.partners.ok.OKStreamPublisher ' + _t, _c);
			}
		}
		
	}
	
}









