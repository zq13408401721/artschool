import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yhschool/BaseState.dart';
import 'package:yhschool/utils/Constant.dart';
import 'package:yhschool/utils/SizeUtil.dart';
import 'package:yhschool/video/VideoMorePage.dart';
import 'package:yhschool/widgets/BackButtonWidget.dart';

/**
 * 每日单词
 */
class EgWorkPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
     return EgWorkPageState();
  }
}

class EgWorkPageState extends BaseState{

  String word = "";
  @override
  void initState() {
    super.initState();
    getWord();
  }

  getWord(){
    queryEgWord().then((value){
      print("eg:$value");
      setState(() {
        word = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          color: Colors.grey[100],
          child: Column(
            children: [
              MyAppBar(
                preferredSize: Size.fromHeight(SizeUtil.getHeight(80)),
                childView: Container(
                  padding: EdgeInsets.only(
                      top: ScreenUtil().setHeight(SizeUtil.getHeight(60))
                  ),
                  decoration: BoxDecoration(
                      color:Colors.white
                  ),
                  child: BackButtonWidget(cb: (){
                    Navigator.pop(context);
                  },title: "每日记单词",),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: ScreenUtil().setWidth(SizeUtil.getWidth(40))
                  ),
                  child: Center(
                    child: Text(word,style: TextStyle(fontSize: ScreenUtil().setSp(SizeUtil.getFontSize(80))),),
                  ),
                ),
              ),
              InkWell(
                onTap: (){
                  getWord();
                },
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(ScreenUtil().setWidth(SizeUtil.getWidth(10)))
                  ),
                  alignment: Alignment(0,0),
                  margin: EdgeInsets.only(
                      left: ScreenUtil().setWidth(SizeUtil.getWidth(100)),
                      right: ScreenUtil().setWidth(SizeUtil.getWidth(100)),
                      bottom: ScreenUtil().setHeight(SizeUtil.getHeight(100))
                  ),
                  padding: EdgeInsets.symmetric(
                      vertical: ScreenUtil().setHeight(SizeUtil.getHeight(40))
                  ),
                  child:Text("换一个",style: TextStyle(fontSize:ScreenUtil().setSp(SizeUtil.getFontSize(30)),color: Colors.white),),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}