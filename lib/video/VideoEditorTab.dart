import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yhschool/BaseState.dart';
import 'package:yhschool/bean/entity_tab_bean.dart';

import 'VideoMorePage.dart';

class VideoEditorTab extends StatefulWidget{

  List<TabBeanData> tabsList;

  VideoEditorTab({Key key,@required this.tabsList}):super(key: key);

  @override
  State<StatefulWidget> createState() {
    return VideoEditorTabState()
    ..tabsList = tabsList;
  }

}

class VideoEditorTabState extends BaseState{

  List<TabBeanData> tabsList;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 238, 238, 238),
      appBar: MyAppBar(
        preferredSize: Size.fromHeight(80),
        childView: Container(
          padding: EdgeInsets.only(
              top: ScreenUtil().setHeight(60)
          ),
          decoration: BoxDecoration(
              color:Colors.white
          ),
          child: Row(
            children: [
              InkWell(
                onTap: (){
                  Navigator.pop(context);
                },
                child: Image.asset("image/ic_arrow_left.png",width: ScreenUtil().setWidth(60),height: ScreenUtil().setHeight(80),),
              ),
              Text("我的分类",style: TextStyle(fontSize: ScreenUtil().setSp(40),fontWeight: FontWeight.bold),),
              Expanded(
                child: InkWell(
                  onTap: (){

                  },
                  child: Container(
                    alignment: Alignment(0.9,0),
                    child: Text("编辑",style: TextStyle(fontSize: ScreenUtil().setSp(30),color: Colors.red),),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}