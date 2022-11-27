import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:yhschool/BaseRefreshState.dart';
import 'package:yhschool/BasefulWidget.dart';
import 'package:yhschool/bean/pan_list_bean.dart';
import 'package:yhschool/bean/pan_classify_bean.dart' as P;
import 'package:yhschool/pan/PanCopyDialog.dart';
import 'package:yhschool/pan/PanDetailPage.dart';
import 'package:yhschool/pan/PanPage.dart';
import 'package:yhschool/bean/user_search.dart' as S;
import 'package:yhschool/utils/EnumType.dart';
import 'package:yhschool/widgets/CoustSizeImage.dart';

import '../utils/Constant.dart';
import '../utils/DataUtils.dart';
import '../utils/HttpUtils.dart';
import '../utils/SizeUtil.dart';
import 'PanUserDetail.dart';

class PanAllPage extends BasefulWidget<PanPageState>{

  BuildContext panContext;
  String marknames;

  PanAllPage({Key key,@required this.panContext,@required this.marknames}):super(key: key);

  @override
  State<StatefulWidget> createState() {
    return PanAllPageState();
  }

  @override
  PanPageState getBaseState(){
    return (this.panContext.widget.key as GlobalKey).currentState as PanPageState;
  }

}

class PanAllPageState extends BaseRefreshState<PanAllPage> with SingleTickerProviderStateMixin{

  ScrollController _scrollController;
  List<P.Data> tabs = [];
  int pagenum=1,pagesize=10;
  List<Data> panList = [];
  int selectClassifyid;
  String selectClassName;
  String selectMarks;
  bool isteacher;


  @override
  void initState() {
    super.initState();
    print("ColumnListPage initState");
    /*isShowAdvert = false;
    super.advertData = {
      "url":"http://res.yimios.com:9050/videos/advert/advert_column_list.jpg",
      "weburl":"https://support.qq.com/products/326279/faqs/121942",
      "height":Constant.ADVERT_COLUMN_HEIGHT
    };*/
    _scrollController = initScrollController(isfresh: false);
  }

  void queryPanListAll(classifyid,{String classifyname,String marks,bool visible,}){
    pagenum = 1;
    selectClassifyid = classifyid;
    selectClassName = classifyname;
    isteacher = visible;
    selectMarks = marks;
    panList = [];
    var param = {
      "page":pagenum,
      "size":pagesize,
      "classifyid":classifyid,
      "isteacher":visible,
      "marks":marks
    };
    print("panlistall ${pagenum} ${selectClassifyid}");
    getPanList(param);
  }

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
      "marks":marks,
    };
    getPanList(param);
  }

  /**
   * 获取网盘数据
   */
  void getPanList(param){
    print("pagenum:${pagenum}");
    httpUtil.post(DataUtils.api_panlist,data: param).then((value){
      print("panlist:$value");
      hideLoadMore();
      if(value != null){
        var panListBean = PanListBean.fromJson(json.decode(value));
        if(panListBean.errno == 0){
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
   * 复制网盘
   */
  void copyPan(panid){
    showDialog(context: context, builder: (context){
      return StatefulBuilder(builder: (_context,_builder) => PanCopyDialog(callback: (result,panid){
        if(result){
          httpUtil.post(DataUtils.api_pancopy,data: {panid:panid}).then((value){
            //跳转到我的网盘
            PanPageState _state = widget.getBaseState();
            _state.changeTab(2);
          });
        }else{
          //创建网盘
        }
      }));
    });
  }

  //panitem
  Widget panItem(Data item){
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(ScreenUtil().setWidth(SizeUtil.getWidth(10))),
          bottomRight: Radius.circular(ScreenUtil().setWidth(SizeUtil.getWidth(10)))
        )
      ),
      child: InkWell(
        onTap: (){
          //进入网盘详情页面
          Navigator.push(context, MaterialPageRoute(builder: (context){
            return PanDetailPage(panData: item,isself: item.uid == m_uid,tabs: tabs,classifyname:item.classifyname,marknames: item.marknames,);
          })).then((result){
            if(result != null){
              PanEditor editor = result["editor"];
              if(editor == PanEditor.EDITOR){
                if(result["value"] == 0){
                  panList.remove(item);
                }
                item.imagenum = result["value"];
              }else if(editor == PanEditor.DELETE){
                for(Data data in panList){
                  if(data.id == item.id){
                    panList.remove(data);
                    break;
                  }
                }
              }
              setState(() {
              });
            }
          });
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            (item.url != null && item.imagenum > 0) ? CoustSizeImage(Constant.parsePanSmallString(item.url), mWidth: item.width, mHeight: item.height)
                : Padding(padding: EdgeInsets.symmetric(horizontal: 0,vertical: SizeUtil.getAppHeight(100)),
              child: Center(
                child: Text(item.uid == m_uid ? "上传图片" : "无图",style: Constant.titleTextStyleNormal,textAlign: TextAlign.center,),
              ),
            ),
            Padding(padding: EdgeInsets.only(
                left: SizeUtil.getAppWidth(20),
                right: SizeUtil.getAppWidth(20),
                top: SizeUtil.getAppHeight(20),
                bottom: SizeUtil.getAppHeight(5)
            ),child:Text(item.name),),
            //图片数量
            Padding(padding: EdgeInsets.only(
                left: SizeUtil.getAppWidth(20),
                right: SizeUtil.getAppWidth(20),
                top: SizeUtil.getAppHeight(5)
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
      mainAxisSpacing: ScreenUtil().setWidth(SizeUtil.getWidth(Constant.DIS_LIST)),
      crossAxisSpacing: ScreenUtil().setHeight(SizeUtil.getHeight(Constant.DIS_LIST)),
      controller: _scrollController,
      //addAutomaticKeepAlives: false,
      padding: EdgeInsets.only(left: ScreenUtil().setWidth(SizeUtil.getWidth(Constant.DIS_LIST)),right: ScreenUtil().setWidth(SizeUtil.getWidth(Constant.DIS_LIST))),
      staggeredTileBuilder: (int index) => StaggeredTile.fit(1),
      //StaggeredTile.count(3,index==0?2:3),
      itemBuilder: (context,index){
        return panItem(panList[index]);
      },
    );
  }

  @override
  void loadmore() {
    var param = {
      "page":pagenum,
      "size":pagesize,
      "classifyid":selectClassifyid.toString(),
      "isteacher":isteacher
    };
    if(selectMarks != null){
      param["marks"] = selectMarks.toString();
    }
    print("loadmore");
    getPanList(param);
  }

  @override
  void refresh() {

  }

}