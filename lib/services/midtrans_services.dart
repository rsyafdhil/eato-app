import 'package:flutter/services.dart';

class MidtransService {
  static const _channel = MethodChannel('midtrans_channel');

  static Future<void> paySnapToken(String snapToken) async {
    try {
      await _channel.invokeMethod('paySnapToken', {"token": snapToken});
    } on PlatformException catch (e) {
      print("Error Midtrans: ${e.message}");
    }
  }
}
