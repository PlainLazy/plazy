








package org.plazy.partners.vkontakte {
	
	import org.plazy.FlashVars;
	CONFIG::LLOG { import org.plazy.Logger; }
	
	public class DiApplicationData {
		
		/*
		api_url – это адрес сервиса API, по которому необходимо осуществлять запросы. 
		api_id – это id запущенного приложения. 
		user_id – это id пользователя, со страницы которого было запущено приложение. Если приложение запущено не со страницы пользователя, то значение равно 0. 
		sid – id сессии для осуществления запросов к API 
		secret – Секрет, необходимый для осуществления подписи запросов к API 
		group_id – это id группы, со страницы которой было запущено приложение. Если приложение запущено не со страницы группы, то значение равно 0. 
		viewer_id – это id пользователя, который просматривает приложение. 
		is_app_user – если пользователь установил приложение – 1, иначе – 0. 
		viewer_type – это тип пользователя, который просматривает приложение (возможные значения описаны ниже). 
		auth_key – это ключ, необходимый для авторизации пользователя на стороннем сервере (см. описание ниже). 
		language – это id языка пользователя, просматривающего приложение (см. список языков ниже). 
		api_result – это результат первого API-запроса, который выполняется при загрузке приложения (см. описание ниже). 
		api_settings – битовая маска настроек текущего пользователя в данном приложении (подробнее см. в описании метода getUserSettings).
		*/
		
		public var api_secret:String;
		
		public var api_url:String;
		public var api_id:String;
		public var user_id:String;
		public var sid:String;
		public var secret:String;
		public var group_id:String;
		public var viewer_id:String;
		public var is_app_user:String;
		public var viewer_type:String;
		public var auth_key:String;
		public var language:String;
		public var api_result:String;
		public var api_settings:String;
		
		public var access_token:String;
		
		public function DiApplicationData () { }
		
		public function update ():void {
			CONFIG::LLOG { Logger.me.add('vkontakte:DiApplicationData update'); }
			
			// flashvars
			
			api_url = FlashVars.me.get_value('api_url', 'UNDEF_VK_API_URL');
			api_id = FlashVars.me.get_value('api_id', 'UNDEF_VK_API_ID');
			user_id = FlashVars.me.get_value('user_id', 'UNDEF_VK_USER_ID');
			sid = FlashVars.me.get_value('sid', 'UNDEF_VK_SID');
			secret = FlashVars.me.get_value('secret', 'UNDEF_VK_SECRET');
			group_id = FlashVars.me.get_value('group_id', 'UNDEF_VK_GROUP_ID');
			viewer_id = FlashVars.me.get_value('viewer_id', 'UNDEF_VIEWER_ID');
			is_app_user = FlashVars.me.get_value('is_app_user', 'UNDEF_VK_IS_APP_USER');
			viewer_type = FlashVars.me.get_value('viewer_type', 'UNDEF_VK_VIEWER_TYPE');
			auth_key = FlashVars.me.get_value('auth_key', 'UNDEF_VK_AUTH_KEY');
			language = FlashVars.me.get_value('language', 'UNDEF_VK_LANGUAGE');
			api_result = FlashVars.me.get_value('api_result', 'UNDEF_VK_API_RESULT');
			api_settings = FlashVars.me.get_value('api_settings', 'UNDEF_VK_API_SETTINGS');
			
		}
		
		public function get_referral_id ():String {
			return user_id == viewer_id ? '0' : user_id;
		}
		
	}
	
}









