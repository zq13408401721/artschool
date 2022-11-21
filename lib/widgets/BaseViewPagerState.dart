import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yhschool/BaseDialogState.dart';
import 'package:yhschool/BaseState.dart';

/**
 * 抽取viewpager state基类，实现item的复用
 * 显示页面最大3个 数据可以无限多，然后复用3个显示对象实现数据的展示
 */
abstract class BaseViewPagerState<T,P extends StatefulWidget> extends BaseDialogState{

  Axis direction;
  bool reverse;
  ScrollPhysics physics; //滚动方式 BouncingScrollPhysics阻尼效果 ClampingScrollPhysics水波效果
  bool snapping; //是否有回弹效果
  List<T> data;
  PageController _pageController;
  int start,pos,oldpos; // start 数据的开始显示位置，pos显示页面的当前位置，oldpos显示页面的上一个位置用来判断是向左还是向右滑动
  T curSelect;

  P getWidget(){
    return widget as P;
  }

  BaseViewPagerState({
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
      if(_pageController.position.maxScrollExtent > 0 && _pageController.position.pixels > _pageController.position.maxScrollExtent-100){
        print("horizontal scroll:${_pageController.position.maxScrollExtent} ${_pageController.position.pixels}");
      }
    });
    curSelect = data[start];
  }

  /**
   * 根据数据产生不同数量的子对象
   */
  List<Widget> getChildren(BuildContext context){
    List<Widget> children = [];
    if(data == null || data.length == 0) return children;
    //最大子元素的数量3
    var num = data.length <= 3 ? data.length : 3;
    while(children.length < num){
      children.add(initChildren(context,data[children.length]));
    }
    return children;
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          height: double.infinity,
          decoration: BoxDecoration(
            color:Colors.grey[100]
          ),
          child: PageView.builder(
            scrollDirection: direction,
            reverse: reverse,
            controller: _pageController,
            physics: physics,
            pageSnapping: snapping,
            itemCount: data.length,
            onPageChanged: (index){
              curSelect = data[index];
              pageChange();
            },
            itemBuilder: (context,index){
              return initChildren(context, data[index]);
            },
          ),
        ),
      )
    );
  }

  Widget initChildren(BuildContext context,T data);

  void pageChange();
}