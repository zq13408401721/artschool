import 'dart:async';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yhschool/bean/CollectDB.dart';
import 'package:yhschool/bean/CollectDateDB.dart';
import 'package:yhschool/bean/collect_add_bean.dart';
import 'package:yhschool/bean/collect_date_bean.dart';
import 'package:yhschool/bean/collect_delete_bean.dart';
import 'package:yhschool/bean/entity_gallery_list.dart';
import 'package:yhschool/utils/Constant.dart';
import 'package:yhschool/utils/DBUtils.dart';
import 'package:yhschool/utils/DataUtils.dart';
import 'package:yhschool/utils/HttpUtils.dart';
import 'package:yhschool/utils/ImageType.dart';
import 'package:yhschool/utils/SizeUtil.dart';
import 'package:yhschool/widgets/BackButtonWidget.dart';
import 'package:yhschool/widgets/BaseViewPagerState.dart';
import 'package:yhschool/widgets/CollectButton.dart';
import 'package:yhschool/widgets/CustomLoad.dart';
import 'package:yhschool/widgets/LineLoad.dart';
import 'package:yhschool/widgets/PushButtonWidget.dart';

import '../GalleryBig.dart';

class GalleryPageView extends StatefulWidget{

  List<GalleryListData> list;
  int position;
  int from; //当前页面打开的方式，课堂作业，图库 网盘 等
  bool isaction; //是否隐藏操作栏
  GalleryPageView({Key key,@required this.list,@required this.position=0,@required this.from,@required this.isaction=false}):super(key: key);

  @override
  State<StatefulWidget> createState() {
    return GalleryPageViewState(list: list,position: position);
  }
}

class GalleryPageViewState extends BaseViewPagerState<GalleryListData,GalleryPageView>{

  static final GlobalKey<CollectButtonState> _collectButtonState = GlobalKey<CollectButtonState>();

  bool waiting = false;
  bool iscollect = false;

  List<GalleryListData> list;
  int position;

  double loadingProgress=-1;
  bool loadover = false;
  double _width=0;

  Timer timer;

  GalleryPageViewState({Key key,@required this.list,@required this.position}):super(key:key,data: list,start: position,physics: ClampingScrollPhysics());


  @override
  void initState() {
    super.initState();
    registerTimer();
  }

  void registerTimer(){
    timer = Timer.periodic(Duration(milliseconds: 50), (timer) {
      if(!mounted){
        timer.cancel();
        return;
      }
      if(!loadover){
        setState(() {
        });
      }else{
        setState(() {
        });
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    if(timer != null){
      timer.cancel();
    }
    super.dispose();
  }
  /**
   * 页面切换
   */
  @override
  void pageChange() {
    if(!timer.isActive){
      registerTimer();
    }
    loadingProgress = 0;
    loadover = false;
    if(curSelect != null){
      DBUtils.dbUtils.then((value){
        value.checkCollect(m_uid, getWidget().from, curSelect.id).then((value){
          setState(() {
            this.iscollect = value;
          });
        });
      });
    }
  }

  @override
  Widget initChildren(BuildContext context, GalleryListData data) {
    Size _size = MediaQuery.of(context).size;
    _width = _size.width;
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BackButtonWidget(cb: (){
                  Navigator.pop(context);
                }, title: (data.name != null && data.name.length > 8) ? data.name.substring(0,8) : data.name),
                Offstage(
                  offstage: getWidget().isaction,
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: ScreenUtil().setWidth(SizeUtil.getWidth(30))
                          ),
                          child: CollectButton(fromid: data.id,
                            url: data.url,name: data.name,width: data.width,height: data.height,from: getWidget().from,
                          ),
                        ),
                        InkWell(
                          onTap: (){
                            pushGallery(context, {
                              "name":m_username == null ? m_nickname : m_username,
                              "url":data.url,
                              "width":data.width,
                              "height":data.height,
                              "maxwidth":data.maxwidth,
                              "maxheight":data.maxheight
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.purple,
                                borderRadius: BorderRadius.all(Radius.circular(SizeUtil.getAppWidth(5)))
                            ),
                            margin: EdgeInsets.only(right: SizeUtil.getAppWidth(20)),
                            padding: EdgeInsets.symmetric(
                                horizontal: SizeUtil.getAppWidth(20),
                                vertical: SizeUtil.getAppHeight(10)
                            ),
                            child: Text("推送到班级",style: TextStyle(fontSize: SizeUtil.getAppFontSize(25),color: Colors.white),),
                          ),
                        )
                        /*m_role == 1 ? PushButtonWidget(cb: (){
                          pushGallery(context, {
                            "name":m_username == null ? m_nickname : m_username,
                            "url":data.url,
                            "width":data.width,
                            "height":data.height,
                            "maxwidth":data.maxwidth,
                            "maxheight":data.maxheight
                          });
                        },title: "推送",) : SizedBox()*/
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      left: ScreenUtil().setWidth(SizeUtil.getWidth(40)),
                      right: ScreenUtil().setWidth(SizeUtil.getWidth(40)),
                      top: ScreenUtil().setWidth(SizeUtil.getHeight(40))
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: (){
                            Navigator.pushAndRemoveUntil(context, new MaterialPageRoute(builder: (BuildContext context){
                              return GalleryBig(imgUrl: data.url,imageType: BigImageType.gallery,width: data.width,height: data.height,);
                            }), (route) => true);
                          },
                          child: Stack(
                            children: [
                              Container(
                                padding: EdgeInsets.only(
                                  left: ScreenUtil().setWidth(SizeUtil.getWidth(Constant.isPad ? 200 : 0)),
                                  right: ScreenUtil().setWidth(SizeUtil.getWidth(Constant.isPad ? 200 : 0)),
                                  top: ScreenUtil().setWidth(SizeUtil.getWidth(Constant.isPad ? 180 : 0)),
                                ),
                                child: CachedNetworkImage(
                                  imageUrl: Constant.parseMiddleImageString(data.url,data.width,data.height,75),
                                  width: double.infinity,
                                  progressIndicatorBuilder:(_context,_url,_progress){
                                    if(_progress.totalSize == null){
                                      loadover = true;
                                      print("loadingProgress:${loadingProgress} ${_progress.downloaded}/${_progress.totalSize}");
                                    }else{
                                      loadover = false;
                                      if(!timer.isActive){
                                        registerTimer();
                                      }
                                      loadingProgress = (_progress.downloaded/_progress.totalSize).toDouble()*_width;
                                    }
                                    return SizedBox();
                                  },
                                  /*placeholder: (_context,_url)=>
                                  Stack(
                                    alignment: Alignment(0,0),
                                    children: [
                                      Container(
                                        width: ScreenUtil().setWidth(40),
                                        height: ScreenUtil().setWidth(40),
                                        child: CircularProgressIndicator(color: Colors.red,),
                                      ),
                                    ],
                                  ),*/
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned(
                                right: ScreenUtil().setWidth(SizeUtil.getWidth(40)),
                                top: ScreenUtil().setHeight(SizeUtil.getHeight(40)),
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(ScreenUtil().setWidth(40)),
                                      border: Border.all(color: Colors.red,width: ScreenUtil().setWidth(1))
                                  ),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: ScreenUtil().setWidth(SizeUtil.getWidth(40)),
                                      vertical: ScreenUtil().setHeight(SizeUtil.getHeight(20))
                                  ),
                                  child: Text("高清",style: TextStyle(fontSize: ScreenUtil().setSp(SizeUtil.getFontSize(30)),color: Colors.red),),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                //进度条
                loadover == false ? LineLoad(loadingProgress, 5.0) : SizedBox(),
              ],
            ),
          )
        ],
      ),
    );
  }

}