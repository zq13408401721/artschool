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
import 'package:yhschool/bean/pan_classify_bean.dart' as P;
import 'package:yhschool/popwin/DialogManager.dart';
import 'package:yhschool/utils/EnumType.dart';
import 'package:yhschool/widgets/CoustSizeImage.dart';
import '../bean/pan_list_bean.dart';
import '../utils/Constant.dart';
import '../utils/DataUtils.dart';
import '../utils/HttpUtils.dart';
import '../utils/SizeUtil.dart';
import 'PanDetailPage.dart';
import 'package:yhschool/bean/user_search.dart' as S;

import 'PanUserDetail.dart';

class PanMine extends BasefulWidget<PanPageState>{

  BuildContext panContext;
  Function callback;

  PanMine({Key key,@required this.panContext,@required this.callback}):super(key: key);

  @override
  State<StatefulWidget> createState() {
    return PanMineState();
  }

  @override
  PanPageState getBaseState() {
    return (this.panContext.widget.key as GlobalKey).currentState as PanPageState;
  }

}

class PanMineState extends BaseRefreshState<PanMine>{

  ScrollController _scrollController;

  List<P.Data> tabs = [];

  int pagenum=1,pagesize=10;
  List<Data> panList = [];
  dynamic queryParam;
  String _marks;
  int _classifyid;

  int selectClassifyid;
  String selectClassName;
  String selectMarks;

  @override
  void initState() {
    super.initState();
    _scrollController = initScrollController(isfresh: false);

  }

  /**
   * 查询网盘列表数据
   */
  void queryPanList({int classifyid,String marks}){
    print("panmine ${classifyid}}");
    pagenum = 1;
    this.panList = [];
    _classifyid = classifyid;
    var param = {
      "page":pagenum.toString(),
      "size":pagesize.toString(),
      "classifyid":classifyid.toString(),
      "isself":true
    };
    if(marks != null){
      _marks = marks;
      param["mark"] = marks;
    }
    queryParam = param;
    _getPanList(param);
  }

  void _queryMore(){
    var param = {
      "page":pagenum.toString(),
      "size":pagesize.toString(),
      "classifyid":_classifyid.toString(),
      "isself":true
    };
    if(_marks != null){
      param["mark"] = _marks;
    }
    queryParam = param;
    _getPanList(param);
  }

  /**
   * 网盘置顶/取消置顶
   */
  void panTopping(int top,String panid){
    pagenum = 1;
    this.panList = [];
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
  void deletePan(String name,String panid){
    DialogManager().showDeletePanDialog(context,type:PanDeleteType.PAN, title: "是否确定删除${name}网盘？", panid: panid).then((value){
      if(value){
        for(Data item in panList){
          if(item.panid == panid){
            panList.remove(item);
            break;
          }
        }
        if(widget.callback != null){
          widget.callback();
        }
        setState(() {
        });
      }
    });
  }

  /**
   * 获取标签相关的盘列表
   */
  void queryPanListByMark(classifyid,marks,{String classifyname}){
    selectClassifyid = classifyid;
    selectClassName = classifyname;
    selectMarks = marks;
    pagenum=1;
    panList = [];
    var param = {
      "page":pagenum,
      "size":pagesize,
      "classifyid":classifyid,
      "marks":marks
    };
    _getPanList(param);
  }

  /**
   * 获取网盘数据
   */
  void _getPanList(param){
    httpUtil.post(DataUtils.api_querymypanlist,data: param).then((value){
      print("mine panlist:$value");
      hideLoadMore();
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
            return PanDetailPage(panData: item,isself: item.uid == m_uid,tabs: tabs,);
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
            CoustSizeImage(Constant.parsePanSmallString(item.url), width: item.width, height: item.height)
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
                top: SizeUtil.getAppHeight(10),
                bottom: SizeUtil.getAppHeight(10)
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
                  SizedBox(width: SizeUtil.getAppWidth(20),),
                  Text(item.nickname != null ? item.nickname : item.username,style: Constant.smallTitleTextStyle,)
                ],
              ),
            )),
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
                        deletePan(item.name,item.panid);
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
        return panItem(panList[index]);
      },
    );
  }

  @override
  void loadmore() {
    _queryMore();
  }

  @override
  void refresh() {
  }

}
