import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gt_onelogin_flutter_plugin/gt_onelogin_flutter_plugin.dart';
import 'package:yhschool/BaseState.dart';
import 'package:yhschool/Login.dart';
import 'package:yhschool/bean/class_room_datelist_bean.dart';
import 'package:yhschool/bean/login_bean.dart';
import 'package:yhschool/bean/pan_search.dart';
import 'package:yhschool/login/PhoneActiveCodePage.dart';
import 'package:yhschool/login/PhoneLogin.dart';
import 'package:yhschool/utils/Button.dart';
import 'package:yhschool/utils/Constant.dart';

import '../Home.dart';
import '../WebStage.dart';
import '../other/ActiveCodePage.dart';
import '../utils/DataUtils.dart';
import '../utils/HttpUtils.dart';
import '../utils/SizeUtil.dart';

class LoginApp extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return new LoginAppState();
  }

}

class LoginAppState extends BaseState<LoginApp>{

  final tip_phone = "请输入手机好码";
  final title_phone = "手机号码";
  final tip_pw = "你的密码";
  final title_code = "验证码";

  var phone = "";
  var password = "";
  GtOneloginFlutterPlugin oneloginPlugin;
  var isinit = false;

  @override
  void initState() {
    permissionCheck = false;
    super.initState();
    //initGeetLogin();
    if(this.isAndroid){
      showDialog();
    }else{
      initGeetLogin();
    }

  }

  void init() {
    if (!isShowDialog) {
      showPhonePermissionDialog(context,callback: (){
        savePhoneDialogState();
        showDialog();
      });
    }
  }

  /**
   * 初始化极验登录
   */
  void initGeetLogin(){
    oneloginPlugin = GtOneloginFlutterPlugin(Constant.GEET_AAPID);
    var configure = OLUIConfiguration();
    setGeetUIStyle(configure);
    oneloginPlugin.requestToken(configure).then((result) async{
      print("geet config result:$result");
      int status = result["status"];
      if(status == 200){
        var timestamp = DateTime.now().millisecondsSinceEpoch;
        var signmsg = Constant.GEET_AAPID + "&&" + timestamp.toString();
        Map<String,dynamic> params = {};
        params["process_id"] = result["process_id"];
        params["token"] = result["token"];
        params["id_2_sign"] = result["app_id"];
        params["sign"] = Constant.getSha256(signmsg);
        params["timestamp"] = timestamp;
        if(result["authcode"] != null){
          params["authcode"] = result["authcode"];
        }
        await verifyToken(params);
      }else{
        var errCode = result["errorCode"];
        // 获取网关token失败
        if (Platform.isIOS) { //iOS错误码
          if ("-20103" == errCode) {
            // TO-DO
            // 重复调用 requestTokenWithViewController:viewModel:completion:
          }
          else if ("-20202" == errCode) {
            // TO-DO
            // 检测到未开启蜂窝网络
          }
          else if ("-20203" == errCode) {
            // TO-DO
            // 不支持的运营商类型
          }
          else if ("-20204" == errCode) {
            // TO-DO
            // 未获取有效的 `accessCode` 或已经失效, 请重新初始化，init(appId):
          }
          else {
            // TO-DO
            // 其他错误类型
          }
        } else { //Android错误码
          if ("-20200" == errCode) {
            // TO-DO
            // 网络不可用
          } else if ("-20202" == errCode) {
            // TO-DO
            // 检测到未开启蜂窝网络
          }
          else if ("-20203" == errCode) {
            // TO-DO
            // 不支持的运营商类型
          }
          else if ("-20105" == errCode) {
            // TO-DO
            // 超时。网络信号较差或者配置的超时时间较短，导致预取号或者取号超时
          } else {
            // TO-DO
            // 其他错误类型
          }
        }
        //未查电话卡
        if ("-40201" == errCode) {
          print("未插电话卡");
        }
        Navigator.push(context, MaterialPageRoute(builder: (context)=>PhoneLogin()));
        oneloginPlugin.dismissAuthView();
      }
    });
    oneloginPlugin.addEventListener(
        onBackButtonClick: (_){
          print("onBackButtonClick");
          exit(0);
        },
        onAuthButtonClick: (_){
          print("onAuthButtonClick");

        },
        onSwitchButtonClick: (_){
          print("onSwitchButtonClick");
          oneloginPlugin.dismissAuthView();
          Navigator.push(context, MaterialPageRoute(builder: (context)=>PhoneLogin())).then((value){
            initGeetLogin();
          });
        },
        onTermCheckBoxClick: (isChecked){
          print("onTermCheckBoxClick");
        },
        onAuthDialogDisagreeBtnClick: (_){
          print("onAuthDialogDisagreeBtnClick");
        }
    );
  }

  /**
   * 设置geet UI
   */
  void setGeetUIStyle(OLUIConfiguration config){
    config.logoImage = Platform.isAndroid ? "ic_about" : "ic_about.png";
    config.isDialogStyle = !Platform.isAndroid;
    //config.logoImageRect = OLRect(width: 80,height: 80,x: 0,y: 0);
    config.logoImageHidden = false;
    config.numberSize = 18;
    //config.switchButtonText = "激活账号";
    if(Platform.isAndroid){
      config.switchButtonRect = OLRect(width: 80,height: 30,x: 0,y: SizeUtil.getAppHeight(500));
      config.numberRect = new OLRect(width: 0,height: 0, x:0, y:SizeUtil.getAppWidth(550));
    }
    //config.auxiliaryPrivacyWords = ["注册登录即表示同意艺画用户协议"];
    //config.termsClauseColor = Colors.blue;
    var list = <OLTermsPrivacyItem>[];
    if(this.isAndroid){
      config.terms = [
        OLTermsPrivacyItem(" 和 ", " "),
        OLTermsPrivacyItem("注册登录即表示同意艺画用户协议", "http://res.yimios.com:9070/html/treaty.html")
      ];
      config.termsClauseColor = Colors.black54;
      config.termsBookTitleMarkHidden = true;
      config.termsUncheckedToastText = "";
    }else{
      list.add(new OLTermsPrivacyItem("注册登录即表示同意",""));
      list.add(new OLTermsPrivacyItem("艺画用户协议","http://res.yimios.com:9070/html/treaty.html"));
    }
    config.authBtnText = "本机号码一键登录";
    config.authBtnColor = Colors.white;
    config.authButtonCornerRadius = SizeUtil.getAppWidth(20);
    //config.switchButtonRect = new OLRect(width:80,height:25,x:0,y:SizeUtil.getAppWidth(320));
  }

  //一键登录校验token
  Future<dynamic> verifyToken(Map<String, dynamic> params) async {
    var options = BaseOptions(
      baseUrl: 'http://onelogin.geetest.com',
      connectTimeout: 5000,
      receiveTimeout: 3000,
    );
    Dio dio = Dio(options);
    final response =
    await dio.post<Map<String, dynamic>>("/check_phone", data: params);
    //geet登录手机号验证
    if (response.statusCode == 200) {
      var result = response.data;
      debugPrint(response.data.toString());
      if (result != null && result["status"] == 200) {
        loginPhone(result["result"]);
      }
    }
  }

  /**
   * 使用手机号登录
   */
  void loginPhone(String phone) async{
    httpUtil.post(DataUtils.api_registerphone,data: {"phone":phone,"type":1}).then((value) async{
      print("login: $value");
      if(value == null) return;
      checkLoginExpire(value);
      LoginBean loginBean = new LoginBean.fromJson(json.decode(value));
      if(loginBean.errno == ReqCode.Code_PhoneNoActive){
        oneloginPlugin.dismissAuthView();
        Navigator.push(context, MaterialPageRoute(builder: (context)=>PhoneActiveCodePage(phone)));
        return;
      }
      if(loginBean.errno == 0){
        setData("username",loginBean.data.userinfo.username);
        Constant.isLogin = false;
        saveToken(loginBean.data.userinfo.token);
        String classes = "";
        String classids = "";
        if(loginBean.data.classes != null && loginBean.data.classes.length > 0){
          loginBean.data.classes.forEach((element) {
            if(element.id != null) {
              classes += element.name+"、";
              classids += element.id.toString()+"、";
            }
          });
          classes = classes.substring(0,classes.length-1);
        }
        await saveUser(loginBean.data.userinfo,classes,classids);
        oneloginPlugin.dismissAuthView();
        Navigator.push(context, MaterialPageRoute(builder: (context) => MyApp()));
      }else if(loginBean.errno == 99997){
        Navigator.push(context, MaterialPageRoute(builder: (context) => PhoneActiveCodePage(phone)));
      }
    });
  }

  void checkGateWay(Map<String,dynamic> params) async{
    var options = BaseOptions(
      baseUrl: 'http://onepass.geetest.com',
      connectTimeout: 5000,
      receiveTimeout: 3000,
    );
    Dio dio = Dio(options);
    final response =
        await dio.post<Map<String, dynamic>>("/v2.0/check_gateway", data: params);
    if (response.statusCode == 200) {
      var result = response.data;
      debugPrint(response.data.toString());
      if (result != null && result["status"] == 200) {
        print("phone:${result["result"]}");
      }
    }
  }

  void showDialog(){
    if(Platform.isAndroid){
      getPolicy().then((value){
        print("policy:${value}");
        if(value == null || value == 0){
          isShowDialog = true;
          Future.delayed(Duration(milliseconds: 300)).then((value) => showPolicyDialog(context,callback: (){
            getPhoneDialogState().then((value) => {
              if(value == null || !value){
                Future.delayed(Duration(milliseconds: 500),(){
                  init();
                })
              }else{
                checkPhonePermission()
              }
            });
          }));
        }else{
          Future.delayed(Duration(milliseconds: 300)).then((value) {
            getPhoneDialogState().then((value) => {
              if(value == null || !value){
                Future.delayed(Duration(milliseconds: 500),(){
                  init();
                })
              }else{
                checkPhonePermission()
              }
            });
          });
        }
      });
    }else{
      initGeetLogin();
    }
  }

  void checkPhonePermission() async{
    if(this.isAndroid){
      await permission_phone_android();
      initGeetLogin();
    }else{
      initGeetLogin();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(child:
      Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          decoration: BoxDecoration(
            color: Color(0xFFff4100)
          ),
          child: Stack(
            children: [
              /*Positioned(
                left: 0,
                right: 0,
                bottom: SizeUtil.getAppHeight(120),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: (){
                        print("click 切换");
                        oneloginPlugin.dismissAuthView();
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>Login()));
                      },
                      child: Container(
                        alignment: Alignment(0,0),
                        child: Text("切换到账号登录",style: TextStyle(color: Colors.white,fontSize: SizeUtil.getAppFontSize(30)),),
                      ),
                    ),
                    SizedBox(width: SizeUtil.getAppWidth(20),),
                    InkWell(
                      onTap: (){
                        oneloginPlugin.dismissAuthView();
                        Constant.isLogin = false;
                        //激活账号 通过手机号激活
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>ActiveCodePage())).then((value){
                          if(value != null){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => MyApp()));
                          }
                        });
                      },
                      child: Container(
                        alignment: Alignment(0,0),
                        child: Text("账号激活",style: TextStyle(color: Colors.white,fontSize: SizeUtil.getAppFontSize(30)),),
                      ),
                    ),
                  ],
                ),
              )*/
            ],
          ),
        )
      ), onWillPop: (){
        exit(0);
    });
  }

}
