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
  final TextStyle screenTeacherSelect = TextStyle(color: Colors.red,fontSize: SizeUtil.getAppFontSize(30));

  int page = 0;
  List<Data> tabsList=[];
  String icon_enable_teacher = "image/ic_unenable_teacher.png";
  bool enable_teacher = false;
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
    if(index == 0){
      allTopTabState.currentState.select(true);
      schoolTopTabState.currentState.select(false);
      mineTopTabState.currentState.select(false);
      resetSelectTab();
      updatePanList();
    }else if(index == 1){
      allTopTabState.currentState.select(false);
      schoolTopTabState.currentState.select(true);
      mineTopTabState.currentState.select(false);
      resetSelectTab();
      updatePanList();
      //panSchoolStateKey.currentState.queryPanList(schoolid: schoolid,classifyid: 0,marks:marks,visible:enable_teacher);
    }else if(index == 2){
      allTopTabState.currentState.select(false);
      schoolTopTabState.currentState.select(false);
      mineTopTabState.currentState.select(true);
      resetSelectTab();
      updatePanList();
      //panMineStateKey.currentState.queryPanList(classifyid: 0);
    }
    setState(() {
      marknames = "";
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
      panSchoolStateKey.currentState.queryPanListByMark(selectClassify, this.marks,classifyname: selectClassName);
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
                  decoration: BoxDecoration(
                    color: Colors.white
                  ),
                  padding: EdgeInsets.symmetric(
                      vertical: ScreenUtil().setHeight(SizeUtil.getHeight(20))
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      //左边
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: ScreenUtil().setWidth(SizeUtil.getWidth(10))
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(SizeUtil.getWidth(20))),
                              child: PanTopTabButton(key:allTopTabState,name: "全部", tab: "", index: 0, clickCB: changeTab),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(SizeUtil.getWidth(20))),
                              child: PanTopTabButton(key:schoolTopTabState,name: "学校", tab: "", index: 1, clickCB: changeTab),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(SizeUtil.getWidth(20))),
                              child: PanTopTabButton(key:mineTopTabState,name: "我的", tab: "", index: 2, clickCB: changeTab),
                            )
                          ],
                        ),
                      ),
                      //中间
                      Expanded(
                        flex: 1,
                        child: SizedBox(),
                      ),
                      //搜索
                      Container(
                        padding: EdgeInsets.only(
                          right: SizeUtil.getAppWidth(20)
                        ),
                        child: ImageButton(icon: "image/ic_search.png", label: "", cb: ()=>{
                          Navigator.push(context, MaterialPageRoute(builder: (context) => SearchPanPage(callback: (){

                          })))
                        }),
                      ),
                    ],
                  ),
                ),
                //分类
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white
                  ),
                  padding: EdgeInsets.only(
                      left:ScreenUtil().setWidth(SizeUtil.getWidth(30)),
                      right: ScreenUtil().setWidth(SizeUtil.getWidth(30))
                  ),
                  margin: EdgeInsets.only(
                      bottom: ScreenUtil().setHeight(SizeUtil.getHeight(10))
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    //markname
                    Offstage(
                      offstage: marknames == null  || marknames.length == 0 || page == 2,
                      child: InkWell(
                        onTap: (){
                          setState(() {
                            this.marks = "";
                            this.marknames = "";
                          });
                          //panAllPageStateKey.currentState.queryPanListAll(selectClassify,classifyname: selectClassName);
                          updatePanList();
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: SizeUtil.getAppWidth(20)),
                          child: Text(marknames,style: Constant.titleTextStyleNormal,),
                        ),
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
                            child: Row(
                              children: [
                                Checkbox(value: enable_teacher, onChanged: (value){
                                  setState(() {
                                    enable_teacher = value;
                                    selectScreenPanList(marks: this.marks);
                                  });
                                },materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,),
                                InkWell(
                                  onTap: (){
                                    setState(() {
                                      enable_teacher = !enable_teacher;
                                      selectScreenPanList(marks: this.marks);
                                    });
                                  },
                                  child: Text("只看老师",style: enable_teacher ? screenTeacherSelect : screenTeacherNormal,),
                                )
                              ],
                            ),
                          ),
                        ),
                        //筛选 全部分类和我的页面的时候隐藏
                        Offstage(
                          offstage: selectClassify == 0 || page == 2,
                          child: Container(
                            margin:EdgeInsets.only(
                              right: SizeUtil.getAppWidth(20)
                            ),                 
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
              right: ScreenUtil().setWidth(SizeUtil.getWidth(40)),
              bottom: ScreenUtil().setWidth(SizeUtil.getWidth(200)),
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
                child: Image.asset("image/ic_pan_create.png",width: ScreenUtil().setWidth(SizeUtil.getWidth(148)),height: ScreenUtil().setWidth(SizeUtil.getWidth(148)),),
              ),
            )
          ],
        ),
      ),
    );
  }
}
