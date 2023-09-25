import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:yhschool/BaseState.dart';
import 'package:yhschool/utils/DataUtils.dart';
import 'package:yhschool/utils/HttpUtils.dart';
import 'package:yhschool/utils/SizeUtil.dart';

import '../login/LoginApp.dart';
import '../widgets/BackButtonWidget.dart';

class LogoutPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return LogoutPageState();
  }

}

class LogoutPageState extends BaseState<LogoutPage>{

  bool _select = false;
  List words = List.of([
    "很遗憾，艺画美术无法继续为你提供服务，感谢你一直以来的陪伴。注销账号，我们需要对以下信息进行审核，以保证你的账号安全。",
    "(1) 自愿放弃在艺画美术的资产和虚拟权益",
    "(2) 对应的艺画美术账户已注销且已妥善处理相关问题",
    "(3) 账号注销以后无法再使用"
  ]);

  @override
  void initState() {
    super.initState();
  }

  //注销账号
  void logoutUser(){
    httpUtil.post(DataUtils.api_phone_logout,data: {}).then((value){
      print("logout:$value");
      clearCache();
      removeData("token");
      Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=>LoginApp())).then((value) => {

      });
    });
  }


  Widget listItem(String word){
    return Container(
      /*decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey,width: 1,))
      ),*/
      padding: EdgeInsets.symmetric(
        horizontal: SizeUtil.getAppWidth(50),
        vertical: SizeUtil.getAppHeight(20)
      ),
      child: Text("$word",style: TextStyle(fontSize: SizeUtil.getAppFontSize(30),color: Colors.black54),),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            //标题
            BackButtonWidget(cb: (){
              Navigator.pop(context);
            }, title: "账号注销",),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: SizeUtil.getAppWidth(40)
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: SizeUtil.getAppHeight(20)
                      ),
                    ),
                    Text("账号注销",style: TextStyle(fontSize: SizeUtil.getAppFontSize(36),color: Colors.black87),),
                    Expanded(
                      child: ListView.builder(itemBuilder: (context,index){
                        return listItem(words[index]);
                      },itemCount: words.length,shrinkWrap: true,scrollDirection: Axis.vertical,),
                    ),
                    //协议
                    /*Row(
                      children: [
                        Checkbox(value: _select, onChanged: (value){
                          _select = value;
                        }),
                        Text("申请注销即表示你自愿放弃账号资产"),
                      ],
                    ),*/
                    SizedBox(height: SizeUtil.getAppHeight(50),),
                    //申请注销
                    InkWell(
                      onTap: (){
                        logoutUser();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(SizeUtil.getAppWidth(20))
                        ),
                        padding: EdgeInsets.symmetric(
                            vertical: SizeUtil.getAppHeight(20),
                            horizontal: SizeUtil.getAppWidth(100)
                        ),
                        alignment: Alignment(0,0),
                        child: Text("申请注销", style: TextStyle(color: Colors.white,fontSize: SizeUtil.getAppFontSize(30)),),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: SizeUtil.getAppHeight(100),)
          ],
        ),
      ),
    );
  }

}