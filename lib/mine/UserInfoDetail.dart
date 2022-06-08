import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yhschool/BaseState.dart';
import 'package:yhschool/mine/CustomTile.dart';
import 'package:yhschool/utils/Constant.dart';
import 'package:yhschool/utils/DBUtils.dart';
import 'package:yhschool/utils/EnumType.dart';
import 'package:yhschool/utils/SizeUtil.dart';
import 'package:yhschool/widgets/BackButtonWidget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wakelock/wakelock.dart';

import '../BaseDialogState.dart';
import '../Login.dart';
import '../WebStage.dart';

/**
 * 用户详情页修改信息
 */
class UserInfoDetail extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return UserInfoDetailState();
  }
}

class UserInfoDetailState extends BaseDialogState{
  
  String avater="";
  String nickname="";
  bool isLight=false;
  
  @override
  void initState() {
    super.initState();
    getUserInfo().then((value){
      setState(() {
        avater = value["avater"] != null ? value["avater"] : "";
        m_username = value["username"];
        nickname = value["nickname"] != null ? value["nickname"] : "";
      });
    });
    getLight().then((value){
      if(value != null){
        setState(() {
          isLight = value;
        });
      }
    });
  }

  /**
   * 退出登录
   */
  Future<int> loginOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String username = await prefs.getString("username");
    String pw = await prefs.getString("password");
    int policy = await prefs.getInt("policy");
    prefs.clear();
    prefs.setInt("policy", policy);
    prefs.setString("username", username);
    prefs.setString("password", pw);
    return 1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          color: Colors.grey[100],
          child: Column(
            children: [
              BackButtonWidget(cb: (){
                Navigator.pop(context);
              }, title: "个人信息", ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                      color:Colors.grey[100]
                  ),
                  child: ListView(
                    shrinkWrap: true,
                    children: <Widget>[
                      //头像
                      CustomTile(tileType: TileType.IMAGE,label: "ID：$m_username", leading_w: ScreenUtil().setWidth(100),
                          leading_h: ScreenUtil().setHeight(100), startString: avater, endString: "修改头像",divider: 1, cb:(){
                            print("修改头像");
                            openAvaterGallery(context,m_uid, (value){
                              print("头像上传");
                              if(value != null){
                                setState(() {
                                  avater = value.avater;
                                });
                              }
                            });
                          }),
                      //修改密码
                      CustomTile(tileType: TileType.WORD, leading_w: 0, leading_h: 0, startString: "修改密码", endString: "请输入新密码",
                          verticalpadding:ScreenUtil().setHeight(40),divider: 1, cb:(){
                            showEditorPassword(context, "修改密码");
                          }),
                      //昵称
                      CustomTile(tileType: TileType.WORD, leading_w: 0, leading_h: 0, startString: "昵称", endString: nickname != null ? nickname : "请输入昵称，建议使用真是姓名",
                          verticalpadding:ScreenUtil().setHeight(40),divider: 1, cb:(){
                            showEditorDialog(context, "修改昵称", nickname).then((value){
                              if(value != null){
                                setState(() {
                                  nickname = value;
                                });
                              }
                            });
                          }),
                      CustomTile(tileType: TileType.WORD, leading_w: 0, leading_h: 0, startString: "服务协议",endString: "",
                          verticalpadding:ScreenUtil().setHeight(40),divider: 1, cb:(){
                            Navigator.push(context, MaterialPageRoute(builder: (context) =>
                                WebStage(url: 'http://res.yimios.com:9050/html/privacy.html', title: "艺画美术app隐私协议")
                            ));
                          }),
                      CustomTile(tileType: TileType.WORD, leading_w: 0, leading_h: 0, startString: "隐私协议",endString: "",
                          verticalpadding:ScreenUtil().setHeight(40),divider: 1, cb:(){
                            Navigator.push(context, MaterialPageRoute(builder: (context) =>
                                WebStage(url: 'http://res.yimios.com:9050/html/policy.html', title: "艺画美术app隐私协议")
                            ));
                          }),
                      //清理缓存
                      CustomTile(tileType: TileType.WORD, leading_w: 0, leading_h: 0, startString: "清理缓存",endString: "",
                          verticalpadding:ScreenUtil().setHeight(40),divider: 1, cb:() async{
                            DBUtils db = await DBUtils.dbUtils;
                            bool _bool = await db.clearTable();
                            if(_bool){
                              showToast("已清除缓存数据");
                            }
                          }),
                      Padding(padding: EdgeInsets.only(left: ScreenUtil().setWidth(40),top: ScreenUtil().setWidth(20)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Text("软件常亮"),
                                Checkbox(value: this.isLight, onChanged: (value){
                                  setLight(value);
                                  if(value){
                                    Wakelock.enable();
                                  }else{
                                    Wakelock.disable();
                                  }
                                  setState(() {
                                    this.isLight = value;
                                  });
                                })
                              ],
                            ),
                            Padding(padding: EdgeInsets.only(right: ScreenUtil().setWidth(60)),child:Text("打开后会加大设备耗电量",style: TextStyle(color:Colors.green[300]),),),
                          ],
                        ),),

                      SizedBox(height: ScreenUtil().setHeight(SizeUtil.getHeight(200)),),
                      InkWell(
                        child: Container(
                          width: double.infinity,
                          margin: EdgeInsets.symmetric(
                              horizontal: ScreenUtil().setWidth(SizeUtil.getWidth(80))
                          ),
                          padding: EdgeInsets.symmetric(
                              vertical: ScreenUtil().setHeight(SizeUtil.getHeight(20))
                          ),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(SizeUtil.getWidth(10)),
                              color: Colors.red
                          ),
                          alignment: Alignment(0,0),
                          child: Text("退出登录",style: TextStyle(color: Colors.white,fontSize:SizeUtil.getFontSize( Constant.FONT_LOGIN_SIZE)),),
                        ),
                        onTap: (){
                          //退出登录
                          loginOut().then((value){
                            Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=>Login())).then((value) => {

                            });
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}