package com.yhschool.base

import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel

/**
 * viewmodel基类
 */
open class BaseViewModel<R>(val repository: R):ViewModel() {
    protected var status:MutableLiveData<Int> = MutableLiveData()

}