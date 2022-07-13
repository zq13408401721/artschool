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

class ActiveCodePage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return ActiveCodePageState();
  }
}

class ActiveCodePageState extends BaseState<ActiveCodePage>{

  String _username,_password,_code;

  @override
  void initState() {
    super.initState();
    initUser();
  }

  void initUser() async{
    _username = await getString("username");
    _password = await getString("password");
    if(_username != null && _password != null){
      setState(() {
      });
    }
  }

  void _textFiledUserName(String um){
    _username = um;
  }

  void _textFiledPassword(String pw){
    _password = pw;
  }

  void _textFiledCode(String code){
    _code = code;
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
    if(_username == null || _username.length == 0){
      return showToast("输入用户名");
    }
    if(_password == null || _password.length == 0){
      return showToast("输入密码");
    }
    if(_code == null || _code.length == 0){
      return showToast("输入激活码");
    }
    var option = {
      "username":_username,
      "password":dataTomd5(_password),
      "code":_code
    };
    //激活账户
    httpUtil.post(DataUtils.api_activeuser,data: option).then((value){
      print("value:$value");
      Constant.isLogin = false;
      LoginBean loginBean = LoginBean.fromJson(json.decode(value));
      if(loginBean.errno == 0){
        setData("username",this._username);
        setData("password", this._password);
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
        Navigator.pop(context,true);
      }else{
        showToast(loginBean.errmsg);
      }
    });

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
                      top:ScreenUtil().setHeight(SizeUtil.getHeight(300))
                  ),
                  child: Image.asset("image/ic_active.png",width: ScreenUtil().setWidth(SizeUtil.getWidth(300)),height: ScreenUtil().setHeight(100),),
                ),
                SizedBox(height:ScreenUtil().setHeight(SizeUtil.getHeight(50))),
                //账号
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: ScreenUtil().setWidth(SizeUtil.getWidth(100))
                  ),
                  child: TextField(
                    keyboardType: TextInputType.text,
                    maxLines: 1,
                    maxLength: 18,
                    maxLengthEnforcement: MaxLengthEnforcement.enforced,
                    decoration: InputDecoration(
                      hintText: "请输入账号",
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
                    onChanged: _textFiledUserName,
                  ),
                ),
                SizedBox(height:ScreenUtil().setHeight(SizeUtil.getHeight(50))),
                //密码
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: ScreenUtil().setWidth(SizeUtil.getWidth(100))
                  ),
                  child: TextField(
                    keyboardType: TextInputType.text,
                    maxLines: 1,
                    maxLength: 20,
                    maxLengthEnforcement: MaxLengthEnforcement.enforced,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: "请输入密码（登录后可自行修改）",
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
                    onChanged: _textFiledPassword,
                  ),
                ),
                SizedBox(height:ScreenUtil().setHeight(SizeUtil.getHeight(100))),
                //账号
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
                          color: Colors.red, //边线颜色为黄色
                          width: 1, //边线宽度为2
                        ),
                      ),
                    ),
                    onChanged: _textFiledCode,
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
