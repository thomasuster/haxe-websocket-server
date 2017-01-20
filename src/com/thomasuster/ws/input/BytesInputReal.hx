package com.thomasuster.ws.input;
import haxe.io.Input;
import haxe.io.Bytes;
class BytesInputReal implements BytesInputProxy {
    
    public var input:Input;

    public function new():Void {}

    public function readLine() : String {
        return input.readLine();
    }

    public function readFullBytes(buf:Bytes, pos:Int, len:Int):Void {
        input.readBytes(buf,pos,len);
    }
}