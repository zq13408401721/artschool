import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yhschool/BaseDialogState.dart';
import 'package:yhschool/bean/pan_classify_bean.dart';
import 'package:yhschool/bean/pan_num_bean.dart' as N;
import 'package:yhschool/pan/PanAllPage.dart';
import 'package:yhschool/pan/PanCreate.dart';
import 'package:yhschool/pan/PanMine.dart';
import 'package:yhschool/pan/PanSchool.dart';
import 'package:yhschool/pan/SearchPanPage.dart';
import 'package:yhschool/utils/DataUtils.dart';
import 'package:yhschool/utils/HttpUtils.dart';
import 'package:yhschool/widgets/ImageButton.dart';
import 'package:yhschool/widgets/PanTopTabButton.dart';

import '../BaseState.dart';
import '../utils/Constant.dart';
import '../utils/SizeUtil.dart';
import '../widgets/HorizontalListTab.dart';

/**
 * 网盘
 */
class PanPage extends StatefulWidget{

  PanPage({Key key}):super(key: key);

  @override
  State<StatefulWidget> createState() {
    return PanPageState();
  }
}

class PanPageState extends BaseDialogState<PanPage>{

  //toptab state
  final GlobalKey<PanTopTabButtonState> allTopTabState = GlobalKey<PanTopTabButtonState>();
  final GlobalKey<PanTopTabButtonState> schoolTopTabState = GlobalKey<PanTopTabButtonState>();
  final GlobalKey<PanTopTabButtonState> mineTopTabState = GlobalKey<PanTopTabButtonState>();

  //pan page
  final GlobalKey<PanAllPageState> panAllPageStateKey = GlobalKey<PanAllPageState>();
  final GlobalKey<PanSchoolState> panSchoolStateKey = GlobalKey<PanSchoolState>();
  final GlobalKey<PanMineState> panMineStateKey = GlobalKey<PanMineState>();

  //classify tab
  final GlobalKey<HorizontalListTabState> horizontalListTabKey = GlobalKey<HorizontalListTabState>();

  //只看老师
  final TextStyle screenTeacherNormal = TextStyle(color: Colors.black,fontSize: SizeUtil.getAppFontSize(30));
  final TextStyle screenTeacherSelect = TextStyle(color: Colors.redAccent,fontSize: SizeUtil.getAppFontSize(30));

  int page = 0;
  List<Data> tabsList=[];
  String icon_enable_teacher = "image/ic_unenable_teacher.png";
  bool enable_teacher = true;
  int selectClassify = 0;
  String selectClassName="";
  String schoolid;
  N.PanNumBean mPanNumbean;
  String marks="";
  String marknames = "";



  @override
  void initState() {
    super.initState();
    getSchoolid().then((value) => schoolid = value);
    this.getPanClassify();
    //this.queryPanNum();
  }

  //查询网盘相关数量
  void queryPanNum(){
    httpUtil.post(DataUtils.api_querypannum,data: {}).then((value){
      print("pan num:${value}");
      if(value != null){
        N.PanNumBean panNumBean = N.PanNumBean.fromJson(json.decode(value));
        if(panNumBean.errno == 0){
          setState(() {
            mPanNumbean = panNumBean;
          });
        }
      }
    });
  }

  //切换顶部导航
  void changeTab(int index){
    page = index;
    marks = "";
    marknames = "";
    if(index == 0){
      /*allTopTabState.currentState.select(true);
      schoolTopTabState.currentState.select(false);
      mineTopTabState.currentState.select(false);*/
      resetSelectTab();
      updatePanList();
    }else if(index == 1){
      /*allTopTabState.currentState.select(false);
      schoolTopTabState.currentState.select(true);
      mineTopTabState.currentState.select(false);*/
      resetSelectTab();
      updatePanList();
      //panSchoolStateKey.currentState.queryPanList(schoolid: schoolid,classifyid: 0,marks:marks,visible:enable_teacher);
    }else if(index == 2){
      /*allTopTabState.currentState.select(false);
      schoolTopTabState.currentState.select(false);
      mineTopTabState.currentState.select(true);*/
      resetSelectTab();
      updatePanList();
      //panMineStateKey.currentState.queryPanList(classifyid: 0);
    }
    setState(() {
    });
  }

  /**
   * 更新网盘列表
   */
  void updatePanList(){
    if(page == 0){
      this.panAllPageStateKey.currentState.queryPanListAll(selectClassify,classifyname: selectClassName,marks:marks,visible: enable_teacher);
    }else if(page == 1){
      panSchoolStateKey.currentState.queryPanList(schoolid: schoolid,classifyid: selectClassify,marks:marks,visible: enable_teacher,classifyname: selectClassName);
    }else if(page == 2){
      panMineStateKey.currentState.queryPanList(classifyid: selectClassify);
    }
  }

  /**
   * 选择筛选网盘 仅看老师 标签
   */
  void selectScreenPanList({String marks}){
    if(page == 0){
      panAllPageStateKey.currentState.queryPanListAll(selectClassify,classifyname: selectClassName,marks: marks,visible: enable_teacher);
    }else if(page == 1){
      panSchoolStateKey.currentState.queryPanList(schoolid: schoolid,classifyid: selectClassify,marks:marks,visible: enable_teacher,classifyname: selectClassName);
    }else{

    }
  }

  /**
   * 通过标签更新网盘列表
   */
  void updatePanListByMarks(){
    if(page == 0){
      panAllPageStateKey.currentState.queryPanListByMark(selectClassify, this.marks,classifyname: selectClassName);
    }else if(page == 1){
      panSchoolStateKey.currentState.queryPanListByMark(selectClassify, this.marks,classifyname: selectClassName,schoolid:schoolid);
    }else{
      panMineStateKey.currentState.queryPanListByMark(selectClassify, this.marks,classifyname: selectClassName);
    }
  }

  /**
   * 网盘分类
   */
  void getPanClassify(){
    httpUtil.get(DataUtils.api_panclassify).then((value){
      print("getPanClassify:"+value);
      this.tabsList.clear();
      PanClassifyBean panClassify = PanClassifyBean.fromJson(json.decode(value));
      if(panClassify.errno == 0) {
        //最开始位置加全部
        this.tabsList.add(new Data(id:0,name: "全部"));
        this.tabsList.addAll(panClassify.data);
        selectClassify = this.tabsList[0].id;
        selectClassName = this.tabsList[0].name;
        this.tabsList[0].select = true;
        this.panAllPageStateKey.currentState.tabs.addAll(panClassify.data);
        this.panAllPageStateKey.currentState.queryPanListAll(selectClassify,classifyname: selectClassName);
        this.panSchoolStateKey.currentState.tabs.addAll(panClassify.data);
        this.panMineStateKey.currentState.tabs.addAll(panClassify.data);
      }
      setState(() {
      });
    });
  }

  /**
   * 顶部tab默认选中第一个
   */
  void resetSelectTab(){
    for(var i=0; i<tabsList.length; i++){
      if(i == 0){
        tabsList[i].select = true;
        selectClassify = tabsList[i].id;
        selectClassName = tabsList[i].name;
      }else{
        tabsList[i].select = false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    print("panpage build");
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //顶部菜单 左右两边
                Container(
                  height: SizeUtil.getAppHeight(SizeUtil.getTabHeight()),
                  decoration: BoxDecoration(
                    color: Colors.white
                  ),
                  alignment: Alignment(0,0),
                  padding: EdgeInsets.symmetric(
                      horizontal: SizeUtil.getAppWidth(20)
                  ),
                  child: Stack(
                    children: [
                      //左边
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(right: SizeUtil.getAppWidth(30)),
                            child: InkWell(
                              onTap: (){
                                changeTab(0);
                              },
                              child: Image.asset(page == 0 ? "image/ic_photo_all_select.png" : "image/ic_photo_all_normal.png",height: SizeUtil.getAppHeight(80),fit: BoxFit.contain,),
                            ),
                            //child: PanTopTabButton(key:allTopTabState,name: "全部相册", tab: "", index: 0, clickCB: changeTab),
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: SizeUtil.getAppWidth(30)),
                            child: InkWell(
                              onTap: (){
                                changeTab(1);
                              },
                              child: Image.asset(page == 1 ? "image/ic_photo_school_select.png" : "image/ic_photo_school_normal.png",height: SizeUtil.getAppHeight(80),fit: BoxFit.contain,),
                            ),
                            //child: PanTopTabButton(key:schoolTopTabState,name: "学校相册", tab: "", index: 1, clickCB: changeTab),
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: SizeUtil.getAppWidth(30)),
                            child: InkWell(
                              onTap: (){
                                changeTab(2);
                              },
                              child: Image.asset(page == 2 ? "image/ic_photo_mine_select.png" : "image/ic_photo_mine_normal.png",height: SizeUtil.getAppHeight(80),fit: BoxFit.contain,),
                            ),
                            //child: PanTopTabButton(key:mineTopTabState,name: "我的相册", tab: "", index: 2, clickCB: changeTab),
                          )
                        ],
                      ),
                      //搜索
                      Positioned(
                        right: 0,
                        top:0,
                        bottom: 0,
                        child: Container(
                          alignment: Alignment(0,0),
                          padding: EdgeInsets.only(
                              right: SizeUtil.getAppWidth(20)
                          ),
                          child: ImageButton(icon: "image/ic_search.png", label: "", cb: ()=>{
                            Navigator.push(context, MaterialPageRoute(builder: (context) => SearchPanPage(callback: (){

                            })))
                          }),
                        ),
                      )
                    ],
                  ),
                ),
                //分类
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white
                  ),
                  child: HorizontalListTab(key:horizontalListTabKey,datas: tabsList, click: (dynamic _data){
                    setState(() {
                      this.selectClassify = _data.id;
                      this.selectClassName = _data.name;
                      if(_data.id == 0){
                        marks = "";
                        marknames = "";
                      }
                    });
                    print("${_data.id}");
                    updatePanList();
                  }),
                ),
                //广告栏
                //CachedNetworkImage(imageUrl: ""),
                //markname  筛选
                Container(
                  padding: EdgeInsets.only(
                    left: SizeUtil.getAppHeight(20),
                    right:SizeUtil.getAppHeight(20),
                    top: SizeUtil.getAppWidth(20)
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Offstage(
                        offstage: this.marks == null || this.marks.length == 0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: (){
                                setState(() {
                                  this.marks = "";
                                  this.marknames = "";
                                  updatePanList();
                                });
                              },
                              child: RichText(
                                text: TextSpan(
                                    children: [
                                      WidgetSpan(
                                          child: Image.asset("image/ic_btn_close.png",width: SizeUtil.getAppWidth(40),height: SizeUtil.getAppWidth(40),)
                                      ),
                                      TextSpan(
                                          text: "取消筛选",style: TextStyle(color: Colors.orange,fontSize: SizeUtil.getAppFontSize(30))
                                      )
                                    ]
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      //筛选条件
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          //我的页面隐藏只看老师
                          Offstage(
                            offstage: page == 2,
                            child: Container(
                              margin: EdgeInsets.only(
                                right: SizeUtil.getAppWidth(20),
                              ),
                              child: InkWell(
                                onTap: (){
                                  setState(() {
                                    enable_teacher = !enable_teacher;
                                    selectScreenPanList(marks: this.marks);
                                  });
                                },
                                child: Row(
                                  children: [
                                    Image.asset(
                                      enable_teacher ? "image/ic_checkbox_select.png" : "image/ic_checkbox_normal.png",
                                      width: SizeUtil.getAppWidth(30),
                                      height: SizeUtil.getAppWidth(30),
                                    ),
                                    SizedBox(width: SizeUtil.getAppWidth(10),),
                                    Text("只看老师",style: enable_teacher ? screenTeacherSelect : screenTeacherNormal,),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          //筛选 全部分类和我的页面的时候隐藏
                          Offstage(
                            offstage: selectClassify == 0 || page == 2,
                            child: Container(
                              child: ImageButton(icon: "image/ic_pan_screen.png", label: "精准筛选",titleStyle: TextStyle(color: Colors.black87,fontSize: SizeUtil.getAppFontSize(30)), cb: (){
                                //mark筛选
                                showPanScreen(context, selectClassify).then((value){
                                  print("showPanScreen ${value}");
                                  //创建网盘成功 进入我的网盘
                                  if(value != null){
                                    if(value["marks"] != null){
                                      setState(() {
                                        this.marks = value["marks"];
                                        this.marknames = value["marknames"];
                                        updatePanListByMarks();
                                      });
                                    }else{
                                      setState(() {
                                        this.marks = "";
                                        this.marknames = "";
                                        updatePanList();
                                      });
                                    }
                                  }
                                });
                              }),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                //筛选标签名
                Offstage(
                  offstage: marknames == null  || marknames.length == 0 || page == 2,
                  child: Container(
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(
                      horizontal: SizeUtil.getAppWidth(20),
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(SizeUtil.getAppWidth(10))
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: SizeUtil.getAppWidth(20),
                      vertical: SizeUtil.getAppHeight(10)
                    ),
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(text:"你的筛选项目：",style:TextStyle(fontSize: SizeUtil.getAppFontSize(30),color: Colors.deepOrangeAccent),),
                          TextSpan(text: marknames,style: TextStyle(fontSize: SizeUtil.getAppFontSize(30),color: Colors.black87))
                        ]
                      ),
                    )
                  ),
                ),
                //列表
                Expanded(
                  child: IndexedStack(
                    index: page,
                    children: [
                      PanAllPage(key: panAllPageStateKey,panContext: context,marknames: marknames,),
                      PanSchool(key: panSchoolStateKey,panContext: context,),
                      PanMine(key: panMineStateKey,panContext: context,callback: (){
                        //刷新pan数量
                        queryPanNum();
                      },)
                    ],
                  ),
                )
              ],
            ),
            Positioned(
              right: ScreenUtil().setWidth(SizeUtil.getWidth(30)),
              bottom: ScreenUtil().setHeight(SizeUtil.getHeight(100)),
              child: InkWell(
                onTap: (){
                  //创建网盘 tabslist第0个位置是全部，只在前端才有效，不作为其他接口参数
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> PanCreate(tabs: tabsList.sublist(1),isCreate: true,))).then((value){
                    if(value != null){
                      //queryPanNum();
                      selectClassify = 0;
                      selectClassName = "全部";
                      horizontalListTabKey.currentState.resetSelect(0);
                      changeTab(2);
                      //创建网盘切换我的网盘页面
                      setState(() {
                      });
                    }
                  });
                },
                child: Image.asset("image/ic_pan_create.png",width: ScreenUtil().setWidth(SizeUtil.getWidth(150)),height: ScreenUtil().setWidth(SizeUtil.getWidth(150)),),
              ),
            )
          ],
        ),
      ),
    );
  }
}
