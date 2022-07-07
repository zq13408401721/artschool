import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yhschool/BaseState.dart';
import 'package:yhschool/utils/SizeUtil.dart';
import 'package:yhschool/widgets/BackButtonWidget.dart';

abstract class BaseListRefresh<T extends StatefulWidget> extends BaseState<T>{

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
            this.isrefreshing = true;
            refresh();
          });
        }

      }
    });
    return _scrollController;
  }

  //刷新
  void refresh();

  //加载更多
  void loadmore();

  //添加列表子元素
  Widget addChildren();

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
    return Container(
      color: Colors.grey[100],
      child: Column(
        children: [
          //顶部标题
          //刷新动画
          isrefreshing ?
          Center(
            child: Container(
              padding: EdgeInsets.symmetric(
                  vertical: ScreenUtil().setHeight(40)
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: ScreenUtil().setWidth(40),
                    height: ScreenUtil().setWidth(40),
                    child: CircularProgressIndicator(color: Colors.red,),
                  ),
                  SizedBox(width: 10,),
                  Text("数据刷新中",style: TextStyle(color: Colors.grey),)
                ],
              ),
            ),
          ) : SizedBox(),
          SizedBox(height: ScreenUtil().setHeight(SizeUtil.getHeight(20)),),
          Expanded(child: Container(
            child: addChildren(),
          )),
          isloading ?
          Center(
            child: Container(
              padding: EdgeInsets.symmetric(
                  vertical: ScreenUtil().setHeight(40)
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: ScreenUtil().setWidth(40),
                    height: ScreenUtil().setWidth(40),
                    child: CircularProgressIndicator(color: Colors.red,),
                  ),
                  SizedBox(width: 10,),
                  Text("加载更多",style: TextStyle(color:Colors.grey,fontSize: ScreenUtil().setSp(30),fontWeight: FontWeight.normal,decoration: TextDecoration.none),)
                ],
              ),
            ),
          ) : SizedBox()
        ],
      ),
    );
  }

  /*@override
  void dispose() {
    if(_scrollController != null){
      _scrollController.dispose();
    }
    super.dispose();
  }*/

}