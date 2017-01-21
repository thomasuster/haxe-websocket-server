package com.thomasuster.ws.input;
import haxe.io.Bytes;
class ByteStringer {

    public function new():Void {}

    public function makeInput(data:String):Bytes {
        var raw:String = data.split(' ').join('');
        var b:Bytes = Bytes.alloc(Math.floor(raw.length/8));
        var current:Int = 0;
        var pos:Int = 0;
        for (i in 0...raw.length) {
            var r:Int = i % 8;
            if(Std.parseInt(raw.charAt(i)) == 1)
                current |= (1 << (7-r));
            if(r == 7) {
                b.set(pos, current);
                current = 0;
                pos++;
            }
        }
        return b;
    }

    public function printInput(bytes:Bytes):String {
        var bits:Array<Int> = [];
        for (i in 0...bytes.length) {
            for (j in 0...8) {
                var byte:Int = bytes.get(i);
                byte = byte << j;
                byte = byte & 0xFF;
                byte = byte >> 7;
                if(byte == 1)
                    bits.push(1);
                else
                    bits.push(0);
            }
        }
        return bits.join(' ');    
    }

    public function assertEquals(actual:Bytes, expected:String):String {
        var out:String = printInput(actual);
        var s:String = assertLinedUp(out, expected);
        return s;
    }

    public function assertLinedUp(actual:String, expected:String):String {
        var s:String = '';
        if(actual != expected) {
            s+='\nExpected: ' + expected + '\n';
            s+=' But was: ' + actual + '\n';
        }
        return s;
    }
}