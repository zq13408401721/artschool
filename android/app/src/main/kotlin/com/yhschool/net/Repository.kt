package com.yhschool.net



import com.yhschool.api.ServiceApi
import com.yhschool.base.BaseRepository

import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext

class Repository {

    var api:ServiceApi? = null
    init {
        api = RetrofitFactory.instance.create(ServiceApi::class.java)
    }


    /**
     * 获取视频列表
     */
    suspend fun getVideoList(map:Map<String,String>) = withContext(Dispatchers.IO){
        api!!.getVideoList(map)
    }

}