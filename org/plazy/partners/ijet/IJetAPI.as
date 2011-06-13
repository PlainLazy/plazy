








package org.plazy.partners.ijet {
	
	import org.plazy.Locker;
	import org.plazy.BaseObject;
	
	import flash.external.ExternalInterface;
	
	final public class IJetAPI extends BaseObject {
		
		public static const me:IJetAPI = new IJetAPI();
		
		public static const CMD_GET_USER_PROFILE:String     = 'getUserProfile';
		public static const CMD_GET_USERS_PROFILES:String   = 'getUsersProfiles';
		public static const CMD_GET_APP_FRIENDS:String      = 'getAppFriendsInfo';
		public static const CMD_GET_ALL_FRIENDS:String      = 'getAllFriendsInfo';
		public static const CMD_SHOW_INVITE_FRIENDS:String  = 'showInviteFriends';
		public static const CMD_SHOW_PAYMENTS:String        = 'showPayments';
		
		public var contaner_id:String;
		private var queue:Vector.<DtIJetCmd>;
		private var cur_cmd:DtIJetCmd;
		
		// constructor
		
		public function IJetAPI () {
			set_name(this);
			super();
			
			if (ExternalInterface.available) {
				ExternalInterface.addCallback('callback_hr', callback_hr);
			}
			
		}
		
		public override function kill ():void {
			CONFIG::LLOG { log('kill'); }
			super.kill();
		}
		
		public function reset ():void {
			CONFIG::LLOG { log('reset'); }
			if (queue != null) {
				for each (var cmd:DtIJetCmd in queue) { cmd.handler = null; }
				queue = new Vector.<DtIJetCmd>();
			}
			if (cur_cmd != null) {
				cancel(cur_cmd.handler);
			}
		}
		
		public function send (_cmd:String, _params:Object, _hr:Function, _lock:Boolean):Boolean {
			CONFIG::LLOG { log('send ' + _cmd); }
			
			var cmd:DtIJetCmd = new DtIJetCmd();
			cmd.cmd = _cmd;
			cmd.params = _params;
			cmd.handler = _hr;
			cmd.lock = _lock;
			
			if (queue == null) { queue = new Vector.<DtIJetCmd>(); }
			queue.push(cmd);
			
			return check();
		}
		
		public function cancel (_hr:Function):void {
			CONFIG::LLOG { log('cancel'); }
			if (queue != null && queue.length > 0) {
				for (var i:int = 0; i < queue.length; i++) {
					if (queue[i].handler == _hr) {
						queue.splice(i, 1);
						break;
					}
				}
			}
			if (cur_cmd != null && cur_cmd.handler == _hr) {
				if (cur_cmd.lock) { Locker.me.active = false; }
				cur_cmd.handler = null;
				cur_cmd = null;
				check();
			}
		}
		
		private function check ():Boolean {
			CONFIG::LLOG { log('check'); }
			if (cur_cmd != null) { return true; }  // sime cmd in progress
			if (queue == null || queue.length == 0) { return true; }  // commands queue is empty or null
			
			cur_cmd = queue.shift();
			
			if (!ExternalInterface.available) {
				cur_cmd.handler = null;
				cur_cmd = null;
				return error_def_hr('ExternalInterface not available, cmd (' + cur_cmd.cmd + ') send failed');
			}
			
			if (cur_cmd.lock) { Locker.me.active = true; }
			
			try {
				ExternalInterface.call('SNM.sendRequest', cur_cmd.cmd, cur_cmd.params, 'callback_hr', contaner_id);
			} catch (e:Error) {
				if (cur_cmd.lock) { Locker.me.active = false; }
				cur_cmd.handler = null;
				cur_cmd = null;
				return error_ext_hr('send request failed', e);
			}
			
			return true;
		}
		
		private function callback_hr (_result:Object):void {
			CONFIG::LLOG { log('callback_hr'); }
			if (cur_cmd == null) {
				CONFIG::LLOG { log('WARN: cur_cmd NULL', 0x990000); }
				return;
			}
			
			if (cur_cmd.lock) { Locker.me.active = false; }
			var hr:Function = cur_cmd.handler;
			cur_cmd.handler = null;
			cur_cmd = null;
			
			if (!hr(_result)) {
				CONFIG::LLOG { log('ERR: cmd handler failed', 0x990000); }
				return;
			}
			
			check();
		}
		
		CONFIG::LLOG {
			protected override function log (_t:String, _c:uint = 0x000000):void {
				super.log('IJetAPI ' + _t, _c);
			}
		}
		
	}
	
}









