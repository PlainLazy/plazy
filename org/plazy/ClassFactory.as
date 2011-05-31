








package org.plazy {
	
	import flash.system.ApplicationDomain;
	
	public class ClassFactory {
		
		private static var domains:Array = [];  // array of ApplicationDomains
		private static var classes:Object = {}; // array of ClassRecords
		
		public function ClassFactory () { }
		
		public static function add_domain (_dom:ApplicationDomain):void {
			CONFIG::LLOG { log('add_domain') }
			domains.push(_dom);
		}
		
		public static function create (_class_name:String):Object {
			CONFIG::LLOG { log('cretae ' + _class_name) }
			var cls:Class = construct(_class_name);
			if (cls == null) { return null; }
			return new cls();
		}
		
		public static function construct (_class_name:String):Class {
			CONFIG::LLOG { log('construct ' + _class_name) }
			
			var record:ClassRecord = classes[_class_name];
			
			if (record == null) {
				
				record = new ClassRecord();
				
				var found:Boolean;
				var dom:ApplicationDomain;
				for each (dom in domains) {
					if (dom.hasDefinition(_class_name)) {
						CONFIG::LLOG { log('domain found') }
						try {
							record.cls = dom.getDefinition(_class_name) as Class;
						} catch (e:Error) {
							record.err = e.toString();
							error_hr(_class_name, record.err);
						}
						found = true;
						break;
					}
				}
				
				if (!found) {
					record.err = 'not found';
					error_hr(_class_name, record.err);
				}
				
				classes[_class_name] = record;
				
				return record.cls;
			}
			
			if (record.err != null) {
				error_hr(_class_name, record.err);
				return null;
			}
			
			return record.cls;
		}
		
		private static function error_hr (_class_name:String, _err:String):void {
			CONFIG::LLOG { log('ERR: class "' + _class_name + '" construct failed, err: ' + _err); }
		}
		
		private static function log (_t:String):void {
			trace('ClassFactory ' + _t);
		}
		
	}
	
}

class ClassRecord {
	
	public var err:String;
	public var cls:Class;
	
	public function ClassRecord () { }
	
}









