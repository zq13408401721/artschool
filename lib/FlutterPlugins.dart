import 'package:flutter/services.dart';

class FlutterPlugins{
  static const MethodChannel channel_plugins = const MethodChannel("toNativeChannel");

  static Future<int> setLauncher(String name) async {
    await channel_plugins.invokeMethod('setLauncher',name);
  }

  static Future<void> setOrientation(int screen) async {
    await channel_plugins.invokeMethod('changeOrientation', screen);
  }

  //设置ios原生播放
  static Future<void> setIosVideoPlay(String url) async {
    await channel_plugins.invokeMethod('setVideoPlay',url);
  }

  //主要针对android13 特殊权限(相册 视频 音频)
  static Future<int> requestAndroidPermission() async {
    var result = await channel_plugins.invokeMethod('permission');
    return result;
  }
}