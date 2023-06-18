
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yhschool/BaseDialogState.dart';
import 'package:yhschool/teach/ClassWorkPage.dart';
import 'package:yhschool/teach/TodayNetTeach.dart';
import 'package:yhschool/teach/TodayTeach.dart';
import 'package:yhschool/utils/Constant.dart';
import 'package:yhschool/utils/DataUtils.dart';
import 'package:yhschool/utils/EnumType.dart';
import 'package:yhschool/utils/HttpUtils.dart';
import 'package:yhschool/utils/SizeUtil.dart';
import 'package:yhschool/widgets/ClickCallback.dart';

import 'bean/teacher_classes_bean.dart';
import 'collects/CollectPage.dart';

class Teach extends StatefulWidget{

  CallBack callBack;

  Teach({Key key,@required this.callBack}):super(key: key);

  @override
  State<StatefulWidget> createState() {
    return TeachState();
  }

}

class TeachState extends BaseDialogState{

  final GlobalKey<TodayTeachState> todayTeachState = GlobalKey<TodayTeachState>();
  final GlobalKey<TodayNetTeachState> todayNetTeachState = GlobalKey<TodayNetTeachState>();
  final GlobalKey<ClassWorkPageState> classWorkPageState = GlobalKey<ClassWorkPageState>();

  final List work_push = [{"id":1,"icon":"image/ic_tool_work.png"}];
  //图文课堂
  //final List push = [{"id":4,"icon":"image/ic_tool_photo.png"},{"id":5,"icon":"image/ic_tool_collect.png"},{"id":3,"icon":"image/ic_tool_plan.png"}];
  final List push = [{"id":4,"icon":"image/ic_tool_photo.png"},{"id":5,"icon":"image/ic_tool_collect.png"}];

  List currentTools = [];

  TEACH _teach; // 当前选择的分类

  int tabIndex = 0;
  
  List<Data> classList = []; //用户所在班级id

  void changePage(CMD_MINE cmd){
    if(cmd == CMD_MINE.CMD_PAGE_MYWORK){
      setState(() {
        tabIndex = 1;
        _teach = TEACH.WORK;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _teach = TEACH.CLASS;
    print("Teach initState");
    _initclass();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    print("Teach dispose");
  }

  /**
   * 登录以后刷新状态
   */
  void updateLoginState(){
    setState(() {
      print("Teach updateLoginState");
      this.classList.clear();
      _teach = TEACH.CLASS;
      tabIndex = 0;
      _initclass();
    });
  }

  void checkClassData(){
    if(this.classList.length == 0){
      _initclass();
    }
  }

  /**
   * 初始化班级信息
   * 如果是非老师账号获取用户所在的班级 如果是老师账号获取学校相关所有班级
   */
  void _initclass(){
    /*getRole().then((value) => {
      if(value == 1){
        httpUtil.post(DataUtils.api_schoolclass,data: {}).then((value){
          ClassInfo classInfo = ClassInfo.fromJson(json.decode(value));
          if(classInfo.errno == 0){
            this.classList.addAll(classInfo.data.classes);
            _updateClassList();
          }else{
            showToast(classInfo.errmsg);
          }
        })
      }else{

      }
    });*/
    httpUtil.post(DataUtils.api_classesbyteacher,data: {},context: context).then((value){
      print("teach value:$value");
      String result = checkLoginExpire(value);
      if(result.isNotEmpty){
        TeacherClassesBean classesBean = new TeacherClassesBean.fromJson(json.decode(value));
        if(classesBean.errno == 0){
          classList.addAll(classesBean.data);
          print("Teach classList数据回去返回");
          setState(() {
            _updateClassList();
          });
        }else{
          //showToast(classesBean.errmsg);
        }
      }
    });
  }

  /**
   * 更新班级列表
   */
  void _updateClassList(){
    if(todayTeachState.currentState != null){
      todayTeachState.currentState.initClass(classList);
    }
    if(todayNetTeachState.currentState != null){
      todayNetTeachState.currentState.initClass(classList);
    }
    if(classWorkPageState.currentState != null){
      classWorkPageState.currentState.initClass(classList);
    }
  }

  /**
   * 创建
   */
  Widget _toolItem(dynamic _data){
    return InkWell(
      onTap: (){
        print("icon:${_data["id"]}");
        if(_data["id"] == 1){

        }else if(_data["id"] == 2){ //编辑排课
          todayNetTeachState.currentState.editorPlanClass();
        }else if(_data["id"] == 3){ //排课
          todayNetTeachState.currentState.planGalleryClass();
        }else if(_data["id"] == 4){ //相册发布
          showPushDialog(context,classList,cb: (){
            //发布成功以后刷新页面
            todayTeachState.currentState.updateClassDate();
          });
        }else if(_data["id"] == 5){ //收藏发布
          Navigator.push(context, MaterialPageRoute(builder: (context)=>CollectPage()));
        }
        setState(() {
          _clearTools();
        });
      },
      child: Container(
        child: Image.asset(_data["icon"],width: ScreenUtil().setWidth(SizeUtil.getWidth(170)),height: ScreenUtil().setHeight(SizeUtil.getHeight(170)),),
      ),
    );
  }

  void _clearTools(){
    setState(() {
      currentTools.clear();
    });
  }

  Widget _pushBtn(){
    String _icon;
    if(_teach == TEACH.NET){
      _icon = "image/ic_btn_plan.png";
    }else if(_teach == TEACH.WORK){
      _icon = "image/ic_btn_push.png";
    }else{
      _icon = "image/ic_btn_push.png";
    }
    return Image.asset(_icon,height: ScreenUtil().setHeight(SizeUtil.getHeight(80)),fit: BoxFit.contain,);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                //顶部区域
                Container(
                  //height: ScreenUtil().setHeight(SizeUtil.getHeight(Constant.SIZE_TOP_BAR_HEIGHT)),
                  height: SizeUtil.getAppHeight(SizeUtil.getTabHeight()),
                  decoration: BoxDecoration(
                      color: Colors.white
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        top: 0,
                        bottom: 0,
                        right: 0,
                        left: 0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: (){
                                setState(() {
                                  this._teach = TEACH.CLASS;
                                  tabIndex = 0;
                                  _clearTools();
                                });
                              },
                              child: Image.asset(_teach == TEACH.CLASS ? "image/ic_work_publish_select.png" : "image/ic_work_publish_normal.png",fit: BoxFit.contain,
                                height: SizeUtil.getAppHeight(80),),
                              /*child: Text("发布作业",style: TextStyle(
                                fontSize: _teach == TEACH.CLASS ? ScreenUtil().setSp(SizeUtil.getFontSize(40)) : ScreenUtil().setSp(SizeUtil.getFontSize(30)),
                                color: _teach == TEACH.CLASS ? Colors.red : Colors.black87,
                                fontWeight: _teach == TEACH.CLASS ? FontWeight.bold : FontWeight.normal
                            ),),*/
                            ),
                            /*SizedBox(width: ScreenUtil().setWidth(SizeUtil.getWidth(30)),),
                          InkWell(
                            onTap: (){
                              setState(() {
                                this._teach = TEACH.NET;
                                tabIndex = 1;
                                _clearTools();
                              });
                            },
                            child: Text("发布视频",style: TextStyle(
                                fontSize: _teach == TEACH.NET ? ScreenUtil().setSp(SizeUtil.getFontSize(40)) : ScreenUtil().setSp(SizeUtil.getFontSize(30)),
                                color: _teach == TEACH.NET ? Colors.red : Colors.black87,
                                fontWeight: _teach == TEACH.NET ? FontWeight.bold : FontWeight.normal
                            ),),
                          ),*/
                            SizedBox(width: ScreenUtil().setWidth(SizeUtil.getWidth(30)),),
                            InkWell(
                              onTap: (){
                                setState(() {
                                  this._teach = TEACH.WORK;
                                  tabIndex = 1;
                                  _clearTools();
                                });
                              },
                              child: Image.asset(_teach == TEACH.WORK ? "image/ic_work_student_select.png" : "image/ic_work_student_normal.png",fit: BoxFit.contain,
                                height: SizeUtil.getAppHeight(80),),
                              //学生作业
                              /*child: Text("学生作业",style: TextStyle(
                                fontSize: _teach == TEACH.WORK ? ScreenUtil().setSp(SizeUtil.getFontSize(40)) : ScreenUtil().setSp(SizeUtil.getFontSize(30)),
                                color: _teach == TEACH.WORK ? Colors.red : Colors.black87,
                                fontWeight: _teach == TEACH.WORK ? FontWeight.bold : FontWeight.normal
                            ),),*/
                            )
                          ],
                        ),
                      ),
                      //学生账号发布作业
                      Positioned(
                        right: 0,
                        child: (m_role == 1 && _teach == TEACH.WORK || m_role == 2 && _teach != TEACH.WORK) ? SizedBox() :
                        InkWell(
                          onTap: (){
                            print("click");
                            if(currentTools.length > 0){
                              setState(() {
                                currentTools.clear();
                              });
                            }else{
                              setState(() {
                                if(m_role == 2 && _teach == TEACH.WORK){
                                  //读取当前用户选择的班级
                                  int _cid = classWorkPageState.currentState.getCurrentSelectClass();
                                  if(classList.length == 0 || _cid == 0) return showToast("请先选班级");
                                  //发布作业
                                  openWorkGallery(context, <int>[_cid], (value){
                                    print("作业上传返回");
                                    //更新作业列表
                                    classWorkPageState.currentState.getClassWork();
                                  });
                                }else if(m_role == 1 && _teach == TEACH.CLASS){ //图文课堂
                                  currentTools.addAll(push);
                                }else if(m_role == 1 && _teach == TEACH.NET){ //视频课堂
                                  //currentTools.addAll(plan);
                                  todayNetTeachState.currentState.planVideoClass();
                                }
                                print(currentTools);
                              });
                            }
                          },
                          child: Container(
                            margin: EdgeInsets.only(
                              right: ScreenUtil().setWidth(SizeUtil.getWidth(40)),
                              top: SizeUtil.getAppHeight(20),
                            ),
                            child: _pushBtn(),//Text(_teach == TEACH.NET ? "排课" : "+ 发布",style: TextStyle(fontSize: ScreenUtil().setSp(SizeUtil.getFontSize(40)),color: Colors.purpleAccent),)
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                //班级区域
                Expanded(
                  child: IndexedStack(
                    index: tabIndex,
                    children: [
                      TodayTeach(key:todayTeachState,callBack: (widget as Teach).callBack,),
                      /*TodayNetTeach(key: todayNetTeachState,),*/
                      ClassWorkPage(key: classWorkPageState,)
                    ],
                  ),
                ),
              ],
            ),
            //工具操作栏
            Positioned(
              top: ScreenUtil().setHeight(SizeUtil.getHeight(100)),
              right: ScreenUtil().setWidth(SizeUtil.getWidth(20)),
              child: currentTools.length > 0 ? Container(
                width: SizeUtil.getWidth(100),
                height: ScreenUtil().setHeight(SizeUtil.getHeight(500)),
                child: ListView(
                  children: [
                    for(var i=0; i<currentTools.length; i++) _toolItem(currentTools[i])
                  ],
                ),
              ) : SizedBox(),
            ),
            // 刷新按钮
            Positioned(
              bottom: ScreenUtil().setHeight(SizeUtil.getHeight(100)),
              right: ScreenUtil().setWidth(SizeUtil.getWidth(30)),
              child: InkWell(
                onTap: (){
                  if(tabIndex == 0){
                    todayTeachState.currentState.refresh();
                  }
                  /*else if(tabIndex == 1){
                    todayNetTeachState.currentState.refresh();
                  }*/else{
                    classWorkPageState.currentState.refresh();
                  }
                },
                child: Container(
                  child:Image.asset("image/ic_red_refresh.png",width: ScreenUtil().setWidth(SizeUtil.getWidth(150)),height: ScreenUtil().setWidth(SizeUtil.getWidth(150)),),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

}