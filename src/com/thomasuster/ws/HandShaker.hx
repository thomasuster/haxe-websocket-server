package com.thomasuster.ws;
import haxe.io.Eof;
import com.thomasuster.ws.input.BytesInputProxy;
import com.thomasuster.ws.output.BytesOutputProxy;
import haxe.io.Output;
import haxe.io.Bytes;
import haxe.crypto.Sha1;
import haxe.crypto.Base64;
class HandShaker {

    public var input:BytesInputProxy;
    public var output:BytesOutputProxy;

    var key:String = null;
    
    public function new() {}

    public function shake():Void {
        parseKey();
        writeShake();
    }
    
    function parseKey():Void {
        key = null;
        try {
            while(true) {
                var s:String = input.readLine();
                if(s.substr(0,'Sec-WebSocket-Key:'.length) == 'Sec-WebSocket-Key:') {
                    key = s.substring('Sec-WebSocket-Key:'.length+1,s.length);
                }
                if(s.length == 0)
                    break;
            }
        }
        catch(eof:Eof) {

        }
    }
    function writeShake():Void {
        var shake:String = hash(key);
        var header:String = 'HTTP/1.1 101 Switching Protocols\r\nUpgrade: websocket\r\nConnection: Upgrade\r\nSec-WebSocket-Accept: $shake\n\r\n';
        writeString(header);
    }

    function writeString(string:String):Void {
        var b = Bytes.ofString(string);
        output.writeFullBytes(b,0,b.length);
    }

    public function hash(key:String):String {
        var magic:String = '258EAFA5-E914-47DA-95CA-C5AB0DC85B11';
        var concated:Bytes = Bytes.ofString(key+magic);
        return Base64.encode(Sha1.make(concated));
    }
}