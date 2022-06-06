import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yhschool/BaseState.dart';
import 'package:yhschool/utils/Constant.dart';
import 'package:yhschool/utils/SizeUtil.dart';

class EgWordWidget extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return EgWordWidgetState();
  }
}

class EgWordWidgetState extends BaseState{

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
      alignment: Alignment(1,0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(word == null ? "" : word,style: Constant.smallTitleTextStyle,maxLines: 1,overflow: TextOverflow.ellipsis,softWrap: true),
          InkWell(
            onTap: (){
              getWord();
            },
            child: Image.asset("image/ic_refresh.png",width: ScreenUtil().setWidth(SizeUtil.getWidth(50)),height:ScreenUtil().setHeight(SizeUtil.getHeight(50))),
          )
        ],
      ),
    );
  }
}