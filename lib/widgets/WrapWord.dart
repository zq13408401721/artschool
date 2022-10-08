import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yhschool/BaseState.dart';
import 'package:yhschool/utils/Constant.dart';
import 'package:yhschool/utils/SizeUtil.dart';

/**
 * 流式布局
 */
class WrapWord extends StatefulWidget{

  List<String> words;
  Function callback;
  WrapWord({@required this.words,@required this.callback,Key key}):super(key: key);

  @override
  State<StatefulWidget> createState() {
    return WrapWordState();
  }

}

class WrapWordState extends BaseState<WrapWord>{

  Widget wrapItem(String item) {
    /*return Chip(
      label: Text(item,style: Constant.smallTitleTextStyle,),
      avatar: CircleAvatar(
        backgroundColor: ,
      ),
    );*/
    return InkWell(
      onTap: (){
        if(widget.callback != null){
          widget.callback(item);
        }
      },
      child: Text(item,style: Constant.smallTitleTextStyle,),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(ScreenUtil().setWidth(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: ScreenUtil().setWidth(SizeUtil.getWidth(5)), //水平方向间距
            runSpacing: ScreenUtil().setHeight(SizeUtil.getHeight(10)),//垂直方向间距
            alignment: WrapAlignment.start,
            children: <Widget>[
              for(String item in widget.words) wrapItem(item)
            ],
          )
        ],
      ),
    );
  }
}