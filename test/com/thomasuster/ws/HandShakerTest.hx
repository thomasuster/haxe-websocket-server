package com.thomasuster.ws;
import haxe.io.BytesInput;
import haxe.io.Bytes;
import com.thomasuster.ws.output.BytesOutputMock;
import com.thomasuster.ws.input.BytesInputMock;
import com.thomasuster.ws.input.ByteStringer;
import com.thomasuster.ws.HandShaker;
import org.hamcrest.core.IsEqual;
import org.hamcrest.MatcherAssert;
import haxe.io.BytesBuffer;
class HandShakerTest {

    var frameInput:ByteStringer;
    var shaker:HandShaker;
    var input:BytesInputMock;
    var output:BytesOutputMock;
    
    public function new() {
    }

    @Before
    public function before():Void {
        shaker = new HandShaker();
        input = new BytesInputMock();
        output = new BytesOutputMock();
        shaker.input = input;
        shaker.output = output;
    }
    
    @Test
    public function testExample():Void {
        var shaker:HandShaker = new HandShaker(); 
        MatcherAssert.assertThat(shaker.hash('dGhlIHNhbXBsZSBub25jZQ=='), IsEqual.equalTo('s3pPLMBiTxaQ9kYGzzhZRbK+xOo='));
    }
    
    @Test
    public function testChromeStyleHeader():Void {
        var bb:BytesBuffer = new BytesBuffer();
        bb.add(Bytes.ofString(haxe.Resource.getString('chrome')));
        input.bytes = new BytesInput(bb.getBytes());

        shaker.shake();

        var output:String = output.buffer.getBytes().toString();
        MatcherAssert.assertThat(output.split('\r\n')[3], IsEqual.equalTo('Sec-WebSocket-Accept: 4fsrxpYQajC65Rb0+L7yR+IWNxA='));
    }
    
    @Test
    public function testSafariStyleHeader():Void {
        var bb:BytesBuffer = new BytesBuffer();
        bb.add(Bytes.ofString(haxe.Resource.getString('safari')));
        input.bytes = new BytesInput(bb.getBytes());
        
        shaker.shake();
        
        var output:String = output.buffer.getBytes().toString();
        MatcherAssert.assertThat(output, IsEqual.equalTo('HTTP/1.1 101 Switching Protocols\r\nUpgrade: websocket\r\nConnection: Upgrade\r\nSec-WebSocket-Accept: bP7qsdqdjmOA1Stow2peTeRiYOA=\r\n\r\n'));
    }
}