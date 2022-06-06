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
import 'package:yhschool/widgets/LineLoad.dart';

import '../GalleryBig.dart';

class SingleGalleryPageView extends StatefulWidget{

  List<String> list;
  int position;
  SingleGalleryPageView({Key key,@required this.list,@required this.position=0}):super(key: key);

  @override
  State<StatefulWidget> createState() {
    return SingleGalleryPageViewState(list: list,position: position);
  }
}

class SingleGalleryPageViewState extends BaseViewPagerState<String,SingleGalleryPageView>{

  List<String> list;
  int position;

  double loadingProgress=-1;
  bool loadover = false;
  double _width=0;

  Timer timer;

  SingleGalleryPageViewState({Key key,@required this.list,@required this.position}):super(key: key,data: list,start: position,physics:ClampingScrollPhysics());

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
  Widget initChildren(BuildContext context, String data) {
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
            padding: EdgeInsets.only(
              top: ScreenUtil().setHeight(SizeUtil.getHeight(20))
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BackButtonWidget(cb: (){Navigator.pop(context);}, title: "步骤图")
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
                      top: ScreenUtil().setHeight(SizeUtil.getHeight(40))
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: (){
                            Navigator.pushAndRemoveUntil(context, new MaterialPageRoute(builder: (BuildContext context){
                              return GalleryBig(imgUrl: data,imageType: BigImageType.gallery,);
                            }), (route) => true);
                          },
                          child: CachedNetworkImage(
                            imageUrl: data,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            progressIndicatorBuilder:(_context,_url,_progress){
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
                        )
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