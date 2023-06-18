import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:device_info/device_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yhschool/BaseState.dart';
import 'package:yhschool/WebStage.dart';
import 'package:yhschool/mine/AccountStage.dart';
import 'package:yhschool/other/ActiveCodePage.dart';
import 'package:yhschool/utils/Constant.dart';
import 'package:yhschool/utils/DataUtils.dart';
import 'package:yhschool/utils/HttpUtils.dart';
import 'dart:convert';
import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';
import 'package:yhschool/utils/SizeUtil.dart';
import 'package:video_player/video_player.dart';

import 'Home.dart';
import 'bean/login_bean.dart';
class Login extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return new LoginState();
  }

}

class LoginState extends BaseState<Login>{

  //VideoPlayerController _videoPlayerController;

  var _username="",_password="";

  var isinit = false;

  var loading = false;

  @override
  void initState() {
    permissionCheck = false;
    super.initState();
    Constant.isLogin = true;
    //clearCache();
    print("state:${Constant.isPad}");
    /*_videoPlayerController = VideoPlayerController.asset(Constant.logn_bg(this.isAndroid));
    _videoPlayerController.addListener(() {
      //print("启动视频播放："+_videoPlayerController.value.isPlaying.toString());
    });
    _videoPlayerController.setLooping(true);
    _videoPlayerController.initialize().then((value){
      setState(() {
        isinit = true;
      });
    });
    _videoPlayerController.play();*/
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

  String dataTomd5(String data){
    var content = new Utf8Encoder().convert(data);
    var digest = md5.convert(content);
    return hex.encode(digest.bytes);
  }

  //登录返回
  void loginReturn(BuildContext context,LoginBean result) async {

    if(result.errno == 0){
      Constant.isLogin = false;
      saveToken(result.data.userinfo.token);
      String classes = "";
      String classids = "";
      if(result.data.classes != null && result.data.classes.length > 0){
        result.data.classes.forEach((element) {
          classes += element.name+"、";
          classids += element.id.toString()+"、";
        });
        classes = classes.substring(0,classes.length-1);
      }
      await saveUser(result.data.userinfo,classes,classids);
      Navigator.push(context, MaterialPageRoute(builder: (context) => MyApp()));
      //Navigator.pop(context,true);
    }else if(result.errno == 99998){ //跳转到激活页面
      Navigator.push(context, MaterialPageRoute(builder: (context)=>ActiveCodePage())).then((value){
        //如果激活返回，直接退到主页
        if(value){
          //Navigator.pop(context,true);
          //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyApp()));
          Navigator.push(context, MaterialPageRoute(builder: (context) => MyApp()));
        }
      });
    }else{
      showToast(result.errmsg);
    }
  }

  @override
  void dispose() {
    Constant.isLogin = false;
    /*if(_videoPlayerController.value.isPlaying){
      _videoPlayerController.pause();
    }*/
    super.dispose();
  }

  _showloading(){
    setState(() {
      loading = true;
    });
  }

  _hideloading(){
    setState(() {
      loading = false;
    });
  }

  Widget _videoWidget(){
    return Container(
      color: Colors.black,
      child: Image.asset("image/ic_login_bg.png",fit: BoxFit.cover,width: double.infinity,height: double.infinity,),
      //child: isinit ? VideoPlayer(_videoPlayerController) : SizedBox(),
    );
  }

  void showDialog(){
    if(Platform.isAndroid){
      getPolicy().then((value){
        print("policy:${value}");
        if(value == null || value == 0){
          isShowDialog = true;
          Future.delayed(Duration(milliseconds: 300)).then((value) => showPolicyDialog(context));
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    /*final padding = MediaQuery.of(context).padding;
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;
    print("_wdith:$_width,$_height,${padding.top}");*/
    if (!isShowDialog) {
      showDialog();
    }
    return WillPopScope(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Stack(
            children: [
              _videoWidget(),
              //登录提示
              Container(
                height: ScreenUtil().setHeight(SizeUtil.getHeight(1000)),
                margin: EdgeInsets.only(
                  left: ScreenUtil().setWidth(SizeUtil.getWidth(100)),
                  right:ScreenUtil().setWidth(SizeUtil.getWidth(100)),
                  top:ScreenUtil().setHeight(SizeUtil.getHeight(400)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                            margin: EdgeInsets.only(top: 5),
                            child:Text("让学习更高效",style: TextStyle(fontSize: ScreenUtil().setSp(SizeUtil.getFontSize(60),),color: Colors.black54))
                          //color:Constant.isPad ? Colors.white : Color.fromARGB(255, 36, 36, 36),))
                        ),
                        /*Container(
                        child: Text("艺画美术",style: TextStyle(fontSize: ScreenUtil().setSp(SizeUtil.getFontSize(30)),
                          color:Constant.isPad ? Colors.white : Color.fromARGB(255, 36, 36, 36),)),
                      )*/
                      ],
                    ),
                    Text("星光不问赶路人 时光不负有心人",style: TextStyle(fontSize: ScreenUtil().setSp(SizeUtil.getFontSize(25)),color:Colors.red[300])),
                    SizedBox(height:ScreenUtil().setHeight(SizeUtil.getHeight(100))),
                    //账号
                    TextField(
                      keyboardType: TextInputType.text,
                      maxLines: 1,
                      maxLength: 18,
                      maxLengthEnforcement: MaxLengthEnforcement.enforced,
                      controller: TextEditingController(text: _username),
                      decoration: InputDecoration(
                        hintText: "账号 / 请找机构老师索取账号",
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
                      onChanged: _textFiledUserName,
                    ),
                    SizedBox(height:ScreenUtil().setHeight(SizeUtil.getHeight(50))),
                    //密码
                    TextField(
                      keyboardType: TextInputType.text,
                      maxLines: 1,
                      maxLength: 20,
                      maxLengthEnforcement: MaxLengthEnforcement.enforced,
                      obscureText: true,
                      controller: TextEditingController(text: _password),
                      decoration: InputDecoration(
                        hintText: "密码",
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
                            Radius.circular(SizeUtil.getWidth(50)), //边角为30
                          ),
                          borderSide: BorderSide(
                            color: Colors.white, //边线颜色为黄色
                            width: 1, //边线宽度为2
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          /*边角*/
                          borderRadius: BorderRadius.all(
                            Radius.circular(SizeUtil.getWidth(50)), //边角为30
                          ),
                          borderSide: BorderSide(
                            color: Colors.white, //边线颜色为黄色
                            width: 1, //边线宽度为2
                          ),
                        ),
                      ),
                      onChanged: _textFiledPassword,
                    ),
                    SizedBox(height:ScreenUtil().setHeight(SizeUtil.getHeight(150))),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: (){
                            if(this._username == null || this._password == null || this._username.length == 0 || this._password.length == 0){
                              return showToast("请输入账号或密码");
                            }
                            FocusScope.of(context).unfocus();
                            _showloading();
                            //关闭键盘
                            Future.delayed(Duration(milliseconds: 300),(){
                              //开始登录
                              var pw = dataTomd5(this._password);
                              httpUtil.post(DataUtils.api_login,data:{"username":this._username,"password":pw}).then((value) {
                                _hideloading();
                                setData("username",this._username);
                                setData("password", this._password);
                                this.loginReturn(context,new LoginBean.fromJson(json.decode(value)));
                              }).catchError((err)=>{
                                _hideloading(),
                                print(err)
                              });
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color:Colors.red,
                                borderRadius: BorderRadius.circular(ScreenUtil().setWidth(SizeUtil.getWidth(60)))
                            ),
                            alignment: Alignment(0,0),
                            padding: EdgeInsets.symmetric(
                                vertical: ScreenUtil().setHeight(SizeUtil.getHeight(30)),
                                horizontal: ScreenUtil().setWidth(SizeUtil.getWidth(80))
                            ),
                            child: Text("登 录",style: TextStyle(fontSize:ScreenUtil().setSp(SizeUtil.getFontSize(40)),fontWeight: FontWeight.bold,color:Colors.white),),
                          ),
                        ),
                        Row(
                          children: [
                            InkWell(
                                onTap: (){
                                  Constant.isLogin = false;
                                  //激活账号
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>ActiveCodePage())).then((value){
                                    if(value != null){
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => MyApp()));
                                      //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyApp()));
                                    }
                                  });
                                },
                                child: Text("激活账号",style: TextStyle(fontSize:ScreenUtil().setSp(SizeUtil.getFontSize(30)),color: Colors.black54))
                              //color:Constant.isPad ? Colors.white : Colors.black54),),
                            ),
                            SizedBox(width: SizeUtil.getAppWidth(20),),
                            InkWell(
                                onTap: (){
                                  Constant.isLogin = false;
                                  //激活账号
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=> AccountStage(url: 'http://res.yimios.com:9070/app/%E9%A2%86%E5%8F%96%E8%B4%A6%E5%8F%B7%E4%BA%8C%E7%BB%B4%E7%A0%81.png',title: "免费获取体验帐号",)));
                                },
                                child: Text("获取帐号",style: TextStyle(fontSize:ScreenUtil().setSp(SizeUtil.getFontSize(30)),color: Colors.black54))
                              //color:Constant.isPad ? Colors.white : Colors.black54),),
                            )
                          ],
                        )
                      ],
                    )
                  ],
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 20,
                child: Container(
                    alignment: Alignment(0,0),
                    margin: EdgeInsets.only(bottom: 50),
                    child: RichText(
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
                ),
              ),
              //等了loading
              loading ? Container(
                color: Color(0x70000000),
                width: double.infinity,
                height: double.infinity,
                child: Center(
                  child: Text("登录中...",style: TextStyle(color: Colors.grey[300]),),
                ),
              ) : SizedBox()
            ],
          ),
        ),
        onWillPop: (){
          exit(0);
        });
  }

}