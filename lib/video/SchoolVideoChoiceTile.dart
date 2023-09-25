import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yhschool/utils/Constant.dart';
import 'package:yhschool/bean/choice_bean.dart';
import 'package:yhschool/utils/SizeUtil.dart';
import 'package:yhschool/widgets/ImageCacheFile.dart';

import '../BaseState.dart';
import '../utils/DataUtils.dart';
import '../utils/HttpUtils.dart';

/**
 * 视频条目
 */
class SchoolVideoChoiceTile extends StatefulWidget {

  String title;

  Data data;

  bool showTitle;

  SchoolVideoChoiceTile(
      {Key key, @required this.data, @required this.title, @required this.showTitle = true})
      :super(key: key);

  @override
  State<StatefulWidget> createState() {
    return SchoolVideoChoiceTileState();
  }


}

class SchoolVideoChoiceTileState extends BaseState<SchoolVideoChoiceTile>{


  int total;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getVideoTotal();
  }

  void getVideoTotal(){
    var param = {
      "groupid":widget.data.id
    };
    httpUtil.post(DataUtils.api_school_video_group_total,data:param,context: context).then((value){
      print("videogrouptotal $value");
      if(value != null){
        Map<String,dynamic> map = json.decode(value);
        if(map.containsKey("data")){
          total = map["data"];
          setState(() {
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return  Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(SizeUtil.getAppWidth(20))
        /*borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(ScreenUtil().setWidth(SizeUtil.getWidth(10))),
              bottomRight: Radius.circular(ScreenUtil().setWidth(SizeUtil.getWidth(10)))
          )*/
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            height: SizeUtil.getAppHeight(500),
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(ScreenUtil().setWidth(5)),
                  child: CachedNetworkImage(imageUrl:widget.data.cover,fit: BoxFit.cover,width: double.infinity,),
                ),
                /*Positioned(
                  top: 0,
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    child: Image.asset(Constant.isPad ? "image/ic_play.png" :"image/ic_play_30.png",),
                  ),
                ),*/
              ],
            ),
          ),
          //标题名之底部对齐
          Column(
            children: [
              Padding(
                  padding: EdgeInsets.only(
                      left: ScreenUtil().setWidth(SizeUtil.getWidth(20)),
                      right: ScreenUtil().setWidth(SizeUtil.getWidth(20)),
                      top: ScreenUtil().setHeight(SizeUtil.getHeight(20)),
                      bottom: ScreenUtil().setHeight(SizeUtil.getHeight(20))
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.data.name,style: TextStyle(fontSize: SizeUtil.getAppFontSize(30),color: Colors.black87,fontWeight: FontWeight.bold),maxLines: 1,),
                      SizedBox(height: SizeUtil.getAppHeight(20),),
                      RichText(
                        text: TextSpan(
                            children: [
                              TextSpan(text: "已更新",style: TextStyle(fontSize: SizeUtil.getAppFontSize(25),color: Colors.grey)),
                              TextSpan(text: "$total",style: TextStyle(fontSize: SizeUtil.getAppFontSize(30),color: Colors.red)),
                              TextSpan(text: "个课程，点击立即学习",style: TextStyle(fontSize: SizeUtil.getAppFontSize(25),color: Colors.grey)),
                            ]
                        ),
                      )
                    ],
                  )
              ),
              /*Offstage(
                offstage: !showTitle,
                child: Padding(
                  padding: EdgeInsets.only(
                    //left: ScreenUtil().setWidth(SizeUtil.getWidth(40)),
                    //right: ScreenUtil().setWidth(SizeUtil.getWidth(40)),
                  ),
                  child: Text(title,style: Constant.smallTitleTextStyle,maxLines: 1,),
                ),
              ),*/
            ],
          )
        ],
      ),
    );
  }

}
