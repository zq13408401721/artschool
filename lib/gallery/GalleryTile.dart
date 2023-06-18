import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yhschool/bean/entity_gallery_classify.dart';
import 'package:yhschool/bean/entity_gallery_list.dart';
import 'package:yhschool/utils/Constant.dart';
import 'package:yhschool/utils/ImageType.dart';
import 'package:yhschool/utils/SizeUtil.dart';

class GalleryTile extends StatelessWidget{


  dynamic data;
  String smallurl = "";
  bool hideWord;
  GalleryTile({Key key,@required this.data,@required this.hideWord = false,tileType = BigImageType.gallery}):super(key: key){
    if(this.data != null && this.data.url != null){
      if(tileType == BigImageType.gallery) {
        //smallurl = Constant.parseNewGallerySmallString(this.data.url,this.data.width,this.data.height);
        smallurl = Constant.parseGallerySmallString(this.data.url);
      }else{
        smallurl = Constant.parseBookSmallString(this.data.url);
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    print("smallurl:${smallurl}");
    double _height = ScreenUtil().setHeight(SizeUtil.getHeight(Constant.getScaleH(data.width.toDouble(), data.height.toDouble())));
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
              child:smallurl.isNotEmpty ? CachedNetworkImage(
                imageUrl: smallurl,
                fit: BoxFit.cover,
                memCacheWidth: data.width,
                memCacheHeight: data.height,
              ) : SizedBox()
          ),
          Padding(
            padding: EdgeInsets.only(top: ScreenUtil().setHeight(SizeUtil.getHeight(20)),
                left: ScreenUtil().setWidth(SizeUtil.getWidth(40)),
                right: ScreenUtil().setWidth(SizeUtil.getWidth(40)),
                bottom: ScreenUtil().setHeight(SizeUtil.getHeight(20))
            ),
            child: Text(
              '${data.name}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: ScreenUtil().setSp(SizeUtil.getFontSize(32))),

            ),
          ),
          !hideWord ? Padding(
            padding: EdgeInsets.only(bottom: ScreenUtil().setHeight(SizeUtil.getHeight(30)),left: ScreenUtil().setWidth(SizeUtil.getWidth(40)),right: ScreenUtil().setWidth(SizeUtil.getWidth(40))),
            child: Text(
              '${data.word}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Constant.smallTitleTextStyle,
            ),
          ) : SizedBox()
        ],
      ),
    );
  }

}