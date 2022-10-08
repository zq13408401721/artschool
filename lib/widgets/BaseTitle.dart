import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yhschool/utils/SizeUtil.dart';

/**
 * 带返回箭头的title
 */
class BaseTitle extends StatelessWidget{

  String title;
  BaseTitle({@required this.title});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: ScreenUtil().setHeight(SizeUtil.getHeight(20)),
        horizontal: ScreenUtil().setWidth(SizeUtil.getWidth(10))
      ),
      child: Row(
        children: [
          InkWell(
            onTap: (){
              Navigator.pop(context);
            },
            child: Image.asset("image/ic_arrow_left.png"),
          ),
          SizedBox(width: ScreenUtil().setWidth(SizeUtil.getWidth(20)),),
          Text(this.title,style: TextStyle(fontSize: ScreenUtil().setSp(SizeUtil.getFontSize(30))))
        ],
      ),
    );
  }

}