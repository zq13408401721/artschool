import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BaseTitleBar extends StatelessWidget{

  Function cb;
  String title;

  BaseTitleBar({@required this.title,@required this.cb});

  Widget backArrowWidget(){
    return Container(
        padding: EdgeInsets.only(left: ScreenUtil().setWidth(20),top: ScreenUtil().setHeight(20),bottom: ScreenUtil().setHeight(20),right: ScreenUtil().setWidth(20)),
        child: Icon(
          Icons.arrow_back,
          size: 24,
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil().setHeight(80),
      color: Colors.white,
      child: Row(
        children: [
          InkWell(
            onTap: (){
              Navigator.pop(context);
            },
            child: backArrowWidget(),
            //child: Image.asset("image/ic_arrow_left.png"),
          ),
          SizedBox(width: ScreenUtil().setWidth(40),),
          Text(title,style: TextStyle(fontSize: ScreenUtil().setSp(36)),)
        ],
      ),
    );
  }
}