import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yhschool/utils/Constant.dart';
import 'package:yhschool/utils/SizeUtil.dart';

import 'package:yhschool/bean/pan_bean.dart';
import 'package:yhschool/utils/DataUtils.dart';
import 'package:yhschool/utils/HttpUtils.dart';

class DialogManager{

  DialogManager._privateConstructor();

  static final DialogManager _instantce = DialogManager._privateConstructor();

  factory DialogManager(){
    return _instantce;
  }

  StateSetter _stateSetter;

  List<Data> panList = [];
  Data selectPan;

  int visible;

  bool requesting;

  void _queryPanList(){
    panList = [];
    httpUtil.post(DataUtils.api_querymypan,data: {}).then((value){
      print(value);
      if(value != null){
        PanBean panBean = PanBean.fromJson(json.decode(value));
        if(panBean.errno == 0){
          _stateSetter((){
            panList.addAll(panBean.data);
            selectPan = panList[0];
          });
        }
      }

    });
  }

  /**
   * 显示复制网盘dialog
   */
  void showCopyPanImageDialog(BuildContext context){
    _queryPanList();
    showDialog(context: context, builder: (context){
      return StatefulBuilder(builder: (_context,_state){
        _stateSetter = _state;
        return UnconstrainedBox(
          child: Card(
            child: Container(
              width: SizeUtil.getAppWidth(500),
              height: SizeUtil.getAppHeight(400),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        left: SizeUtil.getAppWidth(20),
                        right: SizeUtil.getAppWidth(20),
                        top: SizeUtil.getAppHeight(20)
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("请选择你的网盘",style: Constant.titleTextStyleNormal,),
                        GestureDetector(
                          onTap: (){
                            Navigator.pop(context);
                          },
                          child: Image.asset("image/ic_fork.png",width: SizeUtil.getAppWidth(40),height: SizeUtil.getAppWidth(40),),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: SizeUtil.getAppWidth(20),),
                  Padding(
                    padding: EdgeInsets.only(
                        left: SizeUtil.getAppWidth(20),
                        right: SizeUtil.getAppWidth(20),
                        top: SizeUtil.getAppHeight(20)
                    ),
                    child: Container(
                      width: SizeUtil.getAppWidth(300),
                      height: SizeUtil.getAppWidth(80),
                      padding: EdgeInsets.only(
                          left:SizeUtil.getAppWidth(20),
                          top:SizeUtil.getAppWidth(10)
                      ),
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
                        hint: Text("选择网盘"),
                        underline: Container(),
                        icon: Icon(Icons.arrow_right),
                        items: panList.map((e) => DropdownMenuItem(
                          child: Text(e.name),
                          value: e,
                        )).toList(),
                        value: selectPan,
                        onChanged: (item){
                          _stateSetter(() {
                            selectPan = item;
                          });
                        },
                      ),
                    ),
                  ),
                  Expanded(child: SizedBox(),flex: 1,),
                  GestureDetector(
                    onTap: (){
                      //保存到网盘
                    },
                    child: Container(
                      height: SizeUtil.getAppHeight(80),
                      alignment: Alignment(0,0),
                      decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(SizeUtil.getAppWidth(5)),
                              bottomRight: Radius.circular(SizeUtil.getAppWidth(5))
                          )
                      ),
                      child: Text("提交",style: TextStyle(color: Colors.white,fontSize: SizeUtil.getAppFontSize(30)),),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      });
    });
  }

  void _selectVisible(value){
    _stateSetter((){
      if(visible == value){
        visible = 0;
      }else{
        visible = value;
      }
    });
  }

  void _copyPan(BuildContext context,String panid){
    if(requesting) return;
    requesting = true;
    httpUtil.post(DataUtils.api_pancopy,data: {panid:panid,visible:visible}).then((value){
      print(value);
      if(value != null){
        Navigator.pop(context);
      }
    });
  }

  /**
   * 复制网盘
   */
  void showCopyPanDialog(BuildContext context,String panid){
    showDialog(context: context, builder: (context){
      return StatefulBuilder(builder: (_context,_state){
        _stateSetter = _state;
        return UnconstrainedBox(
          child: Card(
            child: Container(
              width: SizeUtil.getAppWidth(500),
              height: SizeUtil.getAppHeight(400),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        left: SizeUtil.getAppWidth(20),
                        right: SizeUtil.getAppWidth(20),
                        top: SizeUtil.getAppHeight(20)
                    ),
                    child: Text("复制到我的网盘",style: Constant.titleTextStyleNormal,),
                  ),
                  SizedBox(height: SizeUtil.getAppWidth(20),),
                  Padding(
                    padding: EdgeInsets.only(
                        left: SizeUtil.getAppWidth(20),
                        right: SizeUtil.getAppWidth(20),
                        top: SizeUtil.getAppHeight(20)
                    ),
                    child:Row(
                      children: [
                        GestureDetector(
                          onTap: (){
                            _selectVisible(1);
                          },
                          child: Row(
                            children: [
                              Radio(value: 1, groupValue: visible, activeColor: Colors.red,),
                              Text("本校可见",style: TextStyle(fontSize: SizeUtil.getAppFontSize(30)),)
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: (){
                            _selectVisible(2);
                          },
                          child: Row(
                            children: [
                              Radio(value: 2, groupValue: visible, activeColor: Colors.red,),
                              Text("自己可见",style: TextStyle(fontSize: SizeUtil.getAppFontSize(30)),)
                            ],
                          ),
                        )
                      ],
                    )
                  ),
                  Expanded(child: SizedBox(),flex: 1,),
                  GestureDetector(
                    onTap: (){
                      //保存到网盘
                      requesting = false;
                      _copyPan(context, panid);
                    },
                    child: Container(
                      height: SizeUtil.getAppHeight(80),
                      alignment: Alignment(0,0),
                      decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(SizeUtil.getAppWidth(5)),
                              bottomRight: Radius.circular(SizeUtil.getAppWidth(5))
                          )
                      ),
                      child: Text("提交",style: TextStyle(color: Colors.white,fontSize: SizeUtil.getAppFontSize(30)),),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      });
    });
  }

}