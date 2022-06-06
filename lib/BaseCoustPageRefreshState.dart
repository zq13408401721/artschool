import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yhschool/BaseState.dart';
import 'package:yhschool/utils/SizeUtil.dart';
import 'package:yhschool/widgets/BackButtonWidget.dart';

import 'BaseDialogState.dart';

abstract class BaseCoustPageRefreshState<T extends StatefulWidget> extends BaseDialogState{

  bool isloading = false,isrefreshing = false; //是否加载中
  bool hasData = true; //是否有更多数据

  ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
  }

  /**
   * 初始化控制
   */
  ScrollController initScrollController({bool isfresh=true}){
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if(_scrollController.position.maxScrollExtent > 0 && _scrollController.position.pixels > _scrollController.position.maxScrollExtent-100){
        //加载更多
        if(isloading == false){
          setState(() {
            /*if(hasData){
              loadmore();
            }else{
              Future.delayed(Duration(seconds: 2),(){
                hideLoadMore();
              });
              showToast("没有更多数据");
            }*/
            loadmore();
            this.isloading = true;
          });
        }
      }else if(_scrollController.position.pixels < -100){
        if(!isfresh) return;
        //刷新
        if(isrefreshing == false){
          setState(() {
            refresh();
            this.isrefreshing = true;
          });
        }

      }
    });
    return _scrollController;
  }

  Widget refreshWidget(){
    return Center(
      child: Container(
        padding: EdgeInsets.symmetric(
            vertical: ScreenUtil().setHeight(40)
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: ScreenUtil().setWidth(SizeUtil.getWidth(40)),
              height: ScreenUtil().setWidth(SizeUtil.getWidth(40)),
              child: CircularProgressIndicator(color: Colors.red,),
            ),
            SizedBox(width: 10,),
            Text("数据刷新中",style: TextStyle(color: Colors.grey),)
          ],
        ),
      ),
    );
  }

  Widget loadmoreWidget(){
    return Center(
      child: Container(
        padding: EdgeInsets.symmetric(
            vertical: ScreenUtil().setHeight(40)
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: ScreenUtil().setWidth(SizeUtil.getWidth(40)),
              height: ScreenUtil().setWidth(SizeUtil.getWidth(40)),
              child: CircularProgressIndicator(color: Colors.red,),
            ),
            SizedBox(width: 10,),
            Text("加载更多",style: TextStyle(color:Colors.grey),)
          ],
        ),
      ),
    );
  }

  //刷新
  void refresh();

  //加载更多
  void loadmore();

  //添加列表子元素
  List<Widget> addChildren();

  //隐藏刷新
  void hideRefreshing(){
    setState(() {
      this.isrefreshing = false;
    });
  }

  //隐藏加载更多
  void hideLoadMore(){
    setState(() {
      this.isloading = false;
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          color: Colors.grey[100],
          child: Column(
            children: addChildren(),
          ),
        ),
      ),
    );
  }


  @override
  void dispose() {
    if(_scrollController != null){
      _scrollController.dispose();
    }
    super.dispose();
  }

}