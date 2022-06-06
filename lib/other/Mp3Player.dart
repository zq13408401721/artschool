import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yhschool/BaseState.dart';
import 'package:yhschool/bean/m_bean.dart';
import 'package:yhschool/utils/DataUtils.dart';
import 'package:yhschool/utils/HttpUtils.dart';
import 'package:yhschool/utils/SizeUtil.dart';
import 'package:yhschool/widgets/BackButtonWidget.dart';
import 'package:yhschool/widgets/RoundedButton.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Mp3Player extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return Mp3PlayerState();
  }
}

class Mp3PlayerState extends BaseState<Mp3Player>{

  WebViewController _webViewController;

  String name="",url="";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void loadMusic(){
    httpUtil.post(DataUtils.api_loadmusic,data:{}).then((value){
      MBean bean = MBean.fromJson(json.decode(value));
      if(bean.errno == 0){
        if(mounted){
          setState(() {
            name = bean.data[0].name;
            url = bean.data[0].url;
            _play();
          });
        }
      }else{
        showToast(bean.errmsg);
      }
    });
  }

  _play(){
    if(_webViewController != null){
      String audio_str = "javascript:addMusic('${name}','${url}')";
      _webViewController.evaluateJavascript(audio_str).then((value){
        print("添加mp3："+value);
      });
    }
  }

  /**
   * 定义js调用的通道
   */
  JavascriptChannel initJavascriptChannel(){
    return JavascriptChannel(name: "FClient", onMessageReceived: (JavascriptMessage msg){

    });
  }

  _loadAssetHtml() async{
    String htmlContent = await rootBundle.loadString("files/audio/audio_player.html");
    _webViewController.loadUrl(Uri.dataFromString(htmlContent,mimeType: 'text/html',encoding: Encoding.getByName('utf-8')).toString());
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          color: Colors.grey[100],
          child: Column(
            children: [
              BackButtonWidget(cb: (){
                Navigator.pop(context);
              }, title: "返回",),
              Container(
                height: ScreenUtil().setHeight(SizeUtil.getHeight(300)),
                child: WebView(
                  //initialMediaPlaybackPolicy:AutoMediaPlaybackPolicy.always_allow,
                  initialUrl: "",
                  javascriptMode: JavascriptMode.unrestricted,
                  //javascriptChannels: [initJavascriptChannel()].toSet(),
                  onWebViewCreated: (controller){
                    print("webview 初始化完成");
                    _webViewController = controller;
                    _loadAssetHtml();
                  },
                  onPageStarted: (String url){
                    print("start:$url");
                  },
                  onProgress: (int progress){
                    print("progress:$progress");
                  },
                  onPageFinished: (url){

                  },
                ),
              ),
              RoundedButton(click: (){
                loadMusic();
              }, label: "换一个", vertical:SizeUtil.getHeight(40).toInt(),margin_top: SizeUtil.getHeight(200).toInt(), margin_bottom: SizeUtil.getHeight(100).toInt(), margin_left: SizeUtil.getWidth(100).toInt(), margin_right: SizeUtil.getWidth(100).toInt(),)
            ],
          ),
        ),
      ),
    );
  }
}