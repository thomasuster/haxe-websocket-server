package com.thomasuster.ws;
import massive.munit.Assert;
import String;
import haxe.io.Bytes;
import com.thomasuster.ws.input.ByteStringer;
import com.thomasuster.ws.output.BytesOutputMock;
import com.thomasuster.ws.FrameWriter;
class FrameWriterTest {

    var writer:FrameWriter;
    var mock:BytesOutputMock;
    var byteStringer:ByteStringer;
    
    public function new() {
    }
    
    @Before
    public function before():Void {
        writer = new FrameWriter();
        mock = new BytesOutputMock();
        writer.output = mock;
        byteStringer = new ByteStringer();
    }

    @Test
    public function testOneByte():Void {
        writer.payload = Bytes.alloc(1);
        writer.payload.set(0,1);
        writer.write();
        var expected:String = '1 0 0 0 0 0 1 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 1';
        /*                     0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 */
        var t:String = byteStringer.assertEquals(mock.buffer.getBytes(), expected);
        if(t != '')
            Assert.fail(t);
    }
/*
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
     
     https://developer.mozilla.org/en-US/docs/Web/API/WebSockets_API/Writing_WebSocket_servers
*/
}