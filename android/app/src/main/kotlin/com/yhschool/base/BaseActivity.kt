
package com.yhschool.base
import android.app.Activity
import android.content.Context
import android.os.Bundle
import android.util.Base64
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity
import androidx.databinding.DataBindingUtil
import androidx.databinding.ViewDataBinding
import androidx.lifecycle.ViewModel
import androidx.lifecycle.ViewModelProvider

abstract class BaseActivity<VM:ViewModel,DB:ViewDataBinding>(
    val layoutId:Int,
    var vmClass: Class<VM>
):AppCompatActivity() {
    //当前activity对应的ViewModel
    protected lateinit var mViewModel:VM
    //当前activity对应的DataBinding
    protected lateinit var mDataBinding:DB
    protected lateinit var mContext: Context
    protected lateinit var mActivity: Activity

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        mContext = this
        mActivity = this
        mDataBinding = DataBindingUtil.setContentView(this,layoutId)
        mViewModel = ViewModelProvider(this).get(vmClass)
        initView()
        initVM()
        initData()
        initVariable()
    }

    //模板模式
    protected abstract fun initView()
    protected abstract fun initVM()
    protected abstract fun initData()
    protected abstract fun initVariable()

    /**
     * 提示
     */
    protected fun showTips(tips:String){
        Toast.makeText(mContext,tips,Toast.LENGTH_SHORT).show()
    }

}