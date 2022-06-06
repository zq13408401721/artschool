import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yhschool/BasePhotoState.dart';
import 'package:yhschool/ClassRoom.dart';
import 'package:yhschool/LessonPlan.dart';
import 'package:yhschool/utils/Constant.dart';

class Shared extends StatefulWidget{

  Shared({Key key}):super(key: key);

  @override
  State<StatefulWidget> createState() {
    return SharedState();
  }

}

class SharedState extends BasePhotoState<Shared> with SingleTickerProviderStateMixin{

  GlobalKey<LessonPlanState> globalLessonPlan = GlobalKey<LessonPlanState>();
  GlobalKey<ClassRoomState> globalClassRoom = GlobalKey<ClassRoomState>();

  int role = 0;
  int index = 0;
  List<Widget> pages;

  TabController tabController;


  @override
  void initState() {
    super.initState();
    pages = [
      ClassRoom(key:this.globalClassRoom),
      LessonPlan(key:this.globalLessonPlan)
    ];
    tabController = TabController(length: 2, vsync: this)
    ..addListener(() {
      switch(tabController.index){
        case 0:
          setState(() {
            index = 0;
          });
          break;
        case 1:
          setState(() {
            index = 1;
            globalLessonPlan.currentState.updateTabs();
          });
          break;
      }
    });

    getRole().then((value){
      setState(() {
        role = value;
      });
    });
  }

  /**
   * 更新状态
   */
  void updataState(){
    this.globalClassRoom.currentState.updateState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: ScreenUtil().setHeight(Constant.SIZE_TOP_HEIGHT),
              decoration: BoxDecoration(
                  color: Colors.white
              ),
              child: TabBar(
                controller: tabController,
                tabs: <Tab>[
                  Tab(
                    child: Text(
                      "课堂",
                      style: TextStyle(
                          color: Constant.COLOR_TITLE,
                          fontSize: ScreenUtil().setSp(60),
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                  Tab(
                    child: Text(
                      "教案",
                      style: TextStyle(
                          color: Constant.COLOR_TITLE,
                          fontSize: ScreenUtil().setSp(60),
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: IndexedStack(
                index: index,
                children: pages,
              ),
            )
          ],
        ),
      ),
    );
  }
}