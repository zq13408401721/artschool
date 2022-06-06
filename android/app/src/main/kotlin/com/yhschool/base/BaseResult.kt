package com.yhschool.base

/**
 *   author ：H C
 *   time ：2021/4/27
 */
data class BaseResult<T>(
    val errno:Int,
    val errmsg:String,
    var data:T
)