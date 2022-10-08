import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yhschool/BaseState.dart';
import 'package:yhschool/bean/entity_tab_bean.dart';
import 'package:yhschool/bean/teacher_classes_bean.dart';
import 'package:yhschool/bean/video_category_group_bean.dart' as G;
import 'package:yhschool/utils/Constant.dart';
import 'package:yhschool/utils/DataUtils.dart';
import 'package:yhschool/utils/HttpUtils.dart';
import 'package:yhschool/utils/SizeUtil.dart';
import 'package:yhschool/widgets/TextButton.dart' as T;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yhschool/bean/pan_mark_bean.dart' as M;

class PanScreen extends StatefulWidget{

  int classifyid;

  PanScreen({Key key,@required this.classifyid}):super(key: key);

  @override
  State<StatefulWidget> createState() {
    return PanScreenState();
  }

}

class PanScreenState extends BaseState<PanScreen>{

  List<M.Data> panMarkListOne;
  List<M.Data> panMarkListTwo;
  List<M.Data> panMarkListThree;

  @override
  void initState() {
    super.initState();
    panMarkListOne = [];
    panMarkListTwo = [];
    panMarkListThree = [];
    this.getPanMark();
  }

  void resetSellect(List<M.Data> list){
    for(M.Data item in list){
      item.select = false;
    }
  }

  /**
   * 获取网盘相关的mark信息
   */
  void getPanMark(){
    var option = {
      "classifyid":widget.classifyid
    };
    httpUtil.get(DataUtils.api_panmark,data: option,).then((value){
      var markBean = M.PanMarkBean.fromJson(json.decode(value));
      if(markBean.errno == 0){
        panMarkListOne = [];
        panMarkListTwo = [];
        panMarkListThree = [];
        for(M.Data item in markBean.data){
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

  /**
   * 组合筛选的标签
   */
  String getSelectMark(){
    var marks = "";
    panMarkListThree.forEach((element) {
      if(element.select){
        if(marks == ""){
          marks = "${element.id}";
        }else{
          marks = "$marks"",""${element.id}";
        }
      }
    });
    return marks;
  }

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    //top = _size.height/3*2;
    return Center(
      child: Card(
          margin: EdgeInsets.only(
              top:ScreenUtil().setWidth(SizeUtil.getWidth(100)),
              left: ScreenUtil().setWidth(SizeUtil.getWidth(50)),
              right: ScreenUtil().setWidth(SizeUtil.getWidth(50)),
              bottom: ScreenUtil().setHeight(SizeUtil.getHeight(100))
          ),
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10)
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //关闭按钮
                Align(
                    alignment: Alignment(1,0),
                    child: Padding(
                      padding: EdgeInsets.only(
                          right: ScreenUtil().setWidth(20),
                          top:ScreenUtil().setWidth(20)
                      ),
                      child: InkWell(
                        onTap: (){
                          Navigator.pop(context);
                        },
                        child: Container(
                          padding: EdgeInsets.all(ScreenUtil().setWidth(SizeUtil.getWidth(20))),
                          child: Image.asset("image/ic_fork.png",width: ScreenUtil().setWidth(16),height:  ScreenUtil().setWidth(16),),
                        ),
                      ),
                    )
                ),
                Container(
                  padding: EdgeInsets.only(left: ScreenUtil().setWidth(SizeUtil.getWidth(20))),
                  child: Text("按类型筛选",style:Constant.smallTitleTextStyle,),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Container(
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
                  ),
                ),
                Container(
                  height: ScreenUtil().setHeight(SizeUtil.getHeight(100)),
                  child: Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: (){
                            Navigator.pop(context);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(ScreenUtil().setWidth(SizeUtil.getWidth(10)))
                              )
                            ),
                            alignment: Alignment(0,0),
                            child: Text("重置",style: TextStyle(color: Colors.black54,fontSize: ScreenUtil().setSp(SizeUtil.getFontSize(30))),),
                          ),
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: (){
                            var marks = getSelectMark();
                            Navigator.pop(context,marks);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(ScreenUtil().setWidth(SizeUtil.getWidth(10)))
                              )
                            ),
                            alignment: Alignment(0,0),
                            child: Text("提交",style: TextStyle(color: Colors.white,fontSize: ScreenUtil().setSp(SizeUtil.getFontSize(30))),),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            )
        ),
      ),
    );
  }

}