








package com.adobe.webapis.gettext {
		
    import flash.net.*;
    import flash.utils.*;
    import flash.errors.*;
    import flash.events.*;
    import flash.utils.Endian;
    
    public class Parser {
			
    	protected static const BE:uint = 3725722773
    	protected static const LE:uint = 2500072158 
				
        public function Parser () {
					
        }
				
        public static function parse (byte:ByteArray):Object {
						
            var __object__:Object = new Object();
            var __info__:Object = new Object();
            var __charset__:String = "";
            var lastk:String;
            var k:String;
            var v:String;
            var masteridx:Number
            var transidx:Number
            var msgcount:Number
            var version:Number
            var buflen:Number = byte.bytesAvailable;
            var magic:Number  = byte.readUnsignedInt();
            if(magic == Parser.BE)
            { // BIG-ENDIAN BYTE ORDER
                byte.endian = Endian.BIG_ENDIAN
            } else if(magic == Parser.LE)
            { // LITTLE-ENDIAN BYTE ORDER (Intel machine)
                byte.endian = Endian.LITTLE_ENDIAN
            } else
            {
            	throw new IOError("Invalid file");
            }

            version   = byte.readUnsignedInt()
            msgcount  = byte.readUnsignedInt()
            masteridx = byte.readUnsignedInt()
            transidx  = byte.readUnsignedInt()

            // Start Parsing
            var mlen:Number
            var moff:Number
            var mend:Number
            var tlen:Number
            var toff:Number
            var msg:String
            var tmsg:String
            var tend:Number
            var items:Array
            var item:String
            var splitted_item:Array
            for(var i:Number = 0; i < msgcount; i++){
                byte.position = masteridx;
                mlen = byte.readUnsignedInt();
                moff = byte.readUnsignedInt()
                mend = moff + mlen
                byte.position = transidx;
                tlen = byte.readUnsignedInt()
                toff = byte.readUnsignedInt()
                tend = toff + tlen
                if(mend < buflen && tend < buflen){
                    byte.position = moff;
                    msg  = byte.readUTFBytes(mend-moff)
                    byte.position = toff;
                    tmsg = byte.readUTFBytes(tend-toff)
                    __object__[msg] = tmsg
                } else {
                    throw IOError('File is corrupt')
                }
                if(mlen == 0)
                {
                    lastk = k = null;
                    items = tmsg.split("\n");
                    for(var a:uint = 0; a  < items.length; a++){
                        item = items[a];
                        if(item == "")
                        {
                            continue;
                        }
                        if(item.indexOf(':') >= 0)
                        {
                            splitted_item = item.split(':', 2)
                            k = splitted_item[0]
                            v = splitted_item[1]
                            k = k.toLowerCase()
                            __info__[k] = v
                            lastk = k
                        } else if(lastk){
                            __info__[lastk] += '\n' + item;
                        }
                        if(k == 'content-type')
                        {
                            __charset__ = v.split('charset=')[1]
                        }
                    }
                }
                byte.position = 0;
                masteridx += 8
                transidx  += 8
            }
            return {translation:__object__, info:__info__, charset:__charset__};
        }

    }
}









