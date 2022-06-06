import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yhschool/utils/Constant.dart';
import 'package:yhschool/utils/SizeUtil.dart';

class BarItem extends StatelessWidget{

  String label;
  String icon_select;
  String icon_normal;
  double width,height;
  TextStyle labelStyle_select = TextStyle(fontSize: ScreenUtil().setSp(SizeUtil.getFontSize(25)),color: Colors.red);
  TextStyle labelStyle_normal = TextStyle(fontSize: ScreenUtil().setSp(SizeUtil.getFontSize(25)),color: Colors.grey);
  Function click;
  bool select;
  BarItem({@required this.label,
    @required this.icon_select,
    @required this.icon_normal,
    @required this.width,
    @required this.height,
    @required this.click,
    @required this.select});


  Widget labelTxt(){
    if(label == "课堂"){
      if(select){
        return SizedBox();
      }
      return Text(label,style: labelStyle_normal,);
    }else if(label == "视频"){
      if(select){
        label = "示范课";
      }
    }else if(label == "示范课"){
      if(!select) label = "视频";
    }
    return Text(label,style: select ? labelStyle_select : labelStyle_normal,);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenUtil().setWidth(SizeUtil.getWidth(100)),
      height: ScreenUtil().setHeight(SizeUtil.getHeight(Constant.isPad ? 100 : 110)),
      child: InkWell(
        onTap: (){
          this.click();
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(select ? icon_select : icon_normal,width: width,height: height),
            labelTxt()
          ],
        ),
      ),
    );
  }


}