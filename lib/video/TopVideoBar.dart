import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/Constant.dart';
import '../utils/SizeUtil.dart';
import '../widgets/BackButtonWidget.dart';
import '../widgets/CollectVideoButton.dart';

class TabVideoBar extends StatefulWidget{
  final Key key;
  int role;
  int categoryid;
  String classify;
  String section;
  Function callback;
  TabVideoBar({@required this.key,@required this.role,@required this.categoryid,
    @required this.classify,@required this.section,@required this.callback}):super(key: key);

  @override
  State<StatefulWidget> createState() {
    return TabVideoBarState();
  }

}

class TabVideoBarState extends State<TabVideoBar>{

  String curmodel = "vertical"; //当前屏幕横竖屏

  TextStyle _textStyle = TextStyle(fontSize: SizeUtil.getAppFontSize(25),color: Colors.white);

  void updateModel(String model){
    setState(() {
      this.curmodel = model;
    });
  }

  Widget backArrowWidget(){
    return Container(
        padding: EdgeInsets.only(left: ScreenUtil().setWidth(20),top: ScreenUtil().setHeight(20),bottom: ScreenUtil().setHeight(20),right: ScreenUtil().setWidth(20)),
        child: Icon(
          Icons.arrow_back,
          size: 24,
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    print("tabVideo curmodel:"+curmodel);
    return curmodel == "vertical" ? Container(
      decoration: BoxDecoration(
          color: Colors.white
      ),
      padding: EdgeInsets.symmetric(
        vertical: 10
      ),
      child: Row(
        mainAxisAlignment:MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: (){
              widget.callback("back");
            },
            child: backArrowWidget(),
            /*child: Row(
              children: [
                Image.asset("image/ic_return.png",width: 20,height: 20,),
                Text("返回",),
              ],
            ),*/
          ),
          /*BackButtonWidget(cb: (){
            print("click:${curmodel}");
            widget.callback("back");
          }, title: "返回"),*/
          widget.role == 1 ?
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CollectVideoButton(margin_right: 20,categoryid: widget.categoryid,subject: widget.classify,section: widget.section,),
                InkWell(
                  onTap: (){
                    //pushVideo();
                    widget.callback("push");
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.purple,
                        borderRadius: BorderRadius.all(Radius.circular(2))
                    ),
                    margin: EdgeInsets.only(right: 10),
                    padding: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4
                    ),
                    child: Text("推送到班级",style: _textStyle,),
                  ),
                )
                /* m_role == 1 ?
                                PushButtonWidget(cb: (){
                                  pushVideo();
                                }, title: "推送") : SizedBox()*/
              ],
            ),
          ) : SizedBox()
        ],
      ),
    ) : SizedBox();
  }
}