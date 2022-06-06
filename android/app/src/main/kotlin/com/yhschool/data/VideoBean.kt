package com.yhschool.data

data class VideoData(
    val data: List<Data>,
    val errmsg: String,
    val errno: Int
){
    data class Data(
            val categoryid: Int,
            val ccid: String,
            val id: Int,
            val name: String,
            val sort: Any,
            val time: Any,
            val url: Any,
            var select:Boolean
    )
}

