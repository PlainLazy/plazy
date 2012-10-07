








package org.plazy.partners.mailru {
	
	import org.plazy.FlashVars;
	
	CONFIG::LLOG { import org.plazy.Logger; }
	
	public class DiApplicationData {
		
		public var api_uri:String;
		public var secret_key:String;
		
		public var app_id:String;
		public var session_key:String;
		public var authentication_key:String;
		public var oid:String;
		public var vid:String;
		public var is_app_user:String;
		//public var state:String;
		public var window_id:String;
		public var sig:String;
		
		public var height:int;
		
		public function DiApplicationData () { }
		
		public function update ():void {
			CONFIG::LLOG { Logger.me.add('mailru:DiApplicationData update'); }
			
			// depricated
			
			/*
				Инициализация приложения
				При загрузке страницы вашего приложения в него передаются следующие параметры:
						* app_id - идентификатор приложения;
						* session_key - ключ авторизации пользователя в приложении (служит для авторизации пользователя и используется при вызове некоторых методов API);
						* authentication_key - ключ аутентификации пользователя запустившего приложение на сервере приложения;
						* oid - идентификатор пользователя, установившего приложение;
						* vid - идентификатор пользователя, запустившего приложение;
						* is_app_user - флаг, обозначающий установил ли приложение пользователь просматривающий приложение (если установил = 1, иначе = 0);
						* state - код состояния приложения, этот параметр используется для передачи состояния, в которое должно перейти приложение, если оно было вызвано не с его страницы, а например из раздела "Что нового?";
						* ext_perm - пользовательские настройки приложения. Значение данного параметра является перечисление через запятую настроек пользователя, описанных в документации к методу users.hasAppPermission. Например: ext_perm=stream,notifications
						* window_id - идентификатор окна, в котором запущено приложение. Используется для вызова метода открытия окна приема платежа в приложении payments.openDialog.
						* view - определяет место, из которого открыто приложение. Возможные значения:
									o app_canvas - страница приложения в Моем Мире
									o app_mail_read - страница чтения письма в Почте
									o app_mail_compose - страница написания письма в Почте 
				Ключ аутентификации authentication_key служит для проверки подлинности пользователя на сервере приложения. Его значение рассчитывается следующим образом: md5(app_id + '_' + vid + '_' + secret_key)
				Ключ включает в себя параметр secret_key, поэтому злоумышленник не может его подделать - рассчитав аналогичный ключ на сервере приложения и сравнив его с authentication_key можно убедиться, что пользователь не поддельный. 
			*/
			
			// actual
			
			/*
				app_id	int	идентификатор вашего приложения
				session_key	string	идентификатор сессии
				session_expire	timestamp	время в формате unixtime когда сессия перестанет быть валидной
				oid	uint64	идентификатор пользователя, установившего приложение
				vid	uint64	идентификатор пользователя, запустившего приложение
				is_app_user	bool	флаг, обозначающий установил ли приложение пользователь просматривающий приложение (1 — установил, иначе 0)
				ext_perm	string	пользовательские настройки приложения; значением данного параметра является перечисление через запятую настроек пользователя, описанных в документации к методу users.hasAppPermissionrest; например: ext_perm=stream,notifications
				window_id	string	идентификатор окна, в котором запущено приложение
				view	string	определяет место, из которого открыто приложение
				referer_type	string	определяет тип реферера (см. Бонус за друга); необязательный параметр
				referer_id	string	определяет id реферера (см. Бонус за друга); необязательный параметр
				sig	string	подпись параметров
			*/
			
			// main
			
			//api_uri              = GameState.me.config_di.api_mailru_url;
			//secret_key           = GameState.me.config_di.api_mailru_secret_key;
			
			// flashvars
			
			app_id              = FlashVars.me.get_value('app_id');
			session_key         = FlashVars.me.get_value('session_key');
			authentication_key  = FlashVars.me.get_value('authentication_key');
			oid                 = FlashVars.me.get_value('oid');
			vid                 = FlashVars.me.get_value('vid');
			is_app_user         = FlashVars.me.get_value('is_app_user');
			//state               = FlashVars.me.get_value('state');
			sig                 = FlashVars.me.get_value('sig');
			
		}
		
		public function get_referral_id ():String {
			return oid == vid ? '0' : oid;
		}
		
	}
	
}









