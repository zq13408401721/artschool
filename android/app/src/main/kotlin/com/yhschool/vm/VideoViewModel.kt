package com.yhschool.vm

import android.content.Intent
import androidx.fragment.app.Fragment
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.yhschool.base.BaseViewModel
import com.yhschool.net.Inject
import com.yhschool.net.Repository
import com.yhschool.api.Constants
import com.yhschool.api.ServiceApi
import com.yhschool.data.VideoData
import com.yhschool.net.RetrofitFactory
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext

class VideoViewModel: ViewModel() {



    //视频课程数据
    var videoData:MutableLiveData<List<VideoData.Data>> = MutableLiveData()
    
    var sectionname:String = ""
    var categoryname:String = ""
    var categoryid:Int = 0
    var classify:String = ""

    var page=1
    var size = 10

    var repository:Repository? = null
    init {
        repository = Repository()
    }

    fun parseIntent(intent: Intent){
        Constants.token = intent.getStringExtra("token")
        classify = intent.getStringExtra("classify")!!
        sectionname = intent.getStringExtra("section")!!
        categoryname = intent.getStringExtra("category")!!
        categoryid = intent.getIntExtra("categoryid",0)

    }

    fun getVideoList(){
        var map = HashMap<String,String>()
        map.put("categoryid",categoryid.toString())
        map.put("page",page.toString())
        map.put("size",size.toString())
        viewModelScope.launch {
            var result = repository!!.getVideoList(map)
            if(result.errno == 0){
                videoData.postValue(result.data)
            }
        }
    }

}