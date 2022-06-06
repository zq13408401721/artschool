import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yhschool/BaseState.dart';
import 'package:yhschool/bean/video_category.dart';
import 'package:yhschool/bean/video_tab.dart' as M;
import 'package:yhschool/utils/BaseParam.dart';
import 'package:yhschool/utils/Constant.dart';
import 'package:yhschool/utils/DataUtils.dart';
import 'package:yhschool/utils/HttpUtils.dart';
import 'package:yhschool/utils/SizeUtil.dart';
import 'package:yhschool/widgets/BackButtonWidget.dart';
import 'package:yhschool/widgets/EgWordTopWidget.dart';

import '../VideoWeb.dart';
import 'VideoTile.dart';


class _CategoryMoreParam extends BaseParam{

  _CategoryMoreParam(categoryid,page,size){
    data = {
      "categoryid":categoryid,
      "page":page,
      "size":size
    };
    param = "categoryid:${categoryid}&page:${page}&size:${size}";
  }

}

class VideoMorePage extends StatefulWidget{

  String subject;
  String category;
  int categoryid;
  VideoMorePage({Key key,@required this.subject,@required this.category,@required this.categoryid}):super(key: key);

  @override
  State<StatefulWidget> createState() {
    return VideoMorePageState()
    ..subject = subject
    ..category = category
    ..categoryid = categoryid;
  }

}

class MyAppBar extends PreferredSize{
  Widget childView;
  @override
  final Size preferredSize;
  MyAppBar({this.preferredSize,this.childView});

  @override
  Widget build(BuildContext context) {
    Widget current = childView;
    if(current == null){
      current = LimitedBox(
        maxHeight: 0.0,
        maxWidth: 0.0,
        child: ConstrainedBox(constraints: const BoxConstraints.expand(),),
      );
    }
    return current;
  }

}

class VideoMorePageState extends BaseState{

  String subject,category;
  int categoryid;
  int page=1,size=80;
  List<Data> list=[];

  @override
  void initState() {
    super.initState();
    getVideoMore();
  }

  getVideoMore(){
    var _option = _CategoryMoreParam(categoryid, page, size);
    httpUtil.post(DataUtils.api_video_category_more,option: _option).then((value){
      String result = checkLoginExpire(value);
      if(result.isNotEmpty){
        var data = VideoCategory.fromJson(json.decode(value));
        if(data.errno == 0){
          setState(() {
            list.addAll(data.data);
          });
        }else{
          showToast(data.errmsg);
        }
      }
    }).catchError((err)=>{
      print(err)
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*MyAppBar(
        preferredSize: Size.fromHeight(SizeUtil.getHeight(80)),
        childView: Container(
          padding: EdgeInsets.only(
            top: ScreenUtil().setHeight(SizeUtil.getHeight(60))
          ),
          decoration: BoxDecoration(
            color:Colors.white
          ),
          child: Row(
            children: [
              BackButtonWidget(cb: (){
                Navigator.pop(context);
              }, title: subject+"   "+category),
              Expanded(
                child: Container(
                  alignment: Alignment(0.9,0),
                  child: Text("${list.length}个课程",style: Constant.smallTitleTextStyle,),
                ),
              )
            ],
          ),
        ),
      )*/
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey[100]
          ),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                    color: Colors.white
                ),
                padding: EdgeInsets.only(
                    top: ScreenUtil().setHeight(SizeUtil.getHeight(30)),
                    bottom: ScreenUtil().setHeight(SizeUtil.getHeight(10))
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    BackButtonWidget(cb: (){
                      Navigator.pop(context);
                    }, title: subject+"   "+category),
                    Expanded(
                      child: Container(
                        alignment: Alignment(0.9,0),
                        child: Text("${list.length}个课程",style: Constant.smallTitleTextStyle,),
                      ),
                    )
                  ],
                ),
              ),
              EgWordTopWidget(),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: list.length,
                          padding: EdgeInsets.symmetric(
                              horizontal: ScreenUtil().setWidth(SizeUtil.getWidth(20))
                          ),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisSpacing: ScreenUtil().setWidth(SizeUtil.getHeight(20)),
                              mainAxisSpacing: ScreenUtil().setWidth(SizeUtil.getWidth(20)),
                              crossAxisCount: 3,
                              childAspectRatio: Constant.isPad ? 0.79 : 0.66
                          ),
                          itemBuilder: (context,index){
                            return InkWell(
                              onTap: (){
                                List<M.Step> stepList = [];
                                list[index].step.forEach((element) {
                                  stepList.add(M.Step.fromJson(element.toJson()));
                                });
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>
                                    VideoWeb(classify: subject, section: category, category: list[index].name, categoryid: list[index].id,description: list[index].description,
                                      step: stepList,)
                                ));
                              },
                              child: VideoTile(title: subject+"/"+category,videoCategoryData: list[index],),
                            );
                          }
                      ),
                      SizedBox(height: ScreenUtil().setHeight(SizeUtil.getHeight(120)),)
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}