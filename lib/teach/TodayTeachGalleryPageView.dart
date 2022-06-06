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
import 'package:yhschool/teach/TodayTeachGalleryEditorPage.dart';
import 'package:yhschool/utils/Constant.dart';
import 'package:yhschool/utils/DBUtils.dart';
import 'package:yhschool/utils/DataUtils.dart';
import 'package:yhschool/utils/HttpUtils.dart';
import 'package:yhschool/utils/ImageType.dart';
import 'package:yhschool/utils/SizeUtil.dart';
import 'package:yhschool/widgets/BackButtonWidget.dart';
import 'package:yhschool/widgets/BaseViewPagerState.dart';
import 'package:yhschool/widgets/CollectButton.dart';
import 'package:yhschool/widgets/LineLoad.dart';

import '../GalleryBig.dart';

class TodayTeachGalleryPageView extends StatefulWidget{

  List<GalleryListData> list;
  int position;
  int from; //当前页面打开的方式，课堂作业，图库 网盘 等
  bool isaction; //是否隐藏操作栏
  TodayTeachGalleryPageView({Key key,@required this.list,@required this.position=0,@required this.from, @required this.isaction=false}):super(key: key);

  @override
  State<StatefulWidget> createState() {
    return TodayTeachGalleryPageViewState(list: list,position: position);
  }
}

class TodayTeachGalleryPageViewState extends BaseViewPagerState<GalleryListData,TodayTeachGalleryPageView>{

  bool waiting = false;
  bool iscollect = false;

  List<GalleryListData> list;
  int position;

  //存储一个编辑的URL用来判断是否更新上一个页面的数据
  String editorurl;

  double loadingProgress=-1;
  bool loadover = false;
  double _width=0;

  Timer timer;

  TodayTeachGalleryPageViewState({Key key,@required this.list,@required this.position}):super(key:key,data: list,start: position,physics: ClampingScrollPhysics());

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
      padding: EdgeInsets.only(bottom: ScreenUtil().setHeight(SizeUtil.getHeight(40))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: ScreenUtil().setHeight(SizeUtil.getHeight(Constant.SIZE_TOP_HEIGHT)),
            decoration: BoxDecoration(
              color: Colors.white
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BackButtonWidget(cb: (){
                  Navigator.pop(context,editorurl != null ? {"id":data.id,"editorurl":editorurl} : null);
                }, title: data.name,word:data.markname,wordStyle: TextStyle(
                  fontSize: ScreenUtil().setSp(SizeUtil.getFontSize(30)),fontWeight: FontWeight.bold,color: Colors.red
                ),),
                Offstage(
                  offstage: getWidget().isaction,
                  child: CollectButton(margin_right: SizeUtil.getWidth(40).toInt(),from: getWidget().from,fromid: data.id,name:data.name,url:data.url,width: data.width,height: data.height,)
                )
              ],
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                Column(
                  children: [
                    //评论留言
                    Offstage(
                        offstage: data.comments == null || data.comments.length == 0,
                        child: Container(
                          width: double.infinity,
                          margin: EdgeInsets.symmetric(
                              horizontal: ScreenUtil().setWidth(40),
                              vertical: ScreenUtil().setHeight(20)
                          ),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)
                          ),
                          padding: EdgeInsets.only(
                            left:ScreenUtil().setHeight(30),
                            right:ScreenUtil().setHeight(30),
                            top:ScreenUtil().setHeight(20),
                            bottom:ScreenUtil().setHeight(20),
                          ),
                          child: Text(
                            data.comments != null ? data.comments : "",
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: Constant.titleTextStyleNormal,
                          ),
                        )
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                  left: ScreenUtil().setWidth(SizeUtil.getWidth(40)),
                                  right: ScreenUtil().setWidth(SizeUtil.getWidth(40)),
                                  top: ScreenUtil().setWidth(SizeUtil.getWidth(40))
                              ),
                              child: Stack(
                                children: [
                                  InkWell(
                                    onTap: (){
                                      Navigator.pushAndRemoveUntil(context, new MaterialPageRoute(builder: (BuildContext context){
                                        return GalleryBig(imgUrl: data.url,width: data.width,height: data.height,);
                                      }), (route) => true);
                                    },
                                    child: CachedNetworkImage(
                                      imageUrl: Constant.parseNewIssueSmallString(data.url,data.width*2,data.height*2),
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                      memCacheWidth: data.width,
                                      memCacheHeight: data.height,
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
                                  ),
                                  Positioned(
                                    top: 0,
                                    right: 0,
                                    child: Row(
                                      children: [
                                        InkWell(
                                          onTap: (){
                                            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>TodayTeachGalleryEditorPage(data: data))).then((value){
                                              if(value != null){
                                                editorurl = value;
                                                setState(() {
                                                  data.editorurl = value;
                                                });
                                              }
                                            });
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: Colors.red
                                            ),
                                            padding: EdgeInsets.symmetric(
                                                horizontal: ScreenUtil().setWidth(SizeUtil.getWidth(40)),
                                                vertical: ScreenUtil().setHeight(SizeUtil.getHeight(20))
                                            ),
                                            child: Text("编辑",style: TextStyle(fontSize: ScreenUtil().setSp(SizeUtil.getFontSize(36)),color: Colors.white),),
                                          ),
                                        ),
                                        (data.editorurl != null && data.editorurl.length > 0) ?
                                        InkWell(
                                          onTap: (){
                                            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>GalleryBig(imgUrl: data.editorurl, imageType: BigImageType.issue,width: data.width,height: data.height,)));
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: Colors.purple
                                            ),
                                            padding: EdgeInsets.symmetric(
                                                horizontal: ScreenUtil().setWidth(SizeUtil.getWidth(40)),
                                                vertical: ScreenUtil().setHeight(SizeUtil.getHeight(20))
                                            ),
                                            child: Text("已编辑",style: TextStyle(fontSize: ScreenUtil().setSp(SizeUtil.getFontSize(36)),color: Colors.white),),
                                          ),
                                        ) : SizedBox()
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: ScreenUtil().setHeight(SizeUtil.getHeight(40)),),
                            (data.editorurl == null || data.editorurl.length == 0) ? Container() : Container(
                              padding: EdgeInsets.only(
                                top: ScreenUtil().setHeight(SizeUtil.getHeight(20)),
                                left: ScreenUtil().setWidth(SizeUtil.getWidth(40)),
                              ),
                              child: Text("编辑图片预览",style: Constant.titleTextStyleNormal,),
                            ),
                            //编辑以后的图片预览
                            (data.editorurl == null || data.editorurl.length == 0) ? Container()
                                : InkWell(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>GalleryBig(imgUrl: data.editorurl, imageType: BigImageType.issue,width: data.width,height: data.height,)));
                              },
                              child: Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: ScreenUtil().setWidth(SizeUtil.getWidth(40))
                                ),
                                child: CachedNetworkImage(imageUrl: Constant.parseNewIssueSmallString(data.editorurl,data.width,data.height),
                                  width: ScreenUtil().setWidth(data.width.toDouble()),height: ScreenUtil().setHeight(data.height.toDouble()),
                                  memCacheWidth: data.width,memCacheHeight: data.height,),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
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