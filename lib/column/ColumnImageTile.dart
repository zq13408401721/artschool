import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yhschool/bean/column_gallery_list_bean.dart';
import 'package:yhschool/utils/Constant.dart';
import 'package:yhschool/utils/SizeUtil.dart';

class ColumnImageTile extends StatelessWidget{

  Data data;
  Function deleteClick;
  bool isdelete;

  ColumnImageTile({@required this.data,@required this.deleteClick,@required this.isdelete=false});

  @override
  Widget build(BuildContext context) {
    double _height = ScreenUtil().setHeight(SizeUtil.getHeight(Constant.getScaleH(data.width.toDouble(), data.height.toDouble())));
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(ScreenUtil().setWidth(SizeUtil.getWidth(10)))
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
                    imageUrl: Constant.parseNewColumnSmallString(data.url,data.width,data.height),
                    /*placeholder: (_context, _url) =>
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
                        ),*/
                    fit: BoxFit.cover,
                  )
              ),
            ],
          ),
        ),
        isdelete ?
        Positioned(
          right: 5,
          top: 5,
          child: InkWell(
            onTap: (){
              deleteClick();
            },
            child: Image.asset("image/ic_round_close.png",width: ScreenUtil().setWidth(SizeUtil.getWidth(60)),height: ScreenUtil().setWidth(SizeUtil.getWidth(60)),),
          ),
        ) : SizedBox()
      ],
    );
  }
}