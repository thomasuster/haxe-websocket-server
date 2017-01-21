package com.thomasuster.ws.output;
import haxe.io.BytesBuffer;
import haxe.io.Bytes;
class BytesOutputMock implements BytesOutputProxy {
    
    public var buffer:BytesBuffer;

    public function new():Void {
        buffer = new BytesBuffer();
    }

    public function writeFullBytes(s:Bytes, pos:Int, len:Int):Void {
        buffer.addBytes(s,pos,len);
    }
}