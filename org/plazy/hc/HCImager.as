








package org.plazy.hc {
	
	import flash.utils.ByteArray;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.system.LoaderContext;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	
	public class HCImager {
		
		private var ldr:Loader;
		
		private var in_progress:Boolean;
		
		private var on_bitmap_data:Function;
		
		public function HCImager () {
			ldr = new Loader();
			ldr.contentLoaderInfo.addEventListener(Event.INIT, ldr_init_hr);
			ldr.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, ldr_progress_hr);
			ldr.contentLoaderInfo.addEventListener(HTTPStatusEvent.HTTP_STATUS, ldr_http_status_hr);
			ldr.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ldr_IO_error_hr);
			ldr.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, ldr_security_error_hr);
		}
		
		public function set onBitmapData (_f:Function):void { on_bitmap_data = _f; }
		
		public function kill ():void {
			CONFIG::LLOG { log('kill') }
			
			try { ldr.close(); }
			catch (e:Error) { }
			
			ldr.contentLoaderInfo.removeEventListener(Event.INIT, ldr_init_hr);
			ldr.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, ldr_progress_hr);
			ldr.contentLoaderInfo.removeEventListener(HTTPStatusEvent.HTTP_STATUS, ldr_http_status_hr);
			ldr.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, ldr_IO_error_hr);
			ldr.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, ldr_security_error_hr);
			ldr = null;
			
			on_bitmap_data = null;
			
		}
		
		public function set_data (_bytes:ByteArray):void {
			
			if (in_progress) { return; }
			
			in_progress = true;
			
			ldr.loadBytes(_bytes, new LoaderContext());
			
		}
		
		private function ldr_init_hr (e:Event):void {
			CONFIG::LLOG { log('ldr_init_hr', 0x009900) }
			
			in_progress = false;
			
			var bmp:Bitmap
			
			try { bmp = ldr.content as Bitmap; }
			catch (e:Error) { CONFIG::LLOG { log('ERR: ' + e, 0xFF0000) } }
			
			if (bmp == null) {
				error_def_hr('ivalid_content');
				return;
			}
			
			bitmapdata_hr(bmp.bitmapData);
			
		}
		
		private function ldr_progress_hr (e:ProgressEvent):void { }
		
		private function ldr_http_status_hr (e:HTTPStatusEvent):void {
			if (e.status > 200) {
				CONFIG::LLOG { log('ldr_http_status_hr ' + e, 0xFF0000) }
			}
		}
		
		private function ldr_IO_error_hr (e:IOErrorEvent):void {
			error_def_hr('io_error');
		}
		
		private function ldr_security_error_hr (e:SecurityErrorEvent):void {
			error_def_hr('seru_error');
		}
		
		private function error_hr (_t:String):void {
			CONFIG::LLOG { log('error_hr "' + _t + '"', 0xFF0000) }
			bitmapdata_hr(new BitmapData(20, 20, true, 0x80FF0000));
		}
		
		private function bitmapdata_hr (_bd:BitmapData):void {
			in_progress = false;
			if (on_bitmap_data != null) {
				on_bitmap_data(_bd);
			}
		}
		
		private function log (_t:String, _c:int = 0x000000):void {
			trace('HCImager ' + _t);
		}
		
	}
	
}









