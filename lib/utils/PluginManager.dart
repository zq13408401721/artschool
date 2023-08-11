import 'package:flutter/services.dart';

class PluginManager {
  //定义通道
  static const MethodChannel _channel = const MethodChannel('plugin_video');

  static Future<String> pushVideoActivity(Map param) async {
    //定义方法名 打开视频播放详情页
    String result = await _channel.invokeMethod('openVideoDetail',param);
    return result;
  }

}