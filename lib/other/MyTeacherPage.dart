import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yhschool/BaseState.dart';
import 'package:yhschool/bean/school_teacher_bean.dart';
import 'package:yhschool/utils/DataUtils.dart';
import 'package:yhschool/utils/HttpUtils.dart';
import 'package:yhschool/utils/SizeUtil.dart';
import 'package:yhschool/widgets/BackButtonWidget.dart';

class MyTeacherPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MyTeacherPageState();
  }
}

class MyTeacherPageState extends BaseState{

  List<Data> teacherList = [];

  @override
  void initState() {
    super.initState();
    _queryTeachers();
  }

  /**
   * 查询学校老师
   */
  void _queryTeachers(){
    httpUtil.post(DataUtils.api_queryteacherbyschool,data:{}).then((value) {
      SchoolTeacherBean bean = SchoolTeacherBean.fromJson(json.decode(value));
      if(bean.errno == 0){
        setState(() {
          teacherList.addAll(bean.data);
        });
      }else{
        showToast(bean.errmsg);
      }
    });
  }

  Widget _teacherItem(Data _data) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ClipOval(
          child: _data.avater != null ? CachedNetworkImage(
            imageUrl: _data.avater,
            height: ScreenUtil().setWidth(SizeUtil.getWidth(80)),
            width: ScreenUtil().setWidth(SizeUtil.getWidth(80)),
            fit: BoxFit.cover,) :
          Image.asset(
              "image/ic_head.png", height: ScreenUtil().setWidth(SizeUtil.getWidth(80)),
              width: ScreenUtil().setWidth(SizeUtil.getWidth(80)),
              fit: BoxFit.cover),
        ),
        SizedBox(width: 10,),
        Text(_data.nickname != null ? _data.nickname : _data.username,style: TextStyle(color: Colors.black87,fontSize: ScreenUtil().setSp(SizeUtil.getFontSize(30))))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          color:Colors.grey[100],
          child: Column(
            children: [
              BackButtonWidget(cb: (){
                Navigator.pop(context);
              }, title: "授课老师"),
              Expanded(child: ListView.separated(
                  itemCount: teacherList.length,
                  separatorBuilder: (BuildContext context,int index){
                    return Padding(padding: EdgeInsets.symmetric(
                      horizontal: ScreenUtil().setWidth(SizeUtil.getWidth(20)),
                    ),child: Divider(height: 1,color: Colors.grey,),);
                  },
                  itemBuilder: (context,index){
                    return Padding(padding: EdgeInsets.symmetric(
                        horizontal: ScreenUtil().setWidth(SizeUtil.getWidth(20)),
                        vertical: ScreenUtil().setHeight(SizeUtil.getHeight(10))
                    ),child: _teacherItem(teacherList[index]),);
                  }))
            ],
          ),
        ),
      ),
    );
  }
}