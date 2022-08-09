import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yhschool/BaseState.dart';
import 'package:yhschool/Login.dart';
import 'package:yhschool/VersionState.dart';
import 'package:yhschool/Home.dart';
import 'package:yhschool/bean/CheckLoginBean.dart';
import 'package:yhschool/bean/UrlsDB.dart';
import 'package:yhschool/bean/urls_bean.dart';
import 'package:yhschool/utils/Constant.dart';
import 'package:yhschool/utils/DBUtils.dart';
import 'package:yhschool/utils/DataUtils.dart';
import 'package:yhschool/utils/HttpUtils.dart';
import 'package:yhschool/utils/SizeUtil.dart';

/**
 * 启动页面
 */
void main(){
  //设置沉侵式状态栏
  SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle.dark.copyWith(
    statusBarColor: Colors.transparent
  );
  //SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
  SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  //SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    navigatorKey: Constant.navigatorKey,
    home: StartPage(),
  ));
}


class StartPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return StartPageState();
  }

}

class StartPageState extends BaseState{
  @override
  void initState() {
    //查看本地是否有app服务器地址
    DBUtils.dbUtils.then((db){
      db.queryUrls().then((value){
        if(value != null && value.apiurl != null && value.uploadurl != null){
          //注册网络请求
          registerNet(value.apiurl, value.uploadurl);
          _skipPage(1500);
        }else{
          _getUrls();
        }
      }).catchError((_err){
        print("_err:$_err");
        _getUrls();
      });
    }).catchError((err)=>_getUrls());
    super.initState();
  }

  /**
   * 获取app服务器url地址
   */
  void _getUrls(){
    netUtil.post(DataUtils.api_urls,data:{}).then((value){
      if(value == null){
        return showToast("网络超时");
      }
      UrlsBean bean = UrlsBean.fromJson(json.decode(value));
      if(bean.errno == 0){
        registerNet(bean.data.apiUrl, bean.data.uploadUrl);
        //registerNet("http://res.yimios.com:9060/api/", bean.data.uploadUrl);
        //registerNet("http://192.168.0.198:12005/api/", bean.data.uploadUrl);
        // 1为测试服 2正式服
        if(bean.data.state == 2){
          DBUtils.dbUtils.then((db){
            db.insertUrls(UrlsDB(id: bean.data.id,apiurl: bean.data.apiUrl,uploadurl: bean.data.uploadUrl));
          });
        }
        _skipPage(1500);
      }
    }).catchError((err){
      _skipPage(1500);
    });
  }

  /**
   * 页面跳转
   */
  void _skipPage(int time){
    Future.delayed(Duration(milliseconds: time),(){
      getToken().then((value){
        if(value != null){
          if(httpUtil != null){
            print("checklogin");
            httpUtil.post(DataUtils.api_checklogin,data:{}).then((value){
              print("checklogin:"+value.toString());
              if(value != null){
                CheckLoginBean bean = CheckLoginBean.fromJson(json.decode(value));
                if(bean.errno == 0){
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyApp()));
                }else{
                  if(!Constant.isLogin){
                    Constant.isLogin = true;
                    Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=>Login())).then((value){
                      exit(0);
                    });
                  }
                }
              }else{
                if(!Constant.isLogin){
                  Constant.isLogin = true;
                  Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=>Login())).then((value){
                    exit(0);
                  });
                }
              }
            });
          }else{
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyApp()));
          }
        }else{
          if(!Constant.isLogin){
            Constant.isLogin = true;
            Navigator.push(context,MaterialPageRoute(builder: (context)=>Login())).then((value){
              exit(0);
            });
          }
        }
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    check();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: ScreenUtilInit(
            designSize: Constant.isPad ? Size(1536, 2056) : Size(750,1334),
            builder: (_context,_){
              return Container(
                alignment: Alignment(0,1),
                child: Image.asset("image/ic_logo.png",width: ScreenUtil().setWidth(300),height: ScreenUtil().setHeight(500),),
              );
            }
        ),
      ),
    );
  }
}

class Page extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return PageState();
  }
}

class PageState extends BaseState{

  bool flag = true;

  BuildContext _context;

  @override
  void initState() {
    super.initState();
  }



  @override
  void dispose() {
    print("timer over");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Constant.isPad ? Size(1536, 2056) : Size(750,1334),
      builder: (_context,_){
        return Container(
          alignment: Alignment(0,1),
          child: Image.asset("image/ic_logo.png",width: ScreenUtil().setWidth(SizeUtil.getWidth(300)),height: ScreenUtil().setHeight(SizeUtil.getHeight(500)),),
        );
      }
    );
  }
}