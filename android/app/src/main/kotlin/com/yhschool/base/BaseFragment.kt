package com.yhschool.base

import android.app.Activity
import android.content.Context
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.databinding.DataBindingUtil
import androidx.databinding.ViewDataBinding
import androidx.fragment.app.Fragment
import androidx.lifecycle.ViewModel
import androidx.lifecycle.ViewModelProvider

abstract class BaseFragment<VM:ViewModel,DB:ViewDataBinding>(
    val layoutId:Int,
    val vmClass: Class<VM>
):Fragment() {

    //当前activity对应的ViewModel
    protected lateinit var mViewModel:VM
    //当前activity对应的DataBinding
    protected lateinit var mDataBinding:DB
    protected lateinit var mContext: Context
    protected lateinit var mActivity: Activity

    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        mContext = this.context!!
        mActivity = activity!!
        mDataBinding = DataBindingUtil.inflate(inflater,layoutId,container,false)
        mViewModel = ViewModelProvider(this).get(vmClass)
        var mView = mDataBinding.root
        return mView
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        initView()
        initVM()
        initData()
        initVariable()
    }

    //模板模式
    protected abstract fun initView()
    protected abstract fun initVM();
    protected abstract fun initData()
    protected abstract fun initVariable()

}