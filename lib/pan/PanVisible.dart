
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yhschool/BaseState.dart';

import '../utils/Constant.dart';
import '../utils/SizeUtil.dart';

class PanVisible extends StatefulWidget{

  bool isteacher;

  PanVisible({Key key,@required this.isteacher}):super(key: key);

  @override
  State<StatefulWidget> createState() {
    return PanVisibleState();
  }
}

class PanVisibleState extends BaseState<PanVisible>{

  bool select = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPanVisible().then((value){
      select = value == null ? false : true;
      setState(() {
        select = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Card(
        child: Container(
          padding: EdgeInsets.symmetric(
              horizontal: SizeUtil.getAppWidth(20),
              vertical: SizeUtil.getAppHeight(20)
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.isteacher == true ? "只显示老师的网盘" : "显示所有网盘",style: TextStyle(fontSize: SizeUtil.getAppFontSize(30)),),
              InkWell(
                  onTap: (){
                    setState(() {
                      select = !select;
                      print("select ${select}");
                    });
                  },
                  child: Row(
                    children: [
                      Checkbox(value: select == null ? false : select, onChanged: (value){
                        print("checkbox ${value}");
                        setState(() {
                          select = value;
                        });
                      }),
                      Text("记住我的选择",style: Constant.smallTitleTextStyle,)
                    ],
                  ),
                ),
              SizedBox(height: SizeUtil.getHeight(20),),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: (){
                        print("savePanVisible ${select}");
                        savePanVisible(select);
                        Navigator.pop(context,select);
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: SizeUtil.getAppWidth(10)),
                        padding: EdgeInsets.symmetric(vertical: SizeUtil.getAppWidth(10),horizontal: SizeUtil.getAppWidth(20)),
                        decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.all(Radius.circular(SizeUtil.getWidth(5)))
                        ),
                        child: Text("确定",style: TextStyle(color: Colors.white,fontSize: SizeUtil.getAppFontSize(30)),),
                      ),
                    ),
                    InkWell(
                        onTap: (){
                          print("select ${select}");
                          Navigator.pop(context,select);
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: SizeUtil.getAppWidth(10)),
                          padding: EdgeInsets.symmetric(vertical: SizeUtil.getAppWidth(10),horizontal: SizeUtil.getAppWidth(20)),
                          decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.all(Radius.circular(SizeUtil.getWidth(5)))
                          ),
                          child: Text("取消",style: TextStyle(color: Colors.white,fontSize: SizeUtil.getAppFontSize(30)),),
                        )
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

}