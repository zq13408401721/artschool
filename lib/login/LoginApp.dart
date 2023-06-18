import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yhschool/BaseState.dart';

import '../WebStage.dart';
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

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(child:
    Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Positioned(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("$title_phone",style: TextStyle(fontSize: SizeUtil.getAppFontSize(12)),),
                TextField(
                  keyboardType: TextInputType.text,
                  maxLines: 1,
                  maxLength: 11,
                  maxLengthEnforcement: MaxLengthEnforcement.enforced,
                  controller: TextEditingController(text: phone),
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.white,
                              width: 1
                          )
                      )
                  ),
                  onChanged: (value){
                    RegExp mobile = new RegExp(r"1[0-9]\d{9}$");
                  },
                ),
              ],
            ),
            top: 0,
            bottom: 200,
            left: 20,
            right: 20,
          ),
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Radio(value: true, groupValue: 1, onChanged: (e) {
                  
                }),
                InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) =>
                        WebStage(url: 'files/treaty.html', title: "艺画美术app用户协议")
                    ));
                  },
                  child: Text("登录即表示同意使用手册",style: TextStyle(
                      color: Colors.grey,
                      fontSize: ScreenUtil().setSp(SizeUtil.getFontSize(25))
                  )),
                )
              ],
            ),
          )
        ],
      )
    ), onWillPop: (){
      exit(0);
    });
  }

}
