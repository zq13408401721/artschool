package com.yhschool.ui

import android.os.Bundle
import android.util.SparseArray
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.fragment.app.Fragment
import androidx.recyclerview.widget.LinearLayoutManager
import com.yhschool.base.ItemClick
import com.yhschool.adapter.VideoAdapter
import com.yhschool.data.VideoData
import com.yhschool.evts.CallBack
import com.yhschool.evts.ClickEvt
import com.yhschool.R
import kotlinx.android.synthetic.main.fragment_videolist.*


class VideoListFragment:Fragment() {

    companion object{
        val listFragment:VideoListFragment by lazy {
            VideoListFragment()
        }
    }

    lateinit var callBack:CallBack

    fun addClickEvt(cb:CallBack){
        callBack = cb
    }

    var list:ArrayList<VideoData.Data> = arrayListOf()
    lateinit var videoAdapter:VideoAdapter

    fun setData(_list:ArrayList<VideoData.Data>){
        list = _list
        videoAdapter.addData(list)
    }

    override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?): View? {
        var view = inflater.inflate(R.layout.fragment_videolist,null)
        return view
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        videoAdapter = VideoAdapter(context!!,list,object : CallBack{
            override fun onClick(data: Any) {
                if(callBack != null){
                    callBack.onClick(data)
                }
            }

        })
        recy_list.layoutManager = LinearLayoutManager(context)
        recy_list.adapter = videoAdapter
    }
}