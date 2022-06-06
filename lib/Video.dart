import 'dart:ui';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yhschool/BaseState.dart';
import 'package:yhschool/OfficialVideo.dart';
import 'package:yhschool/TileCard.dart';
import 'package:yhschool/VersionState.dart';
import 'package:yhschool/VideoDetail.dart';
import 'package:yhschool/VideoMore.dart';
import 'package:yhschool/VideoWeb.dart';
import 'package:yhschool/bean/entity_home_bean.dart';
import 'package:yhschool/bean/entity_tab_bean.dart';
import 'package:yhschool/utils/Constant.dart';
import 'package:yhschool/utils/DataUtils.dart';
import 'package:yhschool/utils/ImageType.dart';
import 'package:yhschool/utils/PluginManager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'utils/HttpUtils.dart';
import 'dart:convert';
import 'package:yhschool/bean/video_tab.dart';

/**
 * 主页
 */
class Video extends StatefulWidget{

  Video({Key key}):super(key: key);

  VideoState _videoState;

  @override
  VersionState<StatefulWidget> createState() {
    _videoState = new VideoState();
    return _videoState;
  }

}

class VideoState extends VersionState<Video> with SingleTickerProviderStateMixin{

  List<Widget> officialtabs = []; //平台tab
  List<Widget> schooltabs = []; //学校的视频tab
  List<Widget> gridGroup = [];
  List<Widget> categoryViews = [];

  List<Data> videoClassifyList = []; //视频分类列表
  int R_MAX = 6;
  String selectTab=""; //当前选择的tab
  TabController _tabController; //学校和平台的tab切换管理器
  TabBean officialTabBean; //官方的tab数据
  TabBean schoolTabBean; //学校的tab数据

  VideoType curVideoType; //


  void updataState(){
    getTabs();
  }

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(length:2, vsync: this)
    ..addListener(() {
      //处理响应两次的问题
      if(_tabController.index == _tabController.animation.value){
        switch(_tabController.index){
          case 0: //云视频
            curVideoType = VideoType.official;
            showOfficial();
            break;
          case 1: //库
            curVideoType = VideoType.school;
            showSchool();
            break;
        }
      }
    });
    //默认设置视频为官方视频
    curVideoType = VideoType.official;
    getTabs();
    //checkVersion();
  }

  /**
   * 显示官方内容
   */
  showOfficial(){
    if(officialtabs.length == 0){
      getTabs();
    }else{
      setState(() {
      });
    }
  }

  /**
   *显示学校内容
   */
  showSchool(){
    if(schooltabs.length == 0){
      getTabs();
    }else{
      setState(() {
      });
    }
  }

  /**
   * 获取tab数据返回
   */
  void getTabsReturn(TabBean result){
    if(result.errno != 0){
      showToast(result.errmsg);
      return;
    }

    if(curVideoType == VideoType.official){
      officialtabs = [];
      this.officialTabBean = result;
    }else{
      schooltabs = [];
      this.schoolTabBean = result;
    }
    if(result.data != null && result.data.length > 0){
      //默认选中第一个
      setState(() {
        selectTab = result.data[0].name;
      });

      getCategoryByTab(result.data[0].id);
    }

    /*result.data.forEach((element) {
      var tab = InkWell(
        child:Container(
          padding: EdgeInsets.only(left: ScreenUtil().setWidth(Constant.PADDING_GALLERY_LEFT-40)),
          child: Padding(
            padding: EdgeInsets.only(left: ScreenUtil().setWidth(40),right: ScreenUtil().setWidth(40),top: ScreenUtil().setHeight(15),bottom: ScreenUtil().setHeight(15)),
            child: Text(element.name,style: TextStyle(fontSize: ScreenUtil().setSp(42),
                color: this.selectTab == element.name ? Constant.TAB_SELECT_COLOR : Constant.TAB_UNSELECT_COLOR),),
          ),
        ),
        onTap: ()=>{
          //print("item click+"+element.name)
          if(selectTab != element.name){
            selectTab = element.name,
            getCategoryByTab(element.id)
          }
        },
      );
      if(curVideoType == VideoType.official){
        officialtabs.add(tab);
      }else if(curVideoType == VideoType.yhschool){
        schooltabs.add(tab);
      }
    });*/



  }

  List<Widget> createTabTxts(){
    List<Widget> widgets = [];
    if(officialTabBean == null && schoolTabBean == null) return widgets;
    List<TabBeanData> _list;
    if(curVideoType==VideoType.official){
      _list = officialTabBean.data;
    }else{
      _list = schoolTabBean.data;
    }
    _list.forEach((element) {
      widgets.add(InkWell(
        child:Container(
          padding: EdgeInsets.only(left: ScreenUtil().setWidth(Constant.PADDING_GALLERY_LEFT-40)),
          child: Padding(
            padding: EdgeInsets.only(left: ScreenUtil().setWidth(40),right: ScreenUtil().setWidth(40),top: ScreenUtil().setHeight(15),bottom: ScreenUtil().setHeight(15)),
            child: Text(element.name,style: TextStyle(fontSize: ScreenUtil().setSp(42),
                color: this.selectTab == element.name ? Constant.TAB_SELECT_COLOR : Constant.TAB_UNSELECT_COLOR),),
          ),
        ),
        onTap: ()=>{
          //print("item click+"+element.name)
          if(selectTab != element.name){
            selectTab = element.name,
            getCategoryByTab(element.id)
          }
        },
      ));
    });
    return widgets;
  }

  Widget createCategoryItem(Data item){
    return Container(
      child:Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: ScreenUtil().setHeight(80),
            margin: EdgeInsets.only(top: ScreenUtil().setHeight(30)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  this.selectTab+" | "+item.categoryname,
                  style: TextStyle(fontSize: Constant.FONT_TITLE_SIZE,color: Constant.COLOR_TITLE),
                ),
                GestureDetector(
                  child:Text("更多 >",style: TextStyle(
                      fontSize: Constant.FONT_GRID_NAME_SIZE,
                      color: Constant.COLOR_GRID_DESC
                  ),),
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) =>
                        VideoMore(section: this.selectTab,categoryname: item.categoryname,pid:item.categoryid,)
                    ));
                  },
                ),
              ],
            ),
          ),
          GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: item.categorys.length > R_MAX ? R_MAX : item.categorys.length,
              padding: EdgeInsets.only(top: ScreenUtil().setHeight(20)),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: ScreenUtil().setWidth(Constant.PADDING_GALLERY_CROSS),
                  crossAxisSpacing: Constant.GARRERY_GRID_CROSSAXISSPACING,
                  childAspectRatio: Constant.isPad ? 0.86 : 1.05
              ),
              itemBuilder: (BuildContext context,int index){
                return InkWell(
                  child: Container(
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(ScreenUtil().radius(20.0))),
                      ),
                      child: TileCard(url: item.categorys[index].cover,title: item.categorys[index].name,width: double.infinity,height: Constant.GARRERY_ITEM_HEIGHT),
                    ),
                  ),
                  onTap: () async {
                    String response;
                    try {
                      var prefs = await SharedPreferences.getInstance();
                      var token = prefs.getString("token");
                      var param = {
                        "classify":this.selectTab,
                        "section":item.categoryname,
                        "category":item.categorys[index].name,
                        "categoryid":item.categorys[index].id,
                        "token":token
                      };
                      Navigator.push(context, MaterialPageRoute(builder: (context) =>
                          VideoWeb(classify: selectTab, section: item.categoryname, category: item.categorys[index].name, categoryid: item.categorys[index].id,
                          description: item.categorys[index].description,step: item.categorys[index].step,)
                      ));
                      /*if(Platform.isAndroid){
                        response = await PluginManager.pushVideoActivity(param);
                      }else{
                        Navigator.push(context, MaterialPageRoute(builder: (context) =>
                            VideoDetail(classify: selectTab, section: item.categoryname, category: item.categorys[index].name, categoryid: item.categorys[index].id,)
                        ));
                      }*/
                    }on PlatformException{
                      response = '失败';
                    }
                    print(response);


                  },
                );
              }
          ),
          Padding(
            padding: EdgeInsets.only(top: ScreenUtil().setHeight(20)),
            child: Divider(
              color: Colors.grey[300],
              thickness: ScreenUtil().setHeight(4),
            ),
          )
        ],
      ),
    );
  }

  /**
   * 获取二级目录章节返回
   */
  void getCategoryReturn(VideoTab result){
    if(result.errno == 0){
      gridGroup = [];
      result.data.forEach((item) {
        gridGroup.add(
            Container(
              decoration: BoxDecoration(
                color: Colors.red
              ),
              child:Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: ScreenUtil().setHeight(80),
                    padding: EdgeInsets.only(top: ScreenUtil().setHeight(30)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          this.selectTab+" | "+item.categoryname,
                          style: TextStyle(fontSize: Constant.FONT_TITLE_SIZE,color: Constant.COLOR_TITLE),
                        ),
                        GestureDetector(
                          child:Text("更多 >",style: TextStyle(
                              fontSize: Constant.FONT_GRID_NAME_SIZE,
                              color: Constant.COLOR_GRID_DESC
                          ),),
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) =>
                                VideoMore(section: this.selectTab,categoryname: item.categoryname,pid:item.categoryid,)
                            ));
                          },
                        ),
                      ],
                    ),
                  ),
                  GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: item.categorys.length > R_MAX ? R_MAX : item.categorys.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: ScreenUtil().setWidth(Constant.PADDING_GALLERY_CROSS),
                          crossAxisSpacing: Constant.GARRERY_GRID_CROSSAXISSPACING,
                          childAspectRatio: 1.12
                      ),
                      itemBuilder: (BuildContext context,int index){
                        return InkWell(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.green
                            ),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(ScreenUtil().radius(20.0))),
                              ),
                              child: TileCard(url: item.categorys[index].cover,title: item.categorys[index].name,width: double.infinity,height: Constant.GARRERY_ITEM_HEIGHT),
                            ),
                          ),
                          onTap: () async {
                            print("点击对应的视频");
                            String response;
                            try {
                              var prefs = await SharedPreferences.getInstance();
                              var token = prefs.getString("token");
                              var param = {
                                "classify":this.selectTab,
                                "section":item.categoryname,
                                "category":item.categorys[index].name,
                                "categoryid":item.categorys[index].id,
                                "token":token
                              };
                              // if(Platform.isAndroid){
                              //   response = await PluginManager.pushVideoActivity(param);
                              // }else if(Platform.isIOS){
                              //
                              // }
                              Navigator.push(context, MaterialPageRoute(builder: (context) =>
                                  VideoWeb(classify: selectTab, section: item.categoryname, category: item.categorys[index].name, categoryid: item.categorys[index].id,)
                              ));
                            }on PlatformException{
                              response = '失败';
                            }
                            print(response);

                          },
                        );
                      }
                  ),
                ],
              ),
            )
        );
      });
      setState(() {
      });
    }else{
      showToast(result.errmsg);
    }
  }

  /**
   * 获取一级目录tab对应的章节数据
   */
  void getCategoryByTab(int categoryid){
    var data = {
      "page":1,
      "size":10,
      "categoryid":categoryid,
      "type":curVideoType==VideoType.official ? 1 : 2
    };
    //获取对应的章节数据
    httpUtil.post(DataUtils.api_video_tab_category,data: data).then(
            (result){
          print("video video_tab_category $result");
          var videoTab = new VideoTab.fromJson(json.decode(result));
          videoClassifyList = [];
          setState(() {
            videoClassifyList.addAll(videoTab.data);
          });

          //getCategoryReturn(new VideoTab.fromJson(json.decode(result)));

        }
    ).catchError((err) => {
      print(err)
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
              color:Colors.grey[100]
          ),
          child: Column(
            children: [
              Container(
                height: ScreenUtil().setHeight(Constant.SIZE_TOP_HEIGHT),
                decoration: BoxDecoration(
                    color: Colors.white
                ),
                child: TabBar(
                  controller: _tabController,
                  tabs: <Tab>[
                    Tab(
                      child: Text(
                        "云视频",
                        style: TextStyle(
                            color: Constant.COLOR_TITLE,
                            fontSize: ScreenUtil().setSp(60),
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                    Tab(
                      child: Text(
                        "库",
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
              Container(
                //width: ScreenUtil().setWidth(window.physicalSize.width.toDouble()),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Container(
                    child: Row(
                      children: createTabTxts(),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.fromLTRB(ScreenUtil().setWidth(Constant.PADDING_GALLERY_LEFT), ScreenUtil().setHeight(25), ScreenUtil().setWidth(Constant.PADDING_GALLERY_RIGHT), 0),
                  itemCount: videoClassifyList.length,
                  itemBuilder: (context,index){
                    return createCategoryItem(videoClassifyList[index]);
                  },
                ),
              ),
              /*Container(
            padding: EdgeInsets.fromLTRB(Constant.PADDING_LEFT, 0, Constant.PADDING_RIGHT, 0),
            child:
          ),*/
              /*Padding(
            padding: EdgeInsets.fromLTRB(Constant.PADDING_LEFT, 0, Constant.PADDING_RIGHT, 0),
            child: Divider(),
          ),*/
              /*SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child:
          )*/
            ],
          ),
        ),
      ),
    );
  }

  void getTabs(){
    var option = {
      "type":curVideoType == VideoType.official ? 1 : 2
    };
    print(option);
    httpUtil.get(DataUtils.api_tab,data: option).then((value) => {
      getTabsReturn(new TabBean.fromJson(json.decode(value)))
    }).catchError((err){

    });
  }
}

/**
 * 章节条目封装
 */
class CategoryItem extends Container{

  HomeBeanData _homeBeanData;
  CategoryItem(HomeBeanData homeBeanData){
    _homeBeanData = homeBeanData;
  }

  List<Widget> categoryGridView(List<HomeBeanDataCategory> list){
    List<Widget> widgets = [];
    list.map((item) => {
      widgets.add(createCategoryItem(item))
    });
    return widgets;
  }

  /**
   * 节点item
   */
  Widget createCategoryItem(HomeBeanDataCategory item){
    return Column(
      children: [
        Image.network(item.cover),
        Text(item.name)
      ],
    );
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(_homeBeanData.categoryname),
        GridView.count(
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0,
          padding: EdgeInsets.all(10.0),
          crossAxisCount: 3,
          childAspectRatio: 2.0,
          children: categoryGridView(_homeBeanData.categorys),
        )
      ],
    );
  }

}
