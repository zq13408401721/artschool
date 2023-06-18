
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yhschool/BaseState.dart';
import 'package:yhschool/bean/ApiDB.dart';
import 'package:yhschool/bean/class_room_add_bean.dart';
import 'package:yhschool/bean/class_room_date_bean.dart';
import 'package:yhschool/bean/class_room_datelist_bean.dart';
import 'package:yhschool/bean/class_room_del_bean.dart';
import 'package:yhschool/bean/entity_tab_bean.dart';
import 'package:yhschool/bean/video_category.dart' as M;
import 'package:yhschool/bean/video_tab.dart' as V;
import 'package:yhschool/teach/ClassVideoSelectTile.dart';
import 'package:yhschool/teach/ClassVideoTab.dart';
import 'package:yhschool/utils/Constant.dart';
import 'package:yhschool/utils/DBUtils.dart';
import 'package:yhschool/utils/DataUtils.dart';
import 'package:yhschool/utils/HttpUtils.dart';
import 'package:yhschool/utils/SizeUtil.dart';
import 'package:yhschool/widgets/BackButtonWidget.dart';

import '../TileCard.dart';
import 'ClassVideoTile.dart';

class ClassVideoEditor extends StatefulWidget{

  String classname;
  Date date;

  ClassVideoEditor({Key key,@required this.date,@required this.classname}):super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ClassVideoEditorState()
    ..classname = classname
    ..date = date;
  }
  
}

class ClassVideoEditorState extends BaseState{

  Date date;
  String classname;
  List<String> tabsWord = [];
  List<TabBeanData> tabList = [];
  List<V.Data> videoTabList = [];
  int selectTabId=0,selectCategoryId=0;
  int videoCategoryid=0; //视频对应的小节id
  String section; //科目名
  String categoryname; //章节名
  int page=1,size=50;
  List<M.Data> videoCategoryList=[];
  String username;
  String uid;

  @override
  void initState() {
    super.initState();
    getUserInfo().then((value) => {
      if(value != null){
        username = value["username"],
        uid = value["uid"]
      }
    });
    getTodayDate();
    getVideoTabs();
  }

  /**
   * 获取当前的日期数据
   */
  void getTodayDate(){

  }

  /**
   * 获取当天的课堂视频数据
   */
  void getTodayClassRoomVideo(){

  }

  void getVideoTabs(){
    var option = {
      "type":3
    };
    httpUtil.get(DataUtils.api_tab,data: option).then((value) {
      TabBean tabBean = new TabBean.fromJson(json.decode(value));
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
    }).catchError((err){

    });
  }

  /**
   * 获取视频章节数据
   */
  void getCategoryByTab(int categoryid){

    var key = "${DataUtils.api_video_tab_category}_${categoryid}";
    DBUtils.dbUtils.then((db) async{
      var result = await db.queryApiData(key);
      if(result.length > 0){
        _getCategoryByTabReturn(db,key,result);
      }else{
        var data = {
          "page":1,
          "size":100,
          "categoryid":categoryid,
          "type":1
        };
        //获取对应的章节数据
        httpUtil.post(DataUtils.api_video_tab_category,data: data).then((result){
          _getCategoryByTabReturn(db,key,result);
        }).catchError((err) => {

        });
      }
    });
  }

  void _getCategoryByTabReturn(DBUtils db,String key,String result){
    var videoTab = new V.VideoTab.fromJson(json.decode(result));
    videoTabList.clear();
    if(videoTab.errno == 0 && videoTab.data != null && videoTab.data.length > 0){
      db.insertApi(ApiDB(api:key,result:result));
      videoTabList.addAll(videoTab.data);
      selectCategoryId = videoTabList[0].categoryid;
      categoryname = videoTabList[0].categoryname;
      videoCategoryList.clear();
      getVideoCategoryList(selectCategoryId);
    }
    setState(() {

    });
  }


  void getVideoCategoryList(categoryid){
    var key = "${DataUtils.api_video_category_more}_${categoryid}";

    DBUtils.dbUtils.then((db)async{
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

        });
      }
    });
  }

  /**
   * 获取对应的视频课程数据返回
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
      "dateid":date.dateid,
      "categoryid":videoCategoryid,
      "title":section+"/"+categoryname
    };
    httpUtil.post(DataUtils.api_classroomaddvideo,data: option).then((value){
      ClassRoomAddBean addBean = ClassRoomAddBean.fromJson(json.decode(value));
      if(addBean.errno == 0){
        //本地操作把数据保存到已经添加列表
        Videos _video = Videos(id: addBean.data.id,dateid: addBean.data.dateid,categoryid: addBean.data.categoryid,title: addBean.data.title,
        tid: addBean.data.tid,mark: addBean.data.mark,createtime: addBean.data.createtime,teachername: username,name: name,cover: cover);
        setState(() {
          date.videos.insert(0, _video);
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
      "dateid":date.dateid,
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
    for(Videos item in date.videos){
      if(item.id == id){
        date.videos.remove(item);
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
      bool _bool = date.videos.any((element) => element.categoryid == item.id);
      item.select = _bool;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            color:Colors.grey[100]
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                    color: Colors.white
                ),
                child: BackButtonWidget(cb: (){
                  Navigator.pop(context,date);
                }, title: "返回"),
              ),

              Container(
                width: double.infinity,
                padding: EdgeInsets.only(
                  top:ScreenUtil().setHeight(SizeUtil.getHeight(40)),
                  bottom:ScreenUtil().setHeight(SizeUtil.getHeight(40)),
                  left:ScreenUtil().setWidth(SizeUtil.getWidth(40))
                ),
                decoration: BoxDecoration(
                  color: Colors.white
                ),
                child: Text(classname,style: TextStyle(fontSize: ScreenUtil().setSp(SizeUtil.getFontSize(40)),fontWeight: FontWeight.bold),),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: ScreenUtil().setWidth(SizeUtil.getWidth(20))
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: ScreenUtil().setHeight(SizeUtil.getHeight(40)),),
                        Text(Constant.getDateFormatByString(date.date),style: Constant.titleTextStyleNormal,),
                        GridView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: date.videos.length,
                            padding: EdgeInsets.only(top: ScreenUtil().setHeight(SizeUtil.getHeight(20))),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                mainAxisSpacing: ScreenUtil().setWidth(SizeUtil.getWidth(Constant.PADDING_GALLERY_CROSS)),
                                crossAxisSpacing: ScreenUtil().setHeight(SizeUtil.getHeight(Constant.GARRERY_GRID_CROSSAXISSPACING)),
                                childAspectRatio: Constant.isPad ? 0.8 : 0.68
                            ),
                            itemBuilder: (BuildContext context,int index){
                              return Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(ScreenUtil().setWidth(SizeUtil.getWidth(20))),
                                    bottomRight: Radius.circular(ScreenUtil().setWidth(SizeUtil.getWidth(20)))
                                  )
                                ),
                                child: ClassVideoTile(videos: date.videos[index],isEditor: true,uid: uid,callback: (_id,_categoryid,mark){
                                  //删除选择的课件
                                  deleteClassVideo(_id,_categoryid,mark);
                                },),
                              );
                            }
                        ),
                        SizedBox(height: ScreenUtil().setHeight(SizeUtil.getHeight(80)),),
                        Padding(padding: EdgeInsets.only(left: ScreenUtil().setWidth(SizeUtil.getWidth(10))),
                          child: Text("添加课程",style: TextStyle(fontSize: ScreenUtil().setSp(SizeUtil.getFontSize(40)),fontWeight: FontWeight.bold)),
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
                                    videoTabList.clear();
                                    getCategoryByTab(tabList[index].id);
                                  });
                                }
                              },
                              child: Container(
                                alignment: Alignment(0,0),
                                margin: EdgeInsets.only(right: ScreenUtil().setWidth(SizeUtil.getWidth(40))),
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
                          margin: EdgeInsets.only(top: ScreenUtil().setHeight(SizeUtil.getHeight(40))),
                          child: ListView.builder(itemCount:videoTabList.length,shrinkWrap:true,scrollDirection: Axis.horizontal,addAutomaticKeepAlives: false,itemBuilder: (context,index){
                            return InkWell(
                              onTap: (){
                                if(selectCategoryId != videoTabList[index].categoryid){
                                  setState(() {
                                    selectCategoryId = videoTabList[index].categoryid;
                                    categoryname = videoTabList[index].categoryname;
                                    videoCategoryList.clear();
                                    getVideoCategoryList(selectCategoryId);
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
                            padding: EdgeInsets.only(top: ScreenUtil().setHeight(SizeUtil.getHeight(20))),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                mainAxisSpacing: ScreenUtil().setWidth(Constant.PADDING_GALLERY_CROSS),
                                crossAxisSpacing: Constant.GARRERY_GRID_CROSSAXISSPACING,
                                childAspectRatio: Constant.isPad ? .87 : .78
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
              )
            ],
          ),
        ),
      ),
    );
  }
}