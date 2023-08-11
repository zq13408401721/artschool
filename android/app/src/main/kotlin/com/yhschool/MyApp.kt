package com.yhschool

import android.Manifest
import android.app.Application
import android.os.Build
import java.security.Permission

class MyApp:Application() {

    companion object{
        var app: MyApp? = null
    }

    override fun onCreate() {
        super.onCreate()
        app = this
        init()
    }

    fun init(){
    }

}