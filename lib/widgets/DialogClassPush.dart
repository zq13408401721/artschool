import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yhschool/bean/teacher_classes_bean.dart';
import 'package:yhschool/utils/DataUtils.dart';
import 'package:yhschool/utils/HttpUtils.dart';
import 'package:yhschool/utils/SizeUtil.dart';


import '../BaseState.dart';

/**
 * 收藏推送班级选择
 */
class DialogClassPush extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return DialogClassPushState();
  }

}

class DialogClassPushState extends BaseState{

  List<Data> classesList = [];
  bool loading = false;

  @override
  void initState() {
    super.initState();
    getTeacherClass();
  }

  //获取老师所在的所有班级
  void getTeacherClass(){
    var option = {
      "role":1
    };
    httpUtil.post(DataUtils.api_classesbyteacher,data: option).then((value){
      TeacherClassesBean classesBean = new TeacherClassesBean.fromJson(json.decode(value));
      if(classesBean.errno == 0){
        setState(() {
          classesList.addAll(classesBean.data);
          loading = true;
        });
      }else{
        setState(() {
          loading = true;
        });
      }
    });
  }

  //获取当前选择的班级id
  List<int> getSelectClassIds(){
    List<int> ids = [];
    for(Data _data in classesList){
      if(_data.select){
        ids.add(_data.id);
      }
    }
    return ids;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: Alignment(0,0),
        children: [
          Card(
            child: Container(
              width: ScreenUtil().setWidth(SizeUtil.getWidth(800)),
              height: ScreenUtil().setHeight(SizeUtil.getHeight(500)),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(SizeUtil.getWidth(10))
              ),
              child: Column(
                children: [
                  Padding(padding: EdgeInsets.only(left: ScreenUtil().setWidth(SizeUtil.getWidth(40)),right: ScreenUtil().setWidth(SizeUtil.getWidth(40)),top: ScreenUtil().setHeight(SizeUtil.getHeight(40))),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin:EdgeInsets.only(left: ScreenUtil().setWidth(SizeUtil.getWidth(20))),
                          child: Text("选择班级",style: TextStyle(fontSize: ScreenUtil().setSp(SizeUtil.getFontSize(40)),color: Colors.grey),),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: ScreenUtil().setHeight(SizeUtil.getHeight(20))),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: GridView.builder(shrinkWrap:true,itemCount:classesList.length,gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              mainAxisSpacing: ScreenUtil().setWidth(SizeUtil.getWidth(20)),
                              crossAxisSpacing: ScreenUtil().setHeight(SizeUtil.getHeight(20)),
                              crossAxisCount: 2,
                              childAspectRatio: 8/1,

                            ), itemBuilder: (context,index){
                              return Row(
                                children: [
                                  Checkbox(value: classesList[index].select, onChanged:(_bool){
                                    setState(() {
                                      classesList[index].select = _bool;
                                    });
                                  }),
                                  InkWell(
                                    onTap:(){
                                      setState(() {
                                        classesList[index].select = !classesList[index].select;
                                      });
                                    },
                                    child: Text(classesList[index].name,style: TextStyle(color: classesList[index].select?Colors.red:Colors.black87,fontSize: ScreenUtil().setSp(36)),),
                                  )
                                ],
                              );
                            }),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                  //推送按钮
                  InkWell(
                    onTap: (){
                      //发布图片上传
                      List<int> ids = this.getSelectClassIds();
                      if(ids.length == 0){
                        showToast("请先选择要发布的班级");
                      }else{
                        Navigator.pop(context,ids);
                      }
                    },
                    child: Container(
                      width: double.infinity,
                      alignment: Alignment(0,0),
                      decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(ScreenUtil().setWidth(SizeUtil.getWidth(10))),
                              bottomRight: Radius.circular(ScreenUtil().setWidth(SizeUtil.getWidth(10)))
                          )
                      ),
                      padding: EdgeInsets.symmetric(
                          vertical: ScreenUtil().setHeight(SizeUtil.getHeight(40))
                      ),
                      child: Text("推送到所选班级",style: TextStyle(color: Colors.white,fontSize: ScreenUtil().setSp(40)),),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Offstage(
            offstage: loading,
            child: Container(
              width: ScreenUtil().setWidth(SizeUtil.getWidth(40)),
              height: ScreenUtil().setWidth(SizeUtil.getWidth(40)),
              child: CircularProgressIndicator(color: Colors.red,),
            ),
          ),
        ],
      ),
    );
  }
}