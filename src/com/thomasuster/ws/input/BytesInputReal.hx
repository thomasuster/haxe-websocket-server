package com.thomasuster.ws.input;
import haxe.io.Input;
import haxe.io.Bytes;
class BytesInputReal implements BytesInputProxy {
    
    public var input:Input;

    public function new():Void {}

    public function readLine() : String {
        return input.readLine();
    }

    public function readBytes(buf:Bytes, pos:Int, len:Int):Int {
        return input.readBytes(buf,pos,len);
    }
}