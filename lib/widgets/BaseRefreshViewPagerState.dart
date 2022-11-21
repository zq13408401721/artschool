import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yhschool/BaseCoustRefreshState.dart';
import 'package:yhschool/BaseDialogState.dart';
import 'package:yhschool/utils/SizeUtil.dart';

abstract class BaseRefreshViewPagerState<T,P extends StatefulWidget> extends BaseCoustRefreshState<P>{

  Axis direction;
  bool reverse;
  ScrollPhysics physics;
  bool snapping; //是否有回弹效果
  List<T> data;
  PageController _pageController;
  int start,pos; //start 数据开始的显示位置 pos当前位置
  T curSelect;
  bool _loadmore; //加载更多
  bool _isloadmore=true;  //是否加载更多
  double oldoffset=0; //滑动位置


  P getWidget(){
    return widget as P;
  }

  BaseRefreshViewPagerState({
    Key key,
    this.direction=Axis.horizontal,
    this.reverse=false,
    this.physics,
    this.snapping=true,
    this.data,
    this.start=0

  }):assert(data != null),
     assert(data.length >= start && start >= 0);


  @override
  void initState() {
    super.initState();
    if(physics == null){
      physics = BouncingScrollPhysics();
    }
    _pageController = PageController(initialPage: start);
    _pageController.addListener(() {
      if(!_isloadmore) return;
      if(_pageController.position.maxScrollExtent > 0 && _pageController.position.pixels > _pageController.position.maxScrollExtent+100){
        print("horizontal scroll:${_pageController.position.maxScrollExtent} ${_pageController.position.pixels} ${_pageController.offset}");
        if(!_loadmore){
          setState(() {
            loadData();
            _loadmore = true;
          });
        }
      }
    });
    //curSelect = data[start];
  }

  @override
  Widget build(BuildContext context) {
    print("ViewPager build:${data.length}");
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          height: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey[100]
          ),
          //横向滑动最右边显示加载更多效果
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: PageView.builder(itemBuilder: (context,index){
                  return initChildren(context, data[index]);
                },onPageChanged: (index){
                  curSelect = data[index];
                  pageChange();
                  if(index < data.length){
                    hideLoadMore();
                  }
                },
                scrollDirection: direction,
                reverse: reverse,
                controller: _pageController,
                physics: physics,
                pageSnapping: snapping,
                itemCount: data.length,),
              ),
              //加载更多
              Offstage(
                offstage: !_loadmore,
                child: Container(
                  color: Colors.grey[100],
                  width: SizeUtil.getAppWidth(50),
                  alignment: Alignment.center,
                  child: Text("加载更多",textDirection: TextDirection.ltr,textAlign: TextAlign.center,style: TextStyle(fontSize: SizeUtil.getAppFontSize(30)),),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }


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
          _loadmore = false;
        });
      }
    });
  }

  void setIsLoadMore(bool isloadmore){
    _isloadmore = isloadmore;
  }

}