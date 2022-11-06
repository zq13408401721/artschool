import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yhschool/BaseState.dart';
import 'package:yhschool/utils/Constant.dart';
import 'package:yhschool/utils/SizeUtil.dart';
import 'package:yhschool/widgets/BackButtonWidget.dart';

abstract class BaseRefreshState<T extends StatefulWidget> extends BaseState<T>{

  bool isloading = false,isrefreshing = false; //是否加载中
  bool hasData = true; //是否有更多数据

  bool isShowAdvert = false;
  dynamic advertData = null;

  ScrollController _scrollController;
  double oldoffset = 0;

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
        print("scrollController offset ${_scrollController.offset} pixels:${_scrollController.position.pixels} max:${_scrollController.position.maxScrollExtent}");
        if(oldoffset == 0){
          oldoffset = _scrollController.offset;
          return;
        };
        //如果是向上的滚动就不要出现加载更多
        if(_scrollController.offset < oldoffset){
          oldoffset = _scrollController.offset;
          return;
        }
        oldoffset = _scrollController.offset;
        if(isloading == false){
          this.isloading = true;
          setState(() {
            loadmore();
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
    Future.delayed(new Duration(seconds: 1),(){
      setState(() {
        this.isrefreshing = false;
      });
    });
  }

  //隐藏加载更多
  void hideLoadMore(){
    Future.delayed(new Duration(seconds: 1),(){
      setState(() {
        this.isloading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[100],
      child: Column(
        children: [
          //顶部标题
          /*Container(
                padding: EdgeInsets.only(
                  top: ScreenUtil().setHeight(20)
                ),
                margin: EdgeInsets.only(
                  bottom: ScreenUtil().setHeight(20)
                ),
                decoration: BoxDecoration(
                  color: Colors.white
                ),
                child: BackButtonWidget(
                  cb:(){
                     Navigator.pop(context);
                  },title: "返回",
                ),
              ),*/
          //是否显示广告
          (isShowAdvert && advertData != null) ?
          createAdvert(advertData["url"],advertData["weburl"],advertData["height"]) : SizedBox(),
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
          Expanded(child: addChildren()),
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

  //置顶网盘
  Future<bool> showPanTopping() async{
    bool _bool = false;
    await showDialog(context: context, builder: (context){
      return StatefulBuilder(builder: (context,state){
        return FractionallySizedBox(
          widthFactor: 2/3,
          heightFactor: 1/6,
          child: Card(
            child: Container(
              padding: EdgeInsets.symmetric(
                  horizontal: SizeUtil.getAppWidth(20),
                  vertical: SizeUtil.getAppHeight(20)
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("是否置顶本网盘?",style: TextStyle(fontSize: SizeUtil.getAppFontSize(30)),),
                  SizedBox(height: SizeUtil.getHeight(20),),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap: (){
                            _bool = true;
                            Navigator.pop(context);
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: SizeUtil.getAppWidth(10)),
                            padding: EdgeInsets.symmetric(vertical: SizeUtil.getAppWidth(10),horizontal: SizeUtil.getAppWidth(20)),
                            decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.all(Radius.circular(SizeUtil.getWidth(5)))
                            ),
                            child: Text("确定",style: TextStyle(color: Colors.white,fontSize: SizeUtil.getAppFontSize(30)),),
                          ),
                        ),
                        InkWell(
                            onTap: (){
                              Navigator.pop(context);
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: SizeUtil.getAppWidth(10)),
                              padding: EdgeInsets.symmetric(vertical: SizeUtil.getAppWidth(10),horizontal: SizeUtil.getAppWidth(20)),
                              decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.all(Radius.circular(SizeUtil.getWidth(5)))
                              ),
                              child: Text("取消",style: TextStyle(color: Colors.white,fontSize: SizeUtil.getAppFontSize(30)),),
                            )
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      });
    });
    return _bool;
  }

  @override
  void dispose() {
    if(_scrollController != null){
      _scrollController.dispose();
    }
    super.dispose();
  }

}