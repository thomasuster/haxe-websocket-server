package ;
import js.html.Uint8Array;
import js.html.ArrayBuffer;
import js.html.FileReader;
import js.html.Event;
import js.html.MessageEvent;
import js.html.WebSocket;
class ExampleClient {

    public var ws:WebSocket;

    static function main() {
        new ExampleClient();
    }
    
    public function new():Void {
        connect();
        loop();
    }

    function loop():Void {
        var window:Dynamic = js.Browser.window;
        var rqf:Dynamic = window.requestAnimationFrame ||
        window.webkitRequestAnimationFrame ||
        window.mozRequestAnimationFrame;
        update();
        rqf(loop);
    }

    function connect():Void {
        trace("connecting...");
        ws = new WebSocket("ws://localhost:4000");
        ws.onopen = handleJSOpen;
        ws.onclose = handleJSClose;
        ws.onmessage = cast handleJSMessage;
        ws.onerror = cast handleJSError;
    }

    function update():Void {
        if(ws.readyState == WebSocket.OPEN) {
            trace("ping");
            ws.send('ping');
        }
    }

    function handleJSOpen(evt:Event) {
        trace('connection open\n');
    }

    function handleJSClose(evt:Event) {
        trace("connection closed\n");
    }

    function handleJSMessage(evt:MessageEvent) {
        var fileReader:FileReader = new FileReader();
        fileReader.onload = function() {
            var buffer:ArrayBuffer = fileReader.result;
            var view:Uint8Array = new Uint8Array(buffer);
            var s:String = '';
            for (i in 0...view.length) {
                var char:Int = view[i];
                s += String.fromCharCode(char);
            }
            trace(s);
        };
        fileReader.readAsArrayBuffer(evt.data);
    }

    function handleJSError(evt:MessageEvent) {
        trace("Error: " + evt.data + '\n');
    }
}