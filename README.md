[![Build Status](https://travis-ci.org/thomasuster/haxe-websocket-server.svg?branch=master)](https://travis-ci.org/thomasuster/haxe-websocket-server) 

## Haxe Websocket Server (UNDER DEVELOPMENT)

A haxe to neko server implementation of websockets.

### Run the tests
```
git clone git@github.com:thomasuster/haxe-websocket-server.git
haxelib dev haxe-websocket-server haxe-websocket-server
cd haxe-websocket-server
haxelib run munit test
```

### Run the example

1. Run the example server
    ```
    cd haxe-websocket-server/example/server
    haxe build.hxml
    neko Build.n
    ```

2. In a new console build the example client
    ```
    cd haxe-websocket-server/example/client
    haxe build.hxml
    open index.html
    ```

3. Show the javascript console (alt+command+i for osx chrome)
4. You should see something like this...
    ```
    ping
    pong
    ping
    pong
    ...
    ```

5. Open haxe-websocket-server/example/ and see how it works!