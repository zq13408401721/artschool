import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyRadiuButton extends StatelessWidget{

  double angle,width,height,margin;
  Function cb;
  String label;

  MyRadiuButton({@required this.label,@required this.angle,@required this.width=double.infinity,@required this.height,@required this.margin,@required this.cb});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        cb();
      },
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(angle),
          color: Colors.red
        ),
        alignment: Alignment(0,0),
        margin: EdgeInsets.symmetric(
          horizontal: margin
        ),
        child: Text(this.label,style: TextStyle(fontSize: ScreenUtil().setSp(30),color: Colors.white),),
      ),
    );
  }
}