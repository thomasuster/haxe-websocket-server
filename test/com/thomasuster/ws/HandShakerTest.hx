package com.thomasuster.ws;
import com.thomasuster.ws.input.BytesInputMock;
import com.thomasuster.ws.FrameReader;
import com.thomasuster.ws.input.ByteStringer;
import com.thomasuster.ws.HandShaker;
import org.hamcrest.core.IsEqual;
import org.hamcrest.MatcherAssert;
class HandShakerTest {

    var frameInput:ByteStringer;
    var shaker:HandShaker;
    var mock:BytesInputMock;
    
    public function new() {
    }

    @Before
    public function before():Void {
        shaker = new HandShaker();
        mock = new BytesInputMock();
        shaker.input = mock;
    }
    
    @Test
    public function testExample():Void {
        var shaker:HandShaker = new HandShaker(); 
        MatcherAssert.assertThat(shaker.hash('dGhlIHNhbXBsZSBub25jZQ=='), IsEqual.equalTo('s3pPLMBiTxaQ9kYGzzhZRbK+xOo='));
    }
}