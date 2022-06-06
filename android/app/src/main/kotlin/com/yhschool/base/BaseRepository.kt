package com.yhschool.base

import com.yhschool.net.RetrofitFactory


/**
 * model数据厂库
 */
open class BaseRepository<S>(rCla:Class<S>) {

    protected var api:S? = null //Api接口的实例

    init {
        api = RetrofitFactory.instance.create(rCla)
    }

}