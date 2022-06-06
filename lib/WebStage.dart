import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:yhschool/utils/SizeUtil.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebStage extends StatelessWidget{

  String url;
  String title;
  bool ishttp=false;
  WebViewController _webViewController;
  WebStage({Key key,@required this.url,@required this.title}):super(key: key);

  // 加载本地html
  _loadLocalHtml() async{
    String htmlContent = await rootBundle.loadString(this.url);
    if(_webViewController != null){
      _webViewController.loadUrl(Uri.dataFromString(htmlContent,mimeType: 'text/html',encoding: Encoding.getByName('utf-8')).toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    this.ishttp = url.indexOf("http") != -1 || url.indexOf("https") != -1;
    print("ishttp:$ishttp");
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.only(left: ScreenUtil().setWidth(20),top: ScreenUtil().setHeight(20),bottom: ScreenUtil().setHeight(20),right: ScreenUtil().setWidth(20)),
                  child: GestureDetector(
                    child: Icon(
                      Icons.arrow_back,
                      size: 24,
                    ),
                    onTap: (){
                      Navigator.pop(context);
                    },
                  ),
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment(0,0),
                    child: Text("$title",style: TextStyle(fontSize: ScreenUtil().setSp(SizeUtil.getFontSize(30))),),
                  ),
                )
              ],
            ),
            Expanded(
              child: this.ishttp ? WebviewScaffold(url: url) : WebView(
                initialUrl: this.ishttp ? url : "",
                onPageStarted: (url){
                  print("start:$url");
                },
                onPageFinished: (url){
                  print("finish:$url");
                },
                onWebViewCreated: (controller){
                  _webViewController = controller;
                  print("controller");
                  if(!ishttp){
                    _loadLocalHtml();
                  }
                },
              ),
            )
          ],
        )
      ),
    );
  }
}