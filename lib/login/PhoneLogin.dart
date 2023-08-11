import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yhschool/BaseState.dart';
import 'package:yhschool/utils/DataUtils.dart';
import 'package:yhschool/utils/HttpUtils.dart';

import '../Home.dart';
import '../Login.dart';
import '../WebStage.dart';
import '../bean/login_bean.dart';
import '../utils/Constant.dart';
import '../utils/SizeUtil.dart';
import 'PhoneActiveCodePage.dart';

class PhoneLogin extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return PhoneLoginState();
  }
}

class PhoneLoginState extends BaseState<PhoneLogin>{

  String _phone;
  String _verifycode;
  int _time = 60;
  String _codeword="获取验证码";
  Timer _timer;

  //手机号正则表达式
  RegExp exp = RegExp(r'^((13[0-9])|(14[0-9])|(15[0-9])|(16[0-9])|(17[0-9])|(18[0-9])|(19[0-9]))\d{8}$');
  //验证码正则表达式
  RegExp expCode = RegExp(r'^([A-Za-z]|[0-9])');

  final StreamController<String> _streamController = StreamController<String>();
  var ischecked = false;

  @override
  void initState() {
    permissionCheck = false;
    super.initState();
  }

  void _textFiledPhone(String no){
    _phone = no;
  }

  void _textFiledVerifyCode(String code){
    _verifycode = code;
  }

  void _startTime(){
    _time = 60;
    _timer = Timer.periodic(new Duration(seconds: 1), (timer) {
      _time--;
      if(_time == 0){
        _codeword = "获取验证码";
        _timer.cancel();
      }else{
        _codeword = "${_time}s重新发送";
      }
      _streamController.sink.add(_codeword);
    });
  }

  /**
   * 获取验证码
   */
  void _queryPhoneCode(){

    var param = {"phone":_phone};
    //验证码
    httpUtil.post(DataUtils.api_phone_code,data: param).then((value){
      print("code:$value");
    });
  }

  /**
   * 手机号登录
   */
  void _phoneLogin(){
    if(_phone == null){
      return showToast("请输入手机号");
    }
    if(_verifycode == null){
      return showToast("请输入验证码");
    }
    bool matched = exp.hasMatch(_phone);
    if(matched){
      httpUtil.post(DataUtils.api_registerphone,data:{"phone":_phone,"code":_verifycode,"type":2}).then((value) async{
        print("login: $value");
        LoginBean loginBean = new LoginBean.fromJson(json.decode(value));
        if(loginBean.errno == 0){
          setData("username",loginBean.data.userinfo.username);
          closeTime();
          Constant.isLogin = false;
          saveToken(loginBean.data.userinfo.token);
          String classes = "";
          String classids = "";
          if(loginBean.data.classes != null && loginBean.data.classes.length > 0){
            loginBean.data.classes.forEach((element) {
              if(element.id != null){
                classes += element.name+"、";
                classids += element.id.toString()+"、";
              }
            });
            classes = classes.substring(0,classes.length-1);
          }
          await saveUser(loginBean.data.userinfo,classes,classids);
          Navigator.push(context, MaterialPageRoute(builder: (context) => MyApp()));
        }else{
          showToast(loginBean.errmsg);
          Navigator.push(context, MaterialPageRoute(builder: (context) => PhoneActiveCodePage(_phone)));
        }
      });
    }
  }

  void closeTime(){
    if(_timer != null && _timer.isActive){
      _timer.cancel();
    }
    _streamController.close();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    closeTime();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey[100],
      body: Stack(
        children: [
          Container(
            margin: EdgeInsets.only(
              top: SizeUtil.getAppHeight(200),
              left: SizeUtil.getAppWidth(20),
              right: SizeUtil.getAppWidth(20)
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  keyboardType: TextInputType.text,
                  maxLines: 1,
                  maxLength: 11,
                  maxLengthEnforcement: MaxLengthEnforcement.enforced,
                  controller: TextEditingController(text: _phone),
                  decoration: InputDecoration(
                    hintText: "请输入手机号",
                    hintStyle: TextStyle(fontSize: ScreenUtil().setSp(SizeUtil.getFontSize(36)),color: Colors.black26),
                    counterText: "",
                    fillColor:Colors.white,
                    filled: true,
                    isCollapsed: true,
                    contentPadding: EdgeInsets.only(
                      left: ScreenUtil().setWidth(SizeUtil.getWidth(50)),
                      top: ScreenUtil().setHeight(SizeUtil.getHeight(30)),
                      bottom: ScreenUtil().setHeight(SizeUtil.getHeight(30)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      //边角
                      borderRadius: BorderRadius.all(
                        Radius.circular(SizeUtil.getWidth(50)), //边角为30
                      ),
                      borderSide: BorderSide(
                        color: Colors.white, //边线颜色为黄色
                        width: 1, //边线宽度为2
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      //边角
                      borderRadius: BorderRadius.all(
                        Radius.circular(SizeUtil.getWidth(50)), //边角为30
                      ),
                      borderSide: BorderSide(
                        color: Colors.white, //边线颜色为黄色
                        width: 1, //边线宽度为2
                      ),
                    ),
                  ),
                  onChanged: _textFiledPhone,
                ),
                SizedBox(height: SizeUtil.getAppHeight(20),),
                Container(
                  child: Row(
                    children: [
                      Expanded(
                          child: TextField(
                            keyboardType: TextInputType.text,
                            maxLines: 1,
                            maxLength: 6,
                            maxLengthEnforcement: MaxLengthEnforcement.enforced,
                            controller: TextEditingController(text: _verifycode),
                            decoration: InputDecoration(
                              hintText: "请输入验证码",
                              hintStyle: TextStyle(fontSize: ScreenUtil().setSp(SizeUtil.getFontSize(36)),color: Colors.black26),
                              counterText: "",
                              fillColor:Colors.white,
                              filled: true,
                              isCollapsed: true,
                              contentPadding: EdgeInsets.only(
                                left: ScreenUtil().setWidth(SizeUtil.getWidth(50)),
                                top: ScreenUtil().setHeight(SizeUtil.getHeight(30)),
                                bottom: ScreenUtil().setHeight(SizeUtil.getHeight(30)),
                              ),
                              enabledBorder: OutlineInputBorder(
                                //边角
                                borderRadius: BorderRadius.all(
                                  Radius.circular(SizeUtil.getWidth(50)), //边角为30
                                ),
                                borderSide: BorderSide(
                                  color: Colors.white, //边线颜色为黄色
                                  width: 1, //边线宽度为2
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                //边角
                                borderRadius: BorderRadius.all(
                                  Radius.circular(SizeUtil.getWidth(50)), //边角为30
                                ),
                                borderSide: BorderSide(
                                  color: Colors.white, //边线颜色为黄色
                                  width: 1, //边线宽度为2
                                ),
                              ),
                            ),
                            onChanged: _textFiledVerifyCode,
                          ),
                      ),
                      SizedBox(width: SizeUtil.getAppWidth(20),),
                      InkWell(
                        onTap: (){
                          if(!this.ischecked){
                            return showToast("请勾选用户协议");
                          }
                          if(_phone == null){
                            return showToast("请输入手机号");
                          }else{
                            bool matched = exp.hasMatch(_phone);
                            if(!matched){
                              return showToast("请输入正确的手机号");
                            }
                          }
                          if(_timer == null || !_timer.isActive){
                            _queryPhoneCode();
                            _startTime();
                          }
                        },
                        child: Container(
                          width: SizeUtil.getAppWidth(200),
                          alignment: Alignment(0,0),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(SizeUtil.getAppWidth(50))
                          ),
                          height: SizeUtil.getAppHeight(100),
                          child: StreamBuilder<String>(
                            stream: _streamController.stream,
                            builder: (BuildContext context, snapshot) {
                              return Text("$_codeword");
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: SizeUtil.getAppHeight(50),),
                InkWell(
                  onTap: (){
                    FocusScope.of(context).unfocus();
                    if(!this.ischecked){
                      return showToast("请勾选用户协议");
                    }
                    Future.delayed(Duration(milliseconds: 300),(){
                      _phoneLogin();
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(SizeUtil.getAppWidth(50))
                    ),
                    height: SizeUtil.getAppHeight(100),
                    alignment: Alignment(0,0),
                    child: Text("登 录"),
                  ),
                )
              ],
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom:  SizeUtil.getAppHeight(150),
            child: Container(
                alignment: Alignment(0,0),
                margin: EdgeInsets.only(bottom: 50),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Checkbox(value: this.ischecked, onChanged: (value){
                      setState(() {
                        this.ischecked = value;
                      });
                    },),
                    RichText(
                      text: TextSpan(
                          text: "登录代表同意",
                          style: TextStyle(
                              color: Colors.grey,
                              fontSize: ScreenUtil().setSp(SizeUtil.getFontSize(25))
                          ),
                          children:[
                            TextSpan(
                                text: "《艺画美术APP用户协议》",
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: ScreenUtil().setSp(SizeUtil.getFontSize(25))
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = (){
                                    Navigator.push(context, MaterialPageRoute(builder: (context) =>
                                        WebStage(url: 'files/treaty.html', title: "艺画美术app用户协议")
                                    ));
                                  }
                            )
                          ]
                      ),
                    )
                  ],
                )
            ),
          ),
          /*Positioned(
            left: 0,
            right: 0,
            bottom: SizeUtil.getAppHeight(200),
            child: InkWell(
              onTap: (){
                print("click 切换");
                Navigator.push(context, MaterialPageRoute(builder: (context)=>Login()));
              },
              child: Container(
                alignment: Alignment(0,0),
                child: Text("切换到账号登录",style: TextStyle(color: Colors.black54,fontSize: SizeUtil.getAppFontSize(30)),),
              ),
            ),
          ),*/
        ],
      ),
    );
  }

}