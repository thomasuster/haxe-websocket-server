package com.thomasuster.ws;
import com.thomasuster.ws.input.ByteStringer;
import haxe.io.BytesBuffer;
import haxe.io.BytesBuffer;
import haxe.io.Int32Array;
import haxe.io.BytesData;
import massive.munit.Assert;
import haxe.io.Bytes;
import org.hamcrest.core.IsEqual;
import org.hamcrest.MatcherAssert;
class ByteStringerTest {
    
    var factory:ByteStringer;
    
    public function new() {
    }
    
    @Before
    public function before():Void {
        factory = new ByteStringer();
    }
    
    @Test
    public function test1Byte():Void {
        var data:String = '1 0 0 0 0 0 0 0';
        /*                 0 1 2 3 4 5 6 7 */
        var bytes:Bytes = factory.makeInput(data);
        MatcherAssert.assertThat(bytes.length, IsEqual.equalTo(1));
        MatcherAssert.assertThat(bytes.get(0), IsEqual.equalTo(128));
    }

    @Test
    public function test1ByteInAndOut():Void {
        var data:String = '1 0 0 1 0 0 0 0';
        /*                 0 1 2 3 4 5 6 7 */
        var actual:Bytes = factory.makeInput(data);
        var t:String = factory.assertEquals(actual, data);
        if(t != '')
            Assert.fail(t);
    }
}