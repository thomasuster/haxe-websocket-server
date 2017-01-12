1. Install
```
git clone git@github.com:thomasuster/haxe-websocket-server.git
haxelib dev haxe-websocket-server haxe-websocket-server
```

1. Run the tests
```
cd haxe-websocket-server
haxelib run munit test
```

1. Run the example

  1. Run the example server
  ```
  cd haxe-websocket-server/example/server
  haxe build.hxml
  neko Build.n
  ```

  1. Run the example client (Chrome)
  ```
  cd haxe-websocket-server/example/client
  haxe build.hxml
  open index.html
  ```

  1. Show the javascript console (alt+command+i for osx chrome)
  1. You should see something like this...
  ```
  ping
  pong
  ping
  pong
  ...

  1. Open haxe-websocket-server/example/ and see how it works!