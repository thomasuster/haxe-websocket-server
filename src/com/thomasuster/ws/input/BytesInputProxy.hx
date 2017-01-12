package com.thomasuster.ws.input;
import haxe.io.Bytes;
interface BytesInputProxy {
    function readLine() : String;
    function readBytes( buf : Bytes, pos:Int, len:Int ) : Int;
}