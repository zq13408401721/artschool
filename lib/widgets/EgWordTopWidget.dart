import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yhschool/BaseState.dart';
import 'package:yhschool/utils/Constant.dart';
import 'package:yhschool/utils/SizeUtil.dart';

class EgWordTopWidget extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return EgWordTopWidgetState();
  }
}

class EgWordTopWidgetState extends BaseState{

  String word="";

  @override
  void initState() {
    super.initState();
    getWord();
  }

  getWord(){
    queryEgWord().then((value){
      print("eg:$value");
      setState(() {
        if(value.length > 28){
          word = value.substring(0,27)+"...";
        }else{
          word = value;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(ScreenUtil().setWidth(SizeUtil.getWidth(10)))
      ),
      padding: EdgeInsets.only(
          left: ScreenUtil().setWidth(SizeUtil.getWidth(40)),
          right: ScreenUtil().setWidth(SizeUtil.getWidth(40)),
          top: ScreenUtil().setHeight(SizeUtil.getHeight(20)),
          bottom: ScreenUtil().setHeight(SizeUtil.getHeight(20))
      ),
      margin: EdgeInsets.only(
          left: ScreenUtil().setWidth(SizeUtil.getWidth(20)),
          right: ScreenUtil().setWidth(SizeUtil.getWidth(20)),
          top: ScreenUtil().setHeight(SizeUtil.getHeight(20)),
          bottom: ScreenUtil().setHeight(SizeUtil.getHeight(20))
      ),
      child: Column(
        children: [
          /*Row(
            children: [
              Image.asset("image/ic_eg_word.png",width: ScreenUtil().setWidth(40),height: ScreenUtil().setHeight(40),),
              Text("记个小单词"),
              Expanded(
                child: Container(
                  alignment: Alignment(1,0),
                  child: Text("X"),
                ),
              )
            ],
          ),*/
          InkWell(
            onTap: (){
              getWord();
            },
            child: Row(
              children: [
                Text(word == null ? "" : word,style: TextStyle(fontSize: ScreenUtil().setSp(SizeUtil.getFontSize(30)),color: Colors.black54,),maxLines: 1,overflow: TextOverflow.ellipsis,softWrap: true,),
                Image.asset("image/ic_refresh.png",width: ScreenUtil().setWidth(SizeUtil.getWidth(40)),height:ScreenUtil().setHeight(SizeUtil.getHeight(40))),
              ],
            ),
          )
        ],
      ),
    );
  }
}