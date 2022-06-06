import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:package_info/package_info.dart';
import 'package:yhschool/BaseDialogState.dart';
import 'package:yhschool/BaseState.dart';
import 'package:yhschool/collects/CollectPage.dart';
import 'package:yhschool/utils/EnumType.dart';
import 'package:yhschool/widgets/ClickCallback.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Login.dart';

/**
 * 个人主页
 */
class MinePage extends StatefulWidget{

  final CallBack callBack;

  MinePage({Key key,@required this.callBack}):super(key: key);

  @override
  State<StatefulWidget> createState() {
    return MinePageState().._callBack = callBack;
  }

}

class MinePageState extends BaseDialogState{

  List _data = [
    {"label":"我的专栏","img":"image/ic_mine_subject.png","type":IconType.SUBJECT},
    {"label":"我的收藏","img":"image/ic_mine_collect.png","type":IconType.COLLECT},
    {"label":"我的课堂资料","img":"image/ic_mine_material.png","type":IconType.MATERIAL},
    {"label":"联系","img":"image/ic_mine_phone.png","type":IconType.PHONE},
    {"label":"账号价格","img":"¥1980/年","type":IconType.PRICE},
    {"label":"版本号","img":"image/ic_mine_version.png","type":IconType.VERSION},
  ];

  PackageInfo _packageInfo;
  CallBack _callBack;
  String username="";
  String nickname="";
  String mark="";

  int role=2;
  bool islight = false;

  var userinfo = {};

  @override
  void initState() {
    super.initState();
    PackageInfo.fromPlatform().then((value){
      setState(() {
        _packageInfo = value;
      });
    });

    getLight().then((value) {
      if(value != null){
        setState(() {
          this.islight = value;
        });
      }
    });

    getToken().then((value) => {
      if(value==null){  //token不存在跳转登录
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => Login())
        ).then((value) async {
          //String _result = await value as String;
          print(value);
          if(value){
            getUserInfo().then((value){
              if(value != null){
                userinfo = value;
                setState(() {
                  username = userinfo["username"];
                  nickname = userinfo["nickname"] != null ? userinfo["nickname"] : "";
                  mark = userinfo["schoolname"]+"   "+userinfo["classes"];
                });
              }
            });
            getRole().then((value) {
              setState(() {
                role = value;
              });
            });
            if(_callBack != null){
              _callBack(CMD_MINE.CMD_LOGIN,value,{});
            }
          }
        }),
      }else{
        getUserInfo().then((value){
          userinfo = value;
          if(value != null){
            setState(() {
              role = userinfo["role"];
              username = userinfo["username"];
              nickname = userinfo["nickname"] != null ? userinfo["nickname"] : "";
              mark = userinfo["schoolname"]+"   "+userinfo["classes"];
            });
          }
        })
      }
    }).catchError((err)=>{
      //异常
    });
  }

  /**
   * 更新我的页面状态
   */
  updataState(){
    getToken().then((value) => {
      if(value==null){  //token不存在跳转登录
        Navigator.push(this.context,
            MaterialPageRoute(builder: (context) => Login())
        ).then((value) async {
          //String _result = await value as String;
          print(value);
          if(value){

            getUserInfo().then((opt){
              if(opt != null){
                setState(() {
                  username = opt["username"];
                  nickname = opt["nickname"] != null ? opt["nickname"] : "";
                });
              }
            });
            getRole().then((value) {
              setState(() {
                role = value;
              });
            });
            if(_callBack != null){
              _callBack(CMD_MINE.CMD_LOGIN,value,{});
            }
          }
        }),
      }
    }).catchError((err)=>{
      //异常
    });
  }

  /**
   * 渲染网格布局
   */
  List<TableRow> _renderTable(){
    List<TableRow> _list = [];
    for(var i=0; i<2; i++){
      var element1 = _data[i*3+0];
      var element2 = _data[i*3+1];
      var element3 = _data[i*3+2];
      _list.add(TableRow(
          children: [
            InkWell(
              onTap: (){
                if(element1["type"] == IconType.SUBJECT){

                }else if(element1["type"] == IconType.PHONE){
                  print("拨打电话：${userinfo["phone"]}");
                  callPhone('tel:${userinfo["phone"]}');
                }
              },
              child: Container(
                padding: EdgeInsets.symmetric(
                  vertical: ScreenUtil().setHeight(120),
                ),
                alignment: Alignment(0,1),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Image.asset(element1["img"]),
                    SizedBox(height: ScreenUtil().setHeight(40),),
                    Text((element1["type"] == IconType.PHONE && userinfo["phone"] != null) ? element1["label"]+userinfo["phone"] : element1["label"],style: TextStyle(fontSize: ScreenUtil().setSp(40)),)
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: (){
                if(element2["type"] == IconType.COLLECT){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>CollectPage()));
                }else if(element2["type"] == IconType.PRICE){

                }
              },
              child: Container(
                padding: EdgeInsets.symmetric(
                  vertical: ScreenUtil().setHeight(120),
                ),
                alignment: Alignment(0,1),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    element2["type"] == IconType.COLLECT ? Image.asset(element2["img"]) : Text(element2["img"],style: TextStyle(fontSize: ScreenUtil().setSp(40),color: Colors.black87,fontWeight: FontWeight.bold),),
                    SizedBox(height: ScreenUtil().setHeight(40),),
                    Text(element2["label"],style: TextStyle(fontSize: ScreenUtil().setSp(40)),)
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: (){
                if(element3["type"] == IconType.MATERIAL){

                }else if(element3["type"] == IconType.VERSION){

                }
              },
              child: Container(
                padding: EdgeInsets.symmetric(
                  vertical: ScreenUtil().setHeight(120)
                ),
                alignment: Alignment(0,1),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(element3["img"]),
                    SizedBox(height: ScreenUtil().setHeight(40),),
                    element3["type"] == IconType.MATERIAL ? Text(element3["label"],style: TextStyle(fontSize: ScreenUtil().setSp(40)),) : Text(element3["label"]+(_packageInfo != null ? _packageInfo.version : ""),style: TextStyle(fontSize: ScreenUtil().setSp(40)))
                  ],
                ),
              ),
            ),
          ]
      ));
    }
    return _list;
  }

  Future<int> loginOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    return 1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body:SingleChildScrollView(
        child: Column(
          children: [
            //个人头像
            Container(
              padding: EdgeInsets.only(
                left: ScreenUtil().setWidth(80),
                right: ScreenUtil().setWidth(80),
                top: ScreenUtil().setWidth(80),
                bottom: ScreenUtil().setWidth(20)
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Image.asset("image/ic_head.png",width:ScreenUtil().setWidth(120),height: ScreenUtil().setHeight(120),),
                      Container(
                        margin: EdgeInsets.only(
                            left: ScreenUtil().setWidth(20)
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(username,style: TextStyle(fontSize: ScreenUtil().setSp(40),fontWeight: FontWeight.bold),),
                            Text(mark),
                          ],
                        ),
                      )

                    ],
                  ),
                  InkWell(
                    onTap: (){
                      print("修改密码");
                      showEditorPassword(context, "修改密码");
                    },
                    child: Text.rich(
                      TextSpan(
                          children: [
                            TextSpan(
                                text: "修改密码",style: TextStyle(fontSize: ScreenUtil().setSp(40)),
                            ),
                            WidgetSpan(
                                alignment: PlaceholderAlignment.middle,
                                child: Container(
                                  margin: EdgeInsets.only(left: ScreenUtil().setWidth(20)),
                                  child: Image.asset("image/ic_arrow_right.png"),
                                )
                            )

                          ]
                      ),
                      textAlign: TextAlign.center,
                    ),
                  )

                ],
              ),
            ),
            Divider(
              thickness: ScreenUtil().setHeight(20),
              color: Colors.black12,
            ),
            Container(
              padding: EdgeInsets.symmetric(
                  horizontal: ScreenUtil().setWidth(80),
                  vertical: ScreenUtil().setHeight(40)
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("添加中文昵称：$nickname",style: TextStyle(fontSize: ScreenUtil().setSp(40)),),
                  InkWell(
                    onTap: (){
                      print("修改昵称");
                      showEditorDialog(context, "修改昵称", userinfo["nickname"]).then((value){
                        if(value != null){
                          setState(() {
                            nickname = value;
                          });
                        }
                      });
                    },
                    child: Text.rich(
                        TextSpan(
                            children: [
                              TextSpan(
                                  text: "建议填写",style: TextStyle(fontSize: ScreenUtil().setSp(40)),
                              ),
                              WidgetSpan(
                                  alignment: PlaceholderAlignment.middle,
                                  child: Container(
                                    margin: EdgeInsets.only(left: ScreenUtil().setWidth(20)),
                                    child: Image.asset("image/ic_arrow_right.png"),
                                  )
                              )

                            ]
                        )
                    ),
                  )
                ],
              ),
            ),
            Divider(
              thickness: ScreenUtil().setHeight(10),
              color: Colors.black12,
            ),
            Container(
              padding: EdgeInsets.symmetric(
                  horizontal: ScreenUtil().setWidth(80),
                  vertical: ScreenUtil().setHeight(40)
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text("软件常亮：",style: TextStyle(fontSize: ScreenUtil().setSp(40)),),
                      Checkbox(value: this.islight, onChanged: (value){
                        setLight(value);
                        setState(() {
                          this.islight = value;
                        });
                      })
                    ],
                  ),
                  Text("打开后会加大设备耗电量",style: TextStyle(fontSize: ScreenUtil().setSp(40)),)
                ],
              ),
            ),
            Divider(
              thickness: ScreenUtil().setHeight(10),
              color: Colors.black12,
            ),
            Container(
              child: Table(
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                columnWidths: {0:FlexColumnWidth(),1:FlexColumnWidth(),2:FlexColumnWidth()},
                children: _renderTable(),
              ),
            ),
            Divider(
              thickness: ScreenUtil().setHeight(20),
              color: Color.fromARGB(255, 238, 238, 238),
            ),
            Container(
              padding: EdgeInsets.symmetric(
                vertical: ScreenUtil().setHeight(80),
                horizontal: ScreenUtil().setWidth(80)
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Column(
                          children: [
                            InkWell(
                              onTap: (){
                                //艺画故事
                              },
                              child: Container(
                                height: ScreenUtil().setHeight(280),
                                width: double.infinity,
                                alignment: Alignment(0,0),
                                margin: EdgeInsets.only(
                                    bottom: ScreenUtil().setHeight(20),
                                ),
                                decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 255, 243, 236),
                                    borderRadius: BorderRadius.circular(ScreenUtil().setSp(10))
                                ),
                                child: Text("艺画故事",style: TextStyle(fontSize: ScreenUtil().setSp(50),fontWeight: FontWeight.bold),),
                              ),
                            ),
                            InkWell(
                              onTap: (){

                              },
                              child: Container(
                                height: ScreenUtil().setHeight(280),
                                width: double.infinity,
                                alignment: Alignment(0,0),
                                margin: EdgeInsets.only(
                                  top: ScreenUtil().setHeight(20),
                                ),
                                decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 241, 241, 254),
                                    borderRadius: BorderRadius.circular(ScreenUtil().setSp(10))
                                ),
                                child: Text("艺画APP操作指南",style: TextStyle(fontSize: ScreenUtil().setSp(50),fontWeight: FontWeight.bold),),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          height: ScreenUtil().setHeight(600),
                          width: double.infinity,
                          alignment: Alignment(0,0),
                          margin: EdgeInsets.only(
                            left: ScreenUtil().setWidth(40)
                          ),
                          decoration: BoxDecoration(
                              color: Color.fromARGB(255, 236, 255, 252),
                              borderRadius: BorderRadius.circular(ScreenUtil().setSp(10))
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("艺画课堂学习宝典",style: TextStyle(fontSize: ScreenUtil().setSp(50),fontWeight: FontWeight.bold),),
                              Text("必看！这里有N个变道超车秘籍")
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Container(
                          height: ScreenUtil().setHeight(280),
                          width: double.infinity,
                          alignment: Alignment(0,0),
                          margin: EdgeInsets.only(
                              top: ScreenUtil().setHeight(40),
                          ),
                          decoration: BoxDecoration(
                              color: Color.fromARGB(255, 239, 251, 242),
                              borderRadius: BorderRadius.circular(ScreenUtil().setSp(10))
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("听首歌小憩会儿",style: TextStyle(fontSize: ScreenUtil().setSp(50),fontWeight: FontWeight.bold),),
                              Text("这里只有适合放松的舒缓曲儿")
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          height: ScreenUtil().setHeight(280),
                          width: double.infinity,
                          alignment: Alignment(0,0),
                          margin: EdgeInsets.only(
                              top: ScreenUtil().setHeight(40),
                              left: ScreenUtil().setWidth(40)
                          ),
                          decoration: BoxDecoration(
                              color: Color.fromARGB(255, 243, 249, 229),
                              borderRadius: BorderRadius.circular(ScreenUtil().setSp(10))
                          ),
                          child: Text("看个MV",style: TextStyle(fontSize: ScreenUtil().setSp(50),fontWeight: FontWeight.bold),),
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Container(
                          height: ScreenUtil().setHeight(280),
                          width: double.infinity,
                          alignment: Alignment(0,0),
                          margin: EdgeInsets.only(
                              top: ScreenUtil().setHeight(40),
                          ),
                          decoration: BoxDecoration(
                              color: Color.fromARGB(255, 255, 243, 245),
                              borderRadius: BorderRadius.circular(ScreenUtil().setSp(10))
                          ),
                          child: Text("每天背三个单词",style: TextStyle(fontSize: ScreenUtil().setSp(50),fontWeight: FontWeight.bold),),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          height: ScreenUtil().setHeight(280),
                          width: double.infinity,
                          alignment: Alignment(0,0),
                          margin: EdgeInsets.only(
                              top: ScreenUtil().setHeight(40),
                              left: ScreenUtil().setWidth(40)
                          ),
                          decoration: BoxDecoration(
                              color: Color.fromARGB(255, 245, 245, 245),
                              borderRadius: BorderRadius.circular(ScreenUtil().setSp(10))
                          ),
                          child: Text("每天学两个语法",style: TextStyle(fontSize: ScreenUtil().setSp(50),fontWeight: FontWeight.bold),),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 238, 238, 238)
              ),
              padding: EdgeInsets.only(
                top: ScreenUtil().setHeight(120),
                bottom: ScreenUtil().setHeight(200)
              ),
              child: InkWell(
                onTap: (){
                  loginOut().then((value){
                    Navigator.push(context,MaterialPageRoute(builder: (context)=>Login())).then((value) => {
                      if(_callBack != null){
                        _callBack(CMD_MINE.CMD_LOGIN,value,{})
                      }
                    });
                  });
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: ScreenUtil().setWidth(80)
                  ),
                  child: Container(
                    width: double.infinity,
                    alignment: Alignment(0,0),
                    padding: EdgeInsets.symmetric(
                        vertical: ScreenUtil().setHeight(40)
                    ),
                    decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(ScreenUtil().setWidth(20))
                    ),
                    child: Text("退出登录",style: TextStyle(fontSize: ScreenUtil().setSp(40),color: Colors.white),),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}