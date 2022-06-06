package com.yhschool.evts

import android.view.View

interface ClickEvt {

    fun clickListener(v:View)
}

interface CallBack{
    fun onClick(data:Any)
}