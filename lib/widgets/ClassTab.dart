import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yhschool/BaseState.dart';
import 'package:yhschool/bean/teacher_classes_bean.dart';
import 'package:yhschool/utils/DataUtils.dart';
import 'package:yhschool/utils/HttpUtils.dart';
import 'package:yhschool/utils/SizeUtil.dart';

class ClassTab extends StatefulWidget{

  Function clickTab;
  ClassTab({Key key,@required this.clickTab}):super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ClassTabState();
  }
}

class ClassTabState extends BaseState<ClassTab>{

  int selectClassId;
  String classname;
  List<Data> classList=[];

  @override
  void initState() {
    super.initState();
    print("ClassTab initState");
  }

  /**
   * 更新班级列表
   */
  void updateClassList(List<Data> list){
    print("ClassTab updateClassList:${list.length}");
    if(list.length > 0){
      setState(() {
        classList = list;
        selectClassId = list[0].id;
        classname = list[0].name;
      });
    }
  }

  String updateSelectClass(int cid){
    String classname="";
    for(var i=0; i<classList.length; i++){
      if(classList[i].id == cid){
        setState(() {
          selectClassId = cid;
          classname = classList[i].name;
        });
        classname = classList[i].name;
        break;
      }
    }
    return classname;
  }

  Widget _classItem(Data _data){
    return InkWell(
      onTap: (){
        if(selectClassId != _data.id){
          setState(() {
            selectClassId = _data.id;
            classname = _data.name;
            widget.clickTab({"id":_data.id,"name":_data.name});
          });
        }
      },
      child: Container(
        decoration: BoxDecoration(
            color: selectClassId == _data.id ? Colors.red : Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(ScreenUtil().setWidth(SizeUtil.getWidth(20)),),
              topRight: Radius.circular(ScreenUtil().setWidth(SizeUtil.getWidth(10)),),
              bottomLeft: Radius.circular(ScreenUtil().setWidth(SizeUtil.getWidth(10)),),
              bottomRight: Radius.circular(ScreenUtil().setWidth(SizeUtil.getWidth(20)),),
            ),
            border: Border.all(width: 1.0,color: selectClassId == _data.id ? Colors.red : Colors.grey[200],)
        ),
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(
            horizontal: ScreenUtil().setWidth(SizeUtil.getWidth(30)),
            vertical: ScreenUtil().setHeight(SizeUtil.getHeight(10))
        ),
        margin: EdgeInsets.symmetric(
            horizontal: ScreenUtil().setWidth(SizeUtil.getWidth(10))
        ),
        child: Text(_data.name,style: TextStyle(color: selectClassId == _data.id ? Colors.white : Colors.black87,fontSize: ScreenUtil().setSp(SizeUtil.getFontSize(30))),),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: this.classList.length,
        itemBuilder: (context,index){
          return _classItem(classList[index]);
        },
      ),
    );
  }

}