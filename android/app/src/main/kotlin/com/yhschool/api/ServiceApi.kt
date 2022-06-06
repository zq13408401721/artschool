package com.yhschool.api

import com.yhschool.base.BaseApi
import com.yhschool.data.VideoData
import retrofit2.http.FieldMap
import retrofit2.http.FormUrlEncoded
import retrofit2.http.POST

interface ServiceApi: BaseApi {

    /*@POST("api/cms/detail")
    suspend fun getDetail(@Query("id") id:Int): DetailData*/

    @POST("api/home/videoList")
    @FormUrlEncoded
    suspend fun getVideoList(@FieldMap map: Map<String,String>):VideoData

}