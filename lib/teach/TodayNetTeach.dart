
import 'dart:convert';

import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yhschool/BaseRefreshState.dart';
import 'package:yhschool/BaseState.dart';
import 'package:yhschool/bean/class_room_datelist_bean.dart' as M;
import 'package:yhschool/bean/teacher_classes_bean.dart';
import 'package:yhschool/teach/ClassImagePlanPage.dart';
import 'package:yhschool/teach/ClassPlanPage.dart';
import 'package:yhschool/teach/ClassVideoEditor.dart';
import 'package:yhschool/teach/ClassVideoTile.dart';
import 'package:yhschool/utils/Constant.dart';
import 'package:yhschool/utils/DataUtils.dart';
import 'package:yhschool/utils/HttpUtils.dart';
import 'package:yhschool/utils/SizeUtil.dart';
import 'package:yhschool/widgets/ClassTab.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../BaseCoustRefreshState.dart';
import '../TileCard.dart';
import '../VideoWeb.dart';

/**
 * 双师课堂
 */
class TodayNetTeach extends StatefulWidget{

  TodayNetTeach({Key key}):super(key: key);

  @override
  State<StatefulWidget> createState() {
    return TodayNetTeachState();
  }

}

class TodayNetTeachState extends BaseCoustRefreshState<TodayNetTeach>{

  static final GlobalKey<ClassTabState> classTabKey = GlobalKey<ClassTabState>();

  List<Data> classList=[];
  int selectClassId;
  String classname;
  int page=1,size=20;
  List<M.Date> dateList=[];
  int role;
  String today;
  M.Date todayData;
  int oldid;

  ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = initScrollController();
    getRole().then((value) => role = value);
    today = Constant.getDateFormat();
    //getSchoolClass();
  }

  @override
  void refresh(){
    if(!this.isrefreshing){
      if(selectClassId > 0){
        getDateList();
      }else{
        hideRefreshing();
      }
    }
  }

  @override
  void loadmore(){
    if(!isloading){
      getDateListMore();
    }
  }

  /**
   * 是否有今日数据
   */
  bool hasToday(){
    for(var i=0; i<dateList.length; i++){
      if(role == 1 && today == Constant.getDateFormatByString(dateList[i].date)){
        todayData = dateList[i];
        return true;
      }
    }
    return false;
  }

  /**
   * 初始化班级数据
   */
  void initClass(List<Data> _list){
    if(_list.length > 0){
      classTabKey.currentState.updateClassList(_list);
      selectClassId = _list[0].id;
      classname = _list[0].name;
      getDateList();
    }
  }

  /**
   * 视频排课
   */
  void planVideoClass(){
    Navigator.push(context, MaterialPageRoute(builder: (context)=>ClassPlanPage()));
  }

  /**
   * 图文排课
   */
  void planGalleryClass(){
    Navigator.push(context, MaterialPageRoute(builder: (context)=>ClassImagePlanPage()));
  }

  /**
   * 编辑
   */
  void editorPlanClass(){
    if(todayData == null){
      return showToast("今日暂无数据");
    }
    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context){
      return ClassVideoEditor(date: todayData, classname: classname);
    })).then((value){
      //返回编辑以后的数据
      if(value != null){
        for(var i=0; i<this.dateList.length; i++){
          if(dateList[i].dateid == value.dateid){
            setState(() {
              dateList[i].videos = value.videos;
            });
            break;
          }
        }
      }
    });
  }

  /**
   * 获取对应的班级视频数据
   */
  void getDateList(){
    setState(() {
      dateList.clear();
    });
    var option = {
      "classid":selectClassId,
      "page":1,
      "size":size
    };
    httpUtil.post(DataUtils.api_classroomdatelist,data:option).then((value){
      hideRefreshing();
      String result = checkLoginExpire(value);
      if(result.isNotEmpty){
        M.Class_room_datelist_bean _dateList = M.Class_room_datelist_bean.fromJson(json.decode(value));
        if(_dateList.errno == 0){
          if(_dateList.data.date.length > 0){
            oldid = _dateList.data.date[_dateList.data.date.length-1].dateid;
            setState(() {
              dateList.addAll(_dateList.data.date);
            });
          }
        }else{
          //showToast(_dateList.errmsg);
        }
      }
    }).catchError((err){
      showToast(err.toString());
    });
  }

  /**
   * 加载列表更多数据
   */
  void getDateListMore(){
    var option = {
      "classid":selectClassId,
      "id":oldid,
      "size":size
    };
    httpUtil.post(DataUtils.api_classroomdatelist,data:option).then((value){
      hideLoadMore();
      M.Class_room_datelist_bean _dateList = M.Class_room_datelist_bean.fromJson(json.decode(value));
      if(_dateList.errno == 0){
        if(_dateList.data.date.length > 0){
          oldid = _dateList.data.date[_dateList.data.date.length-1].dateid;
          setState(() {
            dateList.addAll(_dateList.data.date);
          });
        }
      }else{
        showToast(_dateList.errmsg);
      }
    }).catchError((err){
      showToast(err.toString());
    });
  }

  /**
   * 创建双师课堂列表条目
   */
  Widget createItem(M.Date _date){
    print("当天日期：${today} ${Constant.getDateFormatByString(_date.date)}");
    today = Constant.getDateFormat();
    return Column(
      children: [
        //日期和操作按钮
        Padding(
            padding: EdgeInsets.only(
              top: ScreenUtil().setHeight(SizeUtil.getHeight(40))
            ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(Constant.getDateFormatByString(_date.date),style: Constant.titleTextStyle,),
              SizedBox(width: ScreenUtil().setWidth(SizeUtil.getWidth(20)),),
              Expanded(
                child: Offstage(
                  offstage: (role == 1 && today == Constant.getDateFormatByString(_date.date)) ? false : true,
                  child: InkWell(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context){
                        return ClassVideoEditor(date: _date, classname: classname);
                      })).then((value){
                        //返回编辑以后的数据
                        if(value != null){
                          for(var i=0; i<this.dateList.length; i++){
                            if(dateList[i].dateid == value.dateid){
                              setState(() {
                                dateList[i].videos = value.videos;
                              });
                              break;
                            }
                          }
                        }
                      });
                    },
                    child: Text("编辑今日课程",style: TextStyle(fontSize: ScreenUtil().setSp(SizeUtil.getFontSize(30)),color: Colors.red),),
                  )
                ),
              )
            ],
          ),
        ),
        GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: _date.videos.length,
            padding: EdgeInsets.only(top: ScreenUtil().setHeight(SizeUtil.getHeight(20))),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: Constant.isPad ? 3 : 2,
                mainAxisSpacing: ScreenUtil().setWidth(Constant.PADDING_GALLERY_CROSS),
                crossAxisSpacing: Constant.GARRERY_GRID_CROSSAXISSPACING,
                childAspectRatio: Constant.isPad ? 0.8 : 0.76
            ),
            itemBuilder: (BuildContext context,int index){
              return InkWell(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(ScreenUtil().setWidth(SizeUtil.getWidth(10))),
                      bottomRight: Radius.circular(ScreenUtil().setWidth(SizeUtil.getWidth(10)))
                    )
                  ),
                  child: ClassVideoTile(videos: _date.videos[index],),
                ),
                onTap: () async {
                  print("点击对应的视频");
                  String response;
                  try {
                    Navigator.push(context, MaterialPageRoute(builder: (context) =>
                        VideoWeb(classify: "official", section:  _date.videos[index].title, category: _date.videos[index].title, categoryid: _date.videos[index].categoryid,
                        description: _date.videos[index].description,step: [],)
                    ));
                  }on PlatformException{
                    response = '失败';
                  }
                  print(response);


                },
              );
            }
        )
      ],
    );
  }

  Widget _classItem(Data _data){

    return InkWell(
      onTap: (){
        if(selectClassId != _data.id){
          setState(() {
            selectClassId = _data.id;
            classname = _data.name;
            this.dateList.clear();
          });
          getDateList();
        }
      },
      child: Container(
        decoration: BoxDecoration(
            color: selectClassId == _data.id ? Colors.red : Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(ScreenUtil().setWidth(20),),
              topRight: Radius.circular(ScreenUtil().setWidth(10),),
              bottomLeft: Radius.circular(ScreenUtil().setWidth(10),),
              bottomRight: Radius.circular(ScreenUtil().setWidth(20),),
            ),
            border: Border.all(width: 1.0,color: selectClassId == _data.id ? Colors.red : Colors.black12,)
        ),
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(
            horizontal: ScreenUtil().setWidth(SizeUtil.getWidth(40)),
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
  List<Widget> addChildren() {
    print("TodayNetTeach mounted:$mounted");
    return [
      //班级选择区
      Container(
        height: ScreenUtil().setHeight(SizeUtil.getHeight(115)),
        alignment:Alignment(-1,0),
        padding: EdgeInsets.only(
          //top: ScreenUtil().setWidth(SizeUtil.getWidth(25)),
          bottom: ScreenUtil().setHeight(SizeUtil.getHeight(30)),
          left: ScreenUtil().setWidth(SizeUtil.getWidth(20)),
          right: ScreenUtil().setWidth(SizeUtil.getWidth(20)),
        ),
        decoration: BoxDecoration(
            color: Colors.white
        ),
        child:ClassTab(key:classTabKey,clickTab: (dynamic value){
          setState(() {
            selectClassId = value["id"];
            classname = value["name"];
            this.dateList.clear();
            getDateList();
          });
        }),
      ),
      isrefreshing ? refreshWidget() : SizedBox(),
      Expanded(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: ScreenUtil().setWidth(SizeUtil.getWidth(20))
          ),
          child: ListView.builder(
            itemCount: this.dateList.length,
            controller: _scrollController,
            physics: BouncingScrollPhysics(),
            addAutomaticKeepAlives: false,
            itemBuilder: (context,index){
              return createItem(this.dateList[index]);
            },
          ),
        ),
      ),
      isloading ? loadmoreWidget() : SizedBox()
    ];
  }

}