package com.thomasuster.ws.input;
import haxe.io.Bytes;
interface BytesInputProxy {
    function readLine() : String;
    function readFullBytes( buf : Bytes, pos:Int, len:Int ) : Void;
}