import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yhschool/BaseState.dart';
import 'package:yhschool/bean/ApiDB.dart';
import 'package:yhschool/bean/class_info.dart';
import 'package:yhschool/bean/class_room_add_bean.dart';
import 'package:yhschool/bean/class_room_date_bean.dart';
import 'package:yhschool/bean/class_room_datelist_bean.dart';
import 'package:yhschool/bean/class_room_del_bean.dart';
import 'package:yhschool/bean/entity_tab_bean.dart';
import 'package:yhschool/bean/teacher_classes_bean.dart' as C;
import 'package:yhschool/bean/teacher_classes_bean.dart';
import 'package:yhschool/bean/video_category.dart' as M;
import 'package:yhschool/bean/video_tab.dart' as V;
import 'package:yhschool/utils/Constant.dart';
import 'package:yhschool/utils/DBUtils.dart';
import 'package:yhschool/utils/DataUtils.dart';
import 'package:yhschool/utils/HttpUtils.dart';
import 'package:yhschool/utils/SizeUtil.dart';
import 'package:yhschool/widgets/BackButtonWidget.dart';
import 'package:yhschool/widgets/BaseTitleBar.dart';
import 'package:yhschool/widgets/ClassTab.dart';
import 'package:table_calendar/table_calendar.dart';

import 'ClassVideoSelectTile.dart';
import 'ClassVideoTile.dart';

/**
 * 双师课堂排课计划
 */
class ClassPlanPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return ClassPlanPageState();
  }
}

class ClassPlanPageState extends BaseState<ClassPlanPage>{

  static final GlobalKey<ClassTabState> classTabKey = GlobalKey<ClassTabState>();

  DateTime currentDateTime = DateTime.now();

  List<C.Data> classList=[];
  int selectClassId;
  String classname;
  int page=1,size=50;

  int dateid; //当前的日期id
  List<Videos> videosList=[];

  List<String> tabsWord = [];
  List<TabBeanData> tabList = [];
  List<V.Data> videoTabList = [];
  int selectTabId=0,selectCategoryId=0;
  int videoCategoryid=0; //视频对应的小节id
  String section; //科目名
  String categoryname; //章节名
  List<M.Data> videoCategoryList=[];
  String uid;

  var dateMap = Map(); //日期的map

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUid().then((value) => {
      setState(() {
        uid = value;
      })
    });
    getClasses();
    //获取官方视频分类数据 先从本地数据库中查看
    DBUtils.dbUtils.then((value) async{
      var result = await value.queryApiData(DataUtils.api_tab);
      if(result.length > 0){
        _getVideoTabsReturn(result);
      }else{
        getVideoTabs();
      }
    });
  }

  void getClasses(){
    httpUtil.post(DataUtils.api_classesbyteacher,data: {}).then((value){
      print("schoolclass:{$value}");
      C.TeacherClassesBean classInfo = C.TeacherClassesBean.fromJson(json.decode(value));
      if(classInfo.errno == 0){
        if(mounted){
          setState(() {
            this.classList.addAll(classInfo.data);
            classTabKey.currentState.updateClassList(this.classList);
          });
          selectClassId = classInfo.data[0].id;
          classname = classInfo.data[0].name;
          //获取对应的日期id
          getDoubleClassDate();
          //getClassDateList();
        }else{
          showToast("ClassPlanPage dispose");
        }
      }else{
        showToast(classInfo.errmsg);
      }
    });
  }

  /**
   * 获取班级对应的课堂日期id
   */
  void getDoubleClassDate(){
    if(selectClassId == 0) return;
    String _date = Constant.getDateFormatByString(currentDateTime.toString());
    String key = "${_date}-${selectClassId}";
    if(dateMap.containsKey(key)){
      dateid = dateMap[key];
      getClassDateList();
      return;
    }
    var option = {
      "classid":selectClassId,
      "date":Constant.getDateFormatByString(currentDateTime.toString())
    };
    print("获取班级：$option");
    httpUtil.post(DataUtils.api_doubleclassdate,data:option).then((value){
      print("班级数据：$value");
      ClassRoomDateBean bean = ClassRoomDateBean.fromJson(json.decode(value));
      if(bean.errno == 0){
        videosList.clear();
        dateid = bean.data.dateid;
        dateMap[key] = dateid;
        setState(() {
          getClassDateList();
        });
      }else{
        showToast(bean.errmsg);
      }
    });
  }

  /**
   * 获取班级对应的日期数据
   */
  void getClassDateList(){
    var option = {
      "classid":selectClassId,
      "page":page,
      "size":size,
      "date":Constant.getDateFormatByString(currentDateTime.toString())
    };
    print("class option:${option}");
    httpUtil.post(DataUtils.api_classroomdatelist,data:option).then((value){
      print("class videolist:${value}");
      Class_room_datelist_bean _dateList = Class_room_datelist_bean.fromJson(json.decode(value));
      if(_dateList.errno == 0){
        videosList.clear();
        setState(() {
          videosList.addAll(_dateList.data.date[0].videos);
        });
      }else{
        showToast(_dateList.errmsg);
      }
    }).catchError((err){
      showToast(err.toString());
    });
  }
  
  void getVideoTabs(){
    var option = {
      "type":3 // 1官方  2学校  3 官方不包含ai推荐
    };
    print(option);
    httpUtil.get(DataUtils.api_tab,data: option).then((value) {
      DBUtils.dbUtils.then((db) => db.insertApi(ApiDB(api: DataUtils.api_tab,result:value)));
      _getVideoTabsReturn(value);
    }).catchError((err){
      showToast(err.toString());
    });
  }

  /**
   * 处理视频Tab返回
   */
  void _getVideoTabsReturn(String result){
    TabBean tabBean = new TabBean.fromJson(json.decode(result));
    if(tabBean.errno == 0){
      setState(() {
        for(TabBeanData item in tabBean.data){
          tabsWord.add(item.name);
          tabList.add(item);
        }
        videoCategoryList.clear();
        selectTabId = tabList[0].id;
        section = tabList[0].name;
      });
      getCategoryByTab(selectTabId);
    }else{
      showToast(tabBean.errmsg);
    }
  }

  /**
   * 获取视频章节数据
   */
  void getCategoryByTab(int categoryid){
    //本地存储视频分类数据key
    var key = "${DataUtils.api_video_tab_category}_${categoryid}";
    DBUtils.dbUtils.then((db) async{
      var result = await db.queryApiData(key);
      if(result.length > 0){
        _getCategoryByTabReturn(result);
      }else{
        var data = {
          "page":1,
          "size":100,
          "categoryid":categoryid,
          "type":3
        };
        //获取对应的章节数据
        httpUtil.post(DataUtils.api_video_tab_category,data: data).then((result){
          db.insertApi(ApiDB(api:key,result:result));
          _getCategoryByTabReturn(result);
        }).catchError((err) => {
          print(err)
        });
      }
    });
  }

  /**
   * tab对应的视频分类数据获取返回
   */
  void _getCategoryByTabReturn(String result){
    var videoTab = new V.VideoTab.fromJson(json.decode(result));
    videoTabList.clear();
    setState(() {
      videoTabList.addAll(videoTab.data);
      selectCategoryId = videoTabList[0].categoryid;
      categoryname = videoTabList[0].categoryname;
      videoCategoryList.clear();
      getVideoCategoryList(selectCategoryId);
    });
  }

  /**
   * 章节对应的视频列表
   */
  void getVideoCategoryList(categoryid){
    var key = "${DataUtils.api_video_category_more}_${categoryid}";
    print("key:${key}");
    DBUtils.dbUtils.then((db) async{
      var result = await db.queryApiData(key);
      if(result.length > 0){
        _getVideoCategoryListReturn(result);
      }else{
        var option = {
          "categoryid":categoryid,
          "page":this.page,
          "size":this.size
        };
        httpUtil.post(DataUtils.api_video_category_more,data: option).then((value) {
          db.insertApi(ApiDB(api: key,result: value));
          _getVideoCategoryListReturn(value);
        }).catchError((err)=>{
          print(err)
        });
      }
    });
  }

  /**
   * 获取分类视频列表返回
   */
  void _getVideoCategoryListReturn(String result){
    M.VideoCategory videoCategory = new M.VideoCategory.fromJson(json.decode(result));
    if(videoCategory.errno == 0){
      setState(() {
        videoCategoryList.addAll(videoCategory.data);
        checkVideoListSelect();
      });
    }else{
      showToast(videoCategory.errmsg);
    }
  }

  /**
   * 添加班级视频课程
   */
  void addClassVideo(name,cover,){
    var option = {
      "dateid":dateid,
      "categoryid":videoCategoryid,
      "title":section+"/"+categoryname
    };
    print("添加视频课程：${option} 班级：${classname}");
    httpUtil.post(DataUtils.api_classroomaddvideo,data: option).then((value){
      ClassRoomAddBean addBean = ClassRoomAddBean.fromJson(json.decode(value));
      if(addBean.errno == 0){
        //本地操作把数据保存到已经添加列表
        Videos _video = Videos(id: addBean.data.id,dateid: addBean.data.dateid,categoryid: addBean.data.categoryid,title: addBean.data.title,
            tid: addBean.data.tid,mark: addBean.data.mark,createtime: addBean.data.createtime,teachername: m_username,name: name,cover: cover);
        setState(() {
          videosList.insert(0, _video);
        });
      }else{
        showToast(addBean.errmsg);
      }
    }).catchError((err){
      showToast(err.toString());
    });
  }

  /**
   * 删除课程
   */
  void deleteClassVideo(id,_categoryid,mark){
    var option = {
      "dateid":dateid,
      "vid":_categoryid,
      "id":id,
      "mark":mark
    };
    httpUtil.post(DataUtils.api_delvideoclass,data: option).then((value){
      ClassRoomDelBean delBean = ClassRoomDelBean.fromJson(json.decode(value));
      if(delBean.errno == 0){
        setState(() {
          //删除已经选择的课程
          delClassInDate(delBean.data.id);
          //修改备选数据状态
          videoListSelectState(delBean.data.categoryid);
        });

      }else{
        showToast(delBean.errmsg);
      }
    }).catchError((err){
      showToast(err.toString());
    });
  }

  /**
   * 删除选择课件列表数据
   */
  void delClassInDate(id){
    for(Videos item in videosList){
      if(item.id == id){
        videosList.remove(item);
        break;
      }
    }
  }

  /**
   * 修改备选课程数据的选中状态
   */
  void videoListSelectState(id){
    for(M.Data item in videoCategoryList){
      if(item.id == id){
        item.select = false;
        break;
      }
    }
  }

  /**
   * 检查当前获取到的视频数据是否已经在选中课件的列表中
   */
  void checkVideoListSelect(){
    for(M.Data item in videoCategoryList){
      bool _bool = videosList.any((element) => element.categoryid == item.id);
      item.select = _bool;
    }
  }

  @override
  void dispose() {
    super.dispose();
    print("ClassPlanPage dispose");
  }

  @override
  Widget build(BuildContext context) {
    //print("排课videosList:${videosList.toList()}");
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
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
                  child: BackButtonWidget(cb: (){
                    Navigator.pop(context);
                  }, title: "视频课堂排课"),
                ),
                //选中的日期
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color:Colors.white
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
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
                //排课日历
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white
                  ),
                  child: TableCalendar(focusedDay: currentDateTime, firstDay: DateTime.utc(2020,1,1), lastDay: DateTime.utc(2050,1,1),
                    availableGestures: AvailableGestures.horizontalSwipe,
                    rangeSelectionMode: RangeSelectionMode.toggledOn,
                    rangeStartDay: currentDateTime,
                    rangeEndDay: currentDateTime,
                    //隐藏标记
                    availableCalendarFormats:const {
                      CalendarFormat.month: '',
                    },
                    headerVisible: true,
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
                          videosList.clear();
                          getDoubleClassDate();
                          if(tabList.length > 0){
                            selectTabId = tabList[0].id;
                            section = tabList[0].name;
                            getCategoryByTab(tabList[0].id);
                          }
                        });
                      }
                    },
                    onFormatChanged: (format){
                      print("format:"+format.toString());
                    },
                  ),
                ),
                //班级列表
                Container(
                  height: ScreenUtil().setHeight(SizeUtil.getHeight(125)),
                  alignment:Alignment(-1,0),
                  padding: EdgeInsets.only(
                    top: ScreenUtil().setHeight(SizeUtil.getHeight(25)),
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
                        getDoubleClassDate();
                        if(tabList.length > 0){
                          selectTabId = tabList[0].id;
                          section = tabList[0].name;
                          getCategoryByTab(tabList[0].id);
                        }
                      });
                    }
                  }),
                ),
                //班级对应的课程列表
                GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: videosList.length,
                    padding: EdgeInsets.only(top: ScreenUtil().setHeight(SizeUtil.getHeight(20)),left: ScreenUtil().setWidth(SizeUtil.getWidth(20)),right: ScreenUtil().setWidth(SizeUtil.getWidth(20))),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisSpacing: ScreenUtil().setWidth(Constant.PADDING_GALLERY_CROSS),
                        crossAxisSpacing: Constant.GARRERY_GRID_CROSSAXISSPACING,
                        childAspectRatio: Constant.isPad ? 0.8 : 0.68
                    ),
                    itemBuilder: (BuildContext context,int index){
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(ScreenUtil().setWidth(SizeUtil.getWidth(20))),
                            bottomRight: Radius.circular(ScreenUtil().setWidth(SizeUtil.getWidth(20))),
                          )
                        ),
                        child: ClassVideoTile(videos: videosList[index],isEditor: true,uid: uid,callback: (_id,_categoryid,mark){
                          //删除选择的课件
                          if(videosList.length > 1){
                            deleteClassVideo(_id,_categoryid,mark);
                          }else{
                            showToast("班级至少要存在一个课程");
                          }
                        },),
                      );
                    }
                ),
                SizedBox(height: ScreenUtil().setHeight(SizeUtil.getHeight(80)),),
                Padding(padding: EdgeInsets.only(left: ScreenUtil().setWidth(SizeUtil.getWidth(30))),
                  child: Text("添加课程",style: TextStyle(fontSize: ScreenUtil().setSp(SizeUtil.getFontSize(30)),fontWeight: FontWeight.bold)),
                ),
                //视频Tab
                Container(
                  height: ScreenUtil().setHeight(SizeUtil.getHeight(80)),
                  margin: EdgeInsets.only(top: ScreenUtil().setHeight(SizeUtil.getHeight(40))),
                  child: ListView.builder(itemCount:tabList.length,shrinkWrap:true,scrollDirection: Axis.horizontal,addAutomaticKeepAlives: false,itemBuilder: (context,index){
                    return InkWell(
                      onTap: (){
                        if(selectTabId != tabList[index].id){
                          setState(() {
                            selectTabId = tabList[index].id;
                            section = tabList[index].name;
                          });
                          getCategoryByTab(tabList[index].id);
                        }
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: ScreenUtil().setWidth(SizeUtil.getWidth(20))
                        ),
                        alignment: Alignment(0,0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(ScreenUtil().setWidth(SizeUtil.getWidth(30))),
                              bottomRight: Radius.circular(ScreenUtil().setWidth(SizeUtil.getWidth(30))),
                              topRight: Radius.circular(ScreenUtil().setWidth(SizeUtil.getWidth(8))),
                              bottomLeft: Radius.circular(ScreenUtil().setWidth(SizeUtil.getWidth(8))),
                            ),
                            color: selectTabId == tabList[index].id ? Colors.red : Colors.white
                        ),
                        padding: EdgeInsets.symmetric(
                            horizontal: ScreenUtil().setWidth(SizeUtil.getWidth(40)),
                            vertical: ScreenUtil().setHeight(SizeUtil.getHeight(10))
                        ),
                        child: Text(tabList[index].name,style: TextStyle(fontSize: ScreenUtil().setSp(SizeUtil.getFontSize(30)),
                            color: selectTabId == tabList[index].id ? Colors.white : Colors.black
                        ),),
                      ),
                    );
                  }),
                ),
                //视频章节
                Container(
                  height: ScreenUtil().setHeight(SizeUtil.getHeight(80)),
                  margin: EdgeInsets.only(top: ScreenUtil().setHeight(SizeUtil.getHeight(40)),left: ScreenUtil().setWidth(SizeUtil.getWidth(20)),right: ScreenUtil().setWidth(SizeUtil.getWidth(20))),
                  child: ListView.builder(itemCount:videoTabList.length,shrinkWrap:true,scrollDirection: Axis.horizontal,addAutomaticKeepAlives: false,itemBuilder: (context,index){
                    return InkWell(
                      onTap: (){
                        print("click:${videoTabList[index].categoryname}");
                        if(selectCategoryId != videoTabList[index].categoryid){
                          setState(() {
                            selectCategoryId = videoTabList[index].categoryid;
                            categoryname = videoTabList[index].categoryname;
                            videoCategoryList.clear();
                            getVideoCategoryList(videoTabList[index].categoryid);
                          });
                        }
                      },
                      child: Container(
                        margin: EdgeInsets.only(
                            right: ScreenUtil().setWidth(SizeUtil.getWidth(40))
                        ),
                        alignment: Alignment(0,0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(ScreenUtil().setWidth(SizeUtil.getWidth(10))),
                            color: selectCategoryId == videoTabList[index].categoryid ? Colors.red : Colors.white
                        ),
                        padding: EdgeInsets.symmetric(
                            horizontal: ScreenUtil().setWidth(SizeUtil.getWidth(40)),
                            vertical: ScreenUtil().setHeight(SizeUtil.getHeight(10))
                        ),
                        child: Text(videoTabList[index].categoryname,style: TextStyle(fontSize: ScreenUtil().setSp(SizeUtil.getFontSize(25)),
                            color: selectCategoryId == videoTabList[index].categoryid ? Colors.white : Colors.black
                        ),),
                      ),
                    );
                  }),
                ),
                //视频对应的小节列表数据
                GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: videoCategoryList.length,
                    padding: EdgeInsets.only(top: ScreenUtil().setHeight(SizeUtil.getHeight(20)),left:ScreenUtil().setWidth(SizeUtil.getWidth(20)),right:ScreenUtil().setWidth(SizeUtil.getWidth(20))),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisSpacing: ScreenUtil().setWidth(Constant.PADDING_GALLERY_CROSS),
                        crossAxisSpacing: Constant.GARRERY_GRID_CROSSAXISSPACING,
                        childAspectRatio: Constant.isPad ? .87 : 0.78
                    ),
                    itemBuilder: (context,index){
                      return ClassVideoSelectTile(categoryData: videoCategoryList[index],callback: (id){
                        videoCategoryid = id;
                        addClassVideo(videoCategoryList[index].name,videoCategoryList[index].cover);
                      },);
                    }),
                SizedBox(height: ScreenUtil().setHeight(SizeUtil.getHeight(40)),)
              ],
            ),
          ),
        ),
      ),
    );
  }
}