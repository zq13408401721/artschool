import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/scheduler/ticker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yhschool/BaseState.dart';
import 'package:yhschool/bean/entity_home_bean.dart';
import 'package:yhschool/bean/entity_video_list.dart';
import 'package:yhschool/bean/entity_web_player.dart';
import 'package:yhschool/utils/Constant.dart';
import 'package:yhschool/utils/DataUtils.dart';
import 'package:yhschool/utils/HttpUtils.dart';
import 'package:video_player/video_player.dart';
import 'package:webview_flutter/platform_interface.dart';
import 'package:webview_flutter/webview_flutter.dart';

class VideoDetail extends StatefulWidget{

  String classify; // 分类
  String section; //章节
  String category; //节点
  int categoryid; //小节的id

  List<HomeBeanDataCategorysVideo> videoList; //视频课程列表

  VideoDetail({Key key,@required this.classify,@required this.section,@required this.category,@required this.categoryid}):super(key: key);


  @override
  State<StatefulWidget> createState() {
    return new VideoDetailState()
        ..classify = this.classify
        ..section = this.section
        ..category = this.category
        ..categoryid = this.categoryid;
  }

}


class VideoDetailState extends BaseState<VideoDetail> with SingleTickerProviderStateMixin {

  VideoPlayerController controller; //视频控制器
  bool playing = false;
  String playUrl="https://sprout-app.oss-cn-beijing.aliyuncs.com/a.mp4"; //播放地址

  String classify; // 分类
  String section; //章节
  String category; //小节
  int categoryid; //最后的小节名称
  int page=1,size=20;
  int initTimes=0; //初始化次数
  String webData; //播放器数据
  String videoid = ""; //当前播放得视频id
  double s_w = ScreenUtil().setWidth(window.physicalSize.width); //屏幕宽度
  double s_h = ScreenUtil().setHeight(Constant.VIDEO_HEIGHT); //初始化播放器的高度
  String videoName=""; //当前播放的视频名
  bool update = false;
  bool initVideo = false; //播放器是否初始化
  bool isVideoCreating = false; //创建播放器是否完成
  String debug="debug:"; //debug信息
  bool ready = false; //播放器是否

  //WebViewPlusController _webViewPlusController;
  WebViewController _webViewController;  //

  List<VideoListData> videoList=[]; //视频课程列表

  TabController tabController;
  bool initialized = false;

  @override
  void initState(){
    super.initState();
    tabController = new TabController(length:3,vsync:this);
    getVideoList();

  }


  /**
   * 获取视频播放
   */
  getWebPlayer(){
    //通过本地缓存的视频模版处理播放器
    getWebPlayerTemplete().then((value){
      if(value != null){
        setState(() {
          this.webData = value;//注入式修改播放器的宽高
          if(!initVideo){
            if(!isVideoCreating){
              this.addDebug("缓存播放器开始创建 isVideoCreating:$isVideoCreating");
              if(_webViewController != null){
                isVideoCreating = true;
                //替换播放器中的vid
                int start = webData.indexOf("vid=");
                int end = webData.indexOf("&siteid");
                String head = webData.substring(0,start);
                String foot = webData.substring(end,webData.length);
                String playerStr = head+"vid=$videoid$foot";
                var player = "javascript:addPlayer('$videoid',$s_h);";
                this.addDebug("播放器代码：$player");
                _webViewController.evaluateJavascript(player).then((value){
                  isVideoCreating = false;
                  if(value == 0){ //为0 表示视频添加是吧
                    initVideo = false;
                  }else{
                    initVideo = true;
                  }
                  this.addDebug("缓存视频模版初始化:$value");
                });
              }else{

                this.addDebug("webView 初始化还未完成");
              }
            }else{
              this.addDebug("正在创建网络播放器");
            }
          }else{
            selectVideo(this.videoid);
          }
        });
      }else{
        getWebPlayerOnline();
      }
    }).catchError((err){
      getWebPlayerOnline();
    });
  }

  /**
   * 获取在线播放器
   */
  getWebPlayerOnline(){
    var option={
      "videoid":this.videoid,
      "player_width":s_w,
      "player_height":s_h
    };
    httpUtil.post(DataUtils.api_web_player,data:option).then((value) {
      String result = checkLoginExpire(value);
      if(result.isNotEmpty){
        WebPlayer webPlayer = new WebPlayer.fromJson(json.decode(value));
        setState(() {
          this.addDebug("获取网络播放器返回：$value");
          /*int start = result.indexOf("width");
        int end = result.indexOf("&playerid");
        String content = "width="+s_w.toString()+"&height="+s_h.toString();
        result = result.replaceRange(start, end, content);*/
          saveWebPlayerTemplete(webPlayer.data); //保存视频播放器模版
          this.webData = webPlayer.data;//注入式修改播放器的宽高
          this.addDebug("当前播放器状态：initVideo $initVideo,isCreating $isVideoCreating");
          if(!initVideo){
            if(this.isVideoCreating == false){
              this.addDebug("网络播放器开始创建 isVideoCreating:$isVideoCreating");
              var player = "javascript:addPlayer('$videoid',$s_h);";
              this.addDebug("初始化播放器player：$player");
              if(_webViewController != null){
                this.isVideoCreating = true;
                this.addDebug("初始化网络播放器：$player");
                _webViewController.evaluateJavascript(player).then((value){
                  isVideoCreating = false;
                  if(value == 0){
                    this.initVideo = false;
                  }else{
                    this.initVideo = true;
                  }
                  this.addDebug("初始网络播放器完成:$value");
                });
              }else{
                this.addDebug("webview 初始化还未完成");
              }
            }else{
              this.addDebug("正在创建播放器");
            }
          }else{
            this.addDebug("播放器已经初始化，切换播放");
            selectVideo(this.videoid);
          }
        });
      }
    }).catchError((err)=>{
      print(err)
    });
  }

  /**
   * 切换课程
   */
  selectVideo(String ccid){
    if(_webViewController != null){
      var updatePlayer = "javascript:updatePlayer('"+ccid.trim()+"');";
      setState(() {
        this.addDebug("切换播放器："+updatePlayer);
      });
      _webViewController.evaluateJavascript(updatePlayer).then((value) {
        setState(() {
          this.addDebug("切换播放器完成：$value");
        });

      });
    }
  }

  @override
  void dispose(){
    if(controller != null){
      controller.dispose();
    }
    //视频播放器
    /*if(_webViewPlusController != null){
      _webViewPlusController.webViewController.clearCache();
    }*/
    super.dispose();
  }

  getVideoListReturn(VideoList result){
    if(result.errno != 0){
      return showToast(result.errmsg);
    }
    if(result.data != null){
      Timer(Duration(seconds: 1), ()=>{
        setState(() {
          videoList.addAll(result.data);
            if(result.data[0].ccid != null){
              this.videoid = result.data[0].ccid.toString().trim();
              this.videoName = result.data[0].name;
              if(ready){
                getWebPlayer();
              }
            }else{
              playUrl = result.data[0].url;
              showToast("未设置视频播放源");
            }
        })
      });

    }
  }

  /**
   * 获取视频列表
   */
  getVideoList(){
    var option={
      "categoryid":this.categoryid,
      "page":this.page,
      "size":this.size
    };
    httpUtil.post(DataUtils.api_video_list,data:option).then((value){
      print("getVideoList:${value}");
      String result = checkLoginExpire(value);
      if(result.isNotEmpty){
        getVideoListReturn(new VideoList.fromJson(json.decode(value)));
      }
    }).catchError((err)=>{
      print(err)
    });
  }

  /**
   * 网页播放器
   */
  Widget webPlayer(){

    return Container(
      height: s_h,
      child:WebView(
        initialUrl: Platform.isAndroid ? 'files/player.html' : 'http://res.yimios.com:9050/html/test_player.html',
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (controller){
          print("webview 初始化完成");
          _webViewController = controller;
          //controller.loadUrl(Platform.isAndroid ? 'files/player.html' : 'file://Frameworks/App.framework/flutter_assets/files/player.html');
          //数据比播放器先创建好
          if(videoList.isNotEmpty && videoList.length > 0 && !initVideo){
            print("视频列表数据已经准备好：开始创建播放器");
            getWebPlayer();
          }
        },
        onPageStarted: (String url){
          print("start:$url");
        },
        onProgress: (int progress){
          print("progress:$progress");
        },
        onPageFinished: (url){
          print("加载播放器壳");
          ready = true;
          getWebPlayer();
        },
      ),
    );
  }

  addDebug(bug){
    print(bug);
    setState(() {
      //debug += bug+"\n";
    });
  }

  /**
   * 目录布局页面
   */
  Widget sectionView(BuildContext context){
    setState(() {
      this.addDebug("渲染video列表:"+videoList.length.toString());
    });
    return Expanded(
      child: ListView.builder(
          itemCount: videoList.length,
          itemBuilder: (context,index) {
            var name = "第"+(index+1).toString()+"节   |   "+videoList[index].name;
            return Padding(
              padding: EdgeInsets.only(top: 5,bottom: 5),
              child: GestureDetector(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(name,style: TextStyle(fontSize: ScreenUtil().setSp(32)),),
                    Container(
                      padding: EdgeInsets.fromLTRB(10.0, 4, 10, 4),
                      decoration: BoxDecoration(
                          border: Border.all(color: videoid == videoList[index].ccid ? Constant.BUTTON_BG : Constant.COLOR_BTN_BORDER_NORMAL),
                          borderRadius: BorderRadius.circular(15),
                          color: videoid == videoList[index].ccid ? Colors.white : Constant.COLOR_BTN_BG
                      ),
                      child: Text("播放",style: TextStyle(color: videoid == videoList[index].ccid ? Constant.BUTTON_BG : Colors.black),),
                    )
                  ],
                ),
                onTap: (){
                  setState(() {
                    //
                    if(videoList[index].ccid != null && this.videoid != videoList[index].ccid){
                      this.videoid = videoList[index].ccid.toString().trim();
                      this.videoName = videoList[index].name;
                      if(!initVideo){
                        getWebPlayer(); //如果没有初始化播放器
                      }else{
                        selectVideo(this.videoid);
                      }
                      /*String url = "javascript:updatePlayer('https://p.bokecc.com/player?vid=431CD610F5CBA5B20498CE5AAF1F53F5&siteid=A478E06B5AA1107B&autoStart=true&width=768&height=350&playerid=A92CF5EBD279AF74&playertype=1');";
                      _webViewPlusController.webViewController.evaluateJavascript(url).then((value) => {
                        print(value)
                      });*/

                    }else{
                      playUrl = videoList[index].url;
                    }

                  });
                },
              ),
            );
          }
      ),
    );
  }

  /**
   * 当前课程详情信息
   */
  Widget detailInfoView(){
    return Container();
  }

  /**
   * 评论页面
   */
  Widget discussView(){
    return Container();
  }

  //课程信息
  Widget infoView(){
    return Container(
      height: 60,
      padding: EdgeInsets.fromLTRB(Constant.PADDING_LEFT, 0, Constant.PADDING_RIGHT, 0),
      alignment: Alignment(-1,0),
      child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(classify,
                  style: TextStyle(
                      fontSize: Constant.FONT_TITLE_SIZE,
                      color: Constant.COLOR_TITLE
                  ),
                ),
                Text(section+"-"+category,
                  style: TextStyle(
                    fontSize: Constant.FONT_GRID_NAME_SIZE,
                  ),
                ),
              ],
            ),
            Text("$videoName",
              textAlign: TextAlign.start,
              style: TextStyle(
                fontSize: ScreenUtil().setSp(32),
                color: Colors.black,
              ),
            )
          ],
        ),
        TextButton.icon(onPressed: ()=>{
          print("视频推送")
        }, icon:Icon(Icons.share), label: Text("推送"))
      ],
    ),
    );
  }


  //标题
  Widget createTitle(BuildContext context){
    return Container(
      height: ScreenUtil().setHeight(80),
      padding: EdgeInsets.only(left: ScreenUtil().setWidth(Constant.PADDING_LEFT)),
      child: Row(
        children: [
          Align(
            alignment: Alignment(-1,0),
            child: GestureDetector(
              child: Text("返回"),
              onTap: (){
                print("返回");
                Navigator.pop(context);
              },
            ),
          ),
          Expanded(
              child: Container(
                alignment: Alignment(0,0),
                child: Text('$videoName'),
              )
          )

        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            createTitle(context),
            webPlayer(),
            //createPlayer(),
            infoView(),
            Divider(),
            Container(
              height: ScreenUtil().setHeight(80),
              child: TabBar(
                controller: tabController,
                tabs: <Tab>[
                  Tab(
                    child: Text("目录",style: TextStyle(color: Constant.COLOR_TITLE,fontSize: ScreenUtil().setSp(42)),),
                  ),
                  Tab(
                    child: Text("详情",style: TextStyle(color: Constant.COLOR_TITLE,fontSize: ScreenUtil().setSp(42)),),
                  ),
                  Tab(
                    child: Text("评论",style: TextStyle(color: Constant.COLOR_TITLE,fontSize: ScreenUtil().setSp(42)),),
                  )
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                  controller: tabController,
                  children: [
                    //sectionView(context),
                    ListView.builder(
                        itemCount: videoList.length,
                        itemBuilder: (context,index) {
                          var name = "第"+(index+1).toString()+"节   |   "+videoList[index].name;
                          return Padding(
                            padding: EdgeInsets.only(top: 5,bottom: 5,left: 10,right: 10),
                            child: GestureDetector(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(name,style: TextStyle(fontSize: ScreenUtil().setSp(32)),),
                                  Container(
                                    padding: EdgeInsets.fromLTRB(10.0, 4, 10, 4),
                                    decoration: BoxDecoration(
                                        border: Border.all(color: videoid == videoList[index].ccid ? Constant.BUTTON_BG : Constant.COLOR_BTN_BORDER_NORMAL),
                                        borderRadius: BorderRadius.circular(15),
                                        color: videoid == videoList[index].ccid ? Colors.white : Constant.COLOR_BTN_BG
                                    ),
                                    child: Text("播放",style: TextStyle(color: videoid == videoList[index].ccid ? Constant.BUTTON_BG : Colors.black),),
                                  )
                                ],
                              ),
                              onTap: (){
                                setState(() {
                                  //showToast("点击视频："+videoList[index].ccid.toString()+" 当前videoid："+this.videoid);
                                  //
                                  if(videoList[index].ccid != null){
                                    if(this.videoid != videoList[index].ccid){ //正在播放
                                      this.videoid = videoList[index].ccid.toString().trim();
                                      this.videoName = videoList[index].name;
                                      if(!initVideo){
                                        getWebPlayer(); //如果没有初始化播放器
                                      }else{
                                        selectVideo(this.videoid);
                                      }
                                    }else{
                                      showToast("正在播放");
                                    }
                                  }else{
                                    playUrl = videoList[index].url;
                                    showToast("没有设置视频播放源");
                                  }

                                });
                              },
                            ),
                          );
                        }
                    ),
                    detailInfoView(),
                    discussView()
                  ]
              ),
            )
          ],
        ),
    /*child: Stack(
          children: [

            Align(
              alignment: Alignment(1,-1),
              child: Container(
                width: 200,
                height: 400,
                child: SingleChildScrollView(
                  child: Text("$debug"),
                )
              ),
            )
          ],
        ),*/
      )
    );
  }


}