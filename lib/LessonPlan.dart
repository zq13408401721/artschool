
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yhschool/BaseState.dart';
import 'package:yhschool/SharedExam.dart';
import 'package:yhschool/SharedImage.dart';
import 'package:yhschool/SharedStep.dart';
import 'package:yhschool/SharedTeacherEditor.dart';
import 'package:yhschool/bean/shared_select_teachers_bean.dart';
import 'package:yhschool/utils/Constant.dart';
import 'package:yhschool/utils/DataUtils.dart';
import 'package:yhschool/utils/HttpUtils.dart';

import 'PanFolders.dart';

/**
 * 教案
 */
class LessonPlan extends StatefulWidget{

  LessonPlan({Key key}):super(key: key);

  @override
  State<StatefulWidget> createState() {
    return LessonPlanState();
  }

}

class LessonPlanState extends BaseState<LessonPlan> with SingleTickerProviderStateMixin{

  final GlobalKey<SharedImageState> sharedImageState = GlobalKey<SharedImageState>();
  GlobalKey<SharedStepState> sharedStepState = GlobalKey<SharedStepState>();
  GlobalKey<SharedExamState> sharedExamState = GlobalKey<SharedExamState>();

  List<Teachers> teachers=[];

  TabController tabController;


  int selectIndex = 0;

  int pageIndex = 0;
  List<Widget> pages;

  String selectTeacherUid;

  @override
  void initState() {
    super.initState();

    pages = [
      SharedImage(key: sharedImageState,),
      SharedStep(key: sharedStepState,),
      SharedExam(key: sharedExamState,)
    ];

    getSharedTeacher();
    tabController = TabController(length: 3, vsync: this);
    tabController.addListener(() {
      switch(tabController.index){
        case 0:
          setState(() {
            pageIndex = 0;
          });
          getTeacherPanList(this.selectTeacherUid);
          break;
        case 1:
          setState(() {
            pageIndex = 1;
          });
          getTeacherPanList(this.selectTeacherUid);
          break;
        case 2:
          setState(() {
            pageIndex = 2;
          });
          getTeacherPanList(this.selectTeacherUid);
          break;
      }
    });
  }

  /**
   * 更新选中老师的tab导航数据
   */
  updateTabs(){
    getSharedTeacher();
  }

  /**
   * 获取分享选择的老师
   */
  getSharedTeacher(){
    httpUtil.post(DataUtils.api_getsharedteacher,data: {}).then((value){
      SharedSelectTeachersBean teachersBean = SharedSelectTeachersBean.fromJson(json.decode(value));
      if(teachersBean.errno == 0){
        teachers.clear();
        setState(() {
          teachers.addAll(teachersBean.data.teachers);
          if(teachers.length > 0){
            getTeacherPanList(teachers[0].tid);
          }
        });
      }else{
        showToast(teachersBean.errmsg);
      }
    }).catchError((err)=>{
      print("err:$err")
    });
  }


  getTeacherPanList(String uid){
    selectTeacherUid = uid;
    if(pageIndex == 0){
      sharedImageState.currentState.showTeacherPanByUid(uid);
    }else if(pageIndex == 1){
      sharedStepState.currentState.showTeacherPanByUid(uid);
    }else if(pageIndex == 2){
      sharedExamState.currentState.showTeacherPanByUid(uid);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Container(
                  height: ScreenUtil().setHeight(120),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white
                          ),
                          child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: teachers.length,
                              shrinkWrap: true,
                              padding:EdgeInsets.only(left: ScreenUtil().setWidth(20)),
                              separatorBuilder: (BuildContext context,int index) =>
                                  VerticalDivider(width: ScreenUtil().setWidth(20),color: Colors.white,),
                              itemBuilder:(BuildContext context,int index){
                                return InkWell(
                                  onTap: (){
                                    setState(() {
                                      selectIndex = index;
                                      getTeacherPanList(teachers[index].tid);
                                    });
                                  },
                                  child: Align(
                                    alignment: Alignment(-1,0),
                                    child: Container(
                                      margin: EdgeInsets.only(left: 2,right: 2),
                                      padding: EdgeInsets.only(left: 15,right: 15,top: 10,bottom: 10),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[200]
                                      ),
                                      child: Text(teachers[index].teachername,style: TextStyle(
                                          fontSize: ScreenUtil().setSp(60),
                                          color: selectIndex == index ? Colors.red : Colors.black
                                      ),),
                                    ),
                                  ),
                                );
                              }
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) =>
                              SharedTeacherEditor(selectTeachers: teachers,)
                          )).then((value){
                            if(value != null){
                              setState((){
                                teachers = value;
                              });
                            }
                          });
                        },
                        child: Container(
                          width: 40,
                          child: Image.asset("image/ic_shared_more.png",width: 20,height: 20,),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  height: ScreenUtil().setHeight(100),
                  child: TabBar(
                    controller: tabController,
                    tabs: <Tab>[
                      Tab(
                        child: Text(
                          "图片",
                          style: TextStyle(
                              color: Constant.COLOR_TITLE,
                              fontSize: ScreenUtil().setSp(60),
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                      Tab(
                        child: Text(
                          "步骤",
                          style: TextStyle(
                              color: Constant.COLOR_TITLE,
                              fontSize: ScreenUtil().setSp(60),
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                      Tab(
                        child: Text(
                          "个人作品",
                          style: TextStyle(
                              color: Constant.COLOR_TITLE,
                              fontSize: ScreenUtil().setSp(60),
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: IndexedStack(
                    index: pageIndex,
                    children: pages,
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}