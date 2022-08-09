
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yhschool/utils/SizeUtil.dart';

class PanTitle extends StatelessWidget{

  Function cb;

  PanTitle({@required this.cb});

  @override
  Widget build(BuildContext context) {
    return Container(
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
          Text("新建网盘",style: TextStyle(fontSize: ScreenUtil().setSp(SizeUtil.getFontSize(30))),),
          Text("500G超大高速空间/FREE",style: TextStyle(fontSize: ScreenUtil().setSp(SizeUtil.getFontSize(20)),color: Colors.grey),)
        ],
      ),
    );
  }
}
