

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yhschool/utils/Button.dart';


/**
 * 对角选中效果按钮
 */
class DiagonalButton extends StatefulWidget{

  String label;
  int position;


  DiagonalButton({Key key,@required this.label,@required this.position});

  @override
  State<StatefulWidget> createState() {
    return new DiagonalButtonState()
    ..label = label
    ..curState = Button.NORMAL
    ..position = position;
  }
}

class DiagonalButtonState extends State{

  int position;

  double radius_angle = 10;

  Button curState;

  Function callback;

  //按钮文本
  String label;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: curState == Button.NORMAL?ButtonNormalColor:ButtonSelectColor,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(radius_angle),
              topRight: Radius.zero,
              bottomRight: Radius.circular(radius_angle),
              bottomLeft: Radius.zero
          )
      ),
      padding: EdgeInsets.only(
          left: 10,
          right: 10,
          top: 5,
          bottom: 5
      ),
      child: Text(
        label,style: TextStyle(fontSize:16,color: curState == Button.NORMAL?LabelNormalColor:LabelSelectColor),
      ),
    );
  }

}