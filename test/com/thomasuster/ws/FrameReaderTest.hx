package com.thomasuster.ws;
import haxe.io.BytesInput;
import com.thomasuster.ws.input.BytesInputMock;
import com.thomasuster.ws.input.ByteStringer;
import haxe.io.BytesData;
import haxe.io.BytesBuffer;
import massive.munit.Assert;
import haxe.io.Bytes;
import com.thomasuster.ws.FrameReader;
import org.hamcrest.core.IsEqual;
import org.hamcrest.MatcherAssert;
class FrameReaderTest {

    var frameInput:ByteStringer;
    var frame:FrameReader;
    var mock:BytesInputMock;
    
    public function new() {
    }
    
    @Before
    public function before():Void {
        frame = new FrameReader();
        mock = new BytesInputMock();
        frame.input = mock;

        frameInput = new ByteStringer();
    }
    
    @Test
    public function test1ByteInput():Void {
        var data:String = '1 0 0 0 0 0 1 0 1 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1';
        /*                 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 */
        mock.bytes = new BytesInput(frameInput.makeInput(data));
        var out:Bytes = frame.read();
        MatcherAssert.assertThat(out.length, IsEqual.equalTo(1));
        MatcherAssert.assertThat(out.get(0), IsEqual.equalTo(1));
    }

    @Test
    public function test1ByteMasked():Void {
        var data:String = '1 0 0 0 0 0 1 0 1 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0';
        /*                 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 */
        mock.bytes = new BytesInput(frameInput.makeInput(data));
        var out:Bytes = frame.read();
        MatcherAssert.assertThat(out.get(0), IsEqual.equalTo(1));
    }

    @Test
    public function test2ByteInput():Void {
        var data:String = '1 0 0 0 0 0 1 0 1 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 1';
        /*                 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 */
        mock.bytes = new BytesInput(frameInput.makeInput(data));
        var out:Bytes = frame.read();
        MatcherAssert.assertThat(out.length, IsEqual.equalTo(2));
        var t:String = frameInput.assertEquals(out, '0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 1');
        if(t != '')
            Assert.fail(t);
    }

    @Test
    public function test126Payload():Void {
        var data:String = '1 0 0 0 0 0 1 0 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0';
        /*                 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 */
        var intro:Bytes = frameInput.makeInput(data);
        var bytes:BytesBuffer = new BytesBuffer();
        bytes.addBytes(intro,0,8);
        bytes.addBytes(Bytes.alloc(125),0,125);
        bytes.addByte(0x01);
        mock.bytes = new BytesInput(bytes.getBytes());
        var out:Bytes = frame.read();
        MatcherAssert.assertThat(out.length, IsEqual.equalTo(126));
        MatcherAssert.assertThat(out.get(125), IsEqual.equalTo(1));
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