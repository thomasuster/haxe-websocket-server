package com.thomasuster.ws.input;
import haxe.io.Bytes;
import haxe.io.BytesInput;
class BytesInputMock implements BytesInputProxy {
    
    public var bytes:BytesInput;

    public function new():Void {}

    public function readLine():String {
        return bytes.readLine();
    }
    
    public function readFullBytes(buf:Bytes, pos:Int, len:Int):Void {
        return bytes.readFullBytes(buf, pos, len);
    }
}