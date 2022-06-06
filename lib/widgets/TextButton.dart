import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yhschool/BaseState.dart';
import 'package:yhschool/utils/SizeUtil.dart';

class TextButton extends StatefulWidget{
  String label;
  TextStyle normalStyle;
  TextStyle selectStyle;
  double labelSpace;
  bool defaultSelect=false;
  Function cb;
  TextButton({Key key,@required this.label,@required this.normalStyle,@required this.selectStyle,@required this.labelSpace,@required this.defaultSelect=false,@required this.cb}):super(key: key){
    if(normalStyle == null){
      normalStyle = TextStyle(fontSize: ScreenUtil().setSp(SizeUtil.getFontSize(30)),color: Colors.black87);
    }
    if(selectStyle == null){
      selectStyle = TextStyle(fontSize: ScreenUtil().setSp(SizeUtil.getFontSize(40)),color: Colors.red,fontWeight: FontWeight.bold);
    }
  }

  @override
  State<StatefulWidget> createState() {
    return TextButtonState()
    .._select = defaultSelect;
  }

}

class TextButtonState extends BaseState<TextButton>{

  bool _select=false;

  @override
  void initState() {
    super.initState();
  }

  void updateState(bool _bool){
    setState(() {
      _select = _bool;
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        if(widget.cb != null){
          widget.cb();
        }
      },
      child: Container(
        padding: EdgeInsets.only(
          right: widget.labelSpace
        ),
        child: Text(widget.label,style: _select ? widget.selectStyle : widget.normalStyle,),
      ),
    );
  }
}