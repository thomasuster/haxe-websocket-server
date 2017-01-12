package com.thomasuster.ws.input;
import haxe.io.BytesBuffer;
import haxe.io.Eof;
import haxe.io.Bytes;
import haxe.io.BytesInput;
class BytesInputMock implements BytesInputProxy {
    
    public var bytes:Bytes;

    var position:Int = 0;

    public function new():Void {}

    public function readLine():String {
        //
        return null;
    }
    
    public function readBytes(buf:Bytes, pos:Int, len:Int):Int {
        buf.blit(pos, bytes, position, len);
        position+=len;
        return len;
    }
}