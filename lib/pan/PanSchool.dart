import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:yhschool/pan/PanPage.dart';
import 'package:yhschool/utils/SizeUtil.dart';
import 'package:yhschool/bean/pan_list_bean.dart';
import 'package:yhschool/bean/pan_classify_bean.dart' as P;
import 'package:yhschool/widgets/CoustSizeImage.dart';
import 'package:yhschool/utils/EnumType.dart';
import '../BaseRefreshState.dart';
import '../BasefulWidget.dart';
import '../utils/Constant.dart';
import '../utils/DataUtils.dart';
import '../utils/HttpUtils.dart';
import 'PanDetailPage.dart';
import 'PanUserDetail.dart';
import 'package:yhschool/bean/user_search.dart' as S;
import '../bean/pan_topping_bean.dart' as T;

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


class PanSchoolState extends BaseRefreshState<PanSchool> with SingleTickerProviderStateMixin{

  ScrollController _scrollController;
  List<P.Data> tabs = [];
  int pagenum=1,pagesize=10;
  List<Data> panList = [];
  dynamic panParam;

  int selectClassifyid;
  String selectClassName;
  String selectMarks;
  bool isteacher;

  @override
  void initState() {
    super.initState();
    _scrollController = initScrollController(isfresh: false);
  }

  /**
   * 查询网盘列表数据
   */
  void queryPanList({String schoolid,int classifyid,String marks,bool visible,String classifyname}){
    pagenum = 1;
    panList.clear();
    isteacher = visible;
    selectClassName = classifyname;
    var param = {
      "page":pagenum.toString(),
      "size":pagesize.toString(),
      "classifyid":classifyid.toString(),
      "isteacher":visible
    };
    if(schoolid != null){
      param["schoolid"] = schoolid;
    }
    if(marks != null){
      param["marks"] = marks;
    }
    panParam = param;
    print("queryPanList ${marks} ${visible}");
    _getPanList(param);
  }

  /**
   * 获取标签相关的盘列表
   */
  void queryPanListByMark(classifyid,marks,{String classifyname,String schoolid}){
    selectClassifyid = classifyid;
    selectClassName = classifyname;
    selectMarks = marks;
    pagenum=1;
    panList = [];
    var param = {
      "page":pagenum,
      "size":pagesize,
      "classifyid":classifyid,
      "marks":marks,
      "isteacher":isteacher
    };
    if(schoolid != null){
      param["schoolid"] = schoolid;
    }
    print("queryPanListByMark");
    _getPanList(param);
  }

  /**
   * 获取网盘数据
   */
  void _getPanList(param){
    print("getpanlist param:${param.toString()}");
    httpUtil.post(DataUtils.api_panlist,data: param).then((value){
      print("school panlist:$value");
      hideLoadMore();
      if(value != null){
        var panListBean = PanListBean.fromJson(json.decode(value));
        if(panListBean.errno == 0){
          if(pagenum == 1){
            panList.clear();
          }
          if(panListBean.data.length > 0){
            pagenum++;
            panList.addAll(panListBean.data);
            setState(() {
            });
          }else{
            showToast("没有数据");
          }
        }
      }
    });
  }

  /**
   * top 1置顶 0非置顶
   * id 列表id
   */
  void panTopping(int top,int id){
    var param = {
      "top":top,
      "id":id
    };
    httpUtil.post(DataUtils.api_pantopping,data:param).then((value){
      if(value != null){
        T.PanToppingBean panToppingBean = T.PanToppingBean.fromJson(json.decode(value));
        if(panToppingBean.errno == 0){
          showToast("网盘置顶");
          pagenum = 1;
          panList = [];
          panParam["page"] = pagenum;
          _getPanList(panParam);
        }
      }
    });
  }

  /**
   * 删除网盘topping
   */
  void deletePanTopping(int id){
    var param = {
      "id":id
    };
    httpUtil.post(DataUtils.api_deletepantopping,data:param).then((value){
      if(value != null){
        T.PanToppingBean panToppingBean = T.PanToppingBean.fromJson(json.decode(value));
        if(panToppingBean.errno == 0){
          showToast("取消置顶");
          pagenum = 1;
          panList = [];
          panParam["page"] = pagenum;
          _getPanList(panParam);
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
            return PanDetailPage(panData: item,isself: item.uid == m_uid,tabs:tabs,marknames: item.marknames,classifyname: item.classifyname,);
          })).then((value){
            if(value != null && value["editor"] == PanEditor.EDITOR){
              setState(() {
                item.imagenum = value["value"];
              });
            }
          });
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            (item.url != null && item.imagenum > 0) ?
            CoustSizeImage(Constant.parsePanSmallString(item.url), mWidth: item.width, mHeight: item.height)
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
            ),child:Text(item.name,style: Constant.titleTextStyleNormal,),),
            //图片数量
            Padding(padding: EdgeInsets.only(
                left: SizeUtil.getAppWidth(20),
                right: SizeUtil.getAppWidth(20),
                top: SizeUtil.getAppWidth(5)
            ),child: Text("共计${item.imagenum}张图片",style: TextStyle(color: Colors.grey[400],fontSize: SizeUtil.getAppFontSize(30)),),),
            Padding(padding: EdgeInsets.only(
                left: SizeUtil.getAppWidth(20),
                right: SizeUtil.getAppWidth(20),
                top: SizeUtil.getAppHeight(20),
                bottom: SizeUtil.getAppHeight(20)
            ),child: InkWell(
              onTap: (){
                var param = new S.Result(
                  uid: item.uid,
                  username:item.username,
                  nickname:item.nickname,
                  avater:item.avater,
                  role:item.role,
                );
                param.panid = item.panid;
                //进入用户详情页
                Navigator.push(context, MaterialPageRoute(builder: (context){
                  return PanUserDetail(data: param,);
                }));
              },
              child: Row(
                children: [
                  ClipOval(
                    child: (item.avater == null || item.avater.length == 0)
                        ? Image.asset("image/ic_head.png",width: SizeUtil.getAppWidth(50),height: SizeUtil.getAppWidth(50),fit: BoxFit.cover,)
                        : CachedNetworkImage(imageUrl: item.avater,width: SizeUtil.getAppWidth(50),height: SizeUtil.getAppWidth(50),fit: BoxFit.cover),
                  ),
                  SizedBox(width: SizeUtil.getAppWidth(10),),
                  Text(item.nickname != null ? item.nickname : item.username,style: TextStyle(color: Colors.grey,fontSize: SizeUtil.getAppFontSize(30)),)
                ],
              ),
            )),
            Align(
              alignment:Alignment.centerRight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  //copy
                  InkWell(
                      onTap: (){
                        //网盘置顶
                        if(item.top == 0){
                          panTopping(1,item.id);
                        }else{
                          deletePanTopping(item.id);
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.only(
                            left:SizeUtil.getAppWidth(20),
                            right:SizeUtil.getAppWidth(20),
                            top:SizeUtil.getAppWidth(5),
                            bottom:SizeUtil.getAppWidth(10)
                        ),
                        child: Image.asset(item.top == 1 ? "image/ic_pan_toped.png" : "image/ic_pan_top.png",width: SizeUtil.getAppWidth(40),height: SizeUtil.getAppWidth(40),),
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
    print("loadmore");
    panParam["page"] = pagenum;
    panParam["isteacher"] = isteacher;
    if(selectMarks != null){
      panParam["marks"] = selectMarks;
    }
    _getPanList(panParam);
  }

  @override
  void refresh() {
  }

}