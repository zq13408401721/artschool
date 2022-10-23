import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:yhschool/BaseState.dart';
import 'package:yhschool/pan/PanPage.dart';
import 'package:yhschool/utils/SizeUtil.dart';
import 'package:yhschool/bean/pan_list_bean.dart';
import 'package:yhschool/bean/pan_classify_bean.dart' as P;
import '../BaseRefreshState.dart';
import '../BasefulWidget.dart';
import '../utils/Constant.dart';
import '../utils/DataUtils.dart';
import '../utils/HttpUtils.dart';
import 'PanDetailPage.dart';

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
  List<P.Data> tabs = [];
  int pagenum=1,pagesize=10;
  List<Data> panList = [];
  dynamic panParam;

  @override
  void initState() {
    super.initState();
    _scrollController = initScrollController(isfresh: false);
  }

  /**
   * 查询网盘列表数据
   */
  void queryPanList({String schoolid,int classifyid,String marks}){
    pagenum = 1;
    panList.clear();
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
    panParam = param;
    _getPanList(param);
  }

  /**
   * 获取网盘数据
   */
  void _getPanList(param){
    httpUtil.post(DataUtils.api_panlist,data: param).then((value){
      print("school panlist:$value");
      if(value != null){
        var panListBean = PanListBean.fromJson(json.decode(value));
        if(panListBean.errno == 0){
          pagenum++;
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
          Navigator.push(context, MaterialPageRoute(builder: (context){
            return PanDetailPage(panData: item,isself: item.uid == m_uid,tabs:tabs,);
          })).then((value){
            if(value != null){
              setState(() {
                item.imagenum = value;
              });
            }
          });
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            (item.url != null && item.imagenum > 0) ?
            CachedNetworkImage(imageUrl: Constant.parsePanSmallString(item.url))
            : Padding(padding: EdgeInsets.symmetric(horizontal: 0,vertical: SizeUtil.getAppHeight(100)),
              child: Center(
                child: Text(item.uid == m_uid ? "上传图片" : "无图",style: Constant.titleTextStyleNormal,textAlign: TextAlign.center,),
              ),
            ),
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
        return panItem(panList[index]);
      },
    );
  }

  @override
  void loadmore() {
    panParam["page"] = pagenum;
    _getPanList(panParam);
  }

  @override
  void refresh() {
  }

}