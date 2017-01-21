package com.thomasuster.ws.output;
import haxe.io.Bytes;
interface BytesOutputProxy {
    function writeFullBytes( s : Bytes, pos : Int, len : Int ) : Void;
}