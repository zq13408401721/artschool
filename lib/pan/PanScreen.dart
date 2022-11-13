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
  var marknames = ["","",""];
  //前两个标签id
  var oneMarkId=0,twoMarkId=0;

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
      print("panmark :${widget.classifyid} ${value}");
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
        marknames[0] = panMarkListOne[0].name;
        marknames[1] = panMarkListTwo[0].name;
        oneMarkId = panMarkListOne[0].id;
        twoMarkId = panMarkListTwo[0].id;
        setState(() {

        });
      }
    });
  }

  /**
   * 组合筛选的标签
   */
  String getSelectMark(){
    var marks = "${oneMarkId},${twoMarkId}";
    panMarkListThree.forEach((element) {
      if(element.select){
        marks = "$marks"",""${element.id}";
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
                          child: Image.asset("image/ic_fork.png",width:SizeUtil.getAppWidth(40),height:SizeUtil.getAppWidth(40),),
                        ),
                      ),
                    )
                ),
                Container(
                  padding: EdgeInsets.only(left: ScreenUtil().setWidth(SizeUtil.getWidth(20))),
                  child: Text("按类型筛选",style:TextStyle(fontSize: SizeUtil.getAppFontSize(30),color: Colors.grey),),
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
                            child: Text("标签一(单选)",style: TextStyle(fontSize: SizeUtil.getAppFontSize(30),color: Colors.grey),),
                          ),
                          Container(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: GridView.builder(shrinkWrap:true,itemCount:panMarkListOne.length,physics:NeverScrollableScrollPhysics(),gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                mainAxisSpacing: ScreenUtil().setWidth(SizeUtil.getWidth(10)),
                                crossAxisSpacing: ScreenUtil().setHeight(SizeUtil.getHeight(10)),
                                crossAxisCount: 2,
                                childAspectRatio: Constant.isPad ? 8/1 : 4/1,

                              ), itemBuilder: (context,index){
                                return Row(
                                  children: [
                                    Checkbox(value: panMarkListOne[index].select, onChanged:(_bool){
                                      resetSellect(panMarkListOne);
                                      setState(() {
                                        panMarkListOne[index].select = _bool;
                                        marknames[0] = panMarkListOne[index].name;
                                        oneMarkId = panMarkListOne[index].id;
                                      });
                                    }),
                                    InkWell(
                                      onTap: (){
                                        resetSellect(panMarkListOne);
                                        setState(() {
                                          panMarkListOne[index].select = !panMarkListOne[index].select;
                                          marknames[0] = panMarkListOne[index].name;
                                          oneMarkId = panMarkListOne[index].id;
                                        });
                                      },
                                      child: Text(panMarkListOne[index].name,style: TextStyle(color: panMarkListOne[index].select?Colors.red:Colors.black87),),
                                    )
                                  ],
                                );
                              }),
                            ),
                          ),
                          SizedBox(height: ScreenUtil().setHeight(SizeUtil.getHeight(40)),),
                          Container(
                            padding:EdgeInsets.symmetric(horizontal: ScreenUtil().setHeight(SizeUtil.getHeight(20))),
                            child: Text("标签二(单选)",style: TextStyle(fontSize: SizeUtil.getAppFontSize(30),color: Colors.grey),),
                          ),
                          Container(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: GridView.builder(shrinkWrap:true,itemCount:panMarkListTwo.length,physics:NeverScrollableScrollPhysics(),gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                mainAxisSpacing: ScreenUtil().setWidth(SizeUtil.getWidth(10)),
                                crossAxisSpacing: ScreenUtil().setHeight(SizeUtil.getHeight(10)),
                                crossAxisCount: 2,
                                childAspectRatio: Constant.isPad ? 8/1 : 4/1,

                              ), itemBuilder: (context,index){
                                return Row(
                                  children: [
                                    Checkbox(value: panMarkListTwo[index].select, onChanged:(_bool){
                                      resetSellect(panMarkListTwo);
                                      setState(() {
                                        panMarkListTwo[index].select = _bool;
                                        marknames[1] = panMarkListTwo[index].name;
                                        twoMarkId = panMarkListTwo[index].id;
                                      });
                                    }),
                                    InkWell(
                                      onTap: (){
                                        resetSellect(panMarkListTwo);
                                        setState(() {
                                          panMarkListTwo[index].select = !panMarkListTwo[index].select;
                                          marknames[1] = panMarkListTwo[index].name;
                                          twoMarkId = panMarkListTwo[index].id;
                                        });
                                      },
                                      child: Text(panMarkListTwo[index].name,style: TextStyle(color: panMarkListTwo[index].select?Colors.red:Colors.black87),),
                                    )
                                  ],
                                );
                              }),
                            ),
                          ),
                          SizedBox(height: ScreenUtil().setHeight(SizeUtil.getHeight(40)),),
                          Container(
                            padding:EdgeInsets.symmetric(horizontal: ScreenUtil().setHeight(SizeUtil.getHeight(20))),
                            child: Text("标签三(多选)",style: TextStyle(fontSize: SizeUtil.getAppFontSize(30),color: Colors.grey),),
                          ),
                          Container(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: GridView.builder(shrinkWrap:true,itemCount:panMarkListThree.length,physics:NeverScrollableScrollPhysics(),gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                mainAxisSpacing: ScreenUtil().setWidth(SizeUtil.getWidth(10)),
                                crossAxisSpacing: ScreenUtil().setHeight(SizeUtil.getHeight(10)),
                                crossAxisCount: 2,
                                childAspectRatio: Constant.isPad ? 8/1 : 4/1,

                              ), itemBuilder: (context,index){
                                return Row(
                                  children: [
                                    Checkbox(value: panMarkListThree[index].select, onChanged:(_bool){
                                      setState(() {
                                        panMarkListThree[index].select = _bool;
                                        marknames[2] = panMarkListThree[index].name;
                                      });
                                    }),
                                    InkWell(
                                      onTap: (){
                                        setState(() {
                                          panMarkListThree[index].select = !panMarkListThree[index].select;
                                          marknames[2] = panMarkListThree[index].name;
                                        });
                                      },
                                      child: Text(panMarkListThree[index].name,style: TextStyle(color: panMarkListThree[index].select?Colors.red:Colors.black87),),
                                    )
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
                            //重置 返回结果参数不能为空
                            Navigator.pop(context,{});
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
                            var names = "${marknames[0]} / ${marknames[1]}";
                            if(marks.length == 0){

                            }else{
                              names += " / ${marknames[2]}";
                            }

                            print("names:${names}");
                            Navigator.pop(context,{"marks":marks,"marknames":names});
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