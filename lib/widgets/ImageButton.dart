import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yhschool/utils/SizeUtil.dart';

class ImageButton extends StatelessWidget{

  String icon;
  String label;
  Function cb;
  TextStyle titleStyle;

  ImageButton({@required this.icon,@required this.label,@required this.cb,@required this.titleStyle}):
        assert(icon != null),
        assert(label != null),
        assert(cb != null);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        cb();
      },
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          children: [
            WidgetSpan(
              alignment: PlaceholderAlignment.middle,
              child: Container(
                padding: EdgeInsets.only(
                  right: SizeUtil.getAppWidth(10)
                ),
                child: Image.asset(icon,width: ScreenUtil().setWidth(40),height: ScreenUtil().setHeight(40),),
              ),
            ),
            TextSpan(
              text: label,style: titleStyle == null ? TextStyle(fontSize: ScreenUtil().setSp(30),color: Colors.black87) : titleStyle
            )
          ]
        ),
      ),
    );
  }
}