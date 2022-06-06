import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yhschool/BaseState.dart';
import 'package:yhschool/utils/Constant.dart';
import 'package:yhschool/utils/SizeUtil.dart';

class CollectTile extends StatelessWidget{

  String smallurl = '';
  String url = '';
  String title = '';
  String name = '';
  int width,height;
  bool ispush; //当前是否是推送状态
  bool selectState; //选中状态
  Function callback;

  CollectTile({Key key,@required this.smallurl,@required this.url,@required this.title,@required this.name,@required this.width,@required this.height,@required this.ispush,
    @required this.callback,@required this.selectState=false}):super(key: key);


  @override
  Widget build(BuildContext context) {
    print("title:${title}");
    double _height = ScreenUtil().setHeight(SizeUtil.getHeight(Constant.getScaleH(width.toDouble(), height.toDouble())));
    return Card(
      color: Colors.white,
      elevation: 0.0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                  height: _height,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Constant.getColor(),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: smallurl,
                    width: double.infinity,
                    height: _height,
                    /*placeholder: (_context, _url) =>
                        Center(
                          child: Container(
                            width: ScreenUtil().setWidth(SizeUtil.getWidth(40)),
                            height: ScreenUtil().setWidth(SizeUtil.getWidth(40)),
                            child: CircularProgressIndicator(color: Colors.red,),
                          ),
                        ),*/
                    fit: BoxFit.cover,
                  )
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: ScreenUtil().setHeight(SizeUtil.getHeight(20)),left: ScreenUtil().setWidth(SizeUtil.getWidth(30)),right: ScreenUtil().setWidth(SizeUtil.getWidth(10))),
            child: Text(
              '$name',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Constant.titleTextStyleNormal,

            ),
          ),
          SizedBox(height: ScreenUtil().setHeight(SizeUtil.getHeight(10)),),
          (title != null && title.length > 0) ?
          Padding(
            padding: EdgeInsets.only(bottom: ScreenUtil().setHeight(SizeUtil.getHeight(20)),left: ScreenUtil().setWidth(SizeUtil.getWidth(30)),right: ScreenUtil().setWidth(SizeUtil.getWidth(10))),
            child: Text(
              '$title',
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
