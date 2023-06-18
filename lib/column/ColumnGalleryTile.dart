import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yhschool/bean/column_gallery_bean.dart';
import 'package:yhschool/utils/Constant.dart';
import 'package:yhschool/utils/SizeUtil.dart';
import 'package:yhschool/widgets/ImagePlaceHolder.dart';

class ColumnGalleryTile extends StatelessWidget{

  String author;
  String url;
  String columnname;
  int width,height;
  String avater;

  ColumnGalleryTile({@required this.author,@required this.url,@required this.columnname,@required this.avater,
  @required this.width,@required this.height});


  String _getColumnName(){
    if(Constant.isPad){
      if(columnname.length > 8){
        columnname = columnname.substring(0,8);
      }
    }else{
      if(columnname.length > 5){
        columnname = columnname.substring(0,5);
      }
    }
    return columnname;
  }

  @override
  Widget build(BuildContext context) {
    double _height = ScreenUtil().setHeight(SizeUtil.getHeight(Constant.getScaleH(width.toDouble(), height.toDouble())));
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(ScreenUtil().setWidth(SizeUtil.getWidth(10)))
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /*Container(
              height: _height,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Constant.getColor(),
              ),
              child: CachedNetworkImage(
                imageUrl: Constant.parseColumnSmallString(url),
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
          ),*/
          ImagePlaceHolder(url: Constant.parseNewColumnListIconString(url,width,height), width: double.infinity, height: _height),
          //头像信息显示区域
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: ScreenUtil().setWidth(SizeUtil.getWidth(20)),
                vertical: ScreenUtil().setWidth(SizeUtil.getWidth(20))
            ),
            child: Row(
              children: [
                ClipOval(
                  child: avater == null ? Image.asset("image/ic_head.png",width: SizeUtil.getWidth(40),height: SizeUtil.getWidth(40),fit:BoxFit.cover) : CachedNetworkImage(imageUrl: avater,width: SizeUtil.getWidth(40),height: SizeUtil.getWidth(40),fit:BoxFit.cover),
                ),
                SizedBox(width: ScreenUtil().setWidth(SizeUtil.getWidth(18)),),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(author,style: Constant.titleTextStyleNormal,maxLines: 1,),
                    Text("相册《${_getColumnName()}》",style: Constant.smallTitleTextStyle,maxLines: 1,)
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}