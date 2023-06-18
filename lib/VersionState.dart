import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:open_appstore/open_appstore.dart';
import 'package:package_info/package_info.dart';
import 'package:yhschool/BaseState.dart';
import 'package:yhschool/bean/app_info.dart';
import 'package:yhschool/popwin/PopWinStartAdvert.dart';
import 'package:yhschool/utils/Constant.dart';
import 'package:yhschool/utils/DataUtils.dart';
import 'package:yhschool/utils/HttpUtils.dart';
import 'package:yhschool/utils/SizeUtil.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';

abstract class VersionState<T extends StatefulWidget> extends BaseState<T>{

  AppInfo appInfo;

  bool isloading = false,isrefreshing = false; //是否加载中
  bool hasData = true; //是否有更多数据
  ScrollController _scrollController;
  int mintop;
  String loadmoreword="加载更多";

  @override
  void initState() {
    super.initState();
    mintop = -100;
  }

  ScrollController initScrollController({bool isfresh=true}){
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      print("scroll ${_scrollController.position.pixels}:${_scrollController.position.maxScrollExtent}");
      if(_scrollController.position.maxScrollExtent > 0 && _scrollController.position.pixels > _scrollController.position.maxScrollExtent-100){
        //加载更多
        if(isloading == false && hasData){
          print("isloading:$isloading");
          setState(() {
            loadmore();
            this.isloading = true;
          });
        }
      }else if(_scrollController.position.pixels <= mintop){
        if(!isfresh) return;
        print("refresh:$isrefreshing");
        //刷新
        if(isrefreshing == false){
          setState(() {
            refresh();
            this.isrefreshing = true;
          });
        }

      }
    });
    return _scrollController;
  }

  //刷新动画
  Widget refreshUI(){
    return isrefreshing ?
    Center(
      child: Container(
        padding: EdgeInsets.symmetric(
            vertical: ScreenUtil().setHeight(40)
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: ScreenUtil().setWidth(40),
              height: ScreenUtil().setWidth(40),
              child: CircularProgressIndicator(color: Colors.red,),
            ),
            SizedBox(width: 10,),
            Text("数据刷新中",style: TextStyle(color: Colors.grey),)
          ],
        ),
      ),
    ) : SizedBox();
  }

  Widget loadmoreUI(){
    return isloading ?
    Center(
      child: Container(
        padding: EdgeInsets.symmetric(
            vertical: ScreenUtil().setHeight(40)
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: ScreenUtil().setWidth(40),
              height: ScreenUtil().setWidth(40),
              child: CircularProgressIndicator(color: Colors.red,),
            ),
            SizedBox(width: 10,),
            Text("${loadmoreword}",style: TextStyle(color:Colors.grey,fontSize: ScreenUtil().setSp(30),fontWeight: FontWeight.normal,decoration: TextDecoration.none),)
          ],
        ),
      ),
    ) : SizedBox();
  }

  //隐藏刷新
  void hideRefreshing(){
    Future.delayed(new Duration(seconds: 1),(){
      setState(() {
        this.isrefreshing = false;
      });
    });
  }

  //隐藏加载更多
  void hideLoadMore(){
    Future.delayed(new Duration(seconds: 1),(){
      if(mounted){
        setState(() {
          this.isloading = false;
        });
      }
    });
  }

  /**
   * 加载更多
   */
  void setLoadmoreword(String word){
    setState(() {
      loadmoreword = word;
    });
  }

  //刷新
  void refresh();

  //加载更多
  void loadmore();


  //版本更新提醒
  void checkVersion(){
    PackageInfo packageInfo;
    PackageInfo.fromPlatform().then((value){
      // 获取最新的版本信息
      packageInfo = value;
      print("versionName:${packageInfo.version} versionCode:${packageInfo.buildNumber}");
      var option = {
        "package":this.isAndroid ? "com.yhschool" : "com.yimi.art",
        "model":this.isAndroid ? "android" : "ios"
      };

      httpUtil.post(DataUtils.api_app_version,data: option).then((value){
        appInfo = new AppInfo.fromJson(json.decode(value));
        if(appInfo.errno == 0){
          if(appInfo.data.code > int.parse(packageInfo.buildNumber)){
            var arr = appInfo.data.description.split("\\n");
            StringBuffer sb = new StringBuffer();
            for(String m in arr){
              sb.write(m+"\n");
            }
            appInfo.data.description = sb.toString();
            showVersionPage();
          }
        }
      });

    });
  }

  // 打开外部浏览器
  _launchURL(apkUrl) async {
    if (await canLaunch(apkUrl)) {
      await launch(apkUrl);
    } else {
      throw 'Could not launch $apkUrl';
    }
  }

  // 显示最新版本更新信息
  void showVersionPage(){
    showDialog(context: this.context,
        barrierDismissible: false,
        builder: (BuildContext context){
          return WillPopScope(
              onWillPop: () async => false,
              child: Container(
                child: Card(
                  margin: EdgeInsets.only(
                      left: ScreenUtil().setWidth(SizeUtil.getWidth(100)),
                      right: ScreenUtil().setWidth(SizeUtil.getWidth(100)),
                      top: ScreenUtil().setHeight(SizeUtil.getHeight(400)),
                      bottom: ScreenUtil().setHeight(SizeUtil.getHeight(400))
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Container(
                          alignment: Alignment.bottomCenter,
                          child: Text((this.appInfo != null) ? "新版本${appInfo.data.version}" : "",style: TextStyle(fontSize: ScreenUtil().setSp(SizeUtil.getFontSize(70)),fontWeight: FontWeight.bold),maxLines: 50,),
                        ),
                      ),
                      Expanded(
                        flex: 4,
                        child: Container(
                          alignment: Alignment.topLeft,
                          padding:  EdgeInsets.only(left: ScreenUtil().setWidth(SizeUtil.getWidth(100)),right: ScreenUtil().setWidth(SizeUtil.getWidth(100)),top: ScreenUtil().setHeight(SizeUtil.getHeight(40))),
                          child: SingleChildScrollView(
                            child: Text((this.appInfo != null) ? appInfo.data.description : "",textAlign: TextAlign.left,style: TextStyle(color: Colors.grey,fontSize: ScreenUtil().setSp(SizeUtil.getFontSize(40))),),
                          ),
                        )
                      ),
                      Expanded(
                        flex: 2,
                        child: Column(
                          children: [
                            InkWell(
                              onTap: (){
                                if(appInfo != null){
                                  if(appInfo.data.model == "android"){
                                    _launchURL(appInfo.data.url);
                                  }else{
                                    OpenAppstore.launch(androidAppId: "com.yhschool",iOSAppId: "1570938984");
                                  }
                                }
                              },
                              child: Container(
                                padding: EdgeInsets.only(
                                  left: ScreenUtil().setWidth(SizeUtil.getWidth(100)),
                                  right: ScreenUtil().setWidth(SizeUtil.getWidth(100)),
                                  top: ScreenUtil().setHeight(SizeUtil.getHeight(30)),
                                  bottom: ScreenUtil().setHeight(SizeUtil.getHeight(30)),
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(SizeUtil.getWidth(30))
                                  )
                                ),
                                child: Text("立即更新",style: TextStyle(color: Colors.white,fontSize: ScreenUtil().setSp(SizeUtil.getFontSize(40))),),
                              )
                            ),
                            SizedBox(height: ScreenUtil().setHeight(20),),
                            Offstage(
                              offstage: (appInfo == null || appInfo.data.force == 0) ? false : true,
                              child: TextButton(
                                  onPressed: (){
                                    print("暂不更新");
                                    Navigator.pop(this.context);
                                  }, child: Text("暂不更新",style: TextStyle(color: Colors.grey,fontSize: ScreenUtil().setSp(SizeUtil.getFontSize(40))),)
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ));
        }
    );
  }

  /**
   * 显示开始页的弹框广告
   */
  /*showAdvertDialog(BuildContext context){
    showDialog(context: context, builder: (context){
      return StatefulBuilder(builder: (_context,_state){
        return PopWinStartAdvert();
      });
    }).then((value){
    });
  }*/

  @override
  void dispose() {
    if(_scrollController != null){
      _scrollController.dispose();
    }
    super.dispose();
  }

}