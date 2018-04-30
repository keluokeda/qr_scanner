import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_scanner/qr_scanner.dart';
import 'dart:typed_data';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
//  String _platformVersion = 'Unknown';

  String _result = "";

  TextEditingController _controller = new TextEditingController();

  Uint8List _imageData;

  @override
  initState() {
    super.initState();
//    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  scan() async {
    String result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      print("start scan");
      result = await QrScanner.scan();
    } on PlatformException catch (e) {
      result = e.message;
    }

    print("stop scan");

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted)
      return;

    setState(() {
      _result = result;
    });
  }


  createQRImage() async {
    String content = _controller.text;

    Uint8List data = await QrScanner.createQrImageData(content, 200);

    setState(() {
      _imageData = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
            title: new Text('Plugin example app')
        ),
        body: new ListView(
          children: <Widget>[
            new ListTile(
              title: new Text(_result),
              trailing: new IconButton(
                  icon: new Icon(Icons.camera_alt), onPressed: scan),
            ),
            new ListTile(
              title: new TextFormField(controller: _controller,),
              trailing: new IconButton(
                  icon: new Icon(Icons.create), onPressed: createQRImage),
            ),
            new Container(
              padding: new EdgeInsets.all(20.0),
              child: _imageData == null ? new Text("") : new Image.memory(
                _imageData, width: 200.0, height: 200.0,),
            )
          ],
        ),
      ),
    );
  }
}
