import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';

class FlashlightPlugin {
  static const MethodChannel _channel = MethodChannel('flashlight_plugin');

  static Future<void> toggleFlashlight({required bool enable}) async {
    if (defaultTargetPlatform == TargetPlatform.android) {
      try {
        await _channel.invokeMethod('toggleFlashlight', {'enable': enable});
      } on PlatformException catch (e) {
        if (kDebugMode) {
          print("Failed to toggle flashlight: ${e.message}");
        }
      }
    } else {
      throw UnsupportedError("Flashlight is only available on Android.");
    }
  }
}
