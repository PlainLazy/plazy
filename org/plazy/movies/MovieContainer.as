








package org.plazy.movies {
	
	import org.plazy.Err;
	import org.plazy.BaseDisplayObject;
	
	import flash.utils.ByteArray;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.system.LoaderContext;
	import flash.system.ApplicationDomain;
	import flash.display.Loader;
	import flash.display.DisplayObjectContainer;
	
	final public class MovieContainer extends BaseDisplayObject {
		
		[Embed(source = 'NA.png', mimeType='application/octet-stream')]
		private var NA:Class;
		
		// external
		
		private var on_progress:Function;
		private var on_complete:Function;
		
		// vars
		
		private var url:String;
		private var auto_play:Boolean;
		private var bytes:ByteArray;
		
		// objects
		
		private var mc:Loader;
		
		// constructor
		
		public function MovieContainer () {
			super();
			set_name(this);
			mouseEnabled = false;
			mouseChildren = false;
			mc = new Loader();
			mc.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, mc_io_error_hr);
			mc.contentLoaderInfo.addEventListener(Event.INIT, mc_init_hr);
			addChild(mc);
		}
		
		public function set onProgress (_f:Function):void { on_progress = _f; }
		public function set onComplete (_f:Function):void { on_complete = _f; }
		
		public function init2 (_url:String, _auto_play:Boolean, _bytes:ByteArray = null):Boolean {
			CONFIG::LLOG { log('init2 url="' + _url + '" auto_play=' + _auto_play); }
			if (!super.init()) { return false; }
			auto_play = _auto_play;
			
			if (_url == null) {
				if (_bytes == null) { return error_def_hr('invalid parameters'); }
				return complete_hr(_bytes);
			} else {
				if (url != null) { return error_def_hr('already in progress'); }
				url = _url;
				MoviesController.me.load(url, complete_hr, progress_hr);
			}
			
			return true;
		}
		
		public override function kill ():void {
			CONFIG::LLOG { log('kill'); }
			
			on_progress = null;
			on_complete = null;
			
			if (url != null) {
				MoviesController.me.cancel_url(url, complete_hr, progress_hr);
				url = null;
			}
			
			bytes = null;
			
			stop_movie(mc as DisplayObjectContainer);
			
			removeChild(mc);
			mc.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, mc_io_error_hr);
			mc.contentLoaderInfo.removeEventListener(Event.INIT, mc_init_hr);
			try { mc.unloadAndStop(); } catch (e:Error) { }
			//mc.unload();
			mc = null;
			
			super.kill();
		}
		
		public function play ():Boolean {
			CONFIG::LLOG { log('play'); }
			if (url != null) { return error_def_hr('still in progress'); }
			if (bytes == null) { return error_def_hr('movie bytes is null'); }
			
			try { mc.loadBytes(bytes, new LoaderContext(false, new ApplicationDomain())); }
			catch (e:Error) {
				CONFIG::LLOG { log('ERR: ' + e, 0xFF0000) }
				return set_NA_image();
			}
			
			return true;
		}
		
		public function get_loader ():Loader { return mc; }
		
		private function mc_io_error_hr (_e:IOErrorEvent):Boolean {
			CONFIG::LLOG { log('mc_io_error_hr ' + _e, 0xFF0000); }
			return set_NA_image();
		}
		
		private function set_NA_image ():Boolean {
			CONFIG::LLOG { log('set_NA_image'); }
			
			try { mc.loadBytes((new NA()) as ByteArray, new LoaderContext(false, new ApplicationDomain())); }
			catch (e:Error) {
				CONFIG::LLOG { log('ERR: ' + e, 0xFF0000) }
				return error_def_hr('invalid NA content');
			}
			
			return true;
		}
		
		private function mc_init_hr (_e:Event):void {
			CONFIG::LLOG { log('mc_init_hr'); }
			if (on_complete != null) { on_complete(); }
		}
		
		private function progress_hr (_pc:Number):void {
			if (on_progress != null) { on_progress(_pc); }
		}
		
		private function complete_hr (_bytes:ByteArray):Boolean {
			CONFIG::LLOG { log('complete_hr') }
			url = null;
			bytes = _bytes;
			return auto_play ? (bytes == null ? set_NA_image() : play()) : true;
		}
		
		private function stop_movie (_obj:DisplayObjectContainer):void {
			CONFIG::LLOG { log('stop_movie ' + _obj); }
			if (_obj == null) { return; }
			if (_obj.hasOwnProperty('stop')) { _obj['stop'](); }
			
			var i:int;
			var sub_obj:DisplayObjectContainer;
			for (i = 0; i < _obj.numChildren; i++) {
				sub_obj = _obj.getChildAt(i) as DisplayObjectContainer;
				if (sub_obj != null) {
					stop_movie(sub_obj);
				}
			}
		}
		
	}
	
}









