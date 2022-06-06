
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yhschool/BaseState.dart';
import 'package:yhschool/teach/TodayTeachGallery.dart';
import 'package:yhschool/teach/TodayTeachSmallVideo.dart';
import 'package:yhschool/teach/TodayTeachVideo.dart';
import 'package:yhschool/utils/Constant.dart';
import 'package:yhschool/utils/SizeUtil.dart';
import 'package:yhschool/widgets/BackButtonWidget.dart';

class TodayTeachList extends StatefulWidget{

  String teacherName;
  String tid;
  int dateId;
  String date;
  int classid;

  TodayTeachList({Key key,@required this.teacherName,@required this.tid,@required this.dateId,@required this.date,@required this.classid}):super(key: key);

  @override
  State<StatefulWidget> createState() {
    return TodayTeachListState()
    ..teacherName=teacherName
    ..tid=tid
    ..dateId=dateId;
  }

}

class TodayTeachListState extends BaseState<TodayTeachList>{

  String teacherName;
  String tid;
  int dateId;

  //当前选中标签 0图片 1小视频 2长视频
  int selectIndex=0;
  //对应选中的页面 0图片页面 1小视频页面 2长视频页面

  @override
  void initState(){
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
              BackButtonWidget(cb: (){
                Navigator.pop(context);
              }, title: this.teacherName),
              Container(
                decoration: BoxDecoration(
                    color: Colors.white
                ),
                padding: EdgeInsets.only(
                    left: ScreenUtil().setWidth(SizeUtil.getWidth(120)),
                    right: ScreenUtil().setWidth(SizeUtil.getWidth(120)),
                    top: ScreenUtil().setHeight(SizeUtil.getHeight(30)),
                    bottom: ScreenUtil().setHeight(SizeUtil.getHeight(30))
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
                          child: Text("图片资料",style: TextStyle(
                              color:selectIndex == 0 ? Colors.white : Colors.black87,
                              fontSize: ScreenUtil().setSp(SizeUtil.getFontSize(40))
                          ),),
                        ),
                      ),
                    ),
                    //小视频暂时屏蔽
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
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                      color:Colors.grey[100]
                  ),
                  child: Stack(
                    children: [
                      Offstage(
                        offstage:selectIndex != 0,
                        child: TodayTeachGallery(tid: tid,dateId: dateId,),
                      ),
                      //TodayTeachSmallVideo(),
                      Offstage(
                        offstage: selectIndex != 1,
                        child: TodayTeachVideo(uid: tid,date: widget.date,classid: widget.classid,),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}