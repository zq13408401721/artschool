
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yhschool/BaseState.dart';
import 'package:yhschool/collects/CollectGallery.dart';
import 'package:yhschool/collects/CollectSmallVideo.dart';
import 'package:yhschool/collects/CollectVideo.dart';
import 'package:yhschool/utils/Constant.dart';
import 'package:yhschool/utils/SizeUtil.dart';
import 'package:yhschool/widgets/BackButtonWidget.dart';

class CollectPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return CollectPageState();
  }

}

class CollectPageState extends BaseState{

  //当前选中标签 0图片 1小视频 2长视频
  int selectIndex=0;

  @override
  void initState() {
    super.initState();
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
              Container(
                height: ScreenUtil().setHeight(SizeUtil.getHeight(Constant.SIZE_TOP_HEIGHT)),
                decoration: BoxDecoration(
                    color: Colors.white
                ),
                child:BackButtonWidget(
                  cb: (){
                    Navigator.pop(context);
                  },title: "我的收藏",
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    color: Colors.white
                ),
                padding: EdgeInsets.only(
                    left: ScreenUtil().setWidth(SizeUtil.getWidth(120)),
                    right: ScreenUtil().setWidth(SizeUtil.getWidth(120)),
                    top: ScreenUtil().setHeight(SizeUtil.getHeight(60)),
                    bottom: ScreenUtil().setHeight(SizeUtil.getHeight(60))
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: InkWell(
                        onTap: (){
                          //点击图片
                          setState(() {
                            selectIndex = 0;
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.only(
                              top: ScreenUtil().setHeight(SizeUtil.getHeight(20)),
                              bottom: ScreenUtil().setHeight(SizeUtil.getHeight(20))
                          ),
                          alignment: Alignment(0,0),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(ScreenUtil().setWidth(SizeUtil.getWidth(10))),
                                bottomLeft: Radius.circular(ScreenUtil().setWidth(SizeUtil.getWidth(10))),
                              ),
                              color: selectIndex == 0 ? Colors.red : Colors.white
                          ),
                          child: Text("图片",style: TextStyle(
                              color:selectIndex == 0 ? Colors.white : Colors.black87,
                              fontSize: ScreenUtil().setSp(SizeUtil.getFontSize(40))
                          ),),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: InkWell(
                        onTap: (){
                          //点击长视频
                          setState(() {
                            selectIndex = 1;
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.only(
                              top: ScreenUtil().setHeight(SizeUtil.getHeight(20)),
                              bottom: ScreenUtil().setHeight(SizeUtil.getHeight(20))
                          ),
                          alignment: Alignment(0,0),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(ScreenUtil().setWidth(SizeUtil.getWidth(10))),
                                bottomRight: Radius.circular(ScreenUtil().setWidth(SizeUtil.getWidth(10))),
                              ),
                              color: selectIndex == 1 ? Colors.red : Colors.white
                          ),
                          child: Text("视频课程",style: TextStyle(
                              color:selectIndex == 1 ? Colors.white : Colors.black87,
                              fontSize: ScreenUtil().setSp(SizeUtil.getFontSize(40))
                          ),),
                        ),
                      ),
                    )

                  ],
                ),
              ),
              SizedBox(height: ScreenUtil().setHeight(SizeUtil.getHeight(20)),),
              Expanded(
                child: IndexedStack(
                  index: selectIndex,
                  children: [
                    CollectGallery(),
                    //CollectSmallVideo(),
                    CollectVideo()
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}