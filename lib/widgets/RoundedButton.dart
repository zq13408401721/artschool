import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yhschool/utils/Constant.dart';

class RoundedButton extends StatelessWidget{

  Function click;
  String label;
  int horizontal;
  int vertical;
  int margin_top,margin_bottom,margin_left,margin_right;
  TextStyle txtStyle;
  RoundedButton({@required this.click,@required this.label,
    @required this.horizontal=20,
    @required this.vertical=10,
    @required this.margin_top=0,
    @required this.margin_bottom=0,
    @required this.margin_left=0,
    @required this.margin_right=0,
    @required this.txtStyle
  }):assert(click!=null){
    if(txtStyle == null){
      txtStyle = TextStyle(fontSize: ScreenUtil().setSp(30),color: Colors.white);
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        click();
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.red
        ),
        padding: EdgeInsets.symmetric(
          horizontal:ScreenUtil().setWidth(horizontal),
          vertical: ScreenUtil().setHeight(vertical)
        ),
        margin: EdgeInsets.only(
          left: ScreenUtil().setWidth(margin_left),
          right: ScreenUtil().setWidth(margin_right),
          top:ScreenUtil().setHeight(margin_top),
          bottom: ScreenUtil().setHeight(margin_bottom)
        ),
        alignment: Alignment(0,0),
        child: Text(this.label,style: txtStyle,),
      ),
    );
  }
}