package com.yhschool

import android.content.Intent
import android.os.Build
import android.os.Bundle
import com.yhschool.api.Constants
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity: FlutterActivity() {

    val channel = "plugin_video"
    var classify:String = ""
    var section:String = ""
    var category:String = ""
    var categoryid:Int = 0
    var token:String = ""
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor,channel).setMethodCallHandler { call, result ->
            if(call.method.equals("openVideoDetail")){
                classify = call.argument<String>("classify").toString()
                section = call.argument<String>("section").toString()
                category = call.argument<String>("category").toString()
                categoryid = call.argument<Int>("categoryid")!!.toInt()
                token = call.argument<String>("token").toString()
                Constants.token = token
                // 跳转
                var intent = Intent(this,VideoActivity::class.java)
                intent.putExtra("classify",classify)
                intent.putExtra("section",section)
                intent.putExtra("category",category)
                intent.putExtra("categoryid",categoryid)
                intent.putExtra("token",token)
                startActivity(intent)
                result.success("打开videoactivity")
            }else{
                result.notImplemented()
            }
        }
    }

    /*override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)
    }*/

}
