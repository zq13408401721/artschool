import 'dart:convert';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yhschool/utils/Constant.dart';
import 'package:yhschool/utils/SizeUtil.dart';

import 'package:yhschool/bean/pan_bean.dart';
import 'package:yhschool/utils/DataUtils.dart';
import 'package:yhschool/utils/HttpUtils.dart';

import '../utils/EnumType.dart';

class DialogManager{

  DialogManager._privateConstructor();

  static final DialogManager _instantce = DialogManager._privateConstructor();

  factory DialogManager(){
    return _instantce;
  }

  StateSetter _stateSetter;

  List<Data> panList = [];
  Data selectPan;

  int visible=0;

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
   * 复制网盘文件
   */
  void _copyPanFile(BuildContext context,String panid,int fileid){
    var param = {
      "panid":panid,
      "fileid":fileid
    };
    httpUtil.post(DataUtils.api_pancopyfile,data: param).then((value){
      print("copy pan file $value");
      if(value != null){
        Navigator.pop(context);
      }
    });
  }

  /**
   * 显示复制网盘文件dialog
   */
  Future<bool> showCopyPanImageDialog(BuildContext context,String panid,int fileid) async{
    _queryPanList();
    bool _bool;
    await showDialog(context: context, builder: (context){
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
                      if(selectPan != null){
                        _copyPanFile(_context,selectPan.panid,fileid);
                      }
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
    return _bool;
  }

  void _selectVisible(value){
    _stateSetter((){
      visible = value;
      print("visible:${visible}");
    });
  }

  void _copyPan(BuildContext context,String panid){
    if(requesting) return;
    requesting = true;
    var param = {
      "panid":panid,
      "visible":visible+1
    };
    httpUtil.post(DataUtils.api_pancopy,data:param).then((value){
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
                    child: Text("复制到我的相册",style: Constant.titleTextStyleNormal,),
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
                            _selectVisible(0);
                          },
                          child: Row(
                            children: [
                              Radio(value: 0, groupValue: visible, activeColor: Colors.red,onChanged: (value){
                                _selectVisible(0);
                              },),
                              Text("本校可见",style: TextStyle(fontSize: SizeUtil.getAppFontSize(30)),)
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: (){
                            _selectVisible(1);
                          },
                          child: Row(
                            children: [
                              Radio(value: 1, groupValue: visible, activeColor: Colors.red,onChanged: (value){
                                _selectVisible(1);
                              },),
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

  /**
   * 删除网盘
   */
  void deletePan(BuildContext context,String panid){
    var param = {
      "panid":panid
    };
    httpUtil.post(DataUtils.api_deletepan,data:param).then((value){
      print("value:$value");
      if(value != null){
        Navigator.pop(context,true);
      }
    });
  }

  /**
   * 删除网盘文件
   */
  void deletePanFile(BuildContext context,String panid,int fileid){
    var param = {
      "panid":panid,
      "fileid":fileid
    };
    httpUtil.post(DataUtils.api_deletepanfile,data: param).then((value){
      print("deletepan file $value");
      if(value != null){
        Navigator.pop(context,true);
      }
    });
  }

  /**
   * 删除确认弹框
   */
  Future<bool> showDeletePanDialog(BuildContext context,{PanDeleteType type,String title,String panid,int fileid}) async{
    bool _bool;
    _bool = await showDialog(context: context, builder: (context){
      return StatefulBuilder(builder: (_ct,_state){
        return FractionallySizedBox(
          widthFactor: 2/3,
          heightFactor: 1/6,
          child: Card(
            child: Container(
              padding: EdgeInsets.symmetric(
                  horizontal: SizeUtil.getAppWidth(20),
                  vertical: SizeUtil.getAppHeight(20)
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,style: TextStyle(fontSize: SizeUtil.getAppFontSize(30)),),
                  SizedBox(height: SizeUtil.getHeight(20),),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap: (){
                            if(type == PanDeleteType.PAN){
                              deletePan(_ct,panid);
                            }else if(type == PanDeleteType.FILE){
                              deletePanFile(_ct,panid,fileid);
                            }
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
                              Navigator.pop(context,false);
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
      });
    });
    return _bool;
  }

  /**
   * 确认弹框
   */
  Future<bool> showPanDialogTitle(BuildContext context,{String title}) async{
    bool _bool;
    _bool = await showDialog(context: context, builder: (context){
      return StatefulBuilder(builder: (_ct,_state){
        return UnconstrainedBox(
          child: SizedBox(
            width: SizeUtil.getAppWidth(600),
            height: SizeUtil.getAppHeight(300),
            child: Card(
              child: Container(
                padding: EdgeInsets.symmetric(
                    horizontal: SizeUtil.getAppWidth(20),
                    vertical: SizeUtil.getAppHeight(20)
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,style: TextStyle(fontSize: SizeUtil.getAppFontSize(30)),),
                    SizedBox(height: SizeUtil.getHeight(20),),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          InkWell(
                            onTap: (){
                              Navigator.pop(context,true);
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
                                Navigator.pop(context,false);
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
          ),
        );
      });
    });
    return _bool;
  }

  /**
   * 第一次进入会员提示弹框
   */
  Future<bool> showVipMemberDialog(BuildContext context) async{
    bool _bool;
    _bool = await showDialog(context: context, builder: (context){
      return StatefulBuilder(builder: (_ct,_state){
        return UnconstrainedBox(
          child: SizedBox(
            width: SizeUtil.getAppWidth(600),
            height: SizeUtil.getAppHeight(700),
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset("image/ic_advert_member.png",
                    width: SizeUtil.getAppWidth(500),
                    height: SizeUtil.getAppHeight(500),
                    fit: BoxFit.contain,
                  ),
                  SizedBox(height: SizeUtil.getAppHeight(50),),
                  GestureDetector(
                    onTap: (){
                      Navigator.pop(context,true);
                    },
                    child: Container(
                      child: Image.asset("image/ic_fork.png",
                        width: SizeUtil.getAppWidth(60),
                        height: SizeUtil.getAppWidth(60),
                        color: Colors.grey,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      });
    });
    return _bool;
  }

}