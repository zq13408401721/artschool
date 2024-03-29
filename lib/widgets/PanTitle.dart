
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yhschool/utils/SizeUtil.dart';

class PanTitle extends StatelessWidget{

  Function cb;
  String title;

  PanTitle({@required this.cb,@required this.title="新建网盘"});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setHeight(SizeUtil.getHeight(10))),
      child: Row(
        children: [
          InkWell(
            onTap: (){
             if(cb != null){
               cb();
             }
            },
            child: Image.asset("image/ic_arrow_left.png",width: ScreenUtil().setWidth(60),height: ScreenUtil().setHeight(80),),
          ),
          Text("$title",style: TextStyle(fontSize: ScreenUtil().setSp(SizeUtil.getFontSize(30))),),
          SizedBox(width: SizeUtil.getAppWidth(20),),
          Text("无限容量高速空间",style: TextStyle(fontSize: ScreenUtil().setSp(SizeUtil.getFontSize(25)),color: Colors.grey),)
        ],
      ),
    );
  }
}
