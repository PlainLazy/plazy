








package org.plazy {
	
	import org.plazy.hc.HCKeyCather;
	
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.getTimer;
	import flash.system.Capabilities;
	import flash.display.Stage;
	import flash.display.InteractiveObject;
	
	final public class Logger {
		
		// static
		
		public static const me:Logger = new Logger();
		
		public static const TP_SHOW:int    = 0x01;
		public static const TP_HIDE:int    = 0x02;
		public static const TP_SHITCH:int  = 0x03;
		
		// vars
		
		public var env_hash:Object;
		
		private var inited:Boolean;
		private var name:String;
		private var log_hist:Array;
		private var is_opened:Boolean;
		private var log_length:int;
		private var log_length_x:int;
		private var key:HCKeyCather;
		
		// objects
		
		private var stage:Stage;
		private var old_focus:InteractiveObject;
		private var tf:TextField;
		
		// constructor
		
		public function Logger () { }
		
		public function reset ():void {
			kill();
			inited = false;
		}
		
		public function init (_stage:Stage, _name:String, _length:int):void {
			if (inited) {
				reset();
			}
			
			inited = true;
			
			stage = _stage;
			name = _name;
			log_hist = [];
			
			key = new HCKeyCather(_stage);
			key.set_catch(76, catch_key);
			key.with_shift = true;
			key.ignore_tf = true;
			
			log_length = _length;
			log_length_x = log_length + 500;
			
			add('------');
			add('logger for "' + name + '"');
			add('------');
		}
		
		public function kill ():void {
			bot();
			log_hist = null;
			key.kill();
			key = null;
			stage = null;
			old_focus = null;
		}
		
		public function rename (_name:String):void {
			name = _name;
		}
		
		private function catch_key ():void {
			add('Shift+L pressed');
			blink();
		}
		
		public function blink (_mode:int = TP_SHITCH):void {
			
			if (_mode != TP_SHITCH) {
				if (_mode == TP_SHOW && is_opened || _mode == TP_HIDE && !is_opened) {
					return;
				}
			}
			
			if (!is_opened) {
				
				add('=== log open ===');
				
				is_opened = true;
				
				var out:String = '<p>Log (last ' + String(log_length) + ' records) generated ' + (new Date()).toString() + '</p>';
				var i:uint = Math.max(0, log_hist.length - log_length);
				
				var types_hash:Object = {};
				var line:String;
				var type:String;
				
				while (i < log_hist.length) {
					
					line = '<p>' + log_hist[i][2] + ' <font color="#' + log_hist[i][1].toString(16) + '">' + log_hist[i][0] + '</font></p>';
					
					out += line;
					
					if (log_hist[i][3] != 0) {
						type = log_hist[i][3];
						if (types_hash[type] != null) {
							types_hash[type] += line;
						} else {
							types_hash[type] = line;
						}
					}
					
					i++;
					
				}
				
				for (type in types_hash) {
					out += '<p>=== "' + type + '" ===</p>';
					out += types_hash[type];
				}
				
				out += '<p>--------</p>';
				out += '<p>∙ app     uptime=' + String(int(getTimer() / 1000)) + ' url=' + unescape(stage.loaderInfo.url) + '</p>';
				out += '<p>∙ player  ver=' + Capabilities.version + ' type=' + Capabilities.playerType + ' debug=' + Capabilities.isDebugger + '</p>';
				out += '<p>∙ stage   size=' + (stage != null ? + stage.stageWidth + 'x' + stage.stageHeight : 'null') + '</p>';
				
				if (env_hash != null) {
					var env_list:Vector.<String> = new Vector.<String>();
					for (var env_key:String in env_hash) {
						env_list.push('<p> ∙ ' + env_key + ': ' + env_hash[env_key] + '</p>');
					}
					if (env_list.length > 0) {
						out += '<p>∙ env:</p>';
						out += env_list.join('');
					}
				}
				
				tf = new TextField();
				tf.defaultTextFormat = new TextFormat('Lucida Console', 10, 0x000000, false);
				tf.x = 4;
				tf.y = 4;
				tf.width = stage.stageWidth - 8;
				tf.height = stage.stageHeight - 8;
				tf.background = true;
				tf.multiline = true;
				tf.htmlText = out;
				tf.scrollV = tf.maxScrollV;
				
				stage.addChild(tf);
				
				old_focus = stage.focus;
				stage.focus = tf;
				key.ignore_tf = false;
				Omni.me.call('onLogOpen');
				
			} else {
				
				add('=== log close ===');
				
				is_opened = false;
				
				stage.removeChild(tf);
				tf = null;
				
				stage.focus = old_focus;
				key.ignore_tf = true;
				Omni.me.call('onLogClose');
				
			}
			
		}
		
		public function add (_txt:String, _col:uint = 0x000000, _type:String = ''):void {
			var dt:Date = new Date();
			var tm:String = dt.toString().split(' ')[3] + '.' + String(dt.getTime()).substr(-3);
			
			trace(tm + ' ' + name + ' ' + _txt);
			
			/*
			if (_col == 0xFF0000 && Capabilities.isDebugger) {
				var st:String = (new Error()).getStackTrace();
				if (st != null) {
					trace('IS_ERROR (RED COLOR) StackTrace {' + st.split('\n').join(' | ') + '}');
				}
			}
			/**/
			
			if (log_hist == null) {
				return;
			}
			
			log_hist.push([_txt, _col, tm, _type]);
			
			if (log_hist.length > log_length_x) {
				log_hist.splice(0, 500);
			}
		}
		
		public function quote (_t:String):String {
			if (_t == null) { return ''; }
			return _t.split('<').join('&lt;');
		}
		
		public function top ():void {
			var e:Error = new Error();
			add('StackTrace: ' + e.getStackTrace(), 0xFF0000);
			blink(TP_SHOW);
		}
		
		public function bot ():void {
			blink(TP_HIDE);
		}
		
	}
	
}









