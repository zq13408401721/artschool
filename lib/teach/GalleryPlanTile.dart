import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yhschool/bean/gallery_plan_list_bean.dart';
import 'package:yhschool/utils/Constant.dart';
import 'package:yhschool/utils/SizeUtil.dart';

class GalleryPlanTile extends StatelessWidget{

  Groups groups;
  String classname;
  GalleryPlanTile({@required this.groups,@required this.classname});

  @override
  Widget build(BuildContext context) {
    double _height = ScreenUtil().setHeight(SizeUtil.getHeight(Constant.getScaleH(groups.width.toDouble(), groups.height.toDouble())));
    return Container(
      decoration: BoxDecoration(
        color:Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(ScreenUtil().setWidth(SizeUtil.getWidth(20))),
          bottomRight: Radius.circular(ScreenUtil().setWidth(SizeUtil.getWidth(20)))
        )
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              height: _height,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Constant.getColor(),
              ),
              child: CachedNetworkImage(
                imageUrl: Constant.parseIssueSmallString(groups.url),
                //height: ScreenUtil().setHeight(height),
                placeholder: (_context, _url) =>
                    Stack(
                      alignment: Alignment(0,0),
                      children: [
                        Image.network(_url,width:double.infinity,height:_height,fit: BoxFit.cover,),
                        Container(
                          width: ScreenUtil().setWidth(40),
                          height: ScreenUtil().setWidth(40),
                          child: CircularProgressIndicator(color: Colors.red,),
                        ),
                      ],
                    ),
                fit: BoxFit.cover,
              )
          ),
          Padding(
            padding: EdgeInsets.only(top: ScreenUtil().setHeight(SizeUtil.getHeight(20)),left: ScreenUtil().setWidth(SizeUtil.getWidth(20)),right: ScreenUtil().setWidth(SizeUtil.getWidth(20))),
            child: Text(
              '${groups.name}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Constant.titleTextStyleNormal,

            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: ScreenUtil().setHeight(SizeUtil.getHeight(10)),bottom: ScreenUtil().setHeight(SizeUtil.getHeight(10)),left: ScreenUtil().setWidth(SizeUtil.getWidth(20)),right: ScreenUtil().setWidth(SizeUtil.getWidth(20))),
            child: Text(
              '${this.classname}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Constant.smallTitleTextStyle,

            ),
          ),
        ],
      ),
    );
  }
}