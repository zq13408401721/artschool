
import 'dart:async';
import 'dart:ui';

import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:package_info/package_info.dart';
import 'package:yhschool/BarItem.dart';
import 'package:yhschool/BaseState.dart';
import 'package:yhschool/Chat.dart';
import 'package:yhschool/Gallery.dart';
import 'package:yhschool/Issue.dart';
import 'package:yhschool/column/ColumnPage.dart';
import 'package:yhschool/mine/Mine.dart';
import 'package:yhschool/Shared.dart';
import 'package:yhschool/Teach.dart';
import 'package:yhschool/VersionState.dart';
import 'dart:io';

import 'package:yhschool/Video.dart';
import 'package:yhschool/pan/PanPage.dart';
import 'package:yhschool/utils/Constant.dart';
import 'package:yhschool/utils/EnumType.dart';
import 'package:yhschool/utils/EventBusUtils.dart';
import 'package:yhschool/utils/SizeUtil.dart';
import 'package:yhschool/video/VideoPage.dart';
import 'package:video_player/video_player.dart';
import 'package:wakelock/wakelock.dart';
import 'dart:math' as math;


import 'Login.dart';
import 'mine/MinePage.dart';



/*void main(){
  //设置沉侵式状态栏
  SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(statusBarColor: Colors.black54);
  SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);

  runApp(MyApp());

}*/

class MyApp extends StatefulWidget {
  @override
  BaseState<StatefulWidget> createState() {
    return new AppState();
  }
}

//with SingleTickerProviderStateMixin
class AppState extends VersionState<MyApp> with SingleTickerProviderStateMixin{

  final GlobalKey<VideoPageState> videoStateKey = GlobalKey<VideoPageState>();
  final GlobalKey<GalleryState> galleryStateKey = GlobalKey<GalleryState>();
  final GlobalKey<IssueState> issueStateKey = GlobalKey<IssueState>();
  final GlobalKey<MineState> mineStateKey = GlobalKey<MineState>();
  final GlobalKey<MinePageState> minePageStateKey = GlobalKey<MinePageState>();
  final GlobalKey<SharedState> sharedStateKey = GlobalKey<SharedState>();
  final GlobalKey<ColumnPageState> columnPageStateKey = GlobalKey<ColumnPageState>();
  //课堂全局状态
  final GlobalKey<TeachState> teachStateKey = GlobalKey<TeachState>();
  //网盘
  final GlobalKey<PanPageState> panPageStateKey = GlobalKey<PanPageState>();

  final List<List<String>> barIcons = [
    ["image/ic_tab_video_normal.png","image/ic_tab_video_select.png"],
    ["image/ic_tab_gallery_normal.png","image/ic_tab_gallery_select.png"],
    ["image/ic_tab_class_normal.png","image/ic_tab_class_select.png"],
    ["image/ic_tab_zl_normal.png","image/ic_tab_zl_select.png"],
    ["image/ic_tab_mine_normal.png","image/ic_tab_mine_select.png"]
  ];

  final List<String> barTitles = ["视频","图库","上课","网盘","我的"];

  TabController tabController;

  List<Widget> pages;
  int index = 0;
  int role = 0;

  bool loadover = false;
  
  /*VideoPlayerController _videoPlayerController;
  bool isinit = false;*/

  int barIndex = 0;

  @override
  void initState(){
    print("Home initState");
    checkVersion();

    //屏幕常亮
    getLight().then((value){
      if(value != null){
        if(value){
          Wakelock.enable();
        }else{
          Wakelock.disable();
        }
      }
    });

    Timer(Duration(seconds: 3),(){/* _videoPlayerController = VideoPlayerController.asset(Constant.isPad ? "videos/start_page.mp4" : "videos/x2/start_page_x2.mp4");
    _videoPlayerController.addListener(() {
      print("启动视频播放："+_videoPlayerController.value.isPlaying.toString());
    });
    _videoPlayerController.setLooping(true);
    _videoPlayerController.initialize().then((value){
      setState(() {
        isinit = true;
      });
    });
    _videoPlayerController.play();*/
      setState(() {
        this.loadover = true;
      });
    });


    //初始化日期格式
    pages = [
      //Video(key: videoStateKey),
      VideoPage(key: videoStateKey,callback: (){
        _selectBar(3);
        columnPageStateKey.currentState.initColumn();
      },),
      Gallery(key:galleryStateKey),
      //Issue(key: issueStateKey,),
      //Shared(key:sharedStateKey),
      Teach(key: teachStateKey,callBack: (CMD_MINE _cmd,bool _bool,dynamic data){
        _parseMineCMD(cmd: _cmd, data: data, isbool: _bool);
      },),
      //ColumnPage(key: columnPageStateKey,),
      PanPage(key:panPageStateKey),
      Mine(key:mineStateKey,callBack:(CMD_MINE _cmd,bool _bool,dynamic data){
        _parseMineCMD(cmd: _cmd, data: data, isbool: _bool);
      },)
    ];
    getRole().then((value){
      role = value;
      //学生身份
      /*if(role == 2){
        setState(() {
          pages[2] = Shared(key:sharedStateKey);
        });
      }*/
    });

    tabController = new TabController(length: 5, vsync: this);
    // 跨页面数据传递 更新专栏订阅状态
    EventBusUtils.instance.getEventBus().on<int>().listen((event) {
      columnPageStateKey.currentState.columnListPageKey.currentState.updateColumnSubscrible(event);
    });
  }

  /**
   * 解析我们的页面调整过来的指令
   */
  void _parseMineCMD({@required CMD_MINE cmd,@required dynamic data,@required bool isbool=false}){
    if(cmd == CMD_MINE.CMD_LOGIN){
      if(isbool){
        videoStateKey.currentState.updataState();
        galleryStateKey.currentState.updataState();
        //切换登录以后更新登录状态
        teachStateKey.currentState.updateLoginState();
        //minePageStateKey.currentState.updataState();
        //新版本老师和学生界面显示同步
        //sharedStateKey.currentState.updataState();
        //老版本分老师学生账号区别
      }else{
        showToast("用户未登录");
      }
    }else if(cmd == CMD_MINE.CMD_NICKNAME){
      //用户修改昵称同步更新云盘订阅老师信息
      if(data != null){

      }
    }else if(cmd == CMD_MINE.CMD_PAGE_COLUMN_MINE){
      _selectBar(3);
      columnPageStateKey.currentState.changePage(cmd);
    }else if(cmd == CMD_MINE.CMD_PAGE_MYWORK){
      _selectBar(2);
      teachStateKey.currentState.changePage(cmd);
    }else if(cmd == CMD_MINE.CMD_PAGE_CLASSPLAN){

    }else if(cmd == CMD_MINE.CMD_PAGE_VIDEO){
      _selectBar(0);
    }
  }
  
  @override
  void dispose() {
    print("Home dispose");
    tabController.dispose();
    super.dispose();
  }

  /*BottomNavigationBarItem getBarItem(int no){
    Image _image = Image.asset(barIcons[no][index == no ? 1 : 0],width: ScreenUtil().setWidth(60),height: ScreenUtil().setHeight(60),);
    return BottomNavigationBarItem(icon: _image,title: barTitles[no]);
  }*/

  void _selectBar(int _index){
    setState(() {
      barIndex = _index;
      index = _index;
      if(_index == 3){
        panPageStateKey.currentState.queryPanNum();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    //区分平台 通过计算记录当前是手机还是平板
    return  ScreenUtilInit(
      designSize: Constant.isPad ? Size(Constant.PAD_SCREEN_WIDTH,Constant.PAD_SCREEN_HEIGHT) : Size(Constant.PHONE_SCREEN_WIDTH,Constant.PHONE_SCREEN_HEIGHT),
      //designSize: Size(1080,1920),
      builder: (_context,_){
        return WillPopScope(
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              backgroundColor: Colors.white,
              body:  Stack(
                children: [
                  SafeArea(
                    child: Column(
                      children: [
                        Expanded(
                          child: IndexedStack(
                            index: this.index,
                            children: this.pages,
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border(
                                  top: BorderSide(width: 1.0,color: Colors.grey[100])
                              )
                          ),
                          padding: EdgeInsets.only(
                              top:ScreenUtil().setHeight(SizeUtil.getHeight(20)),
                              bottom: ScreenUtil().setHeight(SizeUtil.getHeight(10))
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              BarItem(label: barTitles[0], icon_select: barIcons[0][1],icon_normal: barIcons[0][0],
                                  width: ScreenUtil().setWidth(SizeUtil.getWidth(50)), height: ScreenUtil().setHeight(SizeUtil.getHeight(50)),select: barIndex == 0, click: (){
                                    _selectBar(0);
                                  }),
                              BarItem(label: barTitles[1], icon_select: barIcons[1][1],icon_normal: barIcons[1][0],
                                  width: ScreenUtil().setWidth(SizeUtil.getWidth(50)), height: ScreenUtil().setHeight(SizeUtil.getHeight(50)),select: barIndex == 1, click: (){
                                    _selectBar(1);
                                  }),
                              BarItem(label: barTitles[2], icon_select: barIcons[2][1],icon_normal: barIcons[2][0],
                                  width: barIndex == 2 ? ScreenUtil().setWidth(SizeUtil.getWidth(90)) : ScreenUtil().setWidth(SizeUtil.getWidth(50)),
                                  height: barIndex == 2 ? ScreenUtil().setHeight(SizeUtil.getHeight(90)) : ScreenUtil().setHeight(SizeUtil.getHeight(50)),
                                  select: barIndex == 2, click: (){
                                    _selectBar(2);
                                  }),
                              BarItem(label: barTitles[3], icon_select: barIcons[3][1],icon_normal: barIcons[3][0],
                                  width: ScreenUtil().setWidth(SizeUtil.getWidth(50)), height: ScreenUtil().setHeight(SizeUtil.getHeight(50)),select: barIndex == 3, click: (){
                                    _selectBar(3);
                                  }),
                              BarItem(label: barTitles[4], icon_select: barIcons[4][1],icon_normal: barIcons[4][0],
                                  width: ScreenUtil().setWidth(SizeUtil.getWidth(50)), height: ScreenUtil().setHeight(SizeUtil.getHeight(50)),select: barIndex == 4, click: (){
                                    _selectBar(4);
                                  })
                            ],
                          ),
                        )

                      ],
                    ),
                  ),
                  //启动页面
                  loadover ? SizedBox() :
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                    color: Colors.white,
                    child: Center(
                      child: Image.asset("image/start.png"),
                        //child: Image.asset("image/start.png",width: ScreenUtil().setWidth(463),height: ScreenUtil().setHeight(565),)
                      //isinit ? VideoPlayer(_videoPlayerController) : SizedBox(),
                    ),
                  )

                ],
              ),
            ),
            onWillPop: () async{
              exit(0);
            });
      },
    );

  }
  
}

