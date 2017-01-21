package com.thomasuster.ws.output;
import haxe.io.Bytes;
import haxe.io.Output;
class BytesOutputReal implements BytesOutputProxy {
    
    public var output:Output;

    public function new():Void {}

    public function writeFullBytes(s:Bytes, pos:Int, len:Int):Void {
        output.writeFullBytes(s, pos, len);
    }
}