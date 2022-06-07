package com.yhschool

import android.app.Application

class MyApp:Application() {

    companion object{
        var app: MyApp? = null
    }

    override fun onCreate() {
        super.onCreate()
        app = this
    }

}