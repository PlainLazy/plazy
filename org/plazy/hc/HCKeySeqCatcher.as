








package org.plazy.hc {
	
	import org.plazy.StageController;
	
	import flash.events.KeyboardEvent;

	CONFIG::LLOG { import org.plazy.Logger; }
	
	final public class HCKeySeqCatcher {
		
		// base
		
		private var delay:int = 1000;
		
		// vars
		
		private var seqs:Object = {}; // keys: id:String, value: *:DiSequence
		private var last_time:Number = 0;
		private var cur_seq:Array = [];
		
		// conatructor
		
		public function HCKeySeqCatcher () {
			StageController.me.stage.addEventListener(KeyboardEvent.KEY_DOWN, key_down_hr);
		}
		
		public function kill ():void {
			CONFIG::LLOG { log('kill'); }
			StageController.me.stage.removeEventListener(KeyboardEvent.KEY_DOWN, key_down_hr);
			for each (var ho:DiSequence in seqs) { ho.kill(); }
			seqs = null;
		}
		
		public function set_delay (_val:int):void { delay = _val; }
		
		public function add_key_seq (_id:String, _seq:Array, _hr:Function):void {
			CONFIG::LLOG { log('add_key_seq ' + _id + ' ' + _seq); }
			rem_key_seq(_id);
			if (_id == null || _hr == null) { return; }
			
			var hi:int;
			for (hi = 0; hi < _seq.length; hi++) {
				if (_seq[hi] is String) {
					_seq[hi] = _seq[hi].charCodeAt();
				} else {
					_seq[hi] = int(_seq[hi]);
				}
			}
			
			seqs[_id] = new DiSequence(_id, _seq, _hr);
		}
		
		public function rem_key_seq (_id:String):void {
			if (seqs[_id] != null) { delete seqs[_id]; }
		}
		
		private function key_down_hr (_e:KeyboardEvent):void {
			CONFIG::LLOG { log('key_down_hr ' + _e.charCode); }
			
			var d:Date = new Date();
			var now:Number = d.getTime();
			
			if (now - last_time > delay) { reset_cur_seqs(); }
			
			last_time = now;
			
			pass_key(_e.charCode);
		}
		
		private function reset_cur_seqs ():void {
			for each (var ho:DiSequence in seqs) { ho.passed = []; }
		}
		
		private function pass_key (_code:uint):void {
			//CONFIG::LLOG { log('pass_key ' + _code); }
			if (_code == 0) { return; }
			
			var hi:int;
			var match:Boolean;
			
			for each (var ho:DiSequence in seqs) {
				ho.passed.push(_code);
				
				for (hi = 0; hi < ho.passed.length; hi++) {
					//log(' ' + ho.passed[hi] + ' ? ' + ho.expected[hi]);
					if (ho.passed[hi] != ho.expected[hi]) {
						//log(' failed');
						ho.passed = [_code];
						continue;
					}
				}
				
				if (ho.passed.length == ho.expected.length) {
					//log(' passed');
					ho.passed = [];
					ho.handler();
				}
				
			}
			
		}
		
		CONFIG::LLOG {
			private function log (_t:String, _c:uint = 0x00000000):void {
				Logger.me.add('HCKeySeqCatcher ' + _t, _c);
			}
		}
		
	}
	
}

class DiSequence {
	
	public var id:String;
	public var expected:Array = [];
	public var passed:Array = [];
	public var handler:Function;
	
	public function DiSequence (_id:String, _seq:Array, _hr:Function) {
		id = _id;
		expected = _seq;
		handler = _hr;
	}
	
	public function kill ():void {
		handler = null;
	}
	
	public function toString ():String {
		return '{DiSequence: id=' + id + ' expected=' + expected.join(',') + ' passed=' + passed.join(',') + ' handler=' + handler + '}';
	}
	
}







