








package org.plazy {
	
	import flash.media.Sound;
	import flash.utils.ByteArray;
	//import flash.utils.describeType;
	import flash.system.ApplicationDomain;
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.BitmapData;
	
	final public class Gfx {
		
		// static
		
		public static const me:Gfx = new Gfx();
		
		// vars
		
		private var apps:Array = [];
		private var cache:Object = {};  // key: bitmap_name, value: BitmapData
		
		// constructor
		
		public function Gfx () { }
		
		public function add_appdom (_app:ApplicationDomain):void {
			if (_app != null) {
				apps.push(_app);
			}
		}
		
		public function bmd_cached (_nm:String):Boolean {
			return cache[_nm] != null;
		}
		
		public function get_sound (_nm:String):Sound {
			
			var app:ApplicationDomain;
			for each (app in apps) {
				if (app.hasDefinition(_nm)) {
					var tmp:Class = app.getDefinition(_nm) as Class;
					if (tmp != null) {
						var snd:Sound = new tmp() as Sound;
						if (snd != null) {
							return snd;
						}
					}
				}
				break;
			}
			
			return null;
		}
		
		public function get_bd (_nm:String, _cache:Boolean = true):BitmapData {
			
			if (_cache) {
				if (bmd_cached(_nm)) {
					return cache[_nm];
				}
			}
			
			var app:ApplicationDomain;
			for each (app in apps) {
				if (app.hasDefinition(_nm)) {
					var cls:Class = app.getDefinition(_nm) as Class;
					if (cls != null) {
						
						var bd_instance:BitmapData;
						try {
							bd_instance = new cls(1, 1) as BitmapData;
							if (bd_instance == null) {
								bd_instance = create_err_bd(0x80FF00FF);
							}
						} catch (e:Error) {
							CONFIG::LLOG { log('ERR: bd ' + _nm + ' instance creation failed: ' + e, 0xFF0000); }
							bd_instance = create_err_bd(0x80FF00FF);
						}
						
						cache[_nm] = bd_instance;
						return cache[_nm];
						if (!_cache) {
							delete cache[_nm];
						}
					}
				}
			}
			
			CONFIG::LLOG { log('WARN: bd ' + _nm + ' not found', 0xFF0000); }
			
			return create_err_bd(0x80FF0000);
		}
		
		public function get_bd_flex (_nm:String, _cache:Boolean = true):BitmapData {
			if (_cache) {
				if (bmd_cached(_nm)) { return cache[_nm]; }
			}
			
			var app:ApplicationDomain;
			for each (app in apps) {
				if (app.hasDefinition(_nm)) {
					var cls:Class = app.getDefinition(_nm) as Class;
					if (cls != null) {
						//CONFIG::LLOG { log(' ' + describeType(cls), 0x990000); }
						
						var bitmap_asset:Object;
						try {
							bitmap_asset = new cls();
						} catch (e:Error) {
							CONFIG::LLOG { log('ERR: bitmap_asset ' + _nm + ' creation faile: ' + e, 0xFF0000); }
							return create_err_bd(0x80FFFF00);
						}
						
						if (!bitmap_asset.hasOwnProperty('bitmapData')) {
							CONFIG::LLOG { log('ERR: bitmap_asset ' + _nm + ' has no bitmapData', 0xFF0000); }
							return create_err_bd(0x80FFFF00);
						}
						
						var bd_instance:BitmapData = bitmap_asset['bitmapData'] as BitmapData;
						if (bd_instance == null) {
							CONFIG::LLOG { log('ERR: bitmap_asset ' + _nm + ' has invalid bitmapData', 0xFF0000); }
							bd_instance = create_err_bd(0x80FF00FF);
						}
						
						cache[_nm] = bd_instance;
						return cache[_nm];
						if (!_cache) {
							delete cache[_nm];
						}
					}
				}
			}
			
			CONFIG::LLOG { log('WARN: bd ' + _nm + ' not found', 0xFF0000); }
			
			return create_err_bd(0x80FF0000);
		}
		
		public function set_bd (_nm:String, _bd:BitmapData):void {
			cache[_nm] = _bd;
		}
		
		public function get_sprite (_nm:String):Sprite {
			
			var app:ApplicationDomain;
			for each (app in apps) {
				if (app.hasDefinition(_nm)) {
					var spr:* = app.getDefinition(_nm);
					var sprite:Sprite = new spr() as Sprite;
					if (sprite != null) {
						return sprite;
					} else {
						CONFIG::LLOG { log('WARN: sprite "' + _nm + '" not invalid', 0xFF0000); }
						return new Sprite();
					}
				}
			}
			
			CONFIG::LLOG { log('WARN: sprite "' + _nm + '" not found', 0xFF0000); }
			return new Sprite();
		}
		
		public function get_movie (_nm:String):MovieClip {
			
			var app:ApplicationDomain;
			for each (app in apps) {
				if (app.hasDefinition(_nm)) {
					var mc:Class = app.getDefinition(_nm) as Class;
					if (mc != null) {
						var movie:MovieClip = new mc() as MovieClip;
						if (movie != null) {
							return movie;
						} else {
							CONFIG::LLOG { log('WARN: movie clip "' + _nm + '" not valid', 0xFF0000); }
							return new MovieClip();
						}
					}
				}
			}
			
			CONFIG::LLOG { log('WARN: movie clip "' + _nm + '" not found', 0xFF0000); }
			return new MovieClip();
		}
		
		public function get_bytes (_nm:String):ByteArray {
			
			var app:ApplicationDomain;
			for each (app in apps) {
				if (app.hasDefinition(_nm)) {
					var bin:Class = app.getDefinition(_nm) as Class;
					if (bin != null) {
						var bytes:ByteArray = new bin() as ByteArray;
						if (bytes != null) {
							return bytes;
						} else {
							CONFIG::LLOG { log('WARN: bin "' + _nm + '" not valid', 0xFF0000); }
							return null;
						}
					}
				}
			}
			
			CONFIG::LLOG { log('WARN: bin "' + _nm + '" not found', 0xFF0000); }
			return null;
		}
		
		private function create_err_bd (_col:uint):BitmapData {
			return new BitmapData(20, 20, true, _col);
		}
		
		CONFIG::LLOG {
			public function log (_t:String, _c:int = 0x000000):void {
				Logger.me.add('Gfx ' + _t, _c);
			}
		}
		
	}
	
}









