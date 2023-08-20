package com.yhschool

import android.Manifest
import android.app.ActivityManager
import android.content.ComponentName
import android.content.Context
import android.content.pm.PackageManager
import android.content.pm.PermissionInfo
import android.os.Build
import android.os.Bundle
import android.util.Log
import android.view.Gravity
import android.view.ViewGroup
import androidx.core.content.PermissionChecker
import androidx.core.content.pm.PermissionInfoCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant
import java.lang.System.out
import java.security.Permission

class MainActivity: FlutterActivity() {


    val CHANNEL:String = "toNativeChannel"
    var resultCall: MethodChannel.Result? = null


    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        //开启手机缓存
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        var androidMethodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger,CHANNEL)
        GeneratedPluginRegistrant.registerWith(flutterEngine)
        androidMethodChannel.setMethodCallHandler {call, result ->
            run {
                if (call.method != null) {
                    if ("setLauncher".equals(call.method)) {
                        setLauncher("com.art.NewLuncherActivity")
                        result.success(1);
                    } else if ("permission".equals(call.method)) {
                        requestPermission(result)
                    } else if ("haspermission".equals(call.method)){
                        //当前sdk小于android 13
                        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.TIRAMISU) {
                            result.success(1000)
                        }else{
                            var permissions = arrayListOf<String>()
                            for(item in arrayOf(Manifest.permission.READ_MEDIA_AUDIO, Manifest.permission.READ_MEDIA_IMAGES,
                                    Manifest.permission.READ_MEDIA_VIDEO)){
                                if(checkSelfPermission(item) != PackageManager.PERMISSION_GRANTED){
                                    permissions.add(item)
                                }
                            }
                            if(permissions.size > 0){
                                result!!.success(-1)
                            }else{
                                result!!.success(0)
                            }
                        }
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

    /**
     * 权限申请 针对android13
     */
    fun requestPermission(result:MethodChannel.Result) {
        resultCall = result
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.TIRAMISU) {
            result.success(1000)
            resultCall = null
        } else {
            var permissions = arrayListOf<String>()
            for(item in arrayOf(Manifest.permission.READ_MEDIA_AUDIO, Manifest.permission.READ_MEDIA_IMAGES,
                Manifest.permission.READ_MEDIA_VIDEO)){
                if(checkSelfPermission(item) != PackageManager.PERMISSION_GRANTED){
                    permissions.add(item)
                }
            }
            if(permissions.size > 0){
                requestPermissions(permissions.toTypedArray(),100)
            }else{
                if(resultCall != null){
                    resultCall!!.success(0)
                    resultCall = null
                }
            }
        }
    }

    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<out String>,
        grantResults: IntArray
    ) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        var result = true
        for(i in grantResults) {
            if(i != PackageManager.PERMISSION_GRANTED){
                result = false
                break
            }
        }
        Log.d("tag", "onRequestPermissionsResult " + resultCall)
        if(resultCall != null) {
            Log.d("tag","resultCall is not null")
            if(result){
                resultCall!!.success(1)
            }else{
                resultCall!!.success(-1)
            }
            resultCall = null
        }
    }



}
