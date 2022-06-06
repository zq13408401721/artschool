import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yhschool/BaseState.dart';
import 'package:yhschool/utils/SizeUtil.dart';

class RefreshListView extends StatefulWidget{

  Axis direction;
  int count;
  Widget Function(BuildContext context,int index) itemBuilder;

  RefreshListView({
    @required this.direction=Axis.vertical,
    @required this.count,
    @required this.itemBuilder
  }){
    assert((){
      if(count < 0){
        throw AssertionError("ListView count is not < 0!");
      }
      return true;
    }());
    assert((){
      if(itemBuilder == null){
        throw AssertionError("itemBuilder is not null");
      }
      return true;
    }());
  }

  @override
  State<StatefulWidget> createState() {
    return RefreshListViewState()
        ..direction = direction
        ..count = count
        ..itemBuilder = itemBuilder;
  }

}

class RefreshListViewState extends BaseState{

  ScrollController _controller;
  bool isloading=false;
  Axis direction;
  int count;
  Widget Function(BuildContext context,int index) itemBuilder;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController()
      ..addListener(() {
        if(_controller.position.pixels > _controller.position.maxScrollExtent - 100){
          if(!isloading){
            _showLoading();
            Future.delayed(Duration(seconds: 2),(){

            });
          }
        }
      });
  }

  void _showLoading(){
    setState(() {
      isloading = true;
    });
  }

  void _hideLoading(){
    setState(() {
      isloading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            scrollDirection: direction,
            itemCount: count,
            controller: _controller,
            addAutomaticKeepAlives: false,
            itemBuilder: itemBuilder,
          ),
        ),
        Offstage(
          offstage: !isloading,
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(ScreenUtil().setWidth(SizeUtil.getWidth(20))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: ScreenUtil().setWidth(40),
                    height: ScreenUtil().setWidth(40),
                    child: CircularProgressIndicator(color: Colors.red,),
                  ),
                  Text('加载中...', style: TextStyle(fontSize: 16.0),)
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}