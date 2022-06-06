import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yhschool/utils/Constant.dart';
import 'package:yhschool/utils/SizeUtil.dart';

class ColumnMineTileAdd extends StatelessWidget{
  
  Function cb;
  
  ColumnMineTileAdd({@required this.cb});
  
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        cb();
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(ScreenUtil().setWidth(SizeUtil.getWidth(10)))
        ),
        height: ScreenUtil().setHeight(SizeUtil.getHeight(500)),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("+",style: TextStyle(fontSize: ScreenUtil().setSp(SizeUtil.getFontSize(70))),),
              SizedBox(height: ScreenUtil().setHeight(SizeUtil.getHeight(20)),),
              Text("新建专栏",style: TextStyle(fontSize: ScreenUtil().setSp(SizeUtil.getFontSize(30)),fontWeight: FontWeight.bold),),
              SizedBox(height: ScreenUtil().setHeight(SizeUtil.getHeight(150)),),
              Text("500G超大高速空间",style: Constant.smallTitleTextStyle,maxLines: 1,)
            ],
          ),
        ),
      ),
    );
  }
}