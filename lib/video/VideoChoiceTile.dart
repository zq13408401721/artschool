import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yhschool/utils/Constant.dart';
import 'package:yhschool/bean/choice_bean.dart';
import 'package:yhschool/utils/SizeUtil.dart';
import 'package:yhschool/widgets/ImageCacheFile.dart';

/**
 * 视频条目
 */
class VideoChoiceTile extends StatelessWidget{

  String title;

  Data data;

  VideoChoiceTile({Key key,@required this.data,@required this.title}):super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(ScreenUtil().setWidth(SizeUtil.getWidth(10))),
              bottomRight: Radius.circular(ScreenUtil().setWidth(SizeUtil.getWidth(10)))
          )
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              CachedNetworkImage(imageUrl:data.cover),
              Positioned(
                top: 0,
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  child: Image.asset(Constant.isPad ? "image/ic_play.png" :"image/ic_play_30.png",),
                ),
              ),
            ],
          ),
          Spacer(),
          Padding(
            padding: EdgeInsets.only(
                left: ScreenUtil().setWidth(SizeUtil.getWidth(40)),
                right: ScreenUtil().setWidth(SizeUtil.getWidth(40)),
                bottom: ScreenUtil().setHeight(SizeUtil.getHeight(10))
            ),
            child: Text(data.name,style: Constant.titleTextStyleNormal,maxLines: 1,),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: ScreenUtil().setWidth(SizeUtil.getWidth(40)),
              right: ScreenUtil().setWidth(SizeUtil.getWidth(40)),
            ),
            child: Text(title,style: Constant.smallTitleTextStyle,maxLines: 1,),
          ),
          SizedBox(height: ScreenUtil().setHeight(SizeUtil.getHeight(30)),)
        ],
      ),
    );
  }

}