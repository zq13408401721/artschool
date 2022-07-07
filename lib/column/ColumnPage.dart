import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yhschool/bean/special_type_bean.dart';
import 'package:yhschool/column/ColumnGalleryPage.dart';
import 'package:yhschool/column/ColumnListPage.dart';
import 'package:yhschool/column/ColumnMinePage.dart';
import 'package:yhschool/column/ColumnSchoolPage.dart';
import 'package:yhschool/utils/Constant.dart';
import 'package:yhschool/utils/DataUtils.dart';
import 'package:yhschool/utils/EnumType.dart';
import 'package:yhschool/utils/HttpUtils.dart';
import 'package:yhschool/utils/SizeUtil.dart';
import 'package:yhschool/widgets/HorizontalListTab.dart';
import 'package:yhschool/widgets/TextButton.dart' as M;

import '../BaseState.dart';
import 'ColumnSubscriblePage.dart';

class ColumnPage extends StatefulWidget{

  ColumnPage({Key key}):super(key:key);

  @override
  State<StatefulWidget> createState() {
    return ColumnPageState();
  }
}

class ColumnPageState extends BaseState{

  //final GlobalKey<M.TextButtonState> columnGalleryKey = GlobalKey<M.TextButtonState>();
  final GlobalKey<M.TextButtonState> columnAllKey = GlobalKey<M.TextButtonState>();
  final GlobalKey<M.TextButtonState> columnSchoolKey = GlobalKey<M.TextButtonState>();
  final GlobalKey<M.TextButtonState> columnMyKey = GlobalKey<M.TextButtonState>();

  //final GlobalKey<ColumnGalleryPageState> columnGalleryPageKey = GlobalKey<ColumnGalleryPageState>();
  final GlobalKey<ColumnListPageState> columnListPageKey = GlobalKey<ColumnListPageState>();
  //final GlobalKey<ColumnSubscriblePageState> columnSubsriblePageKey = GlobalKey<ColumnSubscriblePageState>();
  final GlobalKey<ColumnMinePageState> columnMinePageKey = GlobalKey<ColumnMinePageState>();
  final GlobalKey<ColumnSchoolPageState> columnSchoolPageKey = GlobalKey<ColumnSchoolPageState>();



  List<Data> types=[];
  int page=0;
  bool showteacher = false;

  void changePage(CMD_MINE cmd){
    if(cmd == CMD_MINE.CMD_PAGE_COLUMN_MINE){
      changeColumnTab(0);
      setState(() {
        page=0;
        _resetTypeSelect();
        changeType(0);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    print("columnpage initState");
    //_tabController = new TabController(length: length, vsync: vsync)
    _getColumnType();
  }

  @override
  void dispose() {
    super.dispose();
    print("columnpage dispose");
  }

  void _getColumnType(){
    types.clear();
    types.add(Data(id: 0,name: "全部",sort: 0)
    ..select = true);
    httpUtil.post(DataUtils.api_querycolumntype,data: {}).then((value) {
      print("ColumnPage mounted:$mounted value:$value");
      String result = checkLoginExpire(value);
      if(result.isNotEmpty){
        SpecialTypeBean bean = SpecialTypeBean.fromJson(json.decode(value));
        if(bean.errno == 0){
          setState(() {
            types.addAll(bean.data);
          });
        }else{
          //showToast(bean.errmsg);
        }
      }
    });
  }

  /**
   * 切换专栏tab
   */
  void changeColumnTab(int index){
    //columnGalleryKey.currentState.updateState(false);
    columnAllKey.currentState.updateState(false);
    columnSchoolKey.currentState.updateState(false);
    columnMyKey.currentState.updateState(false);
    //if(index == 0)columnGalleryKey.currentState.updateState(true);
    if(index == 0) columnMyKey.currentState.updateState(true);
    if(index == 1) columnAllKey.currentState.updateState(true);
    if(index == 2) columnSchoolKey.currentState.updateState(true);
  }

  /**
   * 切换分类
   */
  void changeType(int id){
    //if(page == 0) columnGalleryPageKey.currentState.updateGalleryList(id);
    if(page == 0) columnMinePageKey.currentState.updateMineColumn(id);
    if(page == 1) columnListPageKey.currentState.updateColumnList(id);
    if(page == 2) columnSchoolPageKey.currentState.updateColumnSchool(id);
  }

  //初始化显示共享网盘
  void initColumn(){
    changeColumnTab(1);
    setState(() {
      page=1;
      _resetTypeSelect();
      changeType(0);
    });
  }

  /**
   * 重置分类选中状态
   */
  void _resetTypeSelect(){
    types.forEach((element) {
      if(element.id == 0){
        element.select = true;
      }else{
        element.select = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            //顶部导航
            Container(
              height:  ScreenUtil().setHeight(SizeUtil.getHeight(Constant.SIZE_TOP_BAR_HEIGHT)),
              padding:EdgeInsets.only(
                /*top:ScreenUtil().setHeight(SizeUtil.getHeight(32)),
                    bottom: ScreenUtil().setHeight(SizeUtil.getHeight(35)),*/
                  left: ScreenUtil().setWidth(SizeUtil.getWidth(30)),
                  right: ScreenUtil().setWidth(SizeUtil.getWidth(30))
              ),
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  /*M.TextButton(key:columnGalleryKey,label:"全部图片",labelSpace:ScreenUtil().setWidth(SizeUtil.getWidth(20)),defaultSelect:true,cb: (){
                    print("切换到专栏图片");
                    _changeColumnTab(0);
                    setState(() {
                      page = 0;
                      _resetTypeSelect();
                      _changeType(0);
                    });
                  },),*/
                  M.TextButton(key:columnMyKey,label:"我的网盘",labelSpace:ScreenUtil().setWidth(SizeUtil.getWidth(40)),defaultSelect:true,cb: (){
                    print("我的专栏");
                    changeColumnTab(0);
                    setState(() {
                      page = 0;
                      _resetTypeSelect();
                      changeType(0);
                    });
                  },),
                  M.TextButton(key:columnAllKey,label:"全部网盘",labelSpace:ScreenUtil().setWidth(SizeUtil.getWidth(40)),cb: (){
                    print("全部专栏");
                    changeColumnTab(1);
                    setState(() {
                      page=1;
                      _resetTypeSelect();
                      changeType(0);
                    });
                  },),
                  M.TextButton(key:columnSchoolKey,label:"学校网盘",labelSpace:ScreenUtil().setWidth(SizeUtil.getWidth(40)),cb: (){
                    changeColumnTab(2);
                    //切换到我的订阅刷新页面
                    setState(() {
                      page=2;
                      _resetTypeSelect();
                      changeType(0);
                    });
                  },),
                  Expanded(
                    child: Offstage(
                      offstage: page != 2,
                      child: Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Checkbox(value: showteacher,onChanged: (value){
                              columnSchoolPageKey.currentState.updateSchoolColumnShow(value);
                              setState(() {
                                showteacher = value;
                              });
                            },),
                            Text("仅老师",style: TextStyle(fontSize: ScreenUtil().setSp(SizeUtil.getFontSize(30)),color: Colors.grey),)
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            //分类
            Container(
              decoration: BoxDecoration(
                  color: Colors.white
              ),
              padding: EdgeInsets.only(
                  left:ScreenUtil().setWidth(SizeUtil.getWidth(30)),
                  right: ScreenUtil().setWidth(SizeUtil.getWidth(30))
              ),
              margin: EdgeInsets.only(
                  bottom: ScreenUtil().setHeight(SizeUtil.getHeight(10))
              ),
              child: HorizontalListTab(datas: types, click: (dynamic _data){
                print("${_data.id}");
                changeType(_data.id);
              }),
            ),
            //列表
            Expanded(
              child: IndexedStack(
                index: page,
                children: [
                  ColumnMinePage(key: columnMinePageKey,),
                  ColumnListPage(key: columnListPageKey,),
                  ColumnSchoolPage(key: columnSchoolPageKey,)
                  //订阅列表页面
                  /*ColumnSubscriblePage(key:columnSubsriblePageKey,cb: (int cid){
                    columnListPageKey.currentState.updateColumnSubscrible(cid);
                  },)*/
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}