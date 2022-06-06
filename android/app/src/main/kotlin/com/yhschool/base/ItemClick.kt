package com.yhschool.base

import android.view.View

/**
 *   author ：H C
 *   time ：2021/4/26
 */
interface ItemClick<T> {
    fun clickListener(pos: Int,view:View)
}