import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yhschool/utils/Constant.dart';
import 'package:yhschool/utils/SizeUtil.dart';

class PushButtonWidget extends StatelessWidget{

  Function cb;
  String title;

  PushButtonWidget({@required this.cb,@required this.title});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        cb();
      },
      child: Container(
        padding: EdgeInsets.only(
            right:ScreenUtil().setWidth(SizeUtil.getWidth(40)),
            top: ScreenUtil().setHeight(SizeUtil.getHeight(20)),
            bottom: ScreenUtil().setHeight(SizeUtil.getHeight(30))
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset("image/ic_push.png",width: ScreenUtil().setWidth(SizeUtil.getWidth(36)),height: ScreenUtil().setHeight(SizeUtil.getHeight(36)),),
            SizedBox(width: ScreenUtil().setWidth(SizeUtil.getWidth(10)),),
            Text("$title",style: Constant.titleTextStyleNormal,)
          ],
        ),
      ),
    );
  }

}