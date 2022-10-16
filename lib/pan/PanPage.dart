import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yhschool/BaseDialogState.dart';
import 'package:yhschool/bean/pan_classify_bean.dart';
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


  int page = 0;
  List<Data> tabsList=[];
  String icon_enable_teacher = "image/ic_unenable_teacher.png";
  bool enable_teacher = false;
  int selectClassify = 0;
  String schoolid;


  @override
  void initState() {
    super.initState();
    getSchoolid().then((value) => schoolid = value);
    this.getPanClassify();
  }



  //切换顶部导航
  void changeTab(int index){
    if(index == 0){
      allTopTabState.currentState.select(true);
      schoolTopTabState.currentState.select(false);
      mineTopTabState.currentState.select(false);
    }else if(index == 1){
      allTopTabState.currentState.select(false);
      schoolTopTabState.currentState.select(true);
      mineTopTabState.currentState.select(false);
      panSchoolStateKey.currentState.queryPanList(schoolid: schoolid,classifyid: 0);
    }else if(index == 2){
      allTopTabState.currentState.select(false);
      schoolTopTabState.currentState.select(false);
      mineTopTabState.currentState.select(true);
      panMineStateKey.currentState.queryPanList(classifyid: 0);
    }
    setState(() {
      page = index;
    });
  }

  /**
   * 更新网盘列表
   */
  void updatePanList(){
    if(page == 0){
      this.panAllPageStateKey.currentState.queryPanListAll(selectClassify);
    }else if(page == 1){
      panSchoolStateKey.currentState.queryPanList(schoolid: schoolid,classifyid: selectClassify);
    }else if(page == 2){
      panMineStateKey.currentState.queryPanList(classifyid: selectClassify);
    }
  }

  /**
   * 网盘分类
   */
  void getPanClassify(){
    httpUtil.get(DataUtils.api_panclassify).then((value){
      print("getPanClassify:"+value);
      PanClassifyBean panClassify = PanClassifyBean.fromJson(json.decode(value));
      if(panClassify.errno == 0) {
        this.tabsList = panClassify.data;
        selectClassify = this.tabsList[0].id;
        this.tabsList[0].select = true;
        this.panAllPageStateKey.currentState.queryPanListAll(selectClassify);
      }
      setState(() {

      });
    });
  }

  @override
  Widget build(BuildContext context) {
    print("panpage build");
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: Stack(
            children: [
              Column(
                children: [
                  //顶部菜单 左右两边
                  Container(
                    padding: EdgeInsets.symmetric(
                        vertical: ScreenUtil().setHeight(SizeUtil.getHeight(20))
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        //左边
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: ScreenUtil().setWidth(SizeUtil.getWidth(10))
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(SizeUtil.getWidth(20))),
                                child: PanTopTabButton(key:allTopTabState,name: "全部", tab: "P1000", index: 0, clickCB: changeTab),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(SizeUtil.getWidth(20))),
                                child: PanTopTabButton(key:schoolTopTabState,name: "学校", tab: "P1000", index: 1, clickCB: changeTab),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(SizeUtil.getWidth(20))),
                                child: PanTopTabButton(key:mineTopTabState,name: "我的", tab: "P1000", index: 2, clickCB: changeTab),
                              )
                            ],
                          ),
                        ),
                        //中间
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Expanded(
                              flex: 1,
                              child: SizedBox(),
                            ),
                          ),
                        ),
                        //右边
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            //是否仅显老师
                            ImageButton(icon: icon_enable_teacher, label: "", cb: (){
                              showPanVisible(this.enable_teacher).then((value){
                                if(value){
                                  this.enable_teacher = !this.enable_teacher;
                                  setState(() {
                                    this.icon_enable_teacher = this.enable_teacher ? "image/ic_enable_teacher.png" : "image/ic_unenable_teacher.png";
                                  });
                                }
                              });
                            }),
                            //筛选
                            ImageButton(icon: "image/ic_pan_screen.png", label: "", cb: (){
                              //mark筛选
                              showPanScreen(context, selectClassify).then((value){
                                //创建网盘成功 进入我的网盘
                                if(value != null){
                                  panAllPageStateKey.currentState.queryPanListByMark(selectClassify, value);
                                }

                              });
                            }),
                            //搜索
                            ImageButton(icon: "image/ic_search.png", label: "", cb: ()=>{
                              Navigator.push(context, MaterialPageRoute(builder: (context) => SearchPanPage(callback: (){

                              })))
                            }),
                          ],
                        )
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
                    child: HorizontalListTab(datas: tabsList, click: (dynamic _data){
                      this.selectClassify = _data.id;
                      print("${_data.id}");
                      updatePanList();
                    }),
                  ),
                  //广告栏
                  //CachedNetworkImage(imageUrl: ""),
                  //列表
                  Expanded(
                    child: IndexedStack(
                      index: page,
                      children: [
                        PanAllPage(key: panAllPageStateKey,panContext: context),
                        PanSchool(key: panSchoolStateKey,panContext: context,),
                        PanMine(key: panMineStateKey,panContext: context,)
                      ],
                    ),
                  ),
                  //SizedBox(height: SizeUtil.getAppHeight(50),)
                ],
              ),
              Positioned(
                right: ScreenUtil().setWidth(SizeUtil.getWidth(40)),
                bottom: ScreenUtil().setWidth(SizeUtil.getWidth(200)),
                child: InkWell(
                  onTap: (){
                    //创建网盘
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> PanCreate(tabs: tabsList,))).then((value){
                      if(value != null){

                      }
                    });
                  },
                  child: Image.asset("image/ic_pan_create.png",width: ScreenUtil().setWidth(SizeUtil.getWidth(148)),height: ScreenUtil().setWidth(SizeUtil.getWidth(148)),),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
