








package org.plazy.partners.vkontakte.profiles {
	
	public class DiVkProfileRequest {
		
		public var uids_list:Vector.<uint>;
		public var on_done:Function;
		
		public function DiVkProfileRequest () { }
		
		public function toString ():String {
			return '{DiVkProfileRequest: uids_list=[' + uids_list + '] on_done=' + on_done + '}';
		}
		
	}
	
}









