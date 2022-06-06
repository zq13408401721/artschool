import 'dart:convert';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yhschool/VersionState.dart';
import 'package:yhschool/VideoMore.dart';
import 'package:yhschool/bean/advert_video_bean.dart';
import 'package:yhschool/bean/entity_tab_bean.dart';
import 'package:yhschool/bean/live_room_bean.dart';
import 'package:yhschool/bean/school_brochure_bean.dart' as M;
import 'package:yhschool/bean/video_a_i_bean.dart';
import 'package:yhschool/bean/video_tab.dart' as V;
import 'package:yhschool/live/LivePage.dart';
import 'package:yhschool/other/AdvertVideoPage.dart';
import 'package:yhschool/other/QRViewPage.dart';
import 'package:yhschool/utils/BaseParam.dart';
import 'package:yhschool/utils/Constant.dart';
import 'package:yhschool/utils/DataUtils.dart';
import 'package:yhschool/utils/HttpUtils.dart';
import 'package:yhschool/utils/SizeUtil.dart';
import 'package:yhschool/video/VideoChoiceTile.dart';
import 'package:yhschool/video/VideoEditorTab.dart';
import 'package:yhschool/video/VideoMorePage.dart';
import 'package:yhschool/video/VideoTile.dart';
import 'package:yhschool/widgets/EgWordWidget.dart';
import 'package:yhschool/widgets/Marquee.dart';
import 'package:yhschool/bean/choice_bean.dart' as C;
import 'package:yhschool/bean/user_bean.dart' as U;
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:video_player/video_player.dart';
import '../VideoWeb.dart';
import '../WebStage.dart';
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

class VideoPage extends StatefulWidget{

  VideoPage({Key key}):super(key: key);

  @override
  State<StatefulWidget> createState() {
    return VideoPageState();
  }
}

class VideoPageState extends VersionState{

  TextStyle _tabSelectStyle;
  TextStyle _tabNormalStyle;

  int tabIndex = 0; // 0云视频 1学校视频
  List<TabBeanData> tabsList1 = [];
  List<TabBeanData> tabsList2 = [];
  int tabItemId = 0;
  String tabItemName;
  var videoMap;
  List<V.Data> videoTabList = [];
  //AI推荐视频
  List<Videos> aiList = [];
  //官方精选
  List<C.Data> choiceList = [];


  List<String> marquee = [];
  TextStyle marqueeStyle;

  //招生简章相关数据
  List<M.Data> brochureList=[];
  String schoolname = "";

  LiveRoomBean _liveRoomBean;
  //视频广告
  AdvertVideoBean _advertVideoBean;

  VideoPlayerController _videoPlayerController;
  bool videoInit=false;

  @override
  void initState() {
    super.initState();
    print("VideoPage initState");
    videoMap = Map();
    _tabSelectStyle = TextStyle(fontSize: ScreenUtil().setSp(SizeUtil.getFontSize(40)),fontWeight: FontWeight.bold,color: Colors.red);
    _tabNormalStyle = TextStyle(fontSize: ScreenUtil().setSp(SizeUtil.getFontSize(30)),color: Colors.black87);
    marqueeStyle = TextStyle(fontSize: ScreenUtil().setSp(SizeUtil.getFontSize(36)),color: Colors.black54);
    getUserInfo().then((value){
      setState(() {
        schoolname = value["schoolname"];
      });
    });

    _videoPlayerController = VideoPlayerController.network("http://res.yimios.com:9050/videos/advert.mp4");
    _videoPlayerController.initialize().then((value){
      setState(() {
        videoInit = true;
      });
    });
    _videoPlayerController.play();

    getTabs();
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
  void checkAdvert(){
    Navigator.push(context, MaterialPageRoute(builder: (_context)=>AdvertVideoPage()));
  }

  /**
   * 获取直播房间信息
   */
  void getLiveRoom(){
    httpUtil.post(DataUtils.api_liveroom,data:{},context: context).then((value){
       _liveRoomBean = LiveRoomBean.fromJson(json.decode(value));
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
          }else{
            tabsList2.addAll(_tabBean.data);
          }
          tabItemId = _tabBean.data[0].id;
          tabItemName = _tabBean.data[0].name;
          getCategoryByTab(_tabBean.data[0].id);
        });
      }
    }).catchError((err){

    });
  }

  /**
   * 获取一级目录tab对应的章节数据
   */
  void getCategoryByTab(int categoryid){
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
          print(result);
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
        decoration: BoxDecoration(
            color: tabItemId == _data.id ? Colors.red : Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(ScreenUtil().setWidth(SizeUtil.getWidth(20)),),
              topRight: Radius.circular(ScreenUtil().setWidth(SizeUtil.getWidth(10)),),
              bottomLeft: Radius.circular(ScreenUtil().setWidth(SizeUtil.getWidth(10)),),
              bottomRight: Radius.circular(ScreenUtil().setWidth(SizeUtil.getWidth(20)),),
            ),
            border: Border.all(width: 1.0,color: tabItemId == _data.id ? Colors.red : Colors.grey[200],)
        ),
        padding: EdgeInsets.only(
            left: ScreenUtil().setWidth(SizeUtil.getWidth(30)),
            right: ScreenUtil().setWidth(SizeUtil.getWidth(30)),
            top: ScreenUtil().setHeight(SizeUtil.getHeight(15)),
            bottom: ScreenUtil().setHeight(SizeUtil.getHeight(15)),

        ),
        margin: EdgeInsets.symmetric(
            horizontal: ScreenUtil().setWidth(SizeUtil.getWidth(10))
        ),
        child: Text(_data.name,style: TextStyle(color: tabItemId == _data.id ? Colors.white : Colors.black87,fontSize: ScreenUtil().setSp(SizeUtil.getFontSize(30))),),

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
        decoration: BoxDecoration(
          color:Constant.getColor()
        ),
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
            Image.network(_data.icon,width: ScreenUtil().setWidth(SizeUtil.getWidth(50)),height: ScreenUtil().setHeight(SizeUtil.getHeight(50)),),
            SizedBox(height: ScreenUtil().setHeight(SizeUtil.getHeight(10)),),
            Text(_data.label,style: TextStyle(fontSize: ScreenUtil().setSp(SizeUtil.getFontSize(25))),)
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
      padding: EdgeInsets.symmetric(
        horizontal: ScreenUtil().setWidth(SizeUtil.getWidth(20))
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
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(_data.categoryname,style: Constant.titleTextStyle,),
                //英文单词
                Expanded(
                  child: EgWordWidget(),
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
          ),
          InkWell(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => VideoMorePage(subject: tabItemName,category: _data.categoryname,categoryid: _data.categoryid,)));
            },
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                borderRadius: BorderRadius.circular(SizeUtil.getWidth(10))
              ),
              padding: EdgeInsets.symmetric(
                  vertical: ScreenUtil().setHeight(SizeUtil.getHeight(30))
              ),
              alignment: Alignment(0,0),
              margin: EdgeInsets.symmetric(
                vertical: ScreenUtil().setHeight(SizeUtil.getHeight(20))
              ),
              child: Text("更多课程"),
            ),
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
              height:ScreenUtil().setHeight(SizeUtil.getHeight(Constant.SIZE_TOP_BAR_HEIGHT)),
              decoration: BoxDecoration(
                color: Colors.white
              ),
              padding: EdgeInsets.only(
                  /*top: ScreenUtil().setHeight(SizeUtil.getHeight(24)),
                  bottom: ScreenUtil().setHeight(SizeUtil.getHeight(10)),*/
                  left: ScreenUtil().setWidth(SizeUtil.getWidth(30))
              ),
              child:Row(
                children: [
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
                      child: Text("云视频",style: tabIndex == 0 ? this._tabSelectStyle : this._tabNormalStyle,),
                    ),
                  ),
                  SizedBox(width: ScreenUtil().setWidth(SizeUtil.getWidth(30)),),
                  InkWell(
                    onTap: (){
                      //showToast("学校暂未开启本功能");
                      setState(() {
                            tabIndex = 1;
                            if(tabsList2.length == 0){
                              getTabs();
                            }else{
                              tabItemId = tabsList2[0].id;
                              tabItemName = tabsList2[0].name;
                              videoTabList.clear();
                              getCategoryByTab(tabItemId);
                            }
                          });
                    },
                    child: Container(
                      child: Text("学校视频",style: tabIndex == 1 ? this._tabSelectStyle : this._tabNormalStyle),
                    ),
                  ),
                  SizedBox(width: ScreenUtil().setWidth(SizeUtil.getWidth(30)),),
                  //超级直播
                  /*InkWell(
                    onTap: (){
                      //print(_liveRoomBean);
                      //showToast("学校暂未开启本功能");
                      if(_liveRoomBean != null){
                        if(_liveRoomBean.errno == 0){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>LivePage(roomid: _liveRoomBean.data.roomid,schoolname: this.schoolname,)));
                        }else{
                          //showToast(_liveRoomBean.errmsg);
                        }
                      }
                    },
                    child: Container(
                      alignment: Alignment.center,
                      child: Image.asset("image/ic_live.png",width: ScreenUtil().setWidth(SizeUtil.getWidth(100)),height: ScreenUtil().setHeight(SizeUtil.getHeight(36)),),
                    ),
                  ),*/
                  //扫码
                  Expanded(child:Container(
                    alignment: Alignment(1,0),
                    child: InkWell(
                      onTap: (){
                        _openQr();
                      },
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: ScreenUtil().setWidth(SizeUtil.getWidth(20)),
                          right: ScreenUtil().setWidth(SizeUtil.getWidth(40))
                        ),
                        child: Image.asset("image/ic_qr.png",width: ScreenUtil().setWidth(40),height: ScreenUtil().setWidth(40),),
                      )
                    ),
                  ),),
                  /*Expanded(child: InkWell(
                    onTap: (){
                      checkAdvert();
                    },
                    child: Container(
                      height: ScreenUtil().setHeight(SizeUtil.getHeight(100)),
                      alignment: Alignment(0.8,0),
                      child: Text(Constant.isPad ? "什么是艺画视频课程？" : "视频介绍",style: TextStyle(color: Colors.grey,fontSize: ScreenUtil().setSp(SizeUtil.getFontSize(25))),),
                    ),
                  ))*/
                ],
              ),
            ),
            Container(
              height: ScreenUtil().setHeight(SizeUtil.getHeight(110)),
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.white
              ),
              padding: EdgeInsets.only(
                  left: ScreenUtil().setWidth(SizeUtil.getWidth(20)),
                  right: ScreenUtil().setWidth(SizeUtil.getWidth(20)),
                  bottom: ScreenUtil().setHeight(SizeUtil.getHeight(30)),
                  //top: ScreenUtil().setHeight(SizeUtil.getHeight(15))
              ),
              child: ListView.builder(itemBuilder:(context,index){
                return getTabWidget(tabIndex == 0 ? tabsList1[index] : tabsList2[index]);
              },itemCount: tabIndex == 0 ? tabsList1.length : tabsList2.length,scrollDirection: Axis.horizontal,shrinkWrap: true,),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //视频广告
                    //http://res.yimios.com:9050/videos/advert.mp4
                    Container(
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
                              WebStage(url: 'https://support.qq.com/products/326279/faqs/119498', title: "")
                          ));
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: Image.network("http://res.yimios.com:9050/videos/advert/ic_advert.jpg",fit:BoxFit.cover),
                        ),
                      ),
                      //child: videoInit ? VideoPlayer(_videoPlayerController) : SizedBox(),
                    ),
                    //画室招生简章
                    Offstage(
                      offstage: (tabItemId == 0 && tabIndex == 0) ? false : true,
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
                              child: Text("$schoolname",style: Constant.titleTextStyle,),
                            ),
                            SizedBox(height: ScreenUtil().setHeight(SizeUtil.getHeight(20)),),
                            Container(
                              height: ScreenUtil().setHeight(SizeUtil.getHeight(150)),
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
                                          left: ScreenUtil().setWidth(SizeUtil.getWidth(20))
                                        ),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(SizeUtil.getHeight(5))),
                                              child: Text("星光不问赶路人，时光不负有心人。",style: TextStyle(color: Colors.deepOrangeAccent,fontSize: ScreenUtil().setSp(SizeUtil.getFontSize(30))),),
                                            ),
                                            Text("欢迎来到$schoolname。",style: TextStyle(color:Colors.black54,fontSize: ScreenUtil().setSp(SizeUtil.getFontSize(30))),)
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

                            /*ListView.builder(itemBuilder: (context,index)=>Text("招生简章"),
                              itemCount: brochureList.length,scrollDirection: Axis.horizontal,)*/
                          ],
                        ),
                      ),
                    ),
                    //滚动广告
                    Offstage(
                      offstage: (tabItemId == 0 && tabIndex == 0) ? false : true,
                      child: Container(
                        height: ScreenUtil().setHeight(SizeUtil.getHeight(100)),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(ScreenUtil().setWidth(SizeUtil.getWidth(10)))
                        ),
                        margin: EdgeInsets.only(
                          bottom: ScreenUtil().setHeight(SizeUtil.getHeight(20)),
                          left: ScreenUtil().setHeight(SizeUtil.getWidth(20)),
                          right: ScreenUtil().setHeight(SizeUtil.getWidth(20))
                        ),
                        padding: EdgeInsets.symmetric(
                          vertical: ScreenUtil().setHeight(SizeUtil.getHeight(20)),
                          horizontal: ScreenUtil().setWidth(SizeUtil.getWidth(40))
                        ),
                        child: Marquee(textList: marquee,fontSize: ScreenUtil().setSp(SizeUtil.getFontSize(30)),),
                      ),
                    ),
                    //官方精选
                    Offstage(
                      offstage: (tabItemId == 0 && tabIndex == 0) ? false : true,
                      child: Padding(
                        padding: EdgeInsets.only(
                          left:ScreenUtil().setWidth(SizeUtil.getWidth(20)),
                          right:ScreenUtil().setWidth(SizeUtil.getWidth(20)),
                          top: ScreenUtil().setHeight(SizeUtil.getHeight(30)),
                          bottom: ScreenUtil().setHeight(SizeUtil.getHeight(80))
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /*Padding(
                              padding: EdgeInsets.only(
                                  bottom:ScreenUtil().setHeight(SizeUtil.getHeight(20))
                              ),
                              child: Text("官方精选",style:Constant.titleTextStyle,),
                            ),*/
                            GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: choiceList.length,
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisSpacing: ScreenUtil().setWidth(SizeUtil.getWidth(20)),
                                    mainAxisSpacing: ScreenUtil().setWidth(SizeUtil.getWidth(20)),
                                    crossAxisCount: 3,
                                    childAspectRatio: Constant.isPad ? 0.79 : 0.66
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
                          ],
                        ),
                      ),
                    ),
                    //AI推荐
                    /*Offstage(
                      offstage: (tabItemId == 0 && tabIndex == 0) ? false : true,
                      child: Padding(
                        padding: EdgeInsets.only(
                          left:ScreenUtil().setWidth(SizeUtil.getWidth(20)),
                          right:ScreenUtil().setWidth(SizeUtil.getWidth(20)),
                          top: ScreenUtil().setHeight(SizeUtil.getHeight(30))
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                bottom:ScreenUtil().setHeight(SizeUtil.getHeight(20))
                              ),
                              child: Text("AI推荐",style:Constant.titleTextStyle,),
                            ),
                            GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: aiList.length,
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisSpacing: ScreenUtil().setWidth(SizeUtil.getWidth(20)),
                                    mainAxisSpacing: ScreenUtil().setWidth(SizeUtil.getWidth(20)),
                                    crossAxisCount: 3,
                                    childAspectRatio: Constant.isPad ? 0.79 : 0.66
                                ),
                                itemBuilder: (context,index){
                                  return InkWell(
                                    onTap: (){
                                      saveTrackVideo(aiList[index].subjectid, aiList[index].categoryid);
                                      List<V.Step> stepList = [];
                                      aiList[index].step.forEach((element) {
                                        stepList.add(V.Step.fromJson(element.toJson()));
                                      });
                                      Navigator.push(context, MaterialPageRoute(builder: (context)=>
                                          VideoWeb(classify: aiList[index].subjectname, section: aiList[index].categoryname, category: aiList[index].name, categoryid: aiList[index].id,
                                          description: aiList[index].description,step: stepList,)
                                      ));
                                    },
                                    child: VideoAITile(title: aiList[index].subjectname+"/"+aiList[index].categoryname,data: aiList[index],),
                                  );
                                }
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: ScreenUtil().setHeight(SizeUtil.getHeight(10)),),*/
                    //换一组
                    /*Offstage(
                      offstage: (tabItemId == 0 && tabIndex == 0) ? false : true,
                      child: InkWell(
                        onTap: (){
                          //重新随机一组AI对应的视频课程
                          getAIVideo();
                        },
                        child: Padding(
                          padding: EdgeInsets.only(
                            bottom: ScreenUtil().setHeight(SizeUtil.getHeight(80)),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                                color:Colors.red,
                                borderRadius: BorderRadius.circular(ScreenUtil().setWidth(SizeUtil.getWidth(20)))
                            ),
                            padding: EdgeInsets.symmetric(
                                vertical: ScreenUtil().setHeight(SizeUtil.getHeight(40))
                            ),
                            margin: EdgeInsets.only(
                                left:ScreenUtil().setWidth(SizeUtil.getWidth(80)),
                                right:ScreenUtil().setWidth(SizeUtil.getWidth(80)),
                                top:ScreenUtil().setHeight(SizeUtil.getHeight(80)),
                                bottom:ScreenUtil().setHeight(SizeUtil.getHeight(80))
                            ),
                            alignment: Alignment(0,0),
                            child: Text("换一组",style: TextStyle(color: Colors.white,fontSize: ScreenUtil().setSp(SizeUtil.getFontSize(30))),),
                          ),
                        ),
                      ),
                    ),*/
                    //正常的分类显示
                    Offstage(
                      offstage: (tabItemId == 0 && tabIndex == 0) ? true : false,
                      child: Padding(
                        padding: EdgeInsets.only(
                          bottom: ScreenUtil().setHeight(SizeUtil.getHeight(100))
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
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

}