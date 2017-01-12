package com.thomasuster.ws.output;
import haxe.io.Bytes;
import haxe.io.Output;
class BytesOutputReal implements BytesOutputProxy {
    
    public var output:Output;

    public function new():Void {}

    public function writeBytes(s:Bytes, pos:Int, len:Int):Int {
        return output.writeBytes(s, pos, len);
    }
}