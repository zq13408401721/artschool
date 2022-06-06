import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ImageButton extends StatelessWidget{

  String icon;
  String label;
  Function cb;

  ImageButton({@required this.icon,@required this.label,@required this.cb}):
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
        text: TextSpan(
          children: [
            WidgetSpan(child: Container(
              margin: EdgeInsets.only(
                right: ScreenUtil().setWidth(20)
              ),
              child: Image.asset(icon,width: ScreenUtil().setWidth(40),height: ScreenUtil().setHeight(40),),
            )),
            TextSpan(
              text: label,style: TextStyle(fontSize: ScreenUtil().setSp(30),color: Colors.black87)
            )
          ]
        ),
      ),
    );
  }
}