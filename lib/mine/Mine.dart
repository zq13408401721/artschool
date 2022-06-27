
import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:package_info/package_info.dart';
import 'package:yhschool/BaseDialogState.dart';
import 'package:yhschool/BaseState.dart';
import 'package:yhschool/Login.dart';
import 'package:yhschool/PanPage.dart';
import 'package:yhschool/WebStage.dart';
import 'package:yhschool/bean/edit_user_info_bean.dart';
import 'package:yhschool/bean/my_work_bean.dart' as W;
import 'package:yhschool/bean/notice_bean.dart';
import 'package:yhschool/bean/relation_bean.dart';
import 'package:yhschool/bean/school_teacher_bean.dart' as M;
import 'package:yhschool/collects/CollectGallery.dart';
import 'package:yhschool/collects/CollectPage.dart';
import 'package:yhschool/message/MessagePage.dart';
import 'package:yhschool/mine/EgWorkGroupPage.dart';
import 'package:yhschool/mine/EgWorkPage.dart';
import 'package:yhschool/mine/MyWorkPage.dart';
import 'package:yhschool/other/MVPlayerPage.dart';
import 'package:yhschool/other/Mp3Player.dart';
import 'package:yhschool/other/MusicPlayerPage.dart';
import 'package:yhschool/other/MyIssuePage.dart';
import 'package:yhschool/other/MyTeacherPage.dart';
import 'package:yhschool/teach/ClassImagePlanPage.dart';
import 'package:yhschool/teach/ClassPlanPage.dart';
import 'package:yhschool/utils/Constant.dart';
import 'package:yhschool/utils/CustomWidget.dart';
import 'package:yhschool/utils/DataUtils.dart';
import 'package:yhschool/utils/EnumType.dart';
import 'package:yhschool/utils/HttpUtils.dart';
import 'package:yhschool/utils/SizeUtil.dart';
import 'package:yhschool/widgets/RoundedButton.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:yhschool/widgets/ClickCallback.dart';

import 'UserInfoDetail.dart';
import 'package:yhschool/bean/help_bean.dart';


/**
 * 个人主页
 */
class Mine extends StatefulWidget{

  final CallBack callBack;

  Mine({Key key,@required this.callBack}):super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new MineState().._callBack = callBack;
  }

}

class MineState extends BaseDialogState{

  CallBack _callBack;
  String schoolname;
  String avater;
  String mark;
  int role=2;
  PackageInfo _packageInfo;
  List<M.Data> teacherList = [];
  NoticeBean noticeBean;
  List<W.Data> workList = [];
  int relationid=0;
  HelpBean _helpBean;

  // 学生身份工具栏
  List<dynamic> _studentToolsData = [
    //{"id":1,"name":"我的老师","icon":"image/ic_myteacher.png"},
    {"id":2,"name":"我的收藏","icon":"image/ic_mycollect.png"},
    {"id":4,"name":"我的网盘","icon":"image/ic_column.png"},
    {"id":5,"name":"我的作业","icon":"image/ic_mywork.png"},
    {"id":7,"name":"学单词","icon":"image/ic_word.png"},
    {"id":8,"name":"学词组","icon":"image/ic_wordgroup.png"},
    //{"id":6,"name":"看MV","icon":"image/ic_mv.png"}
  ];

  List<dynamic> _teacherToolsData = [
    {"id":2,"name":"我的收藏","icon":"image/ic_mycollect.png"},
    {"id":3,"name":"我的课件","icon":"image/ic_mycourse.png"},
    {"id":4,"name":"我的网盘","icon":"image/ic_column.png"},
    {"id":7,"name":"学单词","icon":"image/ic_word.png"},
    {"id":8,"name":"学词组","icon":"image/ic_wordgroup.png"},
    //{"id":6,"name":"看MV","icon":"image/ic_mv.png"},
  ];

  @override
  void initState() {

    if(!this.isAndroid){
      _studentToolsData.add({"id":9,"name":"听歌","icon":"image/ic_music.png"});
      _teacherToolsData.add({"id":9,"name":"听歌","icon":"image/ic_music.png"});
    }
    // _studentToolsData.add({"id":10,"name":"关于艺画","icon":"image/ic_about.png"});
    // _teacherToolsData.add({"id":10,"name":"关于艺画","icon":"image/ic_about.png"});

    PackageInfo.fromPlatform().then((value){
        setState(() {
          _packageInfo = value;
        });
    });

    getToken().then((value) => {
      if(value==null){  //token不存在跳转登录
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => Login())
        ).then((value) async {
          if(value){
            getUserInfo().then((value){
              if(value != null){
                setState(() {
                  avater = value["avater"];
                  m_username = value["username"];
                  m_nickname = value["nickname"];
                  mark = value["schoolname"]+"   "+value["classes"];
                  role = value["role"];
                });
              }
            });
            if(_callBack != null){
              _callBack(CMD_MINE.CMD_LOGIN,value,{});
            }
          }
        }),
      }else{
        //如果已经登录 直接获取关联信息
        this._queryRelation(),
        getUserInfo().then((value){
          if(value != null){
            setState(() {
              avater = value["avater"];
              m_username = value["username"];
              m_nickname = value["nickname"];
              mark = value["schoolname"] == null ? "" : value["schoolname"]+"   "+value["classes"] == null ? "" : value["classes"];
              role = value["role"];
            });
          }
        })
      }
    }).catchError((err)=>{
      //异常
    });
    //初始化查询学校老师
    //_queryTeachers();
    //初始化查询学校通知
    Future.delayed(Duration(seconds: 2),(){
      _queryNotice(0);
    });
    //查询自己的作业
    //_queryMyWork();
    _getHelpInfo();
  }

  /**
   * 获取帮助稳定信息
   */
  void _getHelpInfo(){
    rootBundle.loadString("data/help.json").then((value){
      setState(() {
        _helpBean = HelpBean.fromJson(json.decode(value));
      });
    });
  }

  /**
   * 查询关联信息
   */
  void _queryRelation(){
    httpUtil.post(DataUtils.api_queryrelation,data:{}).then((value){
      String result = checkLoginExpire(value);
      if(result.isNotEmpty){
        RelationBean bean = RelationBean.fromJson(json.decode(value));
        if(bean.errno == 0){
          setState(() {
            relationid = bean.data[0].id;
          });
        }
      }
    });
  }

  /**
   * 查询学校老师
   */
  void _queryTeachers(){
    httpUtil.post(DataUtils.api_queryteacherbyschool,data:{}).then((value) {
      M.SchoolTeacherBean bean = M.SchoolTeacherBean.fromJson(json.decode(value));
      if(bean.errno == 0){
        setState(() {
          teacherList.addAll(bean.data);
        });
      }else{
        showToast(bean.errmsg);
      }
    });
  }

  /**
   * 查询通知 如果查询下一条通知这里需要带当前通知的id
   */
  void _queryNotice(int noticeid){

    var option = {};
    if(noticeid > 0){
      option["noticeid"] = noticeid;
    }
    httpUtil.post(DataUtils.api_querynotice,data:option).then((value) {
      String result = checkLoginExpire(value);
      if(result.isNotEmpty){
        NoticeBean bean = NoticeBean.fromJson(json.decode(value));
        if(bean.errno == 0){
          setState(() {
            noticeBean = bean;
          });
        }else{
          //showToast(bean.errmsg);
        }
      }
    });
  }

  /**
   * 查询我的作业
   */
  void _queryMyWork(){
    var option = {
      "num":5
    };
    httpUtil.post(DataUtils.api_querymywork,data:option).then((value) {
      W.MyWorkBean bean = W.MyWorkBean.fromJson(json.decode(value));
      if(bean.errno == 0){
        setState(() {
          workList.addAll(bean.data);
        });
      }else{
        showToast(bean.errmsg);
      }
    });
  }

  //个人信息
  Widget _userInfo(){
    return Container(
      decoration: BoxDecoration(
          color: Colors.white
      ),
      padding: EdgeInsets.only(
        left: ScreenUtil().setWidth(SizeUtil.getWidth(40)),
        top: ScreenUtil().setHeight(SizeUtil.getHeight(40)),
        bottom: ScreenUtil().setHeight(SizeUtil.getHeight(40))
      ),
      margin: EdgeInsets.only(
        bottom: ScreenUtil().setHeight(SizeUtil.getHeight(10))
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Row(
              children: [
                ClipOval(
                  child: avater != null ? CachedNetworkImage(imageUrl: avater,height: ScreenUtil().setWidth(SizeUtil.getWidth(100)),width: ScreenUtil().setWidth(SizeUtil.getWidth(100)),fit: BoxFit.cover,) :
                  Image.asset("image/ic_head.png",height: ScreenUtil().setWidth(SizeUtil.getWidth(100)),width: ScreenUtil().setWidth(SizeUtil.getWidth(100)),fit:BoxFit.cover),
                ),
                SizedBox(width: ScreenUtil().setWidth(SizeUtil.getWidth(20)),),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    (m_nickname == null && m_username == null) ? Text("") :
                    Text(m_nickname != null ? m_nickname : m_username,style: TextStyle(fontSize: ScreenUtil().setSp(SizeUtil.getFontSize(40)),fontWeight: FontWeight.bold),),
                    SizedBox(height: ScreenUtil().setHeight(SizeUtil.getHeight(5)),),
                    Text(mark != null ? mark : "",style:Constant.smallTitleTextStyle)
                  ],
                )
              ],
            ),
          ),
          InkWell(
            onTap: (){
              //设置
              Navigator.push(context, MaterialPageRoute(builder: (context)=>UserInfoDetail())).then((value){
                getUserInfo().then((value){
                  setState(() {
                    m_nickname = value["nickname"];
                    avater = value["avater"];
                  });
                });
              });
            },
            child: Container(
              margin: EdgeInsets.only(right: ScreenUtil().setWidth(SizeUtil.getWidth(40))),
              child: Image.asset("image/ic_setting.png",height: ScreenUtil().setHeight(SizeUtil.getHeight(40)),),
            ),
          )
        ],
      ),
    );
  }

  /**
   * 排课按钮
   */
  Widget _classCard(){
    return Padding(
      padding: EdgeInsets.only(left:ScreenUtil().setWidth(SizeUtil.getWidth(40)),right:ScreenUtil().setWidth(SizeUtil.getWidth(40))),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>ClassImagePlanPage()));
              },
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.yellow[50],
                    borderRadius: BorderRadius.all(Radius.circular(SizeUtil.getWidth(10)))
                ),
                alignment: Alignment(0,0),
                padding: EdgeInsets.symmetric(
                    vertical: ScreenUtil().setHeight(SizeUtil.getHeight(80))
                ),
                margin: EdgeInsets.only(
                    right: ScreenUtil().setWidth(SizeUtil.getWidth(10)),
                    top: ScreenUtil().setHeight(SizeUtil.getHeight(10)),
                    bottom: ScreenUtil().setHeight(SizeUtil.getHeight(10))
                ),
                child: Text("图文课堂排课",style: TextStyle(fontSize: ScreenUtil().setSp(SizeUtil.getFontSize(40)),color: Colors.black54,fontWeight: FontWeight.bold)),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>ClassPlanPage()));
              },
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.red[50],
                    borderRadius: BorderRadius.all(Radius.circular(SizeUtil.getWidth(10)))
                ),
                alignment: Alignment(0,0),
                padding: EdgeInsets.symmetric(
                    vertical: ScreenUtil().setHeight(SizeUtil.getHeight(80))
                ),
                margin: EdgeInsets.only(
                    left: ScreenUtil().setWidth(SizeUtil.getWidth(10)),
                    top: ScreenUtil().setHeight(SizeUtil.getHeight(10)),
                    bottom: ScreenUtil().setHeight(SizeUtil.getHeight(10))
                ),
                child: Text("视频课堂排课",style: TextStyle(fontSize: ScreenUtil().setSp(SizeUtil.getFontSize(40)),color: Colors.black54,fontWeight: FontWeight.bold),),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _toolItem(dynamic _data){
    return InkWell(
      onTap: (){
        if(_data["id"] == 1){//我的老师
          Navigator.push(context, MaterialPageRoute(builder: (context)=>MyTeacherPage()));
        }else if(_data["id"] == 2){ //收藏
          Navigator.push(context, MaterialPageRoute(builder: (context)=>CollectPage()));
        }else if(_data["id"] == 3){ //我的课件
          Navigator.push(context, MaterialPageRoute(builder: (context)=>MyIssuePage()));
        }else if(_data["id"] == 4){ //我的专栏
          _callBack(CMD_MINE.CMD_PAGE_COLUMN_MINE,false,null);
        }else if(_data["id"] == 5){ //我的作业
          _callBack(CMD_MINE.CMD_PAGE_MYWORK,false,null);
        }else if(_data["id"] == 6){ //看mv
          Navigator.push(context, MaterialPageRoute(builder: (context)=>MVPlayerPage()));
        }else if(_data["id"] == 7){ //学单词
          Navigator.push(context, MaterialPageRoute(builder: (context) => EgWorkPage()));
        }else if(_data["id"] == 8){ //学词组
          Navigator.push(context, MaterialPageRoute(builder: (context) => EgWorkGroupPage()));
        }else if(_data["id"] == 9){ //听歌 MusicPlayerPage
          Navigator.push(context, MaterialPageRoute(builder: (context)=>MusicPlayerPage()));
        }else if(_data["id"] == 10){ //关于艺画
          Navigator.push(context, MaterialPageRoute(builder: (context) =>
              WebStage(url: 'http://res.yimios.com:9050/html/yihua.html', title: "")
          ));
        }
      },
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(_data["icon"],width: ScreenUtil().setWidth(SizeUtil.getWidth(55)),height: ScreenUtil().setWidth(SizeUtil.getWidth(55)),fit: BoxFit.fill,),
            SizedBox(height:4),
            Text(_data["name"],style: TextStyle(color: Colors.black54,fontSize: ScreenUtil().setSp(SizeUtil.getFontSize(30))),),
          ],
        ),
      ),
    );
  }

  //常用功能
  Widget _tools(){
    return Padding(
      padding: EdgeInsets.only(top: ScreenUtil().setHeight(SizeUtil.getHeight(10)),left:ScreenUtil().setWidth(SizeUtil.getWidth(40)),right:ScreenUtil().setWidth(SizeUtil.getWidth(40))),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(ScreenUtil().setWidth(SizeUtil.getWidth(10)))
        ),
        padding: EdgeInsets.only(
            left: ScreenUtil().setWidth(SizeUtil.getWidth(40)),
            right: ScreenUtil().setWidth(SizeUtil.getWidth(40)),
            top: ScreenUtil().setHeight(SizeUtil.getHeight(30)),
            bottom: ScreenUtil().setHeight(SizeUtil.getHeight(30)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("常用功能",style: Constant.titleTextStyle,),
            SizedBox(height: ScreenUtil().setHeight(SizeUtil.getHeight(350)),
              child: GridView.count(
                crossAxisCount: 4,
                padding: EdgeInsets.only(top: ScreenUtil().setHeight(SizeUtil.getHeight(10))),
                childAspectRatio:Constant.isPad ? 2/1 : 1.1,
                children: role == 1 ? _teacherToolsData.map((e) => _toolItem(e)).toList() : _studentToolsData.map((e) => _toolItem(e)).toList(),
              ),
            )
          ],
        ),
      ),
    );;
  }


  Widget _teacherItem(M.Data _data){
    return RichText(
      text: TextSpan(
        children: [
          WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: ClipOval(
              child: _data.avater != null ? CachedNetworkImage(imageUrl: _data.avater,height: ScreenUtil().setHeight(80),width: ScreenUtil().setWidth(80),fit: BoxFit.cover,) :
              Image.asset("image/ic_head.png",height: ScreenUtil().setHeight(80),width: ScreenUtil().setWidth(80),fit:BoxFit.cover),
            )
          ),
          TextSpan(
            text: _data.nickname != null ? _data.nickname : _data.username,style: TextStyle(color: Colors.black87)
          )
        ]
      ),
    );
  }

  /**
   * 学校所有老师
   */
  Widget _teachers(){
    return Card(
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("授课老师",style: TextStyle(fontSize: ScreenUtil().setHeight(36)),),
            SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                    maxHeight: ScreenUtil().setHeight(300)
                ),
                child: GridView.builder(gridDelegate:SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    childAspectRatio: 4/1
                ),itemCount:teacherList.length,itemBuilder: (context,index){
                  return _teacherItem(teacherList[index]);
                }),
              ),
            )
          ],
        ),
      ),
    );
  }

  /**
   * 公告
   */
  Widget _notice(){
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: ScreenUtil().setWidth(SizeUtil.getWidth(40)),
        vertical: ScreenUtil().setHeight(SizeUtil.getHeight(20))
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(ScreenUtil().setWidth(SizeUtil.getWidth(10)))
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: ScreenUtil().setWidth(SizeUtil.getWidth(40)),
          vertical: ScreenUtil().setHeight(SizeUtil.getHeight(40))
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //学校公告
            Row(
              children: [
                Expanded(
                  child: Text("学校公告",style: Constant.titleTextStyle,),
                ),
                Offstage(
                  offstage: role != 1,
                  child: InkWell(
                    onTap: (){
                      showPushNotice(context).then((value){
                        if(value != null){
                          //添加新的公告成功，刷新公告
                          this._queryNotice(0);
                        }
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color:Colors.purple,
                        borderRadius: BorderRadius.circular(ScreenUtil().setWidth(SizeUtil.getWidth(10)))
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: ScreenUtil().setWidth(SizeUtil.getWidth(20)),
                        vertical: ScreenUtil().setHeight(SizeUtil.getHeight(10)),
                      ),
                      child: Text("写公告",style: TextStyle(color:Colors.white),),
                    ),
                  ),
                ),
                InkWell(
                  onTap: (){
                    if(noticeBean != null){
                      _queryNotice(noticeBean.data.id);
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color:Colors.red,
                        borderRadius: BorderRadius.circular(ScreenUtil().setWidth(SizeUtil.getWidth(10)))
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: ScreenUtil().setWidth(SizeUtil.getWidth(20)),
                      vertical: ScreenUtil().setHeight(SizeUtil.getHeight(10)),
                    ),
                    margin: EdgeInsets.only(left: ScreenUtil().setWidth(SizeUtil.getWidth(20))),
                    child: Text("上一条",style: TextStyle(color: Colors.white),),
                  ),
                ),
              ],
            ),
            SizedBox(height: SizeUtil.getHeight(10),),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(noticeBean != null ? (noticeBean.data.nickname != null ? noticeBean.data.nickname : noticeBean.data.username) : "",style:
                  TextStyle(fontSize: ScreenUtil().setSp(SizeUtil.getFontSize(30)),color: Colors.black87,fontWeight: FontWeight.bold),),
                SizedBox(width: SizeUtil.getWidth(10),),
                Text(noticeBean != null ? noticeBean.data.createtime : "")
              ],
            ),
            SizedBox(height: ScreenUtil().setHeight(SizeUtil.getHeight(20)),),
            InkWell(
              onTap: (){
                if(noticeBean != null && noticeBean.data.content != null) {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) =>
                      WebStage(url: 'https://support.qq.com/products/326279/faqs/119499', title: "")
                  ));
                }
              },
              child: Text(noticeBean != null ? noticeBean.data.content : "暂无学校公告",style: TextStyle(color:Colors.black54),),
            )
          ],
        ),
      ),
    );
  }

  /**
   * 公告图片
   */
  Widget _noticeImage(){
    return Container(
      height: ScreenUtil().setHeight(SizeUtil.getHeight(300)),
      width: double.infinity,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(ScreenUtil().setWidth(10)),
          color: Colors.white
      ),
      margin: EdgeInsets.only(
        left: ScreenUtil().setWidth(SizeUtil.getWidth(40)),
        right: ScreenUtil().setWidth(SizeUtil.getWidth(40)),
        top: ScreenUtil().setHeight(SizeUtil.getHeight(20)),
        bottom: ScreenUtil().setHeight(SizeUtil.getHeight(20)),
      ),
      child: InkWell(
        onTap: (){
          //
          Navigator.push(context, MaterialPageRoute(builder: (context) =>
              WebStage(url: 'https://support.qq.com/products/326279/faqs/119499', title: "")
          ));
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: Image.network("http://res.yimios.com:9050/videos/advert/ic_notice.jpg",fit:BoxFit.cover),
        ),
      ),
      //child: videoInit ? VideoPlayer(_videoPlayerController) : SizedBox(),
    );
  }

  /**
   * 我的作业
   */
  Widget _workWidget(){
    return Card(
      child:Container(
        height: ScreenUtil().setHeight(300),
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("我的作业"),
                InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => MyWorkPage()));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(ScreenUtil().setWidth(10)),
                        color: Colors.red
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: ScreenUtil().setWidth(20),
                      vertical: ScreenUtil().setHeight(10),
                    ),
                    child: Text("全部作业",style: TextStyle(color: Colors.white),),
                  ),
                )
              ],
            ),
            Expanded(
              child: ListView.builder(
                itemCount: workList.length,
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                addAutomaticKeepAlives: false,
                itemBuilder: (context,index){
                  return Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: ScreenUtil().setWidth(20),
                      vertical: ScreenUtil().setHeight(10)
                    ),
                    child: CachedNetworkImage(
                      imageUrl: Constant.parseSmallString(workList[index].url, "res.yimios.com:9050/work"),fit: BoxFit.cover,
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  /**
   * 留言版本
   */
  Widget _talkMessage(){
    return Card(
      child: Column(
        children: [
          Row(
            children: [
              Text("家长留言"),
              InkWell(
                onTap: (){
                  print("写留言");
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.purple,
                      borderRadius: BorderRadius.circular(10)
                  ),
                  child: Text("写留言"),
                ),
              )

            ],
          ),
        ],
      ),
    );
  }

  /**
   * 娱乐
   */
  Widget _recreation(){
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: ScreenUtil().setWidth(20),
              vertical: ScreenUtil().setHeight(20)
            ),
            child: Text("娱乐放松",style: TextStyle(fontSize: ScreenUtil().setSp(30),fontWeight: FontWeight.bold),),
          ),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Container(
                  height: ScreenUtil().setHeight(280),
                  alignment: Alignment(0,0),
                  margin: EdgeInsets.symmetric(
                    horizontal: ScreenUtil().setWidth(20),
                    vertical: ScreenUtil().setHeight(20)
                  ),
                  decoration: BoxDecoration(
                      color: Color.fromARGB(255, 239, 251, 242),
                      borderRadius: BorderRadius.circular(ScreenUtil().setSp(10))
                  ),
                  child: Text("听首歌小憩一会儿"),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  height: ScreenUtil().setHeight(280),
                  alignment: Alignment(0,0),
                  margin: EdgeInsets.symmetric(
                    horizontal: ScreenUtil().setWidth(20),
                    vertical: ScreenUtil().setHeight(20)
                  ),
                  decoration: BoxDecoration(
                      color: Color.fromARGB(255, 243, 249, 229),
                      borderRadius: BorderRadius.circular(ScreenUtil().setSp(10))
                  ),
                  child: Text("看个MV"),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  /**
   * 文化课学习
   */
  Widget _cultureClass(){
    return Container(

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: ScreenUtil().setWidth(20),
              vertical: ScreenUtil().setHeight(20)
            ),
            child: Text("文化课学习",style: TextStyle(fontSize: ScreenUtil().setSp(30),fontWeight: FontWeight.bold),),
          ),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>EgWorkPage()));
                  },
                  child: Container(
                    height: ScreenUtil().setHeight(280),
                    alignment: Alignment(0,0),
                    margin: EdgeInsets.symmetric(
                        horizontal: ScreenUtil().setWidth(20),
                        vertical: ScreenUtil().setHeight(20)
                    ),
                    decoration: BoxDecoration(
                        color: Color.fromARGB(255, 255, 243, 245),
                        borderRadius: BorderRadius.circular(ScreenUtil().setSp(10))
                    ),
                    child: Text("每天背三个单词"),
                  ),
                )
              ),
              Expanded(
                flex: 1,
                child: InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>EgWorkGroupPage()));
                  },
                  child: Container(
                    height: ScreenUtil().setHeight(280),
                    alignment: Alignment(0,0),
                    margin: EdgeInsets.symmetric(
                        horizontal: ScreenUtil().setWidth(20),
                        vertical: ScreenUtil().setHeight(20)
                    ),
                    decoration: BoxDecoration(
                        color: Color.fromARGB(255, 245, 245, 245),
                        borderRadius: BorderRadius.circular(ScreenUtil().setSp(10))
                    ),
                    child: Text("每天学三个词组"),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  /**
   * 点击Txt
   */
  Widget _clickVideo(Video data){
    return InkWell(
      onTap: (){
        //视频栏目帮助跳转
        Navigator.push(context, MaterialPageRoute(builder: (context) => WebStage(url: data.url, title: "")));
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: ScreenUtil().setHeight(SizeUtil.getHeight(10))
        ),
        child: Text(data.name,style: TextStyle(color: Colors.grey,fontSize: ScreenUtil().setSp(25)),),
      ),
    );
  }

  /**
   * 点击course
   */
  Widget _clickCourse(Course data){
    return InkWell(
      onTap: (){
        //视频栏目帮助跳转
        Navigator.push(context, MaterialPageRoute(builder: (context) => WebStage(url: data.url, title: "")));
      },
      child: Container(
          padding: EdgeInsets.symmetric(
              vertical: ScreenUtil().setHeight(SizeUtil.getHeight(10))
          ),
        child: Text(data.name,style: TextStyle(color: Colors.grey,fontSize: ScreenUtil().setSp(25)),),
      )
    );
  }

  /**
   * 艺画相关
   */
  Widget _yihuahelp(){
    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: ScreenUtil().setWidth(SizeUtil.getWidth(40)),
          vertical: ScreenUtil().setHeight(SizeUtil.getHeight(5))
      ),
      padding: EdgeInsets.symmetric(
        horizontal: ScreenUtil().setWidth(SizeUtil.getWidth(40)),
        vertical: ScreenUtil().setHeight(SizeUtil.getHeight(20))
      ),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(ScreenUtil().setWidth(10))
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //帮助中心
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("帮助中心",style:  Constant.titleTextStyle,),
              InkWell(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) =>
                      WebStage(url: 'http://res.yimios.com:9050/html/yihua.html', title: "")
                  ));
                },
                child: Container(
                  decoration: BoxDecoration(
                      color:Colors.red,
                      borderRadius: BorderRadius.circular(ScreenUtil().setWidth(SizeUtil.getWidth(10)))
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: ScreenUtil().setWidth(SizeUtil.getWidth(20)),
                    vertical: ScreenUtil().setHeight(SizeUtil.getHeight(10)),
                  ),
                  margin: EdgeInsets.only(left: ScreenUtil().setWidth(SizeUtil.getWidth(20)),top: ScreenUtil().setHeight(SizeUtil.getHeight(20)),bottom: ScreenUtil().setHeight(SizeUtil.getHeight(20))),
                  child: Text("关于艺画",style: TextStyle(color: Colors.white),),
                )
              ),
            ],
          ),
          //视频栏目
          Container(
            margin: EdgeInsets.symmetric(
              vertical: ScreenUtil().setHeight(SizeUtil.getHeight(10))
            ),
            child: Text(_helpBean != null ? _helpBean.videoTitle : "",style: TextStyle(fontSize: ScreenUtil().setSp(25),color: Colors.black54,fontWeight: FontWeight.bold),),
          ),

          //视频栏目
          if(_helpBean != null) for(var item in _helpBean.video) _clickVideo(item),
          //课堂栏目
          Container(
              margin: EdgeInsets.symmetric(
                  vertical: ScreenUtil().setHeight(SizeUtil.getHeight(10))
              ),
            child: Text(_helpBean != null ? _helpBean.courseTitle : "",style: TextStyle(fontSize: ScreenUtil().setSp(25),color: Colors.black54,fontWeight: FontWeight.bold),)
          ),
          //课堂
          if(_helpBean != null) for(var _course in _helpBean.course) _clickCourse(_course),

          Text("......",style: TextStyle(fontSize: ScreenUtil().setSp(25),color: Colors.black54,fontWeight: FontWeight.bold),),
          
          //更多帮助
          InkWell(
            onTap: (){
              //更多帮助
              Navigator.push(context, MaterialPageRoute(builder: (context) => WebStage(url:"https://support.qq.com/products/326279/faqs-more/", title: "")));
            },
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.yellow[100],
                borderRadius: BorderRadius.circular(5)
              ),
              alignment: Alignment(0,0),
              margin: EdgeInsets.only(
                top: ScreenUtil().setHeight(SizeUtil.getHeight(60)),
                bottom: ScreenUtil().setHeight(SizeUtil.getHeight(60))
              ),
              padding: EdgeInsets.symmetric(
                  vertical:ScreenUtil().setHeight(SizeUtil.getHeight(20))
              ),
              child: Text("更多帮助",style: TextStyle(fontSize: ScreenUtil().setSp(30),color: Colors.black54,fontWeight: FontWeight.bold)),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              //用户信息
              _userInfo(),
              //排课图标
              role == 1 ? _classCard() : Container(),
              _tools(),
              //_teachers(),
              _noticeImage(),
              //_workWidget(),
              //_talkMessage(),
              //留言框
              relationid == 0 ? SizedBox() : MessagePage(relationid: relationid,),
              //娱乐放松
              //_recreation(),
              //学习文化课
              //_cultureClass(),
              //关于艺画 帮助信息
              _yihuahelp(),
              SizedBox(height: ScreenUtil().setHeight(SizeUtil.getHeight(100)),),
              Text(_packageInfo != null ? "艺画美术 V${_packageInfo.version}   年费1980/年" : "",textAlign: TextAlign.center,style: TextStyle(fontSize: ScreenUtil().setSp(SizeUtil.getFontSize(25)),color: Colors.grey),),
              SizedBox(height: ScreenUtil().setHeight(SizeUtil.getHeight(100)),)
            ],
          ),
        ),
      )
    );
  }

}