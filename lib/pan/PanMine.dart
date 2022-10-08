import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:yhschool/BaseRefreshState.dart';
import 'package:yhschool/BaseState.dart';
import 'package:yhschool/BasefulWidget.dart';
import 'package:yhschool/bean/pan_topping_bean.dart' as T;
import 'package:yhschool/pan/PanPage.dart';

import '../bean/pan_list_bean.dart';
import '../utils/Constant.dart';
import '../utils/DataUtils.dart';
import '../utils/HttpUtils.dart';
import '../utils/SizeUtil.dart';

class PanMine extends BasefulWidget<PanPageState>{

  BuildContext panContext;

  PanMine({Key key,@required this.panContext}):super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return PanMineState();
  }

  @override
  PanPageState getBaseState() {
    return (this.panContext.widget.key as GlobalKey).currentState as PanPageState;
  }

}

class PanMineState extends BaseRefreshState<PanMine>{

  ScrollController _scrollController;

  int pagenum=1,pagesize=10;
  List<Data> panList = [];
  dynamic queryParam;

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
      "classifyid":classifyid.toString(),
      "isself":true
    };
    if(marks != null){
      param["mark"] = marks;
    }
    queryParam = param;
    _getPanList(param);
  }

  /**
   * 网盘置顶/取消置顶
   */
  void panTopping(int top,String panid){
    var param = {
      "top":top,
      "panid":panid
    };
    httpUtil.post(DataUtils.api_pantopping,data:param).then((value){
      if(value != null){
        T.PanToppingBean panToppingBean = T.PanToppingBean.fromJson(json.decode(value));
        _getPanList(queryParam);
      }
    });
  }

  /**
   * 删除网盘
   */
  void deletePan(String panid){
    var param = {
      "panid":panid
    };
    httpUtil.post(DataUtils.api_deletepan,data:param).then((value){
      print("value:$value");
      for(Data item in panList){
        if(item.panid == panid){
          panList.remove(item);
          break;
        }
      }
      setState(() {
      });
    });
  }

  /**
   * 获取网盘数据
   */
  void _getPanList(param){
    this.panList = [];
    httpUtil.post(DataUtils.api_panlist,data: param).then((value){
      print("mine panlist:$value");
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
            CachedNetworkImage(imageUrl: item.url),
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
                  //top
                  InkWell(
                      onTap: (){
                        //置顶
                        if(item.top == 0){
                          showPanTopping().then((value){
                            if(value){
                              panTopping(1, item.panid);
                            }
                          });
                        }else{
                          //取消置顶
                          panTopping(0, item.panid);
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.only(
                            left:SizeUtil.getAppWidth(20),
                            right:SizeUtil.getAppWidth(20),
                            top:SizeUtil.getAppWidth(5),
                            bottom:SizeUtil.getAppWidth(10)
                        ),
                        child: Image.asset(item.top == 0 ? "image/ic_pan_top.png" : "image/ic_pan_toped.png",width: SizeUtil.getAppWidth(40),height: SizeUtil.getAppWidth(40),),
                      )
                  ),
                  //delete
                  InkWell(
                      onTap: (){
                        //删除
                        deletePan(item.panid);
                      },
                      child: Container(
                        padding: EdgeInsets.only(
                            left:SizeUtil.getAppWidth(20),
                            right:SizeUtil.getAppWidth(20),
                            top:SizeUtil.getAppWidth(5),
                            bottom:SizeUtil.getAppWidth(10)
                        ),
                        child: Image.asset("image/ic_pan_delete.png",width: SizeUtil.getAppWidth(40),height: SizeUtil.getAppWidth(40),),
                      )
                  )
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
    // TODO: implement loadmore
  }

  @override
  void refresh() {
    // TODO: implement refresh
  }

}
