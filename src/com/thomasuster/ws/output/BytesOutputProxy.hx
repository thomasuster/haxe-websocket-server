package com.thomasuster.ws.output;
import haxe.io.Bytes;
interface BytesOutputProxy {
    function writeBytes( s : Bytes, pos : Int, len : Int ) : Int;
}