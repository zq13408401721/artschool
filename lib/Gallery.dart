import 'dart:convert';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yhschool/BaseState.dart';
import 'package:yhschool/GalleryClassifyList.dart';
import 'package:yhschool/GalleryListPage.dart';
import 'package:yhschool/OfficialGallery.dart';
import 'package:yhschool/SchoolGallery.dart';
import 'package:yhschool/TileCard.dart';
import 'package:yhschool/bean/entity_gallery_classify.dart';
import 'package:yhschool/bean/entity_gallery_tab.dart';
import 'package:yhschool/book/OfficialBook.dart';
import 'package:yhschool/utils/Constant.dart';
import 'package:yhschool/utils/DataUtils.dart';
import 'package:yhschool/utils/HttpUtils.dart';
import 'package:yhschool/utils/ImageType.dart';
import 'package:yhschool/utils/SizeUtil.dart';

import 'bean/entity_gallery_tab.dart';
import 'bean/entity_gallery_tab.dart';
import 'bean/entity_gallery_tab.dart';

/**
 * 主页
 */
class Gallery extends StatefulWidget{

  Gallery({Key key}):super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new GalleryState();
  }

}

class GalleryState extends BaseState<Gallery> with SingleTickerProviderStateMixin{

  final GlobalKey<OfficialState> officialGalleryKey = GlobalKey<OfficialState>();
  final GlobalKey<SchoolState> schoolGalleryKey = GlobalKey<SchoolState>();

  TabController tabController;
  int tabIndex=0;
  var currentPage;

  List<Widget> tabPage = [];
  TextStyle tabSelect;
  TextStyle tabNormal;

  @override
  void initState() {
    super.initState();

    tabSelect = TextStyle(fontSize: ScreenUtil().setSp(SizeUtil.getFontSize(40)),fontWeight: FontWeight.bold,color: Colors.red);
    tabNormal = TextStyle(fontSize: ScreenUtil().setSp(SizeUtil.getFontSize(30)),color: Colors.black87);

    tabPage = [
      //OfficialGallery(key: officialGalleryKey,),
      OfficialBook(),
      SchoolGallery(key:schoolGalleryKey,)
    ];
    currentPage = tabPage[tabIndex];
    tabController = TabController(length: 2, vsync: this)
    ..addListener(() {
      switch(tabController.index){
        case 0:
          if(tabIndex != 0){
            setState(() {
              tabIndex = 0;
              currentPage = tabPage[tabIndex];
            });
          }
          break;
        case 1:
          if(tabIndex != 1){
            setState(() {
              tabIndex = 1;
              currentPage = tabPage[tabIndex];
            });
          }
          break;
      }
    });
  }

  updataState(){
    officialGalleryKey.currentState.updataState();
    schoolGalleryKey.currentState.updataState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
              color: Colors.grey[100]
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //顶部导航
              Container(
                //height: ScreenUtil().setHeight(SizeUtil.getHeight(Constant.SIZE_TOP_BAR_HEIGHT)),
                height: SizeUtil.getAppHeight(SizeUtil.getTabHeight()),
                decoration: BoxDecoration(
                    color: Colors.white
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: (){
                        if(tabIndex !=  0){
                          setState(() {
                            tabIndex = 0;
                            currentPage = tabPage[tabIndex];
                          });
                        }
                      },
                      child: Container(
                        //child: Text("图书馆",style: tabIndex == 0 ? tabSelect : tabNormal,),
                        child: Image.asset("image/ic_book.png",height:SizeUtil.getAppHeight(80),fit: BoxFit.contain,),
                      ),
                    ),
                    /*SizedBox(width: ScreenUtil().setWidth(SizeUtil.getWidth(SizeUtil.getWidth(30))),),
                InkWell(
                  onTap: (){
                    //showToast("学校暂未开启本功能");
                    if(tabIndex != 1){
                      setState(() {
                        tabIndex = 1;
                        currentPage = tabPage[tabIndex];
                      });
                    }
                  },
                  child: Container(
                    child: Text("学校图片",style: tabIndex == 1 ? tabSelect : tabNormal,),
                  ),
                )*/
                  ],
                ),
              ),
              Expanded(child: OfficialBook()),
              /*Expanded(
                child: IndexedStack(
                  index: tabIndex,
                  children: tabPage,
                ),
              )*/
            ],
          ),
        ),
      ),
    );
  }
}