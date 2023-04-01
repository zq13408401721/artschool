import 'package:flutter/services.dart';

class FlutterPlugins{
  static const MethodChannel channel_android = const MethodChannel("toNativeChannel");

  static Future<int> setLauncher(String name) async {
    await channel_android.invokeMethod('setLauncher',name);
  }
}