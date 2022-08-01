import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PanTopTabButton extends StatefulWidget{

  String name;
  String tab;
  int index;

  TextStyle nameSelect;
  TextStyle nameStyle;
  TextStyle tabStyle;

  Function clickCB;

  PanTopTabButton({Key key,@required this.name,@required this.tab,@required this.index,@required this.clickCB}):super(key: key);

  @override
  State<StatefulWidget> createState() {

    nameSelect = new TextStyle(color: Colors.red,fontSize: ScreenUtil().setSp(36));
    nameStyle = new TextStyle(color: Colors.grey,fontSize: ScreenUtil().setSp(30));
    tabStyle = new TextStyle(color: Colors.grey,fontSize: ScreenUtil().setSp(25));

    return new PanTopTabButtonState();
  }
}

class PanTopTabButtonState extends State<PanTopTabButton>{

  bool _select;

  /**
   * 选中
   */
  void select(bool _bool){
    _select = _bool;
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        if(widget.clickCB != null){
          widget.clickCB(widget.index);
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(widget.name,style: _select ? widget.nameSelect : widget.nameStyle,),
          Text(widget.tab,style: widget.tabStyle,)
        ],
      ),
    );
  }

}