import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yhschool/bean/entity_gallery_classify.dart';
import 'package:yhschool/bean/entity_gallery_list.dart';
import 'package:yhschool/utils/Constant.dart';
import 'package:yhschool/utils/SizeUtil.dart';

class GalleryTile extends StatelessWidget{


  GalleryListData category;
  String smallurl = "";
  GalleryTile({Key key,@required this.category}):super(key: key){
    smallurl = Constant.parseNewGallerySmallString(this.category.url,category.width,category.height);
  }

  @override
  Widget build(BuildContext context) {

    print("smallurl:${smallurl}");
    double _height = ScreenUtil().setHeight(SizeUtil.getHeight(Constant.getScaleH(category.width.toDouble(), category.height.toDouble())));
    return Card(
      color: Colors.white,
      elevation: 0.0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              height: _height,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Constant.getColor(),
              ),
              child:CachedNetworkImage(
                imageUrl: smallurl,
                fit: BoxFit.cover,
                memCacheWidth: category.width,
                memCacheHeight: category.height,
              )
          ),
          Padding(
            padding: EdgeInsets.only(top: ScreenUtil().setHeight(SizeUtil.getHeight(40)),left: ScreenUtil().setWidth(SizeUtil.getWidth(40)),right: ScreenUtil().setWidth(SizeUtil.getWidth(40))),
            child: Text(
              '${category.name}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: ScreenUtil().setSp(SizeUtil.getFontSize(32))),

            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: ScreenUtil().setHeight(SizeUtil.getHeight(10)),bottom: ScreenUtil().setHeight(SizeUtil.getHeight(30)),left: ScreenUtil().setWidth(SizeUtil.getWidth(40)),right: ScreenUtil().setWidth(SizeUtil.getWidth(40))),
            child: Text(
              '${category.word}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Constant.smallTitleTextStyle,
            ),
          )
        ],
      ),
    );
  }

}