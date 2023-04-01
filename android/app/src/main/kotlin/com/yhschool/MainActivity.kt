package com.yhschool

import android.app.ActivityManager
import android.content.ComponentName
import android.content.Context
import android.content.pm.PackageManager
import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity: FlutterActivity() {


    val CHANNEL:String = "toNativeChannel"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        var androidMethodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger,CHANNEL)
        GeneratedPluginRegistrant.registerWith(flutterEngine)
        androidMethodChannel.setMethodCallHandler {call, result ->
            run {
                if (call.method != null) {
                    if ("setLauncher".equals(call.method)) {
                        setLauncher("com.art.NewLuncherActivity")
                        result.success(1);
                    }
                } else {
                    result.notImplemented()
                }
            }
        }
    }

    fun setLauncher(name:String){
        var pm = getPackageManager()
        pm.setComponentEnabledSetting(getComponentName(),
            PackageManager.COMPONENT_ENABLED_STATE_DISABLED, PackageManager.DONT_KILL_APP)
        pm.setComponentEnabledSetting(ComponentName(this,name),PackageManager.COMPONENT_ENABLED_STATE_ENABLED, PackageManager.DONT_KILL_APP)

    }

}
