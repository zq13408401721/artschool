import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yhschool/utils/Constant.dart';
import 'package:yhschool/utils/SizeUtil.dart';

class BackButtonWidget extends StatelessWidget{

  Function cb;
  String title;
  String word;
  TextStyle wordStyle;
  int grade;
  Color titleBg;
  
  BackButtonWidget({@required this.cb,@required this.title,@required this.word="",@required this.wordStyle,@required this.grade=0,@required this.titleBg=Colors.white}){
    this.word = this.word == null ? "" : this.word;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
       cb();
      },
      child: Container(
        decoration: BoxDecoration(
          color: titleBg
        ),
        padding: EdgeInsets.only(
          left:ScreenUtil().setWidth(SizeUtil.getWidth(30)),
          top: ScreenUtil().setHeight(SizeUtil.getHeight(20)),
          bottom: ScreenUtil().setHeight(SizeUtil.getHeight(30))
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset("image/ic_return.png",width: ScreenUtil().setWidth(SizeUtil.getWidth(40)),height: ScreenUtil().setHeight(SizeUtil.getHeight(40)),),
            Text("$title",style: Constant.titleTextStyleNormal,),
            SizedBox(width: ScreenUtil().setWidth(SizeUtil.getWidth(20)),),
            Text(word,style: wordStyle != null ? wordStyle : Constant.smallTitleTextStyle,),
            SizedBox(width: ScreenUtil().setWidth(SizeUtil.getWidth(20)),),
            Text(grade > 0 ? "优秀作业" : "",style: TextStyle(fontSize: ScreenUtil().setSp(SizeUtil.getFontSize(30)),color: Colors.red,fontWeight: FontWeight.bold),)
          ],
        ),
      ),
    );
  }

}