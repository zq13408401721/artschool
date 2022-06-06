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
import 'package:yhschool/bean/column_gallery_list_bean.dart' as M;
import 'package:yhschool/utils/Constant.dart';
import 'package:yhschool/utils/DBUtils.dart';
import 'package:yhschool/utils/DataUtils.dart';
import 'package:yhschool/utils/HttpUtils.dart';
import 'package:yhschool/utils/ImageType.dart';
import 'package:yhschool/utils/SizeUtil.dart';
import 'package:yhschool/widgets/BackButtonWidget.dart';
import 'package:yhschool/widgets/BaseViewPagerState.dart';
import 'package:yhschool/widgets/CollectButton.dart';
import 'package:yhschool/widgets/HeadTile.dart';
import 'package:yhschool/widgets/ImageButton.dart';
import 'package:yhschool/widgets/LineLoad.dart';
import 'package:yhschool/widgets/PushButtonWidget.dart';

import '../GalleryBig.dart';

class ColumnGalleryPageView extends StatefulWidget{

  List<M.Data> list;
  int position;
  ColumnGalleryPageView({Key key,@required this.list,@required this.position=0}):super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ColumnGalleryPageViewState(list: list,position: position);
  }
}

class ColumnGalleryPageViewState extends BaseViewPagerState<M.Data,ColumnGalleryPageView>{

  List<M.Data> list;
  int position;

  double loadingProgress=-1;
  bool loadover = false;
  double _width=0;

  Timer timer;

  ColumnGalleryPageViewState({Key key,@required this.list,@required this.position}):super(key: key,data: list,start: position,physics:ClampingScrollPhysics());


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
  }

  @override
  Widget initChildren(BuildContext context, M.Data data) {
    double _height = ScreenUtil().setHeight(SizeUtil.getHeight(Constant.getScaleH(data.width.toDouble(), data.height.toDouble())));
    Size _size = MediaQuery.of(context).size;
    _width = _size.width;
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: ScreenUtil().setHeight(SizeUtil.getHeight(100)),
            decoration: BoxDecoration(
              color: Colors.white
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BackButtonWidget(cb: (){
                  Navigator.pop(context);
                }, title: "返回"),
                Container(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                     CollectButton(margin_right: SizeUtil.getWidth(30).toInt(), from: Constant.COLLECT_COLUMN,fromid: data.id,url: data.url,name: data.name,width: data.width,height: data.height,),
                      //推送
                      m_role == 1 ? PushButtonWidget(cb: (){
                        pushGallery(context, {
                          "name":m_username == null ? m_nickname : m_username,
                          "url":data.url,
                          "from":Constant.PUSH_FROM_COLUMN,
                          "width":data.width,
                          "height":data.height,
                          "maxwidth":data.sourcewidth,
                          "maxheight":data.sourceheight
                        });
                      },title: "推送",) : SizedBox()
                    ],
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
                      top: ScreenUtil().setWidth(SizeUtil.getWidth(40))
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
                                Padding(
                                  padding: EdgeInsets.only(
                                    left: ScreenUtil().setWidth(SizeUtil.getWidth(Constant.isPad ? 200 : 0)),
                                    right: ScreenUtil().setWidth(SizeUtil.getWidth(Constant.isPad ? 200 : 0)),
                                    top: ScreenUtil().setWidth(SizeUtil.getWidth(Constant.isPad ? 180 : 0)),
                                  ),
                                  child: CachedNetworkImage(
                                    imageUrl: Constant.parseMiddleImageString(data.url,data.width,data.height,75),
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    progressIndicatorBuilder:(_context,_url,_progress){
                                      print("${data.url}:${_progress.totalSize}");
                                      if(_progress.totalSize == null){
                                        loadover = true;
                                        //print("loadingProgress:${loadingProgress} ${_progress.downloaded}/${_progress.totalSize}");
                                      }else{
                                        loadover = false;
                                        if(!timer.isActive){
                                          registerTimer();
                                        }
                                        loadingProgress = (_progress.downloaded/_progress.totalSize).toDouble()*_width;
                                      }
                                      return SizedBox();
                                    },
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
                            )
                        ),
                        //HeadTile(avater: data.avater, label: data.nickname != null ? data.nickname : data.username),
                      ],
                    ),
                  ),
                ),
                //进度条
                loadover == false ? LineLoad(loadingProgress, 5.0) : SizedBox(),
              ],
            ),
          ),
        ],
      ),
    );
  }

}