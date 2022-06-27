import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yhschool/bean/video_category.dart' as M;
import 'package:yhschool/bean/video_tab.dart';
import 'package:yhschool/utils/Constant.dart';
import 'package:yhschool/utils/SizeUtil.dart';
import 'package:yhschool/widgets/ImageCacheFile.dart';

/**
 * 视频条目
 */
class VideoTile extends StatelessWidget{

  String title;

  Categorys data; //在分类列表中使用
  M.Data videoCategoryData; //在更多中使用

  VideoTile({Key key,@required this.data,@required this.videoCategoryData,@required this.title}):super(key: key);


  @override
  Widget build(BuildContext context) {
    return Container(
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
              ClipRRect(
                borderRadius: BorderRadius.circular(ScreenUtil().setWidth(SizeUtil.getWidth(5))),
                child: CachedNetworkImage(imageUrl: data != null ? data.cover : videoCategoryData.cover),
              ),
              Positioned(
                top: 0,bottom: 0,left: 0,right: 0,
                child: Image.asset(Constant.isPad ? "image/ic_play.png" : "image/ic_play_30.png",width: ScreenUtil().setWidth(SizeUtil.getWidth(60)),height: ScreenUtil().setHeight(SizeUtil.getHeight(60)),),
              )
            ],
          ),
          Spacer(),
          Padding(
            padding: EdgeInsets.only(
                left: ScreenUtil().setWidth(SizeUtil.getWidth(40)),
                right: ScreenUtil().setWidth(SizeUtil.getWidth(40)),
                bottom: ScreenUtil().setHeight(SizeUtil.getHeight(10))
            ),
            child: Text(data != null ? data.name : videoCategoryData.name,style: Constant.titleTextStyleNormal,maxLines: 1,),
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