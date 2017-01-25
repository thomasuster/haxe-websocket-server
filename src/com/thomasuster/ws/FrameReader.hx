package com.thomasuster.ws;
import com.thomasuster.ws.input.BytesInputProxy;
import haxe.io.BytesInput;
import haxe.io.BytesBuffer;
import haxe.io.Bytes;
class FrameReader {
    
    public var input:BytesInputProxy;

    var payloadLength:Int;
    var hasMask:Bool;
    var mask:Bytes;
    var fin:Bool;
    var op:Int;
    var maxFrameIntroSize:Int;
    var bytes:Bytes;

    public function new():Void {
        maxFrameIntroSize = 14;
        bytes = Bytes.alloc(maxFrameIntroSize);
        mask = Bytes.alloc(4);
    }

    public function read():Bytes {
        bytes.fill(0,bytes.length,0);
        readFullBytes(2);
        parseFirstByte();
        parseSecondByte();
        if(payloadLength == 126)
            parseExtendedPayloadLength();
        readFullBytes(4);
        parseMask();
        return parseData();
    }

    function parseFirstByte():Void {
        fin = parseInt(bytes.get(0),0,0) == 1;
        op = parseInt(bytes.get(0), 4,7);    
    }

    function parseSecondByte():Void {
        hasMask = parseInt(bytes.get(1),0,0) == 1;
        payloadLength = parseInt(bytes.get(1), 1,7);
    }

    function parseExtendedPayloadLength():Void {
        readFullBytes(2);
        payloadLength = (bytes.get(0) << 8) | bytes.get(1);    
    }

    function readFullBytes(len:Int ):Void {
        input.readFullBytes(bytes, 0, len);
    }

    function parseMask():Void {
        mask.blit(0, bytes, 0, 4);
    }

    function parseData():Bytes {
        var encoded:Bytes = Bytes.alloc(payloadLength);
        input.readFullBytes(encoded,0,payloadLength);
        var decoded:Bytes = encoded;
        for (i in 0...payloadLength) {
            var frame:Int = encoded.get(i);
            decoded.set(i, frame ^ mask.get(i % 4));
        }
        return decoded;
    }

    function parseInt(byte:Int,start:Int, end:Int):Int {
        var length:Int = end-start+1;
        var lShift:Int = 24+start;
        var leftTrimmed:Int = (byte << lShift); 
        return leftTrimmed >>> (lShift+(7-end));
    }

    /*
    https://developer.mozilla.org/en-US/docs/Web/API/WebSockets_API/Writing_WebSocket_servers
      0                   1                   2                   3 //dec
      0               1               2               3             //bytes
      0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1
     +-+-+-+-+-------+-+-------------+-------------------------------+
     |F|R|R|R| opcode|M| Payload len |    Extended payload length    |
     |I|S|S|S|  (4)  |A|     (7)     |             (16/64)           |
     |N|V|V|V|       |S|             |   (if payload len==126/127)   |
     | |1|2|3|       |K|             |                               |
     +-+-+-+-+-------+-+-------------+ - - - - - - - - - - - - - - - +
     |     Extended payload length continued, if payload len == 127  |
     + - - - - - - - - - - - - - - - +-------------------------------+
     |                               |Masking-key, if MASK set to 1  |
     +-------------------------------+-------------------------------+
     | Masking-key (continued)       |          Payload Data         |
     +-------------------------------- - - - - - - - - - - - - - - - +
     :                     Payload Data continued ...                :
     + - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - +
     |                     Payload Data continued ...                |
     +---------------------------------------------------------------+
    */
}
