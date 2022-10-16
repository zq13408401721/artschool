import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:yhschool/BaseState.dart';
import 'package:yhschool/pan/PanPage.dart';
import 'package:yhschool/utils/SizeUtil.dart';
import 'package:yhschool/bean/pan_list_bean.dart';
import '../BaseRefreshState.dart';
import '../BasefulWidget.dart';
import '../utils/Constant.dart';
import '../utils/DataUtils.dart';
import '../utils/HttpUtils.dart';

class PanSchool extends BasefulWidget<PanPageState>{

  BuildContext panContext;

  PanSchool({Key key,@required this.panContext}):super(key: key);

  @override
  State<StatefulWidget> createState() {
    return PanSchoolState();
  }

  @override
  PanPageState getBaseState(){
    return (this.panContext.widget.key as GlobalKey).currentState as PanPageState;
  }

}


class PanSchoolState extends BaseRefreshState<PanSchool>{

  ScrollController _scrollController;

  int pagenum=1,pagesize=10;
  List<Data> panList = [];

  @override
  void initState() {
    super.initState();
    _scrollController = initScrollController();
  }

  /**
   * 查询网盘列表数据
   */
  void queryPanList({String schoolid,int classifyid,String marks}){
    var param = {
      "page":pagenum.toString(),
      "size":pagesize.toString(),
      "classifyid":classifyid.toString()
    };
    if(schoolid != null){
      param["schoolid"] = schoolid;
    }
    if(marks != null){
      param["marks"] = marks;
    }
    _getPanList(param);
  }

  /**
   * 获取网盘数据
   */
  void _getPanList(param){
    panList = [];
    httpUtil.post(DataUtils.api_panlist,data: param).then((value){
      print("school panlist:$value");
      if(value != null){
        var panListBean = PanListBean.fromJson(json.decode(value));
        if(panListBean.errno == 0){
          panList.addAll(panListBean.data);
          setState(() {

          });
        }
      }
    });
  }

  Widget panItem(Data item){
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(SizeUtil.getAppWidth(10)),
              bottomRight: Radius.circular(SizeUtil.getAppWidth(10))
          )
      ),
      child: InkWell(
        onTap: (){
          //进入网盘详情页面
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CachedNetworkImage(imageUrl: Constant.parsePanSmallString(item.url)),
            Padding(padding: EdgeInsets.only(
              left: SizeUtil.getAppWidth(20),
              right: SizeUtil.getAppWidth(20),
              top: SizeUtil.getAppWidth(10),
              bottom: SizeUtil.getAppWidth(5),
            ),child:Text(item.name),),
            Padding(padding: EdgeInsets.only(
              left: SizeUtil.getAppWidth(20),
              right: SizeUtil.getAppWidth(20),
              top: SizeUtil.getAppWidth(5),
              bottom: SizeUtil.getAppWidth(5),
            ),child: Text(item.nickname != null ? item.nickname : item.username,style: Constant.smallTitleTextStyle,),),
            Padding(padding: EdgeInsets.only(
                left: SizeUtil.getAppWidth(20),
                right: SizeUtil.getAppWidth(20),
                top: SizeUtil.getAppWidth(5)
            ),child: Text("P${item.imagenum}",style: TextStyle(color: Colors.grey,fontSize: SizeUtil.getAppFontSize(30)),),),
            Align(
              alignment:Alignment.centerRight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  //copy
                  InkWell(
                      onTap: (){
                        //置顶
                      },
                      child: Container(
                        padding: EdgeInsets.only(
                            left:SizeUtil.getAppWidth(20),
                            right:SizeUtil.getAppWidth(20),
                            top:SizeUtil.getAppWidth(5),
                            bottom:SizeUtil.getAppWidth(10)
                        ),
                        child: Image.asset("image/ic_pan_top.png",width: SizeUtil.getAppWidth(40),height: SizeUtil.getAppWidth(40),),
                      )
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }


  @override
  Widget addChildren() {
    return StaggeredGridView.countBuilder(
      crossAxisCount: Constant.isPad ? 3 : 2,
      itemCount: panList.length,
      //primary: false,
      physics: BouncingScrollPhysics(),
      mainAxisSpacing: SizeUtil.getAppWidth(Constant.DIS_LIST),
      crossAxisSpacing: SizeUtil.getAppHeight(Constant.DIS_LIST),
      controller: _scrollController,
      //addAutomaticKeepAlives: false,
      padding: EdgeInsets.only(left: SizeUtil.getAppWidth(Constant.DIS_LIST),right: SizeUtil.getAppWidth(Constant.DIS_LIST)),
      staggeredTileBuilder: (int index) => StaggeredTile.fit(1),
      //StaggeredTile.count(3,index==0?2:3),
      itemBuilder: (context,index){
        return GestureDetector(
          child: panItem(panList[index]),
          onTap:(){

          },
        );
      },
    );
  }

  @override
  void loadmore() {
  }

  @override
  void refresh() {
  }

}