
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yhschool/bean/issue_video_list_bean.dart';
import 'package:yhschool/bean/video_tab.dart' as M;
import 'package:yhschool/utils/Constant.dart';
import 'package:yhschool/utils/DataUtils.dart';
import 'package:yhschool/utils/HttpUtils.dart';
import 'package:yhschool/utils/SizeUtil.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../BaseState.dart';
import '../TileCard.dart';
import '../VideoWeb.dart';

/**
 * 进入教学长视频
 */
class TodayTeachVideo extends StatefulWidget{

  String date;
  int classid;
  String uid;

  TodayTeachVideo({Key key,@required this.date,@required this.classid,@required this.uid}):super(key: key);

  @override
  State<StatefulWidget> createState() {
    return TodayTeachVideoState();
  }

}

class TodayTeachVideoState extends BaseState<TodayTeachVideo>{


  List<Data> videoList = [];

  @override
  void initState() {
    super.initState();
    _getPushVideoList();
  }

  void _getPushVideoList(){
    var option = {
      "classid":widget.classid,
      "date":widget.date,
      "uid":widget.uid
    };
    print("option:$option");
    httpUtil.post(DataUtils.api_issuevideolist,data:option).then((value){
      IssueVideoListBean bean = IssueVideoListBean.fromJson(json.decode(value));
      if(bean.errno == 0){
        setState(() {
          videoList.addAll(bean.data);
        });
      }else{
        //showToast(bean.errmsg);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.only(
          left: ScreenUtil().setWidth(SizeUtil.getWidth(30)),
          right: ScreenUtil().setWidth(SizeUtil.getWidth(30)),
          top: ScreenUtil().setHeight(SizeUtil.getHeight(30))
        ),
        child: GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: videoList.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: ScreenUtil().setWidth(Constant.PADDING_GALLERY_CROSS),
                crossAxisSpacing: Constant.GARRERY_GRID_CROSSAXISSPACING,
                childAspectRatio: Constant.isPad ? 0.86 : 0.75
            ),
            itemBuilder: (BuildContext context,int index){
              return InkWell(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(ScreenUtil().setWidth(SizeUtil.getWidth(20))),
                      bottomRight: Radius.circular(ScreenUtil().setWidth(SizeUtil.getWidth(20)))
                    ),
                  ),
                  padding: EdgeInsets.only(bottom: SizeUtil.getHeight(10)),
                  child: TileCard(url: videoList[index].cover,title: videoList[index].name,width: double.infinity,height: Constant.GARRERY_ITEM_HEIGHT),
                ),
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) =>
                      VideoWeb(classify: videoList[index].title.split("/")[0], section: videoList[index].title.split("/")[1], category: videoList[index].name,
                        categoryid: videoList[index].videoid,description: videoList[index].description,step: [],)
                  ));
                },
              );
            }
        ),
      ),
    );
  }
}