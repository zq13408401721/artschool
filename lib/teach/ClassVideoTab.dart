import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yhschool/BaseState.dart';

class ClassVideoTab extends StatefulWidget{

  List<String> tabs;
  Function callback;

  ClassVideoTab({Key key,@required this.tabs,@required this.callback}):super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ClassVideoTabState()
    ..tabs = tabs
    ..callback = callback;
  }

}

class ClassVideoTabState extends BaseState{

  List<String> tabs;
  Function callback;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(itemCount:tabs.length,scrollDirection: Axis.horizontal,addAutomaticKeepAlives: false,itemBuilder: (context,index){
        return InkWell(
          onTap: (){
            if(callback != null){
              callback(index);
            }
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(ScreenUtil().setWidth(20)),
                bottomRight: Radius.circular(ScreenUtil().setWidth(20)),
                topRight: Radius.circular(ScreenUtil().setWidth(8)),
                bottomLeft: Radius.circular(ScreenUtil().setWidth(8)),
              ),
              color: Colors.white
            ),
            padding: EdgeInsets.symmetric(
              horizontal: ScreenUtil().setWidth(40),
              vertical: ScreenUtil().setHeight(20)
            ),
            child: Text(tabs[index],style: TextStyle(fontSize: ScreenUtil().setSp(30)),),
          ),
        );
      }),
    );
  }
}