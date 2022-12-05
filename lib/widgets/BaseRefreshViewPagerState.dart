import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yhschool/BaseCoustRefreshState.dart';
import 'package:yhschool/BaseDialogState.dart';
import 'package:yhschool/BaseState.dart';
import 'package:yhschool/utils/SizeUtil.dart';

import 'BackButtonWidget.dart';

abstract class BaseRefreshViewPagerState<T,P extends StatefulWidget> extends BaseDialogState<P>{

  Axis direction;
  bool reverse;
  ScrollPhysics physics;
  bool snapping; //是否有回弹效果
  List<T> data;
  PageController _pageController;
  int start,pos; //start 数据开始的显示位置 pos当前位置
  T curSelect;
  bool loadmoreright=false; //加载更多
  bool _isloadmore=true;  //是否加载更多
  double oldoffset=0; //滑动位置


  P getWidget(){
    return widget as P;
  }

  BaseRefreshViewPagerState({
    Key key,
    @required this.direction=Axis.horizontal,
    @required this.reverse=false,
    @required this.physics,
    @required this.snapping=true,
    @required this.data,
    @required this.start=0
  }):assert(data != null),
     assert(start >= 0);


  @override
  void initState() {
    super.initState();
    if(physics == null){
      physics = BouncingScrollPhysics();
    }
    print("init start:$start");
    _pageController = PageController(initialPage: start);
    _pageController.addListener(() {
      if(!_isloadmore) return;
      if(_pageController.position.maxScrollExtent > 0 && _pageController.position.pixels > _pageController.position.maxScrollExtent+100){
        print("horizontal scroll:${_pageController.position.maxScrollExtent} ${_pageController.position.pixels} ${_pageController.offset}");
        if(!loadmoreright){
          setState(() {
            loadData();
            loadmoreright = true;
          });
        }
      }
    });
    //curSelect = data[start];
  }

  void setCurrentPage(int _start){
    print("setCurrentPage _start:$_start size:${data.length}");
    start = _start;
    if(_start < data.length){
      _pageController.jumpToPage(start);
    }
  }

  @override
  Widget build(BuildContext context) {
    print("ViewPager build:${data.length} loadmore:$loadmoreright");
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          height: double.infinity,
          decoration: BoxDecoration(
              color: Colors.grey[100]
          ),
          //横向滑动最右边显示加载更多效果
          child: Stack(
            children: [
              //pageview 需要嵌套在expanded中
              PageView.builder(itemBuilder: (context,index){
                return initChildren(context, data[index]);
              },onPageChanged: (index){
                if(index < data.length){
                  curSelect = data[index];
                  pageChange();
                  hideLoadMore();
                }
              },
                scrollDirection: direction,
                reverse: reverse,
                controller: _pageController,
                physics: physics,
                pageSnapping: snapping,
                itemCount: data.length,
              )
              //加载更多
              /*Offstage(
                offstage: !loadmore,
                child: Positioned(
                  right: 0,
                  top: SizeUtil.getAppHeight(100),
                  child: Container(
                    color: Colors.grey[100],
                    width: SizeUtil.getAppWidth(100),
                    alignment: Alignment.center,
                    child: Container(
                      width: SizeUtil.getAppWidth(50),
                      child: Text("加载更多",textDirection: TextDirection.ltr,textAlign: TextAlign.center,style: TextStyle(fontSize: SizeUtil.getAppFontSize(30)),),
                    ),
                  ),
                ),
              )*/
            ],
          ),
        )
      ),
    );
  }


  Widget initTitleBar(T data);

  Widget initChildren(BuildContext context,T data);

  void pageChange();

  void loadData();

  /**
   * 隐藏loadmore
   */
  void hideLoadMore(){
    Future.delayed(new Duration(seconds: 1),(){
      if(mounted){
        setState(() {
          loadmoreright = false;
        });
      }
    });
  }

  void setIsLoadMore(bool isloadmore){
    _isloadmore = isloadmore;
  }

}