import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:yhschool/BaseDialogState.dart';
import 'package:yhschool/BaseState.dart';
import 'package:yhschool/bean/gallery_plan_list_bean.dart';
import 'package:yhschool/bean/teacher_classes_bean.dart' as C;
import 'package:yhschool/teach/GalleryPlanTile.dart';
import 'package:yhschool/utils/Constant.dart';
import 'package:yhschool/utils/DBUtils.dart';
import 'package:yhschool/utils/DataUtils.dart';
import 'package:yhschool/utils/HttpUtils.dart';
import 'package:yhschool/utils/SizeUtil.dart';
import 'package:yhschool/widgets/BackButtonWidget.dart';
import 'package:yhschool/widgets/BaseTitleBar.dart';
import 'package:yhschool/widgets/ClassTab.dart';
import 'package:yhschool/widgets/RoundedButton.dart';
import 'package:yhschool/widgets/TextButton.dart' as M;
import 'package:table_calendar/table_calendar.dart';

import 'ClassImagePlanListPage.dart';
import 'TodayTeachList.dart';

class ClassImagePlanPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return ClassImagePlanPageState();
  }
}

class ClassImagePlanPageState extends BaseDialogState{

  static final GlobalKey<ClassTabState> classTabKey = GlobalKey<ClassTabState>();

  DateTime currentDateTime=DateTime.now();

  List<C.Data> classList=[];
  int selectClassId;
  String classname;
  List<Groups> groupsList = [];
  //班级对应的课程数据
  var mapClass = Map();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getClasses();
  }

  void getClasses(){
    classList.add(C.Data(id:0,name: "全部",));
    httpUtil.post(DataUtils.api_classesbyteacher,data: {}).then((value){
      C.TeacherClassesBean classesBean = new C.TeacherClassesBean.fromJson(json.decode(value));
      if(classesBean.errno == 0){
        classList.addAll(classesBean.data);
        classTabKey.currentState.updateClassList(classList);
        selectClassId = 0;
        classname = "全部";
        //获取对应的日期id
        _getGalleryListByClass();
      }else{
        showToast(classesBean.errmsg);
      }
    });

    /*httpUtil.post(DataUtils.api_schoolclass,data: {}).then((value){
      print("schoolclass:{$value}");
      ClassInfo classInfo = ClassInfo.fromJson(json.decode(value));
      if(classInfo.errno == 0){
        setState(() {
          this.classList.addAll(classInfo.data.classes);
        });
        selectClassId = classInfo.data.classes[0].id;
        classname = classInfo.data.classes[0].name;
        //获取对应的日期id
        _getGalleryListByClass();
      }else{
        showToast(classInfo.errmsg);
      }
    });*/
  }

  /**
   * 根据班级获取排课列表数据
   */
  void _getGalleryListByClass(){
    setState(() {
      groupsList.clear();
    });
    String key = "galleryplan${Constant.getDateFormatByString(currentDateTime.toString())}_${selectClassId}";
    if(mapClass.containsKey(key) && mapClass[key].length > 0){
      setState(() {
        groupsList.addAll(mapClass[key]);
      });
      return;
    }
    var option={
      "date":Constant.getDateFormatByString(currentDateTime.toString()),
      "classid":selectClassId
    };
    var url;
    if(selectClassId == 0){
      url = DataUtils.api_issuelistdateallclass;
    }else{
      url = DataUtils.api_issuedateclasslist;
      option["classname"] = classname;
    }
    httpUtil.post(url,data: option,context: context).then((value){
      GalleryPlanListBean bean = GalleryPlanListBean.fromJson(json.decode(value));
      if(bean.errno == 0){
        setState(() {
          mapClass[key] = bean.data.groups;
          groupsList.addAll(bean.data.groups);
        });
      }else{
        showToast(bean.errmsg);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          height: double.infinity,
          decoration: BoxDecoration(
            color:Colors.grey[100]
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //顶部标题
                Container(
                  decoration: BoxDecoration(
                    color:Colors.white
                  ),
                  child: BackButtonWidget(cb:(){
                    Navigator.pop(context);
                  },title: "图文排课",),
                ),
                //选中的日期
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color:Colors.white
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(SizeUtil.getWidth(10))),
                      border: Border.all(color: Colors.black12,width: 1.0),
                    ),
                    margin: EdgeInsets.only(
                        left: ScreenUtil().setWidth(SizeUtil.getWidth(40)),
                        right: ScreenUtil().setWidth(SizeUtil.getWidth(40))
                    ),
                    padding: EdgeInsets.symmetric(
                        vertical: ScreenUtil().setHeight(SizeUtil.getHeight(20)),
                        horizontal: ScreenUtil().setWidth(SizeUtil.getWidth(20))
                    ),
                    child: Text("${Constant.getDateFormatByString(currentDateTime.toString())}"),
                  ),
                ),
                //图文排课日历
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white
                  ),
                  child: TableCalendar(focusedDay: currentDateTime, firstDay: DateTime.utc(2020,1,1), lastDay: DateTime.utc(2050,1,1),
                    availableGestures: AvailableGestures.horizontalSwipe,
                    rangeSelectionMode: RangeSelectionMode.toggledOn,
                    rangeStartDay: currentDateTime,
                    rangeEndDay: currentDateTime,
                    headerVisible: true,
                    //隐藏标记
                    availableCalendarFormats:const {
                      CalendarFormat.month: '',
                    },
                    calendarStyle: CalendarStyle(
                      selectedTextStyle: const TextStyle(
                          color: Colors.red,
                          fontSize: 16
                      ),
                      holidayTextStyle: TextStyle(color:Colors.orangeAccent),
                      todayTextStyle: TextStyle(color: Colors.white),
                      todayDecoration: BoxDecoration(
                          color: Colors.purple,
                          shape: BoxShape.circle
                      ),
                      rangeStartTextStyle: TextStyle(color: Colors.white),
                      rangeEndTextStyle: TextStyle(color: Colors.white),
                    ),
                    onDaySelected: (selectedDay,focusedDay){
                      if(currentDateTime != focusedDay){
                        setState(() {
                          currentDateTime = DateTime(focusedDay.year,focusedDay.month,focusedDay.day);
                          print(currentDateTime);
                          print(focusedDay);
                          this._getGalleryListByClass();
                        });
                      }
                    },
                    onFormatChanged: (format){
                      print("format:"+format.toString());
                    },
                  ),
                ),
                InkWell(
                  onTap: (){
                    showGalleryPlanDialog(context, Constant.getDateFormatByString(currentDateTime.toString()),classList.sublist(1),(value){
                      if(value){
                        //上传成功重新更新所有的班级数据
                        setState(() {
                          selectClassId = 0;
                          classname = "全部";
                          //清理掉本地的数据
                          String key = "galleryplan${Constant.getDateFormatByString(currentDateTime.toString())}_${selectClassId}";
                          if(mapClass.containsKey(key)){
                            mapClass.remove(key);
                          }
                          _getGalleryListByClass();
                        });
                      }
                    });
                  },
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color:Colors.white
                    ),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(ScreenUtil().setWidth(SizeUtil.getWidth(10))),
                          color: Colors.red
                      ),
                      padding: EdgeInsets.only(
                          left: ScreenUtil().setWidth(SizeUtil.getWidth(40)),
                          top: ScreenUtil().setHeight(SizeUtil.getHeight(20)),
                          bottom: ScreenUtil().setHeight(SizeUtil.getWidth(20))
                      ),
                      margin: EdgeInsets.symmetric(
                          horizontal: ScreenUtil().setWidth(SizeUtil.getWidth(30)),
                          vertical: ScreenUtil().setHeight(SizeUtil.getHeight(20))
                      ),
                      child: Text("+ 上传图片",style: TextStyle(fontSize: ScreenUtil().setSp(SizeUtil.getFontSize(36)),color: Colors.white,fontWeight: FontWeight.bold),),
                    ),
                  ),
                ),
                //班级列表
                Container(
                  height: ScreenUtil().setHeight(SizeUtil.getHeight(125)),
                  alignment:Alignment(-1,0),
                  padding: EdgeInsets.only(
                    top: ScreenUtil().setWidth(SizeUtil.getHeight(25)),
                    bottom: ScreenUtil().setHeight(SizeUtil.getHeight(20)),
                    left: ScreenUtil().setWidth(SizeUtil.getWidth(20)),
                    right: ScreenUtil().setWidth(SizeUtil.getWidth(20)),
                  ),
                  decoration: BoxDecoration(
                      color: Colors.white
                  ),
                  child:ClassTab(key:classTabKey,clickTab: (dynamic value){
                    if(selectClassId != value["id"]){
                      setState(() {
                        selectClassId = value["id"];
                        classname = value["name"];
                        this._getGalleryListByClass();
                      });
                    }
                  }),
                ),
                //班级对应的图片
                StaggeredGridView.countBuilder(
                  crossAxisCount: Constant.isPad ? 3 : 2,
                  itemCount: groupsList.length,
                  primary: false,
                  shrinkWrap: true,
                  mainAxisSpacing: ScreenUtil().setWidth(Constant.DIS_LIST),
                  crossAxisSpacing: ScreenUtil().setWidth(Constant.DIS_LIST),
                  addAutomaticKeepAlives: false,
                  padding: EdgeInsets.only(top:ScreenUtil().setHeight(SizeUtil.getHeight(10)),left: ScreenUtil().setWidth(SizeUtil.getWidth(Constant.DIS_LIST)),right: ScreenUtil().setWidth(SizeUtil.getWidth(Constant.DIS_LIST))),
                  staggeredTileBuilder: (int index) =>
                      StaggeredTile.fit(1),
                  itemBuilder: (context,index){
                    return InkWell(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) =>
                            ClassImagePlanListPage(teacherName: groupsList[index].name,tid: groupsList[index].tid,dateId: groupsList[index].dateId,date: Constant.getDateFormatByString( groupsList[index].date),classid: selectClassId,)
                        ));
                      },
                      child: GalleryPlanTile(groups: groupsList[index],classname: groupsList[index].classname,),
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}