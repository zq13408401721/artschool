import 'dart:collection';
import 'dart:convert';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:yhschool/VersionState.dart';
import 'package:yhschool/VideoMore.dart';
import 'package:yhschool/bean/advert_video_bean.dart';
import 'package:yhschool/bean/entity_tab_bean.dart';
import 'package:yhschool/bean/home_banner_bean.dart' as B;
import 'package:yhschool/bean/live_room_bean.dart';
import 'package:yhschool/bean/school_brochure_bean.dart' as M;
import 'package:yhschool/bean/school_video_group_bean.dart' as Group;
import 'package:yhschool/bean/school_video_tab_bean.dart' as Tab;
import 'package:yhschool/bean/video_a_i_bean.dart';
import 'package:yhschool/bean/video_tab.dart' as V;
import 'package:yhschool/live/LivePage.dart';
import 'package:yhschool/other/AdvertVideoPage.dart';
import 'package:yhschool/other/QRViewPage.dart';
import 'package:yhschool/utils/Banner.dart';
import 'package:yhschool/utils/BaseParam.dart';
import 'package:yhschool/utils/Constant.dart';
import 'package:yhschool/utils/DataUtils.dart';
import 'package:yhschool/utils/HttpUtils.dart';
import 'package:yhschool/utils/SizeUtil.dart';
import 'package:yhschool/video/SchoolVideoChoiceTile.dart';
import 'package:yhschool/video/SchoolVideoListPage.dart';
import 'package:yhschool/video/VideoChoiceTile.dart';
import 'package:yhschool/video/VideoEditorTab.dart';
import 'package:yhschool/video/VideoMorePage.dart';
import 'package:yhschool/video/VideoTile.dart';
import 'package:yhschool/widgets/ClickCallback.dart';
import 'package:yhschool/widgets/EgWordWidget.dart';
import 'package:yhschool/widgets/Marquee.dart';
import 'package:yhschool/bean/choice_bean.dart' as C;
import 'package:yhschool/bean/user_bean.dart' as U;
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:video_player/video_player.dart';
import 'package:yhschool/widgets/RListView.dart';
import '../VideoWeb.dart';
import '../WebStage.dart';
import '../bean/column_list_bean.dart' as COLUMN;
import '../column/ColumnDetail.dart';
import '../widgets/ClickCallback.dart';
import 'VideoAITile.dart';


/************对应的参数类*****************/
//视频对应的tab
class _VideoTabsParam extends BaseParam{
  _VideoTabsParam(int type){
    data = {
      "type":type
    };
    param = "type:${type}";
  }
}

//视频一级分类
class _TabCategoryParam extends BaseParam{
  _TabCategoryParam(page,size,categoryid,type){
    data = {
      "page":page,
      "size":size,
      "categoryid":categoryid,
      "type":type
    };
    param = "page:${page}&size:${size}&categoryid:${categoryid}&type:${type}";
  }
}

//官方精选列表
class _ChoiceListParam extends BaseParam{
  _ChoiceListParam(){
    data = {};
  }
}

//学校招生简章
class _BrochureParam extends BaseParam{
  _BrochureParam(){
    data = {};
  }
}

class _VideoGroupParam extends BaseParam{
  _VideoGroupParam(){
    data = [];
  }
}

class VideoPage extends StatefulWidget{

  CallBack_Column callback;
  VideoPage({Key key,@required this.callback}):super(key: key);

  @override
  State<StatefulWidget> createState() {
    return VideoPageState();
  }
}

class VideoPageState extends VersionState<VideoPage>{

  static final TAB_HOME = 999;

  TextStyle _tabSelectStyle;
  TextStyle _tabNormalStyle;

  int tabIndex = 1; // 0云视频 1学校视频
  List<TabBeanData> tabsList1 = [];
  List<Tab.Data> tabsList2 = [];
  List<Tab.Data> tabsList3 = []; //学校视频二级分类
  int tabItemId = 0;
  int tabItemId2 = 0;
  String selectTab1Name,selectTab2Name;
  String tabItemName;
  var videoMap;
  List<V.Data> videoTabList = [];
  //分组视频
  List<Group.Data> videoGroupList = [];
  //AI推荐视频
  List<Videos> aiList = [];
  //官方精选
  List<C.Data> choiceList = [];


  List<String> marquee = [];
  TextStyle marqueeStyle;

  //招生简章相关数据
  List<M.Data> brochureList=[];
  String schoolname = "";

  //最新的专栏数据
  List<COLUMN.Data> columnList = [];
  int columnNum = 0;

  //banner数据
  List<B.Data> bannerList = [];

  int videoGroupPage = 1;
  int videoGroupSize = 20;


  LiveRoomBean _liveRoomBean;
  //视频广告
  AdvertVideoBean _advertVideoBean;

  final GlobalKey<RListViewState> rListViewStateKey = new GlobalKey<RListViewState>();

  ScrollController _scrollController;

  //分类对应的页码
  Map<int,_VideoGroupParam> pageMap = new HashMap();

  @override
  void initState() {
    super.initState();
    print("VideoPage initState");
    _scrollController = initScrollController(isfresh: false);
    videoMap = Map();
    _tabSelectStyle = TextStyle(fontSize: ScreenUtil().setSp(SizeUtil.getFontSize(40)),fontWeight: FontWeight.bold,color: Colors.red);
    _tabNormalStyle = TextStyle(fontSize: ScreenUtil().setSp(SizeUtil.getFontSize(30)),color: Colors.black87);
    marqueeStyle = TextStyle(fontSize: ScreenUtil().setSp(SizeUtil.getFontSize(36)),color: Colors.black54);
    getUserInfo().then((value){
      setState(() {
        schoolname = value["schoolname"];
      });
    });

   /* _videoPlayerController = VideoPlayerController.network("http://res.yimios.com:9050/videos/advert.mp4");
    _videoPlayerController.initialize().then((value){
      setState(() {
        videoInit = true;
      });
    });
    _videoPlayerController.play();*/
    getHomeBanner();
    columnGalleryList();
    //getTabs();
    getSchoolVideoTabs();
    getChoiceList();
    //getAIVideo();
    getSchoolBrochure();
    getUserGroup();
    getLiveRoom();

    //checkAdvert();
  }

  /**
   * 显示学校相关广告，弹出图片
   */
  void showSchoolBrochure(String url){
    double size = Constant.isPad ? 900 : 650;
    showDialog(context: context, builder: (context){
      return UnconstrainedBox(
        child: GestureDetector(
          onTap: (){
            Navigator.pop(context);
          },
          child: Container(
            width: ScreenUtil().setWidth(SizeUtil.getWidth(size)),
            height:ScreenUtil().setWidth(SizeUtil.getWidth(size)),
            child: CachedNetworkImage(
              imageUrl: url,
              width: ScreenUtil().setWidth(SizeUtil.getWidth(size)),
              height: ScreenUtil().setWidth(SizeUtil.getWidth(size)),
              imageBuilder: (_context,_imageProvider) => Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(ScreenUtil().setWidth(40)),
                  image: DecorationImage(
                    image:_imageProvider,
                    fit: BoxFit.cover
                  )
                ),
              ),
            ),
          ),
        )
      );
    });
  }

  void showVideoTips(String url){
    showDialog(context: context, builder: (context){
      return Container(
          child: GestureDetector(
            onTap: (){
              Navigator.pop(context);
            },
            child: Container(
              margin: EdgeInsets.symmetric(
                horizontal: SizeUtil.getAppWidth(50),
                vertical: SizeUtil.getAppHeight(100),
              ),
              child: Image.asset(url,fit: BoxFit.contain,),
            ),
          )
      );
    });
  }

  /**
   * 页面状态改变 登录成功以后刷新界面
   */
  void updataState(){
    getUserInfo().then((value){
      setState(() {
        schoolname = value["schoolname"];
      });
    });
    getAIVideo();
    getSchoolBrochure();
  }

  /**
   * 检查是否弹出广告
   */
  void checkAdvet(){
    Navigator.push(context, MaterialPageRoute(builder: (_context)=>AdvertVideoPage()));
  }

  /**
   * 获取home页banner数据
   */
  void getHomeBanner(){
    httpUtil.post(DataUtils.api_homebanner,data:{"position":BannerType.position1.position},context: context).then((value){
      if(value != null){
        B.HomeBannerBean bean = B.HomeBannerBean.fromJson(json.decode(value));
        bannerList.addAll(bean.data);
        setState(() {
        });
      }
    });
  }

  /**
   * 获取直播房间信息
   */
  void getLiveRoom(){
    httpUtil.post(DataUtils.api_liveroom,data:{},context: context).then((value){
      if(value != null){
        _liveRoomBean = LiveRoomBean.fromJson(json.decode(value));
      }
    });
  }

  /**
   * 获取视频相关的分类
   */
  void getTabs(){
    var option = _VideoTabsParam(tabIndex == 0 ? 1 : 2);
    httpUtil.get(DataUtils.api_tab,option: option).then((value) {
      var _tabBean = TabBean.fromJson(json.decode(value));
      if(_tabBean.errno == 0){
        setState(() {
          if(tabIndex == 0){
            tabsList1.addAll(_tabBean.data);
            tabItemId = _tabBean.data[0].id;
            tabItemName = _tabBean.data[0].name;
          }else{

          }
          getCategoryByTab(_tabBean.data[0].id);
        });
      }
    }).catchError((err){

    });
  }

  /**
   * 获取学校视频tab
   */
  void getSchoolVideoTabs(){
    var param = {
      "pid":0
    };
    httpUtil.post(DataUtils.api_school_video_tab,data:param,context: context).then((value){
      print("school video tab ${value}");
      Tab.SchoolVideoTabBean tabBean = Tab.SchoolVideoTabBean.fromJson(json.decode(value));
      if(tabBean.errno == 0){
        tabsList2.add(Tab.Data(id: TAB_HOME,name: "首页"));
        tabsList2.addAll(tabBean.data);
        tabItemId = tabsList2[0].id;
        tabItemName = tabsList2[0].name;
        hasData = false;
        setState(() {
        });
        getSchoolVideoChildTabs(tabItemId);
      }
    });
  }

  /**
   * 获取二级分类的tab
   */
  void getSchoolVideoChildTabs(int tabid){
    var param = {
      "pid":tabid
    };
    httpUtil.post(DataUtils.api_school_video_tab,data:param,context: context).then((value){
      print("school video tab ${value}");
      Tab.SchoolVideoTabBean tabBean = Tab.SchoolVideoTabBean.fromJson(json.decode(value));
      tabsList3.clear();
      if(tabBean.errno == 0){
        tabsList3.addAll(tabBean.data);
        if(tabsList3.length > 0){
          tabItemId2 = tabsList3[0].id;
          selectTab2Name = tabsList3[0].name;
          videoGroupList.clear();
          getSchoolVideoGroup(tabid:tabItemId2);
        }
      }
      setState(() {
      });
    });
  }

  //学校分组视频
  void getSchoolVideoGroup({int tabid,bool more=false}){
    print("getVideoGroup");
    _VideoGroupParam videoGroup;
    if(!pageMap.containsKey(tabid)){
      videoGroupPage = 1;
      videoGroup = new _VideoGroupParam();
      videoGroup.page = videoGroupPage;
      pageMap[tabid] = videoGroup;
    }else{
      videoGroup = pageMap[tabid];
      videoGroupPage = videoGroup.page;
      if(more == false && videoGroup.data != null && videoGroup.data.length > 0) {
        for(int i=0; i<videoGroup.data.length; i++){
          videoGroupList.add(videoGroup.data[i]);
        }
        setState(() {
        });
        return;
      }
    }

    var param = {
      "tabid":tabid,
      "page":videoGroupPage,
      "size":videoGroupSize
    };
    httpUtil.post(DataUtils.api_school_video_group,data:param,context: context).then((value){
      print("school video group $value");
      hideLoadMore();
      Group.SchoolVideoGroupBean bean = Group.SchoolVideoGroupBean.fromJson(json.decode(value));
      if(bean.errno == 0){
        if(bean.data != null && bean.data.length > 0){
          videoGroupPage ++;
          videoGroup.page = videoGroupPage;
          videoGroupList.addAll(bean.data);
          videoGroup.data.addAll(bean.data);
        }
      }
      setState(() {
      });
    });
  }

  /**
   * 获取一级目录tab对应的章节数据
   */
  void getCategoryByTab(int categoryid){
    if (categoryid == TAB_HOME) return;
    var key;
    if(tabIndex == 0){
      key="official$categoryid";
    }else{
      key="yhschool$categoryid";
    }
    if(videoMap[key] != null){
      setState(() {
        videoTabList.addAll(videoMap[key]);
      });
      return;
    }
    //获取对应的章节数据
    httpUtil.post(DataUtils.api_video_tab_category,option: _TabCategoryParam(1, 12, categoryid, tabIndex==0 ? 1 : 2)).then((result){
          print("video tab $result");
          var videoTab = new V.VideoTab.fromJson(json.decode(result));
          videoMap[key] = videoTab.data;
          setState(() {
            videoTabList.addAll(videoTab.data);
          });
        }
    ).catchError((err) => {
      print(err)
    });
  }

  /**
   * 获取用户组 读取本地的json文件
   */
  void getUserGroup(){
    rootBundle.loadString("data/user.json").then((value){
      U.UserBean bean = U.UserBean.fromJson(json.decode(value));
      var index = Random().nextInt(bean.data.length-20);
      setState(() {
        for(var i=index; i<index+20; i++){
          marquee.add(bean.data[i].name);
        }
      });
    });
  }

  /**
   * 获取官方精选
   */
  getChoiceList(){
    httpUtil.post(DataUtils.api_choicelist,option:_ChoiceListParam()).then((value){
      C.ChoiceBean bean = C.ChoiceBean.fromJson(json.decode(value));
      if(bean.errno == 0){
        setState(() {
          choiceList.addAll(bean.data);
        });
      }
    });
  }

  /**
   * 获取AI推荐视频
   */
  getAIVideo(){
    //获取对应的章节数据
    httpUtil.post(DataUtils.api_aivideo,data:{}).then((result){
          print("AIVideo:$result");
          var aiVideo = new VideoAIBean.fromJson(json.decode(result));
          if(aiVideo.errno == 0){
            aiList.clear();
            setState(() {
              aiList.addAll(aiVideo.data.videos);
            });
          }else{
            //showToast(aiVideo.errmsg);
          }
        }
    ).catchError((err) => {
      print(err)
    });
  }

  /**
   * 获取学校招生简章相关数据
   */
  getSchoolBrochure(){
    httpUtil.post(DataUtils.api_schoolbrochure,data: {}).then((value){
      print("brochure:$value");
      String result = checkLoginExpire(value);
      if(result.isNotEmpty){
        var brochure = new M.SchoolBrochureBean.fromJson(json.decode(result));
        if(brochure.errno == 0){
          brochureList.clear();
          setState(() {
            brochureList.addAll(brochure.data);
          });
        }else{
          //showToast(brochure.errmsg);
        }
      }
    }
    ).catchError((err) => {
      print(err)
    });
  }

  /**
   * 问?组件
   */
  Widget questionCircle(index){
    return InkWell(
      onTap: (){
        if(index == 0){
          //云视频
          print("云视频说明");
        }else{
          //学校视频
          print("学校视频说明");
        }
      },
      child: Container(
        alignment: Alignment(0,0),
        width: ScreenUtil().setWidth(30),
        height: ScreenUtil().setHeight(30),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(ScreenUtil().setWidth(20)),
            color: tabIndex == index ? Colors.red : Colors.grey
        ),
        child: Text("?",style: TextStyle(color: Colors.white),),
      )
    );
  }

  /**
   * 导航切换组件
   */
  Widget getTabWidget(TabBeanData _data){
    return InkWell(
      onTap: (){
        setState(() {
          tabItemId = _data.id;
          tabItemName = _data.name;
          videoTabList.clear();
          getCategoryByTab(_data.id);
        });

      },
      child: Container(
        alignment: Alignment(0,0),
        decoration: BoxDecoration(
            color: tabItemId == _data.id ? Colors.red : Colors.white,
            /*borderRadius: BorderRadius.only(
              topLeft: Radius.circular(ScreenUtil().setWidth(SizeUtil.getWidth(20)),),
              topRight: Radius.circular(ScreenUtil().setWidth(SizeUtil.getWidth(10)),),
              bottomLeft: Radius.circular(ScreenUtil().setWidth(SizeUtil.getWidth(10)),),
              bottomRight: Radius.circular(ScreenUtil().setWidth(SizeUtil.getWidth(20)),),
            ),*/
            borderRadius: BorderRadius.circular(SizeUtil.getAppWidth(35)),
            border: Border.all(width: 1.0,color: tabItemId == _data.id ? Colors.red : Colors.grey[200],)
        ),
        padding: EdgeInsets.only(
            left: ScreenUtil().setWidth(SizeUtil.getWidth(30)),
            right: ScreenUtil().setWidth(SizeUtil.getWidth(30)),
            top: ScreenUtil().setHeight(SizeUtil.getHeight(10)),
            bottom: ScreenUtil().setHeight(SizeUtil.getHeight(10)),
        ),
        margin: EdgeInsets.symmetric(
            horizontal: ScreenUtil().setWidth(SizeUtil.getWidth(10))
        ),
        child: Text(_data.name,style: TextStyle(color: tabItemId == _data.id ? Colors.white : Colors.black38,fontSize: ScreenUtil().setSp(SizeUtil.getFontSize(30))),),

      ),
    );
  }

  Widget getSchoolVideoTab1(Tab.Data item){
    return InkWell(
      onTap: (){
        //清理视频列表
        videoGroupList.clear();
        hideLoadMore();
        if(item.id == TAB_HOME){
          hasData = false;
        }else{
          hasData = true;
        }
        setState(() {
          tabItemId = item.id;
          tabItemName = item.name;
          selectTab1Name = item.name;
          getSchoolVideoChildTabs(item.id);
        });

      },
      child: Container(
        alignment: Alignment(0,0),
        decoration: BoxDecoration(
            color: tabItemId == item.id ? Colors.red : Colors.white,
            /*borderRadius: BorderRadius.only(
              topLeft: Radius.circular(ScreenUtil().setWidth(SizeUtil.getWidth(20)),),
              topRight: Radius.circular(ScreenUtil().setWidth(SizeUtil.getWidth(10)),),
              bottomLeft: Radius.circular(ScreenUtil().setWidth(SizeUtil.getWidth(10)),),
              bottomRight: Radius.circular(ScreenUtil().setWidth(SizeUtil.getWidth(20)),),
            ),*/
            borderRadius: BorderRadius.circular(SizeUtil.getAppWidth(35)),
            border: Border.all(width: 1.0,color: tabItemId == item.id ? Colors.red : Colors.grey[200],)
        ),
        padding: EdgeInsets.only(
          left: ScreenUtil().setWidth(SizeUtil.getWidth(30)),
          right: ScreenUtil().setWidth(SizeUtil.getWidth(30)),
          top: ScreenUtil().setHeight(SizeUtil.getHeight(10)),
          bottom: ScreenUtil().setHeight(SizeUtil.getHeight(10)),
        ),
        margin: EdgeInsets.symmetric(
            horizontal: ScreenUtil().setWidth(SizeUtil.getWidth(10))
        ),
        child: Text(item.name,style: TextStyle(color: tabItemId == item.id ? Colors.white : Colors.black38,fontSize: ScreenUtil().setSp(SizeUtil.getFontSize(30))),),

      ),
    );
  }

  /**
   * 学校视频分类2
   */
  Widget getSchoolVideoTab2(Tab.Data item){
    return InkWell(
      onTap: (){
        //获取分类的视频group
        tabItemId2 = item.id;
        selectTab2Name = item.name;
        videoGroupList.clear();
        hideLoadMore();
        getSchoolVideoGroup(tabid: tabItemId2);
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: SizeUtil.getWidth(20),
          vertical: SizeUtil.getHeight(10)
        ),
        /*margin: EdgeInsets.symmetric(
            horizontal: ScreenUtil().setWidth(SizeUtil.getWidth(10))
        ),*/
        child: Text(item.name,style: TextStyle(color: tabItemId2 == item.id ? Colors.red : Colors.black38,fontSize: ScreenUtil().setSp(SizeUtil.getFontSize(30)),
        fontWeight: tabItemId2 == item.id ? FontWeight.bold : FontWeight.normal),),

      ),
    );
  }

  /**
   * 招生简章Item
   */
  Widget getBrochureItem(M.Data _data){
    return InkWell(
      onTap: (){
        print("click icon:${_data.url}");
        showSchoolBrochure(_data.url);
        //Navigator.push(context, MaterialPageRoute(builder: (context)=>WebStage(url: _data.url, title: _data.label)));
      },
      child: Container(
        /*decoration: BoxDecoration(
          color:Constant.getColor()
        ),*/
        margin: EdgeInsets.only(
          left:ScreenUtil().setWidth(SizeUtil.getWidth(40))
        ),
        padding: EdgeInsets.only(
          left:ScreenUtil().setWidth(SizeUtil.getWidth(20)),
          right:ScreenUtil().setWidth(SizeUtil.getWidth(20)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(_data.icon,width: ScreenUtil().setWidth(SizeUtil.getWidth(100)),height: ScreenUtil().setHeight(SizeUtil.getHeight(100)),),
            SizedBox(height: ScreenUtil().setHeight(SizeUtil.getHeight(20)),),
            Text(_data.label,style: TextStyle(fontSize: ScreenUtil().setSp(SizeUtil.getFontSize(25)),color: Colors.black38),)
          ],
        ),
      ),
    );
  }

  /**
   * 视频分组条目
   */
  Widget getVideoGroup(V.Data _data){
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(ScreenUtil().setWidth(5))
      ),
      padding: EdgeInsets.only(
        left: ScreenUtil().setWidth(SizeUtil.getWidth(40)),
        right: ScreenUtil().setWidth(SizeUtil.getWidth(40)),
        top: ScreenUtil().setWidth(SizeUtil.getWidth(20))
      ),
      margin: EdgeInsets.only(
        top: ScreenUtil().setHeight(SizeUtil.getHeight(20))
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              vertical: ScreenUtil().setHeight(SizeUtil.getHeight(10))
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(_data.categoryname,style: Constant.titleTextStyle,),
                    EgWordWidget(),
                  ],
                ),
                //英文单词
                InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => VideoMorePage(subject: tabItemName,category: _data.categoryname,categoryid: _data.categoryid,)));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(SizeUtil.getWidth(15)),
                        border: Border.all(
                          color: Colors.black12,
                          width: 1
                        )
                    ),
                    padding: EdgeInsets.symmetric(
                        vertical: ScreenUtil().setHeight(SizeUtil.getHeight(10)),
                        horizontal: ScreenUtil().setWidth(SizeUtil.getWidth(20))
                    ),
                    alignment: Alignment(0,0),
                    child: Text("更多"),
                  ),
                )
              ],
            ),
          ),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _data.categorys.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisSpacing: ScreenUtil().setHeight(SizeUtil.getHeight(20)),
                mainAxisSpacing: ScreenUtil().setWidth(SizeUtil.getWidth(20)),
                crossAxisCount: 3,
                childAspectRatio: Constant.isPad ? 0.79 : 0.66
            ),
            itemBuilder: (context,index){
              return InkWell(
                onTap: (){
                  saveTrackVideo(tabItemId, _data.categoryid);
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>
                      VideoWeb(classify: tabItemName, section: _data.categoryname, category: _data.categorys[index].name, categoryid: _data.categorys[index].id,step:_data.categorys[index].step,description: _data.categorys[index].description,)
                  ));
                },
                child: VideoTile(title: tabItemName+"/"+_data.categoryname,data: _data.categorys[index],),
              );
            }
          )
        ],
      ),
    );
  }

  /**
   * 打开二维码扫描
   * 小红书格式 http://res.yimios.com?classify=素描&section=基础知识&category=苹果&categoryid=1
   */
  void _openQr() async{
    var result = await BarcodeScanner.scan();
    print(result.rawContent);
    //读取到小红书二维码信息然后进行解析
    if(result != null && result.rawContent != null && result.rawContent.indexOf("http://res.yimios.com") != -1){
      Uri _uri = Uri.parse(result.rawContent);
      int categoryid = int.parse(_uri.queryParameters["categoryid"]);
      //打开视频播放
      Navigator.push(context, MaterialPageRoute(builder: (context){
        return VideoWeb(classify: "", section: "", category:"", categoryid: categoryid, description: "",step: [],isqr: true,);
      }));
    }else{
      //showToast("无效的课程二维码");
    }
  }

  /**
   * 最新专栏数据
   */
  void columnGalleryList(){
    var option = {
      "page":1,
      "size":12,
    };
    httpUtil.post(DataUtils.api_columnlist,data: option).then((value){
      String result = checkLoginExpire(value);
      if(result.isNotEmpty) {
        COLUMN.ColumnListBean bean = COLUMN.ColumnListBean.fromJson(json.decode(result));
        if(bean.errno == 0){
          if(bean.data.length > 0){
            for(COLUMN.Data item in bean.data){
              columnNum += item.count;
            }
            setState(() {
              columnList.addAll(bean.data);
            });
          }
        }else{
          //showToast(bean.errmsg);
        }
      }
    });
  }

  /**
   * 网盘griditem
   */
  Widget getPanItem(COLUMN.Data item){
    print(item.url);
    return InkWell(
      child: Container(
        margin: EdgeInsets.only(
          bottom: ScreenUtil().setHeight(SizeUtil.getHeight(10))
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          /*borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(ScreenUtil().setWidth(10)),
            bottomRight: Radius.circular(ScreenUtil().setWidth(10))
          )*/
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(ScreenUtil().setWidth(5)),
                      child: CachedNetworkImage(imageUrl: Constant.parseNewColumnListIconString(item.url,0,0),fit: BoxFit.cover,),
                    ),
                  ),
                  Positioned(
                    child: Text("${item.count}张图片",style: TextStyle(fontSize: ScreenUtil().setSp(SizeUtil.getFontSize(25))),),
                    top: 5,
                    right: 5,
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  //left: ScreenUtil().setWidth(SizeUtil.getWidth(30)),
                  //right: ScreenUtil().setWidth(SizeUtil.getWidth(30)),
                  top: ScreenUtil().setHeight(SizeUtil.getHeight(10)),
                  bottom: ScreenUtil().setHeight(SizeUtil.getHeight(10)),
              ),
              child: Text(item.name,style: TextStyle(fontSize: ScreenUtil().setSp(SizeUtil.getFontSize(30))),maxLines: 1,),
            ),
            Padding(
              padding: EdgeInsets.only(
                  //left: ScreenUtil().setWidth(SizeUtil.getWidth(30)),
                  //right: ScreenUtil().setWidth(SizeUtil.getWidth(30)),
              ),
              child: Text(item.nickname != null ? item.nickname : item.username,style: Constant.smallTitleTextStyle,maxLines: 1,),
            ),
            //SizedBox(height: ScreenUtil().setHeight(SizeUtil.getHeight(30)),)
          ],
        ),
      ),
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>ColumnDetail(
          columnname: item.name,
          columnid: item.id,
          author: item.nickname == null ? item.username : item.nickname,
          uid: item.uid,
          count: item.count,
          avater: item.avater,
          issubscrible: item.subscrible > 0 ? true : false,
          cb: (id,subscrible){

          },
        )));
      },
    );
  }

  /**
   * banner 列表
   */
  Widget banner(){
    return Padding(
      padding: EdgeInsets.only(
          left: SizeUtil.getAppWidth(20),
          right: SizeUtil.getAppWidth(20),
          top:SizeUtil.getAppHeight(20)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: SizeUtil.getAppHeight(SizeUtil.getBannerHeight()),
            child: Swiper(
              itemCount: bannerList.length,
              autoplay: true,
              itemBuilder: (BuildContext context,int index){
                return InkWell(
                  onTap: (){
                    if(bannerList[index].weburl != null){
                      //跳转到对应的网页
                      Navigator.push(context, MaterialPageRoute(builder: (context) =>
                          WebStage(url: bannerList[index].weburl, title: "")
                      ));
                    }
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(SizeUtil.getAppWidth(10)),
                    child: CachedNetworkImage(imageUrl: bannerList[index].url,fit: BoxFit.cover),
                  )
                );
              },
            ),
          )
        ],
      ),
    );
  }

  @override
  void refresh() {

  }

  @override
  void loadmore() {
    //加载更多
    getSchoolVideoGroup(tabid: tabItemId2,more: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //顶部导航
            Container(
              height:SizeUtil.getAppHeight(SizeUtil.getTabHeight()),
              decoration: BoxDecoration(
                  color: Colors.white
              ),
              child: Stack(
                children: [
                  Positioned(
                    left: 0,
                    right: 0,
                    child: Container(
                      height:SizeUtil.getAppHeight(SizeUtil.getTabHeight()),
                      decoration: BoxDecoration(
                          color: Colors.white
                      ),
                      child:Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: (){
                              //showToast("学校暂未开启本功能");
                              hasData = false;
                              setState(() {
                                tabIndex = 1;
                                if(tabsList2.length == 0){
                                  //getTabs();
                                  getSchoolVideoTabs();
                                }else{
                                  tabItemId = tabsList2[0].id;
                                  tabItemName = tabsList2[0].name;
                                  hasData = false;
                                  videoTabList.clear();
                                  getCategoryByTab(tabItemId);
                                }
                              });
                            },
                            child: Container(
                              //child: Text("视频仓库",style: tabIndex == 1 ? this._tabSelectStyle : this._tabNormalStyle),
                              child: Image.asset(tabIndex == 1 ? "image/ic_video_tab_select.png" : "image/ic_video_tab_normal.png",
                                height: SizeUtil.getAppHeight(80),fit: BoxFit.contain,),
                            ),
                          ),
                          /*SizedBox(width: ScreenUtil().setWidth(SizeUtil.getWidth(20)),),
                          InkWell(
                            onTap: (){
                              //云视频
                              setState(() {
                                tabIndex = 0;
                                if(tabsList1.length == 0){
                                  getTabs();
                                }else{
                                  tabItemId = tabsList1[0].id;
                                  tabItemName = tabsList1[0].name;
                                  videoTabList.clear();
                                  getCategoryByTab(tabItemId);
                                }
                              });
                            },
                            child: Container(
                              //child: Text("全体系视频课",style: tabIndex == 0 ? this._tabSelectStyle : this._tabNormalStyle,),
                              child: Image.asset(tabIndex == 0 ? "image/ic_video_alltab_select.png" : "image/ic_video_alltab_normal.png",
                                height: SizeUtil.getAppHeight(80),fit: BoxFit.contain,),
                            ),
                          ),*/
                        ],
                      ),
                    ),
                  ),
                  //超级直播
                  //扫码
                  /*Positioned(
                    right: 0,
                    top:0,
                    bottom: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        *//*InkWell(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context) =>
                                  WebStage(url: 'https://support.qq.com/products/326279/faqs/121944', title: "")
                              ));
                            },
                            child:Image.asset("image/ic_tips.png",width: ScreenUtil().setWidth(48),height: ScreenUtil().setWidth(48),)
                        ),
                        SizedBox(width: ScreenUtil().setWidth(SizeUtil.getWidth(30)),),*//*
                        InkWell(
                            onTap: (){
                              _openQr();
                            },
                            child: Padding(
                              padding: EdgeInsets.only(
                                  left: ScreenUtil().setWidth(SizeUtil.getWidth(20)),
                                  right: ScreenUtil().setWidth(SizeUtil.getWidth(40))
                              ),
                              child: Image.asset("image/ic_qr.png",width: ScreenUtil().setWidth(36),height: ScreenUtil().setWidth(36),),
                            )
                        )
                      ],
                    ),
                  )*/
                ],
              ),
            ),
            //分类选项
            Container(
              height: SizeUtil.getAppHeight(SizeUtil.getTabHeight()),
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.white
              ),
              padding: EdgeInsets.only(
                  left: ScreenUtil().setWidth(SizeUtil.getWidth(20)),
                  right: ScreenUtil().setWidth(SizeUtil.getWidth(20)),
                  top: SizeUtil.getAppHeight(SizeUtil.getTabRadius()),
                  bottom: SizeUtil.getAppHeight(SizeUtil.getTabRadius())
              ),
              child: ListView.builder(itemBuilder:(context,index){
                //return getTabWidget(tabIndex == 0 ? tabsList1[index] : tabsList2[index]);
                return tabIndex == 0 ? getTabWidget(tabsList1[index]) : getSchoolVideoTab1(tabsList2[index]);
              },itemCount: tabIndex == 0 ? tabsList1.length : tabsList2.length,scrollDirection: Axis.horizontal,shrinkWrap: true,),
            ),
            //学校视频二级分类
            Offstage(
              offstage: (tabIndex == 0 || tabItemId == TAB_HOME) ? true : false,
              child: Container(
                height: ScreenUtil().setHeight(SizeUtil.getHeight(80)),
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.white
                ),
                child: ListView.builder(itemBuilder: (context,index){
                  return getSchoolVideoTab2(tabsList3[index]);
                },itemCount: tabsList3.length,scrollDirection: Axis.horizontal,shrinkWrap: true,),
              ),
            ),
            //欢迎语句
            /*Offstage(
              offstage: (tabItemId == TAB_HOME && tabIndex == 1) ? false : true,
              child: Container(
                width: double.infinity,
                color: Colors.white,
                padding: EdgeInsets.only(
                  left:SizeUtil.getAppWidth(40), right:SizeUtil.getAppWidth(40),bottom: SizeUtil.getAppHeight(30),
                ),
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "欢迎来到",
                        style: TextStyle(fontSize: SizeUtil.getAppFontSize(30),color: Colors.black54,),
                      ),
                      TextSpan(
                        text:"${schoolname}",
                        style: TextStyle(fontSize: SizeUtil.getAppFontSize(30),color: Color(0xFFff4100),),
                      ),
                      TextSpan(
                        text: "，以星光为引，赴山河之约。",
                        style: TextStyle(fontSize: SizeUtil.getAppFontSize(30),color: Colors.black54,),
                      )
                    ]
                  ),
                ),
              ),
            ),*/
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //banner
                    Offstage(
                      offstage: (tabItemId == TAB_HOME && tabIndex == 1) ? false : true,
                      child: banner(),
                    ),
                    //画室招生简章
                    Offstage(
                      offstage: (tabItemId == TAB_HOME && tabIndex == 1) ? false : true,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(ScreenUtil().setWidth(10)),
                          color: Colors.white
                        ),
                        margin: EdgeInsets.symmetric(
                          horizontal: ScreenUtil().setWidth(SizeUtil.getWidth(20)),
                          vertical: ScreenUtil().setHeight(SizeUtil.getHeight(20))
                        ),
                        padding: EdgeInsets.symmetric(
                          vertical: ScreenUtil().setHeight(SizeUtil.getHeight(40))
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: ScreenUtil().setWidth(SizeUtil.getWidth(40))),
                              child: RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: "欢迎来到$schoolname",
                                      style: TextStyle(fontSize: SizeUtil.getAppFontSize(36),color: Colors.black87,fontWeight: FontWeight.bold),
                                    ),
                                  ]
                                ),
                              ),
                              //child: Text("$schoolname",style: Constant.titleTextStyle,),
                            ),
                            SizedBox(height: ScreenUtil().setHeight(SizeUtil.getHeight(10)),),
                            Container(
                              width: double.infinity,
                              color: Colors.white,
                              padding: EdgeInsets.only(
                                left:SizeUtil.getAppWidth(40), right:SizeUtil.getAppWidth(40),bottom: SizeUtil.getAppHeight(30),
                              ),
                              child: RichText(
                                text: TextSpan(
                                    children: [
                                      /*TextSpan(
                                        text: "欢迎来到${schoolname}",
                                        style: TextStyle(fontSize: SizeUtil.getAppFontSize(30),color: Colors.black54,fontWeight: FontWeight.bold),
                                      ),*/
                                      /*TextSpan(
                                        text:"${schoolname}",
                                        style: TextStyle(fontSize: SizeUtil.getAppFontSize(30),color: Color(0xFFff4100),fontWeight: FontWeight.bold),
                                      ),*/
                                      TextSpan(
                                        text: "以星光为引，赴山河之约，2023万事顺遂。",
                                        style: TextStyle(fontSize: SizeUtil.getAppFontSize(25),color: Colors.black38,),
                                      )
                                    ]
                                ),
                              ),
                            ),
                            Container(
                              height: ScreenUtil().setHeight(SizeUtil.getHeight(180)),
                              width: double.infinity,
                              alignment: Alignment(0,0),
                              child: brochureList.length == 0 ?
                                  //Text("暂未设置内容",style: TextStyle(color: Colors.grey),)
                                  Row(
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(
                                          left:ScreenUtil().setWidth(SizeUtil.getWidth(40)),
                                        ),
                                        child: Image.asset("image/ic_school.png",width: ScreenUtil().setWidth(SizeUtil.getWidth(80)),height: ScreenUtil().setWidth(SizeUtil.getWidth(80)),),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                          left: ScreenUtil().setWidth(SizeUtil.getWidth(10))
                                        ),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(SizeUtil.getHeight(5))),
                                              child: Text("星光不问赶路人，时光不负有心人。",style: TextStyle(color: Colors.deepOrangeAccent,fontSize: ScreenUtil().setSp(SizeUtil.getFontSize(30))),),
                                            ),
                                            Text("$schoolname",style: TextStyle(color:Colors.black54,fontSize: ScreenUtil().setSp(SizeUtil.getFontSize(30))),)
                                          ],
                                        ),
                                      )
                                    ],
                                  )
                                :
                                  ListView.builder(itemCount: brochureList.length,scrollDirection: Axis.horizontal,addAutomaticKeepAlives:false,itemBuilder:(context,index){
                                return getBrochureItem(brochureList[index]);
                              }),
                            )
                          ],
                        ),
                      ),
                    ),
                    /*//网盘每日更新
                    Offstage(
                      offstage: (tabItemId == TAB_HOME && tabIndex == 1) ? false : true,
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(SizeUtil.getWidth(ScreenUtil().setWidth(5))))
                        ),
                        margin: EdgeInsets.only(
                            left: ScreenUtil().setWidth(20),right: ScreenUtil().setWidth(20),),
                        padding: EdgeInsets.symmetric(horizontal:ScreenUtil().setWidth(20),vertical: ScreenUtil().setHeight(20)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(20),vertical: ScreenUtil().setHeight(5)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("最新网盘图片",style: Constant.titleTextStyle,),
                                  InkWell(
                                    onTap: (){
                                      //切换到网盘
                                      widget.callback();
                                    },
                                    child: Image.asset("image/ic_more_column.png",width: ScreenUtil().setWidth(48),height: ScreenUtil().setWidth(48),),
                                  )
                                ],
                              ),
                            ),
                            //更新信息
                            Container(
                              margin: EdgeInsets.only(
                                  left: ScreenUtil().setWidth(20),right: ScreenUtil().setHeight(20),
                                  top:  ScreenUtil().setHeight(5),bottom: ScreenUtil().setHeight(20)
                              ),
                              child: Text("今日更新了${columnList.length}个网盘，共计$columnNum个文件",style: TextStyle(fontSize: ScreenUtil().setSp(SizeUtil.getFontSize(28)),color: Colors.grey),),
                            ),
                            //专题列表
                            GridView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: columnList.length,
                                padding: EdgeInsets.only(
                                    left: ScreenUtil().setWidth(SizeUtil.getWidth(20)),
                                    right: ScreenUtil().setWidth(SizeUtil.getWidth(20))
                                ),
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisSpacing: ScreenUtil().setWidth(SizeUtil.getWidth(20)),
                                    mainAxisSpacing: ScreenUtil().setWidth(SizeUtil.getWidth(20)),
                                    crossAxisCount: 3,
                                    childAspectRatio: Constant.isPad ? 0.79 : 0.66
                                ),
                                itemBuilder: (context,index){
                                  return getPanItem(columnList[index]);
                                }
                            ),
                          ],
                        ),
                      ),
                    ),
                    //图片广告
                    Offstage(
                      offstage: (tabItemId == TAB_HOME && tabIndex == 1) ? false : true,
                      child: Container(
                        height: ScreenUtil().setHeight(SizeUtil.getHeight(300)),
                        width: double.infinity,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(ScreenUtil().setWidth(10)),
                            color: Colors.white
                        ),
                        margin: EdgeInsets.only(
                          left: ScreenUtil().setWidth(SizeUtil.getWidth(20)),
                          right: ScreenUtil().setWidth(SizeUtil.getWidth(20)),
                          top: ScreenUtil().setHeight(SizeUtil.getHeight(20)),
                        ),
                        child: InkWell(
                          onTap: (){
                            //
                            Navigator.push(context, MaterialPageRoute(builder: (context) =>
                                WebStage(url: 'https://support.qq.com/products/326279/faqs/121955', title: "")
                            ));
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: Image.network("http://res.yimios.com:9050/videos/advert/ic_advert_m.jpg",fit:BoxFit.cover),
                          ),
                        ),
                        //child: videoInit ? VideoPlayer(_videoPlayerController) : SizedBox(),
                      ),
                    ),*/
                    //滚动广告
                    //SizedBox(height: SizeUtil.getAppHeight(20),),
                    //推荐视频
                    Offstage(
                      offstage: (tabItemId == TAB_HOME && tabIndex == 1) ? false : true,
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(Radius.circular(SizeUtil.getWidth(ScreenUtil().setWidth(5))))
                            ),
                            margin: EdgeInsets.only(
                                left: ScreenUtil().setWidth(20),right: ScreenUtil().setWidth(20),
                                top: ScreenUtil().setHeight(0),bottom: ScreenUtil().setHeight(40)),
                            padding: EdgeInsets.symmetric(horizontal:ScreenUtil().setWidth(20),vertical: ScreenUtil().setHeight(20)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                    margin: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(20)),
                                    child: Text("最新视频课程",style: Constant.titleTextStyle,)
                                ),
                                Container(
                                  height: ScreenUtil().setHeight(SizeUtil.getHeight(80)),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(ScreenUtil().setWidth(SizeUtil.getWidth(10)))
                                  ),
                                  margin: EdgeInsets.only(
                                    //bottom: ScreenUtil().setHeight(SizeUtil.getHeight(20)),
                                    //left: ScreenUtil().setHeight(SizeUtil.getWidth(20)),
                                    right: ScreenUtil().setHeight(SizeUtil.getWidth(20)),
                                    //top: ScreenUtil().setHeight(SizeUtil.getWidth(20)),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                      vertical: ScreenUtil().setHeight(SizeUtil.getHeight(20)),
                                      horizontal: ScreenUtil().setWidth(SizeUtil.getWidth(20))
                                  ),
                                  child: Marquee(textList: marquee,fontSize: ScreenUtil().setSp(SizeUtil.getFontSize(28)),textColor: Colors.grey,),
                                ),
                                //官方精选
                                Padding(
                                  padding: EdgeInsets.only(
                                    left:ScreenUtil().setWidth(SizeUtil.getWidth(20)),
                                    right:ScreenUtil().setWidth(SizeUtil.getWidth(20)),
                                    //top: ScreenUtil().setHeight(SizeUtil.getHeight(30)),
                                    //bottom: ScreenUtil().setHeight(SizeUtil.getHeight(80))
                                  ),
                                  child: GridView.builder(
                                      shrinkWrap: true,
                                      physics: const NeverScrollableScrollPhysics(),
                                      itemCount: choiceList.length,
                                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisSpacing: ScreenUtil().setWidth(SizeUtil.getWidth(20)),
                                          mainAxisSpacing: ScreenUtil().setWidth(SizeUtil.getWidth(20)),
                                          crossAxisCount: 3,
                                          childAspectRatio: Constant.isPad ? 0.79 : 0.76
                                      ),
                                      itemBuilder: (context,index){
                                        return InkWell(
                                          onTap: (){
                                            Navigator.push(context, MaterialPageRoute(builder: (context)=>
                                                VideoWeb(classify: choiceList[index].title.split("/")[0], section: choiceList[index].title.split("/")[1], category: choiceList[index].name, categoryid: choiceList[index].categoryid,
                                                  description: choiceList[index].description,step: [],)
                                            ));
                                          },
                                          child: VideoChoiceTile(title: choiceList[index].title,data: choiceList[index],),
                                        );
                                      }
                                  ),
                                )
                              ],
                            ),
                          ),
                          //更多
                          InkWell(
                            onTap: (){
                              showVideoTips("image/ic_image_video_tips.png");
                            },
                            child: Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(
                                horizontal: SizeUtil.getAppWidth(20)
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(SizeUtil.getAppWidth(10))
                                ),
                                child: Image.asset("image/ic_button_more.png",height: SizeUtil.getAppHeight(100),fit: BoxFit.contain,),
                              ),
                            ),
                          ),
                          SizedBox(height: SizeUtil.getAppHeight(100),)
                        ],
                      )
                    ),
                    //正常的分类显示
                    Offstage(
                      offstage: tabIndex == 0 ? false : true,
                      child: Column(
                        children: [
                          //banner
                          SizedBox(height: SizeUtil.getAppHeight(20),),
                          Container(
                            width: double.infinity,
                            child: bannerSingleWidget("image/ic_banner_offical.jpg",horizontal: 20,vertical: 0),
                          ),
                          Container(
                            color: Colors.white,
                            margin: EdgeInsets.only(
                                bottom: ScreenUtil().setHeight(SizeUtil.getHeight(100)),
                                left:  ScreenUtil().setWidth(SizeUtil.getWidth(20)),
                                right: ScreenUtil().setWidth(SizeUtil.getWidth(20)),
                                top:SizeUtil.getAppHeight(20)
                            ),
                            child: ListView.builder(
                                itemCount: videoTabList.length,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                addAutomaticKeepAlives: false,
                                itemBuilder: (_context,_index){
                                  return getVideoGroup(videoTabList[_index]);
                                }
                            ),
                          )
                        ],
                      ),
                    ),
                    //视频group
                    Offstage(
                      offstage: (tabIndex == 1 && tabItemId != TAB_HOME) ? false : true,
                      child: Container(
                          margin: EdgeInsets.only(top: SizeUtil.getAppHeight(20)),
                          child: Padding(
                            padding: EdgeInsets.only(
                              left:ScreenUtil().setWidth(SizeUtil.getWidth(20)),
                              right:ScreenUtil().setWidth(SizeUtil.getWidth(20)),
                              bottom:ScreenUtil().setWidth(SizeUtil.getWidth(40)),
                            ),
                            child: GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: videoGroupList.length,
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisSpacing: ScreenUtil().setWidth(SizeUtil.getWidth(20)),
                                    mainAxisSpacing: ScreenUtil().setWidth(SizeUtil.getWidth(20)),
                                    crossAxisCount: 2,
                                    childAspectRatio: Constant.isPad ? 2.1 : 1.2
                                ),
                                itemBuilder: (context,index){
                                  var _data = new C.Data(
                                      id: videoGroupList[index].id,
                                      name: videoGroupList[index].name,
                                      title: tabItemName,
                                      cover: videoGroupList[index].icon
                                  );
                                  return InkWell(
                                    onTap: (){
                                      //视频合集分类
                                      Navigator.push(context, MaterialPageRoute(builder: (context)=>
                                          SchoolVideoListPage(data: videoGroupList[index],tab1: selectTab1Name,tab2:selectTab2Name,)
                                      ));
                                    },
                                    child: SchoolVideoChoiceTile(title: videoGroupList[index].name,data: _data,),
                                  );
                                }
                            ),
                          )
                      ),
                    )
                  ],
                ),
              ),
            ),
            loadmoreUI()
          ],
        ),
      ),
    );
  }

}