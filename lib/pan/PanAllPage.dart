import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:yhschool/BaseRefreshState.dart';
import 'package:yhschool/BasefulWidget.dart';
import 'package:yhschool/bean/pan_list_bean.dart';
import 'package:yhschool/pan/PanCopyDialog.dart';
import 'package:yhschool/pan/PanDetailPage.dart';
import 'package:yhschool/pan/PanPage.dart';

import '../utils/Constant.dart';
import '../utils/DataUtils.dart';
import '../utils/HttpUtils.dart';
import '../utils/SizeUtil.dart';

class PanAllPage extends BasefulWidget<PanPageState>{

  BuildContext panContext;

  PanAllPage({Key key,@required this.panContext}):super(key: key);

  @override
  State<StatefulWidget> createState() {
    return PanAllPageState();
  }

  @override
  PanPageState getBaseState(){
    return (this.panContext.widget.key as GlobalKey).currentState as PanPageState;
  }

}

class PanAllPageState extends BaseRefreshState<PanAllPage>{

  ScrollController _scrollController;

  int pagenum=1,pagesize=10;
  List<Data> panList = [];

  @override
  void initState() {
    super.initState();
    print("ColumnListPage initState");
    isShowAdvert = true;
    super.advertData = {
      "url":"http://res.yimios.com:9050/videos/advert/advert_column_list.jpg",
      "weburl":"https://support.qq.com/products/326279/faqs/121942",
      "height":Constant.ADVERT_COLUMN_HEIGHT
    };
    _scrollController = initScrollController();
  }

  void queryPanListAll(classifyid){
    panList = [];
    var param = {
      "page":pagenum,
      "size":pagesize,
      "classifyid":classifyid
    };
    getPanList(param);
  }

  void queryPanListByMark(classifyid,marks){
    panList = [];
    var param = {
      "page":pagenum,
      "size":pagesize,
      "classifyid":classifyid,
      "marks":marks
    };
    getPanList(param);
  }

  /**
   * 获取网盘数据
   */
  void getPanList(param){
    httpUtil.post(DataUtils.api_panlist,data: param).then((value){
      print("panlist:$value");
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
            return PanDetailPage(panData: item,isself: item.uid == m_uid,);
          }));
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CachedNetworkImage(imageUrl: Constant.parsePanSmallString(item.url)),
            Padding(padding: EdgeInsets.only(
              left: ScreenUtil().setWidth(SizeUtil.getWidth(20)),
              right: ScreenUtil().setWidth(SizeUtil.getWidth(20)),
              top: ScreenUtil().setWidth(SizeUtil.getWidth(20)),
              bottom: ScreenUtil().setWidth(SizeUtil.getWidth(5)),
            ),child:Text(item.name),),
            Padding(padding: EdgeInsets.only(
              left: ScreenUtil().setWidth(SizeUtil.getWidth(20)),
              right: ScreenUtil().setWidth(SizeUtil.getWidth(20)),
              top: ScreenUtil().setWidth(SizeUtil.getWidth(5)),
              bottom: ScreenUtil().setWidth(SizeUtil.getWidth(5)),
            ),child: Text(item.nickname != null ? item.nickname : item.username,style: Constant.smallTitleTextStyle,),),
            Padding(padding: EdgeInsets.only(
              left: ScreenUtil().setWidth(SizeUtil.getWidth(20)),
              right: ScreenUtil().setWidth(SizeUtil.getWidth(20)),
              top: ScreenUtil().setWidth(SizeUtil.getWidth(5))
            ),child: Text("P${item.imagenum}",style: TextStyle(color: Colors.grey,fontSize: ScreenUtil().setSp(30)),),),
            Align(
              alignment:Alignment.centerRight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  //copy
                  InkWell(
                    onTap: (){
                      //复制网盘
                      //copyPan(item.panid);
                      PanPageState _state = widget.getBaseState();
                      _state.changeTab(2);
                    },
                    child: Container(
                      padding: EdgeInsets.only(
                        left:ScreenUtil().setWidth(SizeUtil.getWidth(20)),
                        right:ScreenUtil().setWidth(SizeUtil.getWidth(20)),
                        top:ScreenUtil().setWidth(SizeUtil.getWidth(5)),
                        bottom:ScreenUtil().setWidth(SizeUtil.getWidth(10))
                      ),
                      child: Image.asset("image/ic_pan_copy.png",width: ScreenUtil().setWidth(SizeUtil.getWidth(40)),height: ScreenUtil().setWidth(SizeUtil.getWidth(40)),),
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
      mainAxisSpacing: ScreenUtil().setWidth(SizeUtil.getWidth(Constant.DIS_LIST)),
      crossAxisSpacing: ScreenUtil().setHeight(SizeUtil.getHeight(Constant.DIS_LIST)),
      controller: _scrollController,
      //addAutomaticKeepAlives: false,
      padding: EdgeInsets.only(left: ScreenUtil().setWidth(SizeUtil.getWidth(Constant.DIS_LIST)),right: ScreenUtil().setWidth(SizeUtil.getWidth(Constant.DIS_LIST))),
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