
import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yhschool/BaseDialogState.dart';
import 'package:yhschool/BaseState.dart';
import 'package:yhschool/bean/video_step_bean.dart';
import 'package:yhschool/bean/video_tab.dart' as S;
import 'package:yhschool/gallery/SingleGalleryPageView.dart';
import 'package:yhschool/utils/BaseParam.dart';
import 'package:yhschool/utils/Constant.dart';
import 'package:yhschool/utils/DataUtils.dart';
import 'package:yhschool/utils/HttpUtils.dart';
import 'package:yhschool/utils/SizeUtil.dart';
import 'package:yhschool/widgets/BackButtonWidget.dart';
import 'package:yhschool/widgets/PushButtonWidget.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:yhschool/widgets/CollectVideoButton.dart';

import 'VideoList.dart' as vd;
import 'bean/entity_video_list.dart';
import 'bean/step_select_bean.dart';


class _VideoListParam extends BaseParam{
  _VideoListParam(categoryid,page,size){
    data = {
      "categoryid":categoryid,
      "page":page,
      "size":size
    };
    param = "categoryid:${categoryid}&page:${page}&size:${size}";
  }
}

class _VideoStepParam extends BaseParam{
  _VideoStepParam(categoryid){
    data = {
      "categoryid":categoryid
    };
    param = "categoryid:${categoryid}";
  }
}


class VideoWeb extends StatefulWidget{

  String classify; // 分类
  String section; //章节
  String category; //节点
  int categoryid; //小节的id
  String description; //描述
  List<S.Step> step; //步骤

  bool isqr; //是否扫码进入


  VideoWeb({Key key,@required this.classify,@required this.section,@required this.category,@required this.categoryid,@required this.description,@required this.step,@required this.isqr=false}):super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new VideoWebState()
      ..classify = this.classify
      ..section = this.section
      ..category = this.category
      ..categoryid = this.categoryid
      ..description = this.description
      ..step = this.step;
  }

}

class VideoWebState extends BaseDialogState{

  String classify; // 分类
  String section; //章节
  String category; //小节
  int categoryid; //最后的小节名称
  List<S.Step> step;
  String description;

  List<VideoListData> videoList=[]; //视频课程列表

  bool initVideo=false; // 初始化视频

  String curmodel = "vertical"; //当前屏幕横竖屏

  WebViewController _webViewController;  //

  int clickTime = 0;


  @override
  void initState() {
    //默认初始化设置为竖屏
    changeScreen();
    super.initState();
    getRole().then((value){
      setState(() {
        m_role = value;
      });
    });

    getVideoList();
    //如果没步骤图从网络上获取一次
    if(step != null && step.length == 0){
      _queryVideoStep();
    }
  }

  /**
   * 获取视频列表
   */
  getVideoList(){
    httpUtil.post(DataUtils.api_video_list,data:{
      "categoryid":categoryid,
      "page":1,
      "size":30
    },context: context).then((value){
      String result = checkLoginExpire(value);
      if(result.isNotEmpty){
        getVideoListReturn(new VideoList.fromJson(json.decode(value)));
      }
    }).catchError((err)=>{
      print(err)
    });
  }

  getVideoListReturn(VideoList result){
    if(result.info != null){
      classify = result.info.classify;
      section = result.info.section;
      category = result.info.category;
      description = result.info.desc;
    }
    if(result.data != null){
      Timer(Duration(seconds: 1), (){
        videoList.addAll(result.data);
        if(initVideo && _webViewController != null){
          initPlayerList(getVideoListJson());
        }
      });
    }
  }

  /**
   * 获取步骤图
   */
  void _queryVideoStep(){
    httpUtil.post(DataUtils.api_videostep,option:_VideoStepParam(categoryid)).then((value){
      String result = checkLoginExpire(value);
      if(result.isNotEmpty){
        VideoStepBean bean = VideoStepBean.fromJson(json.decode(value));
        if(bean.errno == 0){
          bean.data.forEach((element) {
            step.add(S.Step.fromJson(element.toJson()));
          });
          //如果播放器加载完成，添加步骤图
          if(initVideo){
            var content = "javascript:addStep(${getStepJson()})";
            _webViewController.evaluateJavascript(content).then((value){
              print("初始化播放器："+value);
            });
          }
        }
      }
    });
  }

  //切换横竖屏
  changeScreen(){
    if(curmodel == "vertical"){  //竖屏
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown
      ]);
    }else if(curmodel == "horizontal"){  //横屏
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight
      ]);
    }
  }

  /**
   * 定义js调用的通道
   */
  JavascriptChannel initJavascriptChannel(){
    return JavascriptChannel(name: "FClient", onMessageReceived: (JavascriptMessage msg){
      if(Platform.isAndroid){
        /*if(curmodel == "vertical"){
          curmodel = "horizontal";
          _webViewController.loadUrl("javascript:fullScreen();");
        }else if(curmodel == "horizontal"){
          curmodel = "vertical";
          _webViewController.loadUrl("javascript:normalScreen();");
        }*/
        if(curmodel != msg.message){
          setState(() {
            if(msg.message == "vertical"){
              curmodel = msg.message;
              _webViewController.loadUrl("javascript:normalScreen();");
              changeScreen();
              return;
            }else if(msg.message == "horizontal"){
              curmodel = msg.message;
              _webViewController.loadUrl("javascript:fullScreen();");
              changeScreen();
              return;
            }
          });
        }
      }
      //如果当前调用的是步骤图,打开查看步骤图面板
      if(msg.message == "push"){
        //推送这一章节课程到课堂

      }else{
        String result = msg.message;
        StepSelectBean bean = StepSelectBean.fromJson(json.decode(result));
        Navigator.push(context, MaterialPageRoute(builder: (context)=>SingleGalleryPageView(list: bean.data, position: bean.index)));
      }
    });
  }

  JavascriptChannel initJavascriptTips(){
    return JavascriptChannel(name: "FTips", onMessageReceived: (JavascriptMessage msg){
      print("tips:${msg.message}");
    });
  }


  Widget webPlayer(){

    return Container(
      child:WebView(
        initialMediaPlaybackPolicy:AutoMediaPlaybackPolicy.always_allow,
        initialUrl: Constant.isPad ? 'http://res.yimios.com:9050/html/player_ios_test.html' : 'http://res.yimios.com:9050/html/player_phone.html',
        javascriptMode: JavascriptMode.unrestricted,
        javascriptChannels: [initJavascriptChannel(),initJavascriptTips()].toSet(),
        onWebViewCreated: (controller){
          print("webview 初始化完成");
          _webViewController = controller;
          //_loadAssetHtml();
          //controller.loadUrl(Platform.isAndroid ? 'files/player_ios.html' : 'file://Frameworks/App.framework/flutter_assets/files/player_ios.html');
          //数据比播放器先创建好
        },
        onPageStarted: (String url){
          print("start:$url");
        },
        onProgress: (int progress){
          print("progress:$progress");
        },
        onPageFinished: (url){
          initVideo = true;
          print("加载播放器壳");
          if(videoList.isNotEmpty && videoList.length > 0){
            print("视频列表数据已经准备好：开始创建播放器");
            initPlayerList(getVideoListJson());
          }
        },
      ),
    );
  }

  _loadAssetHtml() async{
    String htmlContent = await rootBundle.loadString("files/player_ios.html");
    _webViewController.loadUrl(Uri.dataFromString(htmlContent,mimeType: 'text/html',encoding: Encoding.getByName('utf-8')).toString());
  }

  getVideoListJson(){
    //Map<String,List<Map<String,dynamic>>> list = new HashMap();
    List<Map<String,String>> list = [];

    for(VideoListData item in videoList){
      Map<String,String> map = {
        'ccid':"'${item.ccid}'",
        'url':"'${item.url}'",
        'name':"'${item.name}'",
      };
      list.add(map);
    }

    return list.toString();
  }

  getStepJson(){
    List<String> _list = [];
    if(step != null){
      step.forEach((element) {
        _list.add("\"${element.url}\"");
      });
    }
    return _list.toString();
  }

  int _isPad(){
    return Constant.isPad ? 0 : 1;
  }

  /**
   * 初始化播放器
   */
  initPlayerList(String info){
    //String param = "javascript:addList('"+info+"');";
    if(_webViewController != null){
      int height = Constant.isPad ? 350 : 200;
      String _description;
      if(!Constant.isPad){
        if(description != null && description.length > 90){
          _description = description.substring(0,90)+"...";
        }else{
          _description = description;
        }
      }else{
        _description = description;
      }

      print("description:$_description");
      var player = this.isAndroid ? "javascript:addAndroidPhoneList({data:$info},$height,'android',${Constant.STAGE_W},${Constant.STAGE_H},${getStepJson()},\"$_description\");"
          : "javascript:addPhoneList({data:$info},$height,${getStepJson()},\"$_description\");";
      //var player = "javascript:addPhoneList({data:$info},$height);";
      _webViewController.evaluateJavascript(player).then((value){
        print("初始化播放器："+value);
      });
    }
  }

  /**
   * 推送视频
   */
  void pushVideo(){
    showPushVideo(context,section+"/"+category,categoryid);
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: new Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Offstage(
                    offstage: curmodel == "horizontal",
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white
                      ),
                      child: Row(
                        mainAxisAlignment:MainAxisAlignment.spaceBetween,
                        children: [
                          BackButtonWidget(cb: (){
                            print("click:${curmodel}");
                            if(curmodel == "horizontal"){
                              curmodel = "vertical";
                              changeScreen();
                              _webViewController.loadUrl("javascript:normalScreen();");
                            }else if(curmodel == "vertical"){
                              //当前为双击
                              Navigator.pop(context);
                            }
                          }, title: "返回"),
                          m_role == 1 ?
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                CollectVideoButton(margin_right: 20,categoryid: categoryid,subject: classify,section: section,),
                                InkWell(
                                  onTap: (){
                                    pushVideo();
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.purple,
                                        borderRadius: BorderRadius.all(Radius.circular(SizeUtil.getAppWidth(5)))
                                    ),
                                    margin: EdgeInsets.only(right: SizeUtil.getAppWidth(20)),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: SizeUtil.getAppWidth(20),
                                        vertical: SizeUtil.getAppHeight(10)
                                    ),
                                    child: Text("推送到班级",style: TextStyle(fontSize: SizeUtil.getAppFontSize(25),color: Colors.white),),
                                  ),
                                )
                                /* m_role == 1 ?
                                PushButtonWidget(cb: (){
                                  pushVideo();
                                }, title: "推送") : SizedBox()*/
                              ],
                            ),
                          ) : SizedBox()
                        ],
                      ),
                    ),
                  ),
                  Expanded(child: webPlayer(),),
                ],
              )
          ),
        ),
        onWillPop: (){
          //返回键监听 如何当前是横屏，先调整为竖屏
          setState(() {
            if(curmodel == "horizontal"){
              curmodel = "vertical";
              changeScreen();
              _webViewController.loadUrl("javascript:normalScreen();");
            }else if(curmodel == "vertical"){
              if(DateTime.now().millisecondsSinceEpoch - clickTime < 300){
                //当前为双击
                Navigator.pop(context);
              }else{
                clickTime = DateTime.now().millisecondsSinceEpoch;
              }
            }
          });
        },
    );
  }
}