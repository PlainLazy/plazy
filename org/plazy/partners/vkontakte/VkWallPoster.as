








package org.plazy.partners.vkontakte {
	
	import org.plazy.Omni;
	import org.plazy.Locker;
	import org.plazy.Logger;
	import org.plazy.BaseObject;
	import org.plazy.utils.io.StreamBIN;
	
	import com.adobe.images.PNGEncoder;
	import com.adobe.serialization.json.JSON;
	
	import flash.net.URLRequestHeader;
	import flash.geom.Matrix;
	import flash.utils.ByteArray;
	import flash.display.BitmapData;
	
	final public class VkWallPoster extends BaseObject {
		
		// static
		
		private static var last_server_url:String;
		
		// const
		
		public const WALL_PHOTO_MAX_WIDTH:int  = 130;
		public const WALL_PHOTO_MAX_HEIGHT:int = 130;
		
		// vars
		
		private var started:Boolean;
		private var lock1:Boolean;
		private var bd:BitmapData;
		private var wall_id:String;
		private var post_id:String;
		private var message:String;
		private var ldr:StreamBIN;
		
		// external
		
		private var on_failed:Function;
		private var on_complete:Function;
		
		// constructor
		
		public function VkWallPoster () {
			set_name(this);
			super();
		}
		
		public function set onFailed (_f:Function):void { on_failed = _f; }
		public function set onComplete (_f:Function):void { on_complete = _f; }
		
		public override function kill ():void {
			CONFIG::LLOG { log('kill'); }
			on_failed = null;
			on_complete = null;
			Omni.me.rem('VkWallPostSave', wall_saved_hr);
			Omni.me.rem('VkWallPostCancel', wall_cancelled_hr);
			ApiVkontakte.me.request_cancel(get_server_complete_hr);
			ApiVkontakte.me.request_cancel(save_post_complete_hr);
			unlock();
			if (ldr != null) { ldr.kill(); ldr = null; }
			super.kill();
			bd = null;
		}
		
		public function start (_bd:BitmapData, _wall_id:String, _post_id:String, _message:String, _resize:Boolean, _use_cached_server_url:Boolean, _lock:Boolean):Boolean {
			CONFIG::LLOG { log('start ' + _wall_id + ' ' + _resize + ' ' + _use_cached_server_url + ' ' + _lock); }
			CONFIG::LLOG { log(' post_id=' + _post_id, 0x888888); }
			CONFIG::LLOG { log(' message=' + _message, 0x888888); }
			
			if (started) { return error_def_hr('already started'); }
			if (_bd == null) { return error_def_hr('bd null'); }
			if (_wall_id == null) { return error_def_hr('wall_id null'); }
			
			started = true;
			
			wall_id = _wall_id;
			post_id = _post_id;
			message = _message;
			
			if (_resize) {
				if (_bd.width > WALL_PHOTO_MAX_WIDTH || _bd.height > WALL_PHOTO_MAX_HEIGHT) {
					var scale:Number = Math.min(WALL_PHOTO_MAX_WIDTH / _bd.width, WALL_PHOTO_MAX_HEIGHT / _bd.height);
					try { bd = new BitmapData(_bd.width * scale, _bd.height * scale, true, 0xFF000000); }
					catch (e:Error) { return error_def_hr('bd creation failed: ' + e); }
					bd.draw(_bd, new Matrix(scale, 0, 0, scale), null, null, _bd.rect, true);
				} else {
					bd = _bd;
				}
			} else {
				bd = _bd;
			}
			
			if (_lock) { lock1 = true; Locker.me.active = true; }
			if (_use_cached_server_url && last_server_url != null) { return image_send(last_server_url); }
			return ApiVkontakte.me.request_send(ApiVkontakte.METHOD_WALL_GET_GET_PHOTO_UPLOAD_SERVER, new Vector.<String>(), get_server_err_hr, get_server_complete_hr, false);
		}
		
		private function unlock ():void {
			CONFIG::LLOG { log('unlock'); }
			if (lock1) {
				lock1 = false;
				Locker.me.active = false;
			}
		}
		
		private function get_server_err_hr (_code:int, _msg:String):Boolean {
			CONFIG::LLOG { log('get_server_err_hr code=' + _code + ' msg=' + _msg, 0xFF0000) }
			return error_def_hr('api "' + ApiVkontakte.METHOD_WALL_GET_GET_PHOTO_UPLOAD_SERVER + '" failed: ' + _code + ', ' + _msg);
		}
		
		private function get_server_complete_hr (_resp:Object):Boolean {
			CONFIG::LLOG { log('get_server_complete_hr'); }
			if (_resp == null) { return error_def_hr('resp null'); }
			
			//	{"response":{"upload_url":"http:\/\/cs9231.vkontakte.ru\/upload.php?act=profile&mid=6492&hash=284b5d004f5524e8b781cc9ddfb75de1&rhash=5133711120e3156dbb8f4cb2069fb29f&swfupload=1"}}
			
			last_server_url = _resp['upload_url'];
			if (last_server_url == null) { return error_def_hr('upload_url null'); }
			return image_send(last_server_url);
		}
		
		private function image_send (_upload_url:String):Boolean {
			CONFIG::LLOG { log('image_send ' + _upload_url) }
			
			var boundary:String = 'oga_boga_' + int(int.MAX_VALUE * Math.random());
			var png_image_bytes:ByteArray;
			
			try { png_image_bytes = PNGEncoder.encode(bd); }
			catch (e:Error) { return error_def_hr('PNGEncoder failed: ' + e); }
			
			var request_bytes:ByteArray = new ByteArray();
			request_bytes.writeUTFBytes('--' + boundary + '\r\n');
			request_bytes.writeUTFBytes('Content-Disposition: form-data; name="photo"; filename="photo.png"\r\n');
			request_bytes.writeUTFBytes('Content-Type: application/octet-stream\r\n\r\n');
			request_bytes.writeBytes(png_image_bytes);
			request_bytes.writeUTFBytes('\r\n');
			request_bytes.writeUTFBytes('\r\n');
			request_bytes.writeUTFBytes('--' + boundary + '--');
			
			var headers:Vector.<URLRequestHeader> = new Vector.<URLRequestHeader>();
			headers.push(new URLRequestHeader('Cache-Control', 'no-cache'));
			headers.push(new URLRequestHeader('Content-type', 'multipart/form-data; boundary=' + boundary));
			
			if (ldr != null) { ldr.kill(); }
			
			ldr = new StreamBIN();
			ldr.onError = ldr_err_hr;
			ldr.onComplete = ldr_complete_hr;
			
			return ldr.load(_upload_url, 'POST', request_bytes, headers);
		}
		
		private function ldr_err_hr (_t:String):Boolean {
			CONFIG::LLOG { log('ldr_err_hr "' + _t + '"', 0xFF0000); }
			unlock();
			return failed_hr('image upload failed');
		}
		
		private function ldr_complete_hr ():Boolean {
			CONFIG::LLOG { log('ldr_complete_hr'); }
			
			var bytes:ByteArray = ldr.get_bytes();
			var data:String = bytes.readUTFBytes(bytes.bytesAvailable);
			
			var obj:Object;
			try { obj = JSON.decode(data); }
			catch (e:Error) { return error_ext_hr('JSON.decode failed', e); }
			
			var params:Vector.<String> = new Vector.<String>();
			params.push('wall_id=' + wall_id);
			params.push('server=' + obj['server']);
			params.push('photo=' + obj['photo']);
			params.push('hash=' + obj['hash']);
			
			if (post_id != null) { params.push('post_id=' + post_id); }
			if (message != null) { params.push('message=' + message); }
			
			return ApiVkontakte.me.request_send(ApiVkontakte.METHOD_WALL_SAVE_POST, params, save_post_err_hr, save_post_complete_hr, false);
		}
		
		private function save_post_err_hr (_code:int, _msg:String):Boolean {
			CONFIG::LLOG { log('save_post_err_hr code=' + _code + ' msg=' + _msg, 0xFF0000) }
			return error_def_hr('api "' + ApiVkontakte.METHOD_WALL_SAVE_POST + '" failed: ' + _code + ', ' + _msg);
		}
		
		private function save_post_complete_hr (_resp:Object):Boolean {
			CONFIG::LLOG { log('save_post_complete_hr'); }
			if (_resp == null) { return error_def_hr('resp null'); }
			
			//	{"response":{"post_hash":"264b5d004f5524e8c781cb9dafb75de1", "photo_src":"http:\/\/cs9231.vkontakte.ru\/u06492\/a_7b9c2b04.jpg"}}
			
			if (_resp['post_hash'] == null || _resp['photo_src'] == null) { return error_def_hr('invalid response content'); }
			
			Omni.me.add('VkWallPostSave', wall_saved_hr);
			Omni.me.add('VkWallPostCancel', wall_cancelled_hr);
			
			return ApiVkJs.me.save_wall_post(_resp['post_hash']);
		}
		
		private function wall_saved_hr ():Boolean {
			CONFIG::LLOG { log('wall_saved_hr'); }
			return complete_hr(true);
		}
		
		private function wall_cancelled_hr ():Boolean {
			CONFIG::LLOG { log('wall_cancelled_hr'); }
			return complete_hr(false);
		}
		
		private function complete_hr (_posted:Boolean):Boolean {
			CONFIG::LLOG { log('complete_hr ' + _posted); }
			unlock();
			if (on_complete != null) { return on_complete(_posted); }
			return true;
		}
		
		private function failed_hr (_t:String):Boolean {
			CONFIG::LLOG { log('failed_hr "' + _t + '"', 0xFF0000); }
			if (on_failed != null) { return on_failed(_t); }
			return true;
		}
		
		CONFIG::LLOG {
			protected override function log (_t:String, _c:uint = 0x000000):void {
				super.log('(' + lock1 + ') ' + _t, _c);
			}
		}
		
	}
	
}









