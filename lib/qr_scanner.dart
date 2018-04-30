import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/services.dart';

class QrScanner {
  static const MethodChannel _channel =
  const MethodChannel('github.com/keluokeda/qr_scanner');

  static Future<String> scan() async {
    final String version = await _channel.invokeMethod('scan');
    return version;
  }

  ///创建二维码图片数据
  static Future<Uint8List> createQrImageData(String content, int size) async {
    return await _channel.invokeMethod(
        "createQRImageData", {"content": content, "size": size});
  }
}
