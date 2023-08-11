import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yhschool/BaseState.dart';
import 'package:yhschool/bean/login_bean.dart';
import 'package:yhschool/utils/Constant.dart';
import 'package:yhschool/utils/DataUtils.dart';
import 'package:yhschool/utils/HttpUtils.dart';
import 'package:yhschool/utils/SizeUtil.dart';
import 'package:yhschool/widgets/BackButtonWidget.dart';
import 'dart:convert';
import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';

import '../Home.dart';

/**
 * 手机号激活验证
 */
class PhoneActiveCodePage extends StatefulWidget{

  String phoneNum;

  PhoneActiveCodePage(@required this.phoneNum);

  @override
  State<StatefulWidget> createState() {
    return PhoneActiveCodePageState();
  }
}

class PhoneActiveCodePageState extends BaseState<PhoneActiveCodePage>{

  //验证码
  String _verifycode;
  //激活码
  String _activationcode;

  //手机号正则表达式
  RegExp exp = RegExp(r'^((13[0-9])|(14[0-9])|(15[0-9])|(16[0-9])|(17[0-9])|(18[0-9])|(19[0-9]))\d{8}$');
  //验证码正则表达式
  RegExp expCode = RegExp(r'^([A-Za-z]|[0-9])');
  int _time = 60;
  String _codeword="获取验证码";
  Timer _timer;
  String _phone;
  final StreamController _streamController = StreamController<String>();

  @override
  void initState() {
    super.initState();
    _phone = widget.phoneNum;
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

  void _textFiledPhone(String number){
    _phone = number;
  }

  //验证码
  void _textFiledVerifyCode(String code){
    _verifycode = code;
  }

  void _textFileActivationCode(String code){
    _activationcode = code;
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

  String dataTomd5(String data){
    var content = new Utf8Encoder().convert(data);
    var digest = md5.convert(content);
    return hex.encode(digest.bytes);
  }

  /**
   * 提交激活码
   */
  _submitCode(){
    if(_phone == null || _phone.length == 0){
      return showToast("输入手机号");
    }
    if(_verifycode == null || _verifycode.length == 0){
      return showToast("输入密码");
    }
    if(_activationcode == null || _activationcode.length == 0){
      return showToast("输入激活码");
    }
    var option = {
      "phone":_phone,
      "verifycode":_verifycode,
      "activecode":_activationcode
    };
    //激活账户
    httpUtil.post(DataUtils.api_phone_active,data: option).then((value){
      print("value:$value");
      Constant.isLogin = false;
      LoginBean loginBean = LoginBean.fromJson(json.decode(value));
      if(loginBean.errno == 0){
        closeTime();
        setData("username",loginBean.data.userinfo.username);
        saveToken(loginBean.data.userinfo.token);
        String classes = '';
        String classids = '';
        if(loginBean.data.classes != null && loginBean.data.classes.length > 0){
          loginBean.data.classes.forEach((element) {
            classes += element.name+"、";
            classids += element.id.toString()+"、";
          });
          classes = classes.substring(0,classes.length-1);
        }
        saveUser(loginBean.data.userinfo,classes,classids);
        //跳转页面
        Navigator.push(context, MaterialPageRoute(builder: (context) => MyApp()));
      }else{
        showToast(loginBean.errmsg);
      }
    });

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
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          height: size.height,
          color:Colors.grey[100],
          child: SingleChildScrollView(
            child: Column(
              children: [
                BackButtonWidget(cb: (){
                  Navigator.pop(context);
                }, title: "激活账号",),
                Padding(
                  padding: EdgeInsets.only(
                      left: 0,
                      right: 0,
                      top:ScreenUtil().setHeight(SizeUtil.getHeight(200))
                  ),
                  child: Image.asset("image/ic_active.png",width: ScreenUtil().setWidth(SizeUtil.getWidth(300)),height: ScreenUtil().setHeight(100),),
                ),
                SizedBox(height:ScreenUtil().setHeight(SizeUtil.getHeight(50))),
                //手机号
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: ScreenUtil().setWidth(SizeUtil.getWidth(100))
                  ),
                  child: TextField(
                    keyboardType: TextInputType.text,
                    maxLines: 1,
                    maxLength: 11,
                    maxLengthEnforcement: MaxLengthEnforcement.enforced,
                    decoration: InputDecoration(
                      hintText: "请输入手机号",
                      hintStyle: TextStyle(fontSize: ScreenUtil().setSp(SizeUtil.getFontSize(36)),color: Colors.black26),
                      counterText: "",
                      labelText: "${widget.phoneNum}",
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
                          Radius.circular(SizeUtil.getWidth(10)), //边角为30
                        ),
                        borderSide: BorderSide(
                          color: Colors.white, //边线颜色为黄色
                          width: 1, //边线宽度为2
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        //边角
                        borderRadius: BorderRadius.all(
                          Radius.circular(SizeUtil.getWidth(10)), //边角为30
                        ),
                        borderSide: BorderSide(
                          color: Colors.white, //边线颜色为黄色
                          width: 1, //边线宽度为2
                        ),
                      ),
                    ),
                    onChanged: _textFiledPhone,
                  ),
                ),
                SizedBox(height:ScreenUtil().setHeight(SizeUtil.getHeight(50))),
                //激活码
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: ScreenUtil().setWidth(SizeUtil.getWidth(100))
                  ),
                  child: TextField(
                    keyboardType: TextInputType.text,
                    maxLines: 1,
                    maxLength: 10,
                    maxLengthEnforcement: MaxLengthEnforcement.enforced,
                    decoration: InputDecoration(
                      hintText: "请输入激活码",
                      counterText: "",
                      hintStyle: TextStyle(fontSize: ScreenUtil().setSp(SizeUtil.getFontSize(36)),color: Colors.black26),
                      fillColor:Colors.white,
                      isCollapsed: true,
                      filled: true,
                      contentPadding: EdgeInsets.only(
                        left: ScreenUtil().setWidth(SizeUtil.getWidth(50)),
                        top: ScreenUtil().setWidth(SizeUtil.getHeight(30)),
                        bottom: ScreenUtil().setWidth(SizeUtil.getHeight(30)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        /*边角*/
                        borderRadius: BorderRadius.all(
                          Radius.circular(SizeUtil.getWidth(10)), //边角为30
                        ),
                        borderSide: BorderSide(
                          color: Colors.white, //边线颜色为黄色
                          width: 1, //边线宽度为2
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        /*边角*/
                        borderRadius: BorderRadius.all(
                          Radius.circular(SizeUtil.getWidth(10)), //边角为30
                        ),
                        borderSide: BorderSide(
                          color: Colors.white, //边线颜色为黄色
                          width: 1, //边线宽度为2
                        ),
                      ),
                    ),
                    onChanged: _textFileActivationCode,
                  ),
                ),
                SizedBox(height:ScreenUtil().setHeight(SizeUtil.getHeight(100))),
                //验证码
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: SizeUtil.getAppWidth(100)
                  ),
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
                            builder: (BuildContext context,snapshot){
                              return Text("${_codeword}");
                            },
                          )
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height:ScreenUtil().setHeight(SizeUtil.getHeight(150))),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: ScreenUtil().setWidth(SizeUtil.getWidth(100))
                  ),
                  child: InkWell(
                    onTap: (){
                      FocusScope.of(context).unfocus();
                      //激活账号
                      Future.delayed(Duration(milliseconds: 300),(){
                        _submitCode();
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color:Colors.red,
                          borderRadius: BorderRadius.circular(ScreenUtil().setWidth(SizeUtil.getWidth(10)))
                      ),
                      alignment: Alignment(0,0),
                      padding: EdgeInsets.symmetric(
                          vertical: ScreenUtil().setHeight(SizeUtil.getHeight(30)),
                          horizontal: ScreenUtil().setWidth(SizeUtil.getWidth(150))
                      ),
                      child: Text("确 定",style: TextStyle(fontSize:ScreenUtil().setSp(SizeUtil.getFontSize(40)),fontWeight: FontWeight.bold,color:Colors.white),),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
