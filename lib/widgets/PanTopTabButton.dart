import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yhschool/utils/SizeUtil.dart';

class PanTopTabButton extends StatefulWidget{

  String name;
  String tab;
  int index;



  Function clickCB;

  PanTopTabButton({Key key,@required this.name,@required this.tab,@required this.index,@required this.clickCB}):super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new PanTopTabButtonState();
  }
}

class PanTopTabButtonState extends State<PanTopTabButton>{

  TextStyle nameSelect;
  TextStyle nameStyle;
  TextStyle tabStyle;

  bool _select = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nameSelect = new TextStyle(color: Colors.red,fontSize: SizeUtil.getAppFontSize(40),fontWeight: FontWeight.bold);
    nameStyle = new TextStyle(color: Colors.black87,fontSize:SizeUtil.getAppFontSize(30),fontWeight: FontWeight.normal);
    tabStyle = new TextStyle(color: Colors.grey,fontSize: SizeUtil.getAppFontSize(25));
    if(widget.index == 0){
      select(true);
    }
  }

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
    return Container(
      child: InkWell(
        onTap: (){
          if(widget.clickCB != null){
            widget.clickCB(widget.index);
          }
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(widget.name,style: _select ? nameSelect : nameStyle,textAlign: TextAlign.center,),
            (widget.tab != null && widget.tab.length > 0) ?
            Text(widget.tab,style: tabStyle,textAlign: TextAlign.center,) :
            SizedBox()
          ],
        ),
      ),
    );
  }

}