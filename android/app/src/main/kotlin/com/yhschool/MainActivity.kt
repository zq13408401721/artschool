package com.yhschool

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity: FlutterActivity() {

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine)
    }

    /*override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)
    //setContentView(R.layout.activity_main)
    //定制android pad 通过sendBroadcast来触发

    var intent = Ient("android.media.action.IMACE_CAPTURE")
    // 将要广播的数据添加到Intent对象中
    intent.setPackage("com.android.camera.CameraLauncher")
    // 发送广播
    sendBroadcast(intent);
    }*/

}
