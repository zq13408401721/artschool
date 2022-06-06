package com.yhschool

import android.app.Application
import android.content.SharedPreferences
import android.widget.Toast
import com.bokecc.sdk.mobile.download.VodDownloadManager
import com.bokecc.sdk.mobile.drm.DRMServer
import com.bokecc.sdk.mobile.util.DWSdkStorage
import com.bokecc.sdk.mobile.util.DWStorageUtil
import com.pgyer.pgyersdk.PgyerSDKManager
import com.pgyer.pgyersdk.pgyerenum.FeatureEnum
import com.yhschool.utils.ConfigUtil
import com.yhschool.utils.MultiUtils

class MyApp:Application() {

    companion object{
        var app: MyApp? = null
        var MODULELIST = arrayOf("com.bokecc.vod.HuodeApplication")
        var drmServer: DRMServer? = null
        var drmServerPort = 0
        var sp: SharedPreferences? = null
    }

    override fun onCreate() {
        super.onCreate()
        app = this
        initApp()
    }

    private fun initApp() {
        sp = getSharedPreferences("AccountSettings", MODE_PRIVATE)
        //初始化本地数据库
        //初始化本地数据库
        initDWStorage()
        startDRMServer()

        //初始化VodDownloadManager

        //初始化VodDownloadManager
        val downloadPath: String = MultiUtils.createDownloadPath()
        //使用VodDownloadManager需要以单例VodDownloadManager.getInstance()的形式调用
        //使用VodDownloadManager需要以单例VodDownloadManager.getInstance()的形式调用
        VodDownloadManager.getInstance().init(app, ConfigUtil.USER_ID, ConfigUtil.API_KEY, downloadPath)

        /*PgyerSDKManager.InitSdk()
                .setContext(this) //设置上下问对象
                .enable(FeatureEnum.CHECK_UPDATE)  //添加检查新版本
                .build();*/
    }

    override fun onTerminate() {
        if (drmServer != null) {
            drmServer!!.stop()
        }
        super.onTerminate()
    }

    // 启动DRMServer
    fun startDRMServer() {
        if (drmServer == null) {
           drmServer = DRMServer()
            drmServer!!.setRequestRetryCount(20)
        }
        try { drmServer!!.start()
            setDrmServerPort(drmServer!!.getPort())
        } catch (e: Exception) {
            Toast.makeText(applicationContext, "启动解密服务失败，请检查网络限制情况:" + e.message, Toast.LENGTH_LONG).show()
        }
    }

    private fun initDWStorage() {
        val myDWSdkStorage: DWSdkStorage = object : DWSdkStorage {
            private val sp = applicationContext.getSharedPreferences("mystorage", MODE_PRIVATE)
            override fun put(key: String, value: String) {
                val editor = sp.edit()
                editor.putString(key, value)
                editor.commit()
            }

            override fun get(key: String): String {
                return sp.getString(key, "")!!
            }
        }
        DWStorageUtil.setDWSdkStorage(myDWSdkStorage)
    }
    fun setDrmServerPort(_drmServerPort: Int) {
        drmServerPort = _drmServerPort
    }


}