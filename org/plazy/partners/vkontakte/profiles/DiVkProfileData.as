﻿








package org.plazy.partners.vkontakte.profiles {
	
	public class DiVkProfileData {
		
		public var uid:uint;
		public var first_name:String;
		public var last_name:String;
		public var nickname:String;
		public var sex:int;
		public var photo:String;
		public var photo_medium:String;
		public var photo_big:String;
		
		public function DiVkProfileData () { }
		
		public function toString ():String {
			return '{DiVkProfileData: uid=' + uid + ' first_name=' + first_name + ' last_name=' + last_name + ' nickname=' + nickname + ' sex=' + sex + ' photo=' + photo + ' photo_medium=' + photo_medium + ' photo_big=' + photo_big + '}';
		}
		
	}
	
}








