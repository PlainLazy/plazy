








package org.plazy.partners {
	
	import flash.display.BitmapData;
	import mailru.MailruCall;
	import org.plazy.BaseObject;
	import org.plazy.partners.ok.OKStreamPublisher;
	import org.plazy.partners.vkontakte.VkWallPoster;
	
	final public class Publisher extends BaseObject {
		
		// ext
		
		private var on_complete:Function;
		public function set onComplete (_f:Function):void { on_complete = _f; }
		
		// vars
		
		public var er:String;
		private var vkp:VkWallPoster;
		private var oksp:OKStreamPublisher;
		
		// constructor
		
		public function Publisher () {
			set_name(this);
			super();
		}
		
		public override function kill ():void {
			CONFIG::LLOG { log('kill'); }
			on_complete = null;
			super.kill();
			vkp_rem();
			oksp_rem();
		}
		
		public function publish_vk (_img:BitmapData, _wall_id:String, _post_id:String, _text:String, _append_uri:String):int {
			vkp_rem();
			vkp = new VkWallPoster();
			vkp.append_uri = _append_uri;
			vkp.onError = error_hr;
			vkp.onFailed = vkp_failed_hr;
			vkp.onComplete = vkp_complete_hr;
			return vkp.start(_img, _wall_id, _post_id, _text, true, true, false) == true ? 0 : -2;
		}
		
		public function publish_ok (_cfm:String, _title:String, _msg:String, _ext_img:String, _l1:String, _h1:String, _l2:String, _h2:String):int {
			oksp_rem();
			oksp = new OKStreamPublisher();
			oksp.onComplete = oksp_complete_hr;
			return oksp.start(_cfm, _title, _msg, _ext_img, _l1, _h1, _l2, _h2);
		}
		
		public function publish_mm (_txt:String, _links:Array, _ext_img:String):int {
			// links example: [{'text':'Давайте играть вместе!', 'href':'join_us'}]
			MailruCall.exec('mailru.common.stream.post', null, {'text': _txt, 'img_url': _ext_img, 'action_links': _links});
			return complete();
		}
		
		private function vkp_failed_hr (_t:String):Boolean {
			CONFIG::LLOG { log('vkp_failed_hr ' + _t, 0x990000); }
			er = 'vk failed: ' + _t;
			vkp_rem();
			return complete() == 0;
		}
		private function vkp_complete_hr (_posted:Boolean):Boolean {
			CONFIG::LLOG { log('vkp_complete_hr ' + _posted, 0x009900); }
			vkp_rem();
			return complete() == 0;
		}
		private function vkp_rem ():void {
			if (vkp != null) { vkp.kill(); vkp = null; }
		}
		
		private function oksp_complete_hr (_status:int):void {
			CONFIG::LLOG { log('oksp_complete_hr ' + _status, _status == 0 ? 0x009900 : 0x990000); }
			complete();
		}
		private function oksp_rem ():void {
			if (oksp != null) { oksp.kill(); oksp = null; }
		}
		
		private function complete ():int {
			return on_complete != null ? on_complete() : 0;
		}
		
		CONFIG::LLOG {
			protected override function log (_t:String, _c:uint = 0x000000):void {
				super.log('Publisher ' + _t, _c);
			}
		}
		
	}
	
}









