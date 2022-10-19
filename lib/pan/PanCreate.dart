import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yhschool/BaseState.dart';
import 'package:yhschool/bean/pan_create_bean.dart' as P;
import 'package:yhschool/bean/pan_mark_bean.dart' as M;
import 'package:yhschool/utils/Constant.dart';
import 'package:yhschool/utils/DataUtils.dart';
import 'package:yhschool/utils/HttpUtils.dart';
import 'package:yhschool/widgets/PanTitle.dart';
import '../bean/pan_classify_bean.dart';
import '../utils/SizeUtil.dart';

class PanCreate extends StatefulWidget{

  List<Data> tabs;
  bool isCreate;
  dynamic panData;

  PanCreate({Key key,@required this.tabs,@required this.isCreate,@required this.panData = null}):super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new PanCreateState();
  }

}

class PanCreateState extends BaseState<PanCreate>{

  String panName;
  int visible = 0;
  List types;
  List classifys;
  List categorys;
  dynamic selectItem;
  List<M.Data> panMarkList;
  List<M.Data> panMarkListOne;
  List<M.Data> panMarkListTwo;
  List<M.Data> panMarkListThree;
  int oneIndex,twoIndex,threeIndex;

  @override
  void initState() {
    super.initState();
    types = [];
    classifys = [];
    categorys = [];
    panMarkList = [];
    panMarkListOne = [];
    panMarkListTwo = [];
    panMarkListThree = [];
    if(widget.tabs != null && widget.tabs.length > 0){
      selectItem = widget.tabs[0];
      getPanMarkList();
      if(!widget.isCreate){
        panName = widget.panData.name;
        queryPanMark();
      }
    }
  }

  void selectVisible(int value){
    print("selectVisible:" + value.toString());
    if(this.visible == value){
      this.visible = 0;
    }else{
      this.visible = value;
    }
    setState(() {
    });
  }

  /**
   * 获取网盘相关的mark信息
   */
  void getPanMarkList(){
    if(selectItem == null){
      return;
    }
    var option = {
      "classifyid":selectItem.id
    };
    httpUtil.get(DataUtils.api_panmark,data: option,).then((value){
      var markBean = M.PanMarkBean.fromJson(json.decode(value));
      if(markBean.errno == 0){
        panMarkList = markBean.data;
        panMarkListOne = [];
        panMarkListTwo = [];
        panMarkListThree = [];
        for(M.Data item in panMarkList){
          if(item.type == 1){
            panMarkListOne.add(item);
          }else if(item.type == 2){
            panMarkListTwo.add(item);
          }else{
            panMarkListThree.add(item);
          }
        }
        panMarkListOne[0].select = true;
        panMarkListTwo[0].select = true;
        setState(() {

        });
      }
    });
  }

  void resetSellect(List<M.Data> list){
    for(M.Data item in list){
      item.select = false;
    }
  }

  /**
   * 查询网盘mark
   */
  void queryPanMark(){
    var param = {
      "panid":widget.panData.panid
    };
    httpUtil.post(DataUtils.api_panmark,data: param).then((value){
      print('panmark$value');
      if(value != null){
        var result = json.decode(value);
        String marks = result["data"];
        var markids = marks.split(",");
        if(markids.length >= 2){
          for(var item in panMarkListOne){
            if(item.id == int.parse(markids[0])){
              item.select = true;
              break;
            }
          }
          for(var item in panMarkListTwo){
            if(item.id == int.parse(markids[1])){
              item.select = true;
              break;
            }
          }
          for(var markid in markids.getRange(2, markids.length)){
            for(var item in panMarkListThree){
              if(item.id == int.parse(markid)){
                item.select = true;
              }
            }
          }
        }
        setState(() {
        });
      }
    });
  }

  /**
   * 提交创建网盘
   */
  void submitCreatePan(){
    if(this.panName.isEmpty){
      showToast("请输入网盘名称");
      return;
    }
    if(this.selectItem == null){
      showToast("请选择分类");
      return;
    }
    var marks = "";

    //第一个tag
    for(var item in panMarkListOne){
      if(item.select){
        marks = "${item.id}";
        break;
      }
    }
    //第二个tag
    for(var item in panMarkListTwo){
      if(item.select){
        marks = "$marks"",""${item.id}";
        break;
      }
    }
    bool _bool;
    panMarkListThree.forEach((element) {
      if(element.select){
        marks = "$marks"",""${element.id}";
        _bool = true;
      }
    });
    if(_bool == false){
      showToast("请选择标签");
      return;
    }
    var option = {
      "panname":panName,
      "classifyid":selectItem.id,
      "marks":marks
    };
    httpUtil.post(DataUtils.api_pancreate,data: option).then((value){
      var panCreateBean = P.PanCreateBean.fromJson(json.decode(value));
      if(panCreateBean.errno == 0){
        showToast("创建网盘成功");
        Navigator.pop(context,true);
      }
    });
  }

  /**
   * 提交网盘数据
   */
  void submitEditorPan(){
    if(this.panName.isEmpty){
      showToast("请输入网盘名称");
      return;
    }
    if(this.selectItem == null){
      showToast("请选择分类");
      return;
    }
    var marks = "";
    //第一个tag
    for(var item in panMarkListOne){
      if(item.select){
        marks = "${item.id}";
        break;
      }
    }
    //第二个tag
    for(var item in panMarkListTwo){
      if(item.select){
        marks = "$marks"",""${item.id}";
        break;
      }
    }
    bool _bool;
    panMarkListThree.forEach((element) {
      if(element.select){
        marks = "$marks"",""${element.id}";
        _bool = true;
      }
    });
    if(_bool == false){
      showToast("请选择标签");
      return;
    }
    var option = {
      "panid":widget.panData.panid,
      "panname":panName,
      "classifyid":selectItem.id,
      "visible":visible
    };
    if(marks != widget.panData.marks){
      option["markids"] = marks;
    }
    httpUtil.post(DataUtils.api_paneditor,data: option).then((value){
      print("paneditor:$value");
      if(value != null){
        Navigator.pop(context,true);
      }
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Colors.grey[100],
          child: Column(
            children: [
              //标题
              PanTitle(cb: (){
                Navigator.pop(context);
              },title: widget.isCreate ? "新建网盘" : widget.panData.name,),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(SizeUtil.getWidth(50))),
                      child: Column(
                        children: [
                          SizedBox(height: ScreenUtil().setHeight(SizeUtil.getHeight(20)),),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: TextField(
                                  maxLength: 20,
                                  maxLines: 1,
                                  decoration: InputDecoration(
                                      hintText: "网盘名称",
                                      border:InputBorder.none,
                                      fillColor: Colors.white,
                                      filled: true,
                                      contentPadding: EdgeInsets.all( ScreenUtil().setHeight(SizeUtil.getHeight(20))),
                                      /*border: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.black12)
                                  ),*/
                                      enabledBorder:OutlineInputBorder(
                                          borderSide: BorderSide(color: Colors.black12)
                                      )
                                  ),
                                  onChanged: (value){
                                    panName = value;
                                  },
                                ),
                              ),
                              SizedBox(width: ScreenUtil().setWidth(10),),
                              Text("*",style: TextStyle(color: Colors.red,fontSize: ScreenUtil().setSp(30)),)
                            ],
                          ),
                          Row(
                            children: [
                              Row(
                                children: [
                                  Radio(value: 1, groupValue: visible, activeColor: Colors.red, onChanged: selectVisible),
                                  Text("本校可见",style: TextStyle(fontSize: ScreenUtil().setSp(SizeUtil.getFontSize(30))),)
                                ],
                              ),
                              Row(
                                children: [
                                  Radio(value: 2, groupValue: visible, activeColor: Colors.red, onChanged: selectVisible),
                                  Text("自己可见",style: TextStyle(fontSize: ScreenUtil().setSp(SizeUtil.getFontSize(30))),)
                                ],
                              )
                            ],
                          ),
                          SizedBox(height: ScreenUtil().setHeight(SizeUtil.getHeight(10)),),
                          Container(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  children: [
                                    Row(
                                      children: [
                                        Center(
                                          child: Container(
                                            width: ScreenUtil().setWidth(SizeUtil.getWidth(400)),
                                            padding: EdgeInsets.only(
                                                left:ScreenUtil().setWidth(SizeUtil.getWidth(20)),
                                                top:ScreenUtil().setWidth(SizeUtil.getWidth(10))
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
                                              hint: Text("分类"),
                                              underline: Container(),
                                              icon: Icon(Icons.arrow_right),
                                              items: widget.tabs.map((e) => DropdownMenuItem(
                                                child: Text(e.name),
                                                value: e,
                                              )).toList(),
                                              value: selectItem,
                                              onChanged: (item){
                                                setState(() {
                                                  selectItem = item;
                                                  getPanMarkList();
                                                  print(item.name);
                                                });
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(width: ScreenUtil().setWidth(10),),
                                Text("*",style: TextStyle(color: Colors.red,fontSize: ScreenUtil().setSp(30)),)
                              ],
                            ),
                          ),
                          SizedBox(height: ScreenUtil().setHeight(SizeUtil.getHeight(40)),),
                          Container(
                            padding: EdgeInsets.all(ScreenUtil().setWidth(SizeUtil.getWidth(10))),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(Radius.circular(ScreenUtil().setWidth(5)))
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding:EdgeInsets.symmetric(horizontal: ScreenUtil().setHeight(SizeUtil.getHeight(20))),
                                  child: Text("标签一",style: Constant.smallTitleTextStyle,),
                                ),
                                Container(
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.vertical,
                                    child: GridView.builder(shrinkWrap:true,itemCount:panMarkListOne.length,physics:NeverScrollableScrollPhysics(),gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                      mainAxisSpacing: ScreenUtil().setWidth(SizeUtil.getWidth(10)),
                                      crossAxisSpacing: ScreenUtil().setHeight(SizeUtil.getHeight(10)),
                                      crossAxisCount: 3,
                                      childAspectRatio: Constant.isPad ? 8/1 : 6/1,

                                    ), itemBuilder: (context,index){
                                      return Row(
                                        children: [
                                          Checkbox(value: panMarkListOne[index].select, onChanged:(_bool){
                                            resetSellect(panMarkListOne);
                                            oneIndex = index;
                                            setState(() {
                                              panMarkListOne[index].select = _bool;
                                            });
                                          }),
                                          Text(panMarkListOne[index].name,style: TextStyle(color: panMarkListOne[index].select?Colors.red:Colors.black87),)
                                        ],
                                      );
                                    }),
                                  ),
                                ),
                                SizedBox(height: ScreenUtil().setHeight(SizeUtil.getHeight(40)),),
                                Container(
                                  padding:EdgeInsets.symmetric(horizontal: ScreenUtil().setHeight(SizeUtil.getHeight(20))),
                                  child: Text("标签二",style: Constant.smallTitleTextStyle,),
                                ),
                                Container(
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.vertical,
                                    child: GridView.builder(shrinkWrap:true,itemCount:panMarkListTwo.length,physics:NeverScrollableScrollPhysics(),gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                      mainAxisSpacing: ScreenUtil().setWidth(SizeUtil.getWidth(10)),
                                      crossAxisSpacing: ScreenUtil().setHeight(SizeUtil.getHeight(10)),
                                      crossAxisCount: 3,
                                      childAspectRatio: Constant.isPad ? 8/1 : 6/1,

                                    ), itemBuilder: (context,index){
                                      return Row(
                                        children: [
                                          Checkbox(value: panMarkListTwo[index].select, onChanged:(_bool){
                                            resetSellect(panMarkListTwo);
                                            twoIndex = index;
                                            setState(() {
                                              panMarkListTwo[index].select = _bool;
                                            });
                                          }),
                                          Text(panMarkListTwo[index].name,style: TextStyle(color: panMarkListTwo[index].select?Colors.red:Colors.black87),)
                                        ],
                                      );
                                    }),
                                  ),
                                ),
                                SizedBox(height: ScreenUtil().setHeight(SizeUtil.getHeight(40)),),
                                Container(
                                  padding:EdgeInsets.symmetric(horizontal: ScreenUtil().setHeight(SizeUtil.getHeight(20))),
                                  child: Text("标签三",style: Constant.smallTitleTextStyle,),
                                ),
                                Container(
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.vertical,
                                    child: GridView.builder(shrinkWrap:true,itemCount:panMarkListThree.length,physics:NeverScrollableScrollPhysics(),gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                      mainAxisSpacing: ScreenUtil().setWidth(SizeUtil.getWidth(10)),
                                      crossAxisSpacing: ScreenUtil().setHeight(SizeUtil.getHeight(10)),
                                      crossAxisCount: 3,
                                      childAspectRatio: Constant.isPad ? 8/1 : 6/1,

                                    ), itemBuilder: (context,index){
                                      return Row(
                                        children: [
                                          Checkbox(value: panMarkListThree[index].select, onChanged:(_bool){
                                            setState(() {
                                              panMarkListThree[index].select = _bool;
                                            });
                                          }),
                                          Text(panMarkListThree[index].name,style: TextStyle(color: panMarkListThree[index].select?Colors.red:Colors.black87),)
                                        ],
                                      );
                                    }),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: ScreenUtil().setHeight(SizeUtil.getHeight(40)),),
                          InkWell(
                            onTap: (){
                              //创建网盘
                              if(widget.isCreate){
                                submitCreatePan();
                              }else{
                                submitEditorPan();
                              }
                            },
                            child: Container(
                              width: double.infinity,
                              alignment: Alignment(0,0),
                              margin: EdgeInsetsDirectional.only(bottom: ScreenUtil().setHeight(SizeUtil.getHeight(40))),
                              padding: EdgeInsets.symmetric(
                                  vertical: ScreenUtil().setHeight(SizeUtil.getHeight(20))
                              ),
                              decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.all(Radius.circular(ScreenUtil().setWidth(10)))
                              ),
                              child: Text("提交",style: TextStyle(fontSize: ScreenUtil().setSp(SizeUtil.getFontSize(30)),color: Colors.white),),
                            ),
                          )
                        ],
                      )
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