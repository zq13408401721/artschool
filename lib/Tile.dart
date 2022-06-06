import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yhschool/utils/Constant.dart';

/**
 * 新版的瀑布流列表条目
 */
class Tile extends StatelessWidget{

  String smallurl = '';
  String title = '';
  String author = '';
  double width,height;

  Tile({Key key,@required this.smallurl,@required this.title,@required this.author,@required this.width=0,@required this.height=0}):super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 0.0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              height: ScreenUtil().setHeight(Constant.getScaleH(width, height)),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Constant.getColor(),
              ),
              child: CachedNetworkImage(
                imageUrl: smallurl,
                //height: ScreenUtil().setHeight(height),
                memCacheWidth: width.toInt(),
                memCacheHeight: height.toInt(),
                placeholder: (_context, _url) =>
                    Container(
                      width: 130,
                      height: 80,
                      child: Center(
                          child: Stack(
                            alignment: Alignment(0,0),
                            children: [
                              Image.network(_url,fit: BoxFit.cover,),
                              Container(
                                width: ScreenUtil().setWidth(40),
                                height: ScreenUtil().setWidth(40),
                                child: CircularProgressIndicator(color: Colors.red,),
                              ),
                            ],
                          )
                      ),
                    ),
                fit: BoxFit.cover,
              )
          ),
          Padding(
            padding: EdgeInsets.only(top: ScreenUtil().setHeight(40),left: ScreenUtil().setWidth(10),right: ScreenUtil().setWidth(10)),
            child: Text(
              '$title',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: Constant.isPad ? ScreenUtil().setSp(32) : ScreenUtil().setSp(42)),

            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: ScreenUtil().setHeight(10),bottom: ScreenUtil().setHeight(40),left: ScreenUtil().setWidth(10),right: ScreenUtil().setWidth(10)),
            child: Text(
              '$author',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: Constant.isPad ? ScreenUtil().setSp(32) : ScreenUtil().setSp(42),color: Colors.grey),

            ),
          )
          
        ],
      ),
    );
  }



}