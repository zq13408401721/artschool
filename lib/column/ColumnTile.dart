import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yhschool/BaseState.dart';
import 'package:yhschool/bean/issue_gallery_bean.dart';
import 'package:yhschool/popwin/PopWindowMark.dart';
import 'package:yhschool/utils/Constant.dart';
import 'package:yhschool/utils/SizeUtil.dart';

/**
 * 新版的瀑布流列表条目
 */
class ColumnTile extends StatefulWidget {

  String smallurl = '';
  String title = '';
  String author = '';

  ColumnTile({Key key, @required this.smallurl, @required this.title, @required this.author}) :super(key: key);

  @override
  State<StatefulWidget> createState() {
    return TeachTileState();
  }
}

class TeachTileState extends BaseState{

  String smallurl = '';
  String title = '';
  String author = '';
  int role;
  String uid;
  Gallery gallery;
  @override
  void initState() {
    super.initState();
    getUid().then((value){
      setState(() {
        this.uid = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double _height = ScreenUtil().setHeight(SizeUtil.getHeight(Constant.getScaleH(gallery.width.toDouble(), gallery.height.toDouble())));
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
              child: CachedNetworkImage(
                imageUrl: smallurl,
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
            padding: EdgeInsets.only(top: ScreenUtil().setHeight(40),left: ScreenUtil().setWidth(10),right: ScreenUtil().setWidth(10)),
            child: Text(
              '$title',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: Constant.isPad ? ScreenUtil().setSp(32) : ScreenUtil().setSp(42)),

            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: ScreenUtil().setHeight(10),bottom: ScreenUtil().setHeight(10),left: ScreenUtil().setWidth(10),right: ScreenUtil().setWidth(10)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '$author',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: Constant.isPad ? ScreenUtil().setSp(32) : ScreenUtil().setSp(42),color: Colors.grey),

                ),

              ],
            ),
          ),
        ],
      ),
    );
  }

}