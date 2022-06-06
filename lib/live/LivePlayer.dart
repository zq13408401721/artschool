import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:yhschool/BaseState.dart';
import 'package:yhschool/live/LiveLinePage.dart';
import 'package:yhschool/utils/Constant.dart';
import 'package:yhschool/widgets/BackButtonWidget.dart';
import 'package:webview_flutter/webview_flutter.dart';

/**
 * 直播播放和回放
 */
class LivePlayer extends StatefulWidget{

  String url; //直播地址或回放地址
  String qr_url;
  String name;

  bool islive; //是否直播

  LivePlayer({Key key,@required this.name,@required this.url,@required this.qr_url,@required this.islive=true});

  @override
  State<StatefulWidget> createState() {
    return LivePlayerState();
  }
}

class LivePlayerState extends BaseState<LivePlayer>{
  @override
  void initState() {
    super.initState();
  }

  /**
   * 播放页面
   */
  Widget _player(){

    return WebView(
      initialUrl: "http://res.yimios.com:9050/pan/html/mobile.html",

      onWebViewCreated: (controller){
        print("webview 初始化完成");
        controller.loadUrl(widget.url);
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

      },
    );
  }

  /**
   * ios版本
   */
  Widget _playerIos(){
    return WebviewScaffold(url: widget.url);
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
              Container(
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    BackButtonWidget(cb: (){
                      Navigator.pop(context);
                    }, title: "返回"),
                    /*widget.islive ?
                    InkWell(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context){
                          return LiveLinePage(name: widget.name, qr_url: widget.qr_url, live_url: widget.url);
                        }));
                      },
                      child: Text("分享直播"),
                    ) : SizedBox()*/
                  ],
                ),
              ),
              Expanded(
                child: this.isAndroid ? _playerIos() : _playerIos(),
              )
            ],
          ),
        ),
      ),
    );
  }
}