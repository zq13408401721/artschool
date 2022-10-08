import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yhschool/BaseState.dart';
import 'package:yhschool/utils/Constant.dart';
import 'package:yhschool/utils/DataUtils.dart';
import 'package:yhschool/utils/HttpUtils.dart';
import 'package:yhschool/utils/SizeUtil.dart';
import 'package:yhschool/bean/pan_bean.dart';

class PanCopyDialog extends StatefulWidget{

  Function callback;
  PanCopyDialog({Key key,@required this.callback}):super(key: key);

  @override
  State<StatefulWidget> createState() {
    return PanCopyDialogState();
  }
}

class PanCopyDialogState extends BaseState<PanCopyDialog>{

  List<Data> panList = [];
  Data selectPan;

  @override
  void initState() {
    super.initState();
    queryMyPan();
  }

  void queryMyPan(){
    httpUtil.post(DataUtils.api_querymypan,data: {}).then((value){
      print(value);
      PanBean panBean = PanBean.fromJson(json.decode(value));
      if(panBean.errno == 0){
        panList.addAll(panBean.data);
        selectPan = panList[0];
        setState(() {
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FractionallySizedBox(
        widthFactor: 2/3,
        heightFactor: 1/4,
        child: Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.only(
                    top: ScreenUtil().setWidth(SizeUtil.getWidth(20)),
                    right: ScreenUtil().setWidth(SizeUtil.getWidth(20))
                ),
                alignment: Alignment.topRight,
                child: GestureDetector(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: Image.asset("image/ic_fork.png"),
                ),
              ),
              //title
              Padding(padding: EdgeInsets.only(left: SizeUtil.getAppWidth(20)),
                child: Text("请选择你的网盘",style: TextStyle(fontSize: SizeUtil.getAppFontSize(30),fontWeight: FontWeight.bold),),
              ),
              Offstage(
                offstage: panList.length > 0,
                child: Padding(padding: EdgeInsets.only(left: SizeUtil.getAppWidth(20)),
                child: Text("你还没有创建任何网盘～～",style: Constant.smallTitleTextStyle,)),
              ),
              //选择网盘
              Offstage(
                offstage: panList.length == 0,
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: SizeUtil.getAppWidth(20),vertical: SizeUtil.getAppHeight(20)),
                  padding: EdgeInsets.symmetric(horizontal: SizeUtil.getAppWidth(10)),
                  decoration: BoxDecoration(
                      color:Colors.white,
                      border: Border.all(color: Colors.black12,width: 1),
                      borderRadius: BorderRadius.vertical(
                          top: Radius.elliptical(4,4,),
                          bottom: Radius.elliptical(4, 4)
                      )
                  ),
                  child: DropdownButton(
                    isExpanded: true,
                    hint: Text("我的网盘"),
                    underline: Container(),
                    icon: Icon(Icons.arrow_right),
                    items: panList.map((e) => DropdownMenuItem(
                      child: Text(e.name),
                      value: e,
                    )).toList(),
                    value: selectPan,
                    onChanged: (item){
                      setState(() {
                        selectPan = item;
                        print(item.name);
                      });
                    },
                  ),
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: InkWell(
                    onTap: (){
                      if(widget.callback != null){
                        if(panList.length == 0){
                          //创建网盘
                          widget.callback(false);
                        }else{
                          //复制网盘
                          widget.callback(true,selectPan.panid);
                        }
                      }
                      Navigator.pop(context);
                    },
                    child: Container(
                      height: SizeUtil.getAppHeight(80),
                      decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(SizeUtil.getAppWidth(10)),
                              bottomRight: Radius.circular(SizeUtil.getAppWidth(10))
                          )
                      ),
                      alignment: Alignment.center,
                      child: Text(panList.length == 0 ? "创建网盘" : "提交",style: TextStyle(color: Colors.white,fontSize: SizeUtil.getAppFontSize(30)),),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
