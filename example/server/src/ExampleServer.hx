package ;
import com.thomasuster.ws.FrameWriter;
import haxe.io.Bytes;
import com.thomasuster.ws.FrameReader;
import com.thomasuster.ws.HandShaker;
import com.thomasuster.ws.output.BytesOutputReal;
import com.thomasuster.ws.input.BytesInputReal;
import sys.net.Host;
import sys.net.Socket;
class ExampleServer {

    var socket:Socket;
    var s:Socket;

    public static function main() {
        new ExampleServer();
    }
    
    public function new():Void {
        start();
        while(true)
            update();
    }

    public function start():Void {
        socket = new Socket();
        socket.setBlocking(true);
        socket.setTimeout(60);
        socket.bind(new Host('localhost'),4000);
        socket.listen(1);
    }

    public function update():Void {
        s = socket.accept();
        
        var input:BytesInputReal = new BytesInputReal();
        input.input = s.input;
        var output:BytesOutputReal = new BytesOutputReal();
        output.output = s.output;

        var shaker:HandShaker = new HandShaker();
        shaker.input = input;
        shaker.output = output;
        shaker.shake();

        var reader:FrameReader = new FrameReader();
        reader.input = input;

        while(true) {
            var toServer:Bytes = reader.read();

            if(toServer.toString() == 'ping') {
                var writer:FrameWriter = new FrameWriter();
                writer.output = output;
                writer.payload = Bytes.ofString('pong');
                writer.write();   
            }
        }
    }
}