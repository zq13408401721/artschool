import 'dart:convert';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/shims/dart_ui_real.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:yhschool/widgets/BaseRefreshViewPagerState.dart';
import 'package:yhschool/bean/pan_file_bean.dart' as F;
import 'package:yhschool/bean/user_search.dart' as S;

import '../GalleryBig.dart';
import '../bean/LocalFile.dart';
import '../bean/pan_file_bean.dart';
import '../popwin/DialogManager.dart';
import '../utils/Constant.dart';
import '../utils/DataUtils.dart';
import '../utils/HttpUtils.dart';
import '../utils/ImageType.dart';
import '../utils/SizeUtil.dart';
import '../widgets/BackButtonWidget.dart';
import 'PanUserDetail.dart';

class PanImageDetailViewPager extends StatefulWidget{

  dynamic panData;
  List<Data> panFiles = [];
  int start;
  bool isself;
  PanImageDetailViewPager({Key key,@required this.panData,@required this.isself,@required this.start=0}):super(key: key);

  @override
  State<StatefulWidget> createState() {
    return PanImageDetailViewPagerState(key: key,filesList: panFiles,start:start);
  }
}

class PanImageDetailViewPagerState extends BaseRefreshViewPagerState<Data,PanImageDetailViewPager>{


  int pagenum=1,pagesize=3;
  List<F.Data> filesList=[];
  dynamic imgData;
  int fileid; //对应的文件id
  bool isself = false;
  int start;


  PanImageDetailViewPagerState({Key key,@required this.filesList,@required this.start=0}):super(key: key,data: filesList,start: start);

  @override
  void initState() {
    super.initState();
    print("PanImageDetailViewPager initState");
    // 计算初始化的页码
    pagenum = ((start+1)/pagesize).ceil();
    int mSize = pagenum*pagesize;
    // 初始化从1开始
    queryPanImageList(1,mSize);
  }


  void queryPanImageList(int page,int size){
    var param = {
      "panid":widget.panData.panid,
      "page":page,
      "size":size
    };
    print("queryPanImage page:${pagenum} size:${size}");
    httpUtil.post(DataUtils.api_queryuserpanimage,data:param).then((value){
      hideLoadMore();
      if(value != null){
        print("panimagelist ${value}");
        int currentPage = 0;
        if(page == 1){
          currentPage = start;
          super.data.clear();
        }
        PanFileBean panFileBean = PanFileBean.fromJson(json.decode(value));
        if(panFileBean.errno == 0){
          print("queryImage return ${panFileBean.data.length}");
          if(panFileBean.data.length > 0){
            pagenum++;
            //如果是初始当前页就是start
            if(page == 1){
              currentPage = start;
            }else{
              //加载更多页的时候直接跳转到下一页的第一个
              currentPage = super.data.length;
            }
            print("currentPage:${currentPage}");
            super.data.addAll(panFileBean.data);
            curSelect = super.data[currentPage];
            setState(() {
              setCurrentPage(currentPage);
            });
          }else{
            showToast("没有更多数据");
          }
        }
      }
    });
  }

  /**
   * 添加网盘文件like
   */
  void addPanFileLike(int fileid,String panid){
    var param = {
      "panid":panid,
      "fileid":fileid
    };
    httpUtil.post(DataUtils.api_addpanfilelike,data: param).then((value){
      print("addpanfilelike $value");
      setState(() {
        curSelect.like = 1;
      });
    });
  }

  /**
   * 删除网盘文件like
   */
  void deletePanFileLike(int fileid,String panid){
    var param = {
      "panid":panid,
      "fileid":fileid
    };
    httpUtil.post(DataUtils.api_deletepanfilelike,data: param).then((value){
      print("deletepanfile like $value");
      if(widget.isself){
        //取消喜欢退回到上一个页面
        Navigator.pop(context,fileid);
      }else{
        setState(() {
          curSelect.like = 0;
        });
      }
    });
  }

  @override
  Widget initTitleBar(data) {
    return Container(
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          BackButtonWidget(cb: (){
            Navigator.pop(context);
          },title: "",),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              //喜欢
              Offstage(
                offstage: widget.panData.uid == m_uid,
                child: InkWell(
                  onTap: (){
                    //喜欢
                    if(data.like == 0){
                      addPanFileLike(data.id, widget.panData.panid);
                    }else{
                      deletePanFileLike(data.id, widget.panData.panid);
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: data.like == 0 ? Colors.amberAccent : Colors.red,
                        borderRadius: BorderRadius.all(Radius.circular(SizeUtil.getAppWidth(5)))
                    ),
                    margin: EdgeInsets.only(right: SizeUtil.getAppWidth(20)),
                    padding: EdgeInsets.symmetric(
                        horizontal: SizeUtil.getAppWidth(20),
                        vertical: SizeUtil.getAppHeight(10)
                    ),
                    child: Text(data.like == 0 ? "喜欢" : "取消喜欢",style: TextStyle(fontSize: SizeUtil.getAppFontSize(25),color: Colors.white),),
                  ),
                ),
              ),
              //老师身份推到课堂
              Offstage(
                offstage: m_role != 1,
                child: InkWell(
                  onTap: (){
                    //推送到课堂
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
                ),
              ),
              //存网盘
              Offstage(
                offstage: widget.panData.imagenum == 0 || widget.panData.uid == m_uid,
                child: InkWell(
                  onTap: (){
                    DialogManager().showCopyPanImageDialog(context,widget.panData.panid,data.fileid).then((value){
                      if(value != null){

                      }
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(SizeUtil.getAppWidth(5)),
                        color: Colors.blueAccent
                    ),
                    margin: EdgeInsets.only(
                        right: SizeUtil.getAppWidth(20)
                    ),
                    padding: EdgeInsets.symmetric(
                        horizontal: SizeUtil.getAppWidth(20),
                        vertical: SizeUtil.getAppHeight(10)
                    ),
                    child: Text("存网盘",style: TextStyle(fontSize: SizeUtil.getAppFontSize(25),color: Colors.white),),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget initChildren(BuildContext context, data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //顶部按钮
        Container(
          child: initTitleBar(data),
        ),
        //图片
        Container(
            child: InkWell(
              onTap: (){
                Navigator.pushAndRemoveUntil(context, new MaterialPageRoute(builder: (BuildContext context){
                  return GalleryBig(imgUrl: data.url,imageType: BigImageType.pan);
                }), (route) => true);
              },
              child: Stack(
                children: [
                  CachedNetworkImage(
                    imageUrl: Constant.parsePanSmallString(data.url),
                    width:Constant.SCREEN_W,
                    fit: BoxFit.cover,
                  ),
                  Positioned(
                    right: 0,
                    top: 0,
                    bottom: 0,
                    child: Offstage(
                      offstage: !loadmoreright,
                      child: Container(
                        color: Colors.grey[100],
                        width: SizeUtil.getAppWidth(100),
                        alignment: Alignment.center,
                        child: Container(
                          width: SizeUtil.getAppWidth(50),
                          child: Text("加载更多",textDirection: TextDirection.ltr,textAlign: TextAlign.center,style: TextStyle(fontSize: SizeUtil.getAppFontSize(30)),),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
        ),
        //图片信息
        Padding(
          padding: EdgeInsets.symmetric(
              vertical: SizeUtil.getAppHeight(20),
              horizontal: SizeUtil.getAppWidth(20)
          ),
          child: Text("${widget.panData.date}",style: Constant.smallTitleTextStyle,),
        ),
        InkWell(
          onTap: (){
            //用户详情
            var param = new S.Result(
              uid: widget.panData.uid,
              username:widget.panData.username,
              nickname:widget.panData.nickname,
              avater:widget.panData.avater,
              role:widget.panData.role,
            );
            param.panid = widget.panData.panid;
            //进入用户详情页
            Navigator.push(context, MaterialPageRoute(builder: (context){
              return PanUserDetail(data: param,);
            }));
          },
          child: Padding(
            padding: EdgeInsets.symmetric(
                vertical: SizeUtil.getAppHeight(20),
                horizontal: SizeUtil.getAppWidth(20)
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ClipOval(
                  child: (widget.panData.avater == null || widget.panData.avater.length == 0)
                      ? Image.asset("image/ic_head.png",width: SizeUtil.getAppWidth(50),height: SizeUtil.getAppWidth(50),fit: BoxFit.cover,)
                      : CachedNetworkImage(imageUrl: widget.panData.avater,width: SizeUtil.getAppWidth(50),height: SizeUtil.getAppWidth(50),fit: BoxFit.cover),
                ),
                SizedBox(width: SizeUtil.getAppWidth(10),),
                Text(widget.panData.nickname != null ? widget.panData.nickname : widget.panData.username,style: Constant.smallTitleTextStyle,),
              ],
            ),
          ),
        ),
        Offstage(
          offstage: widget.panData.name == null,
          child: Padding(
            padding: EdgeInsets.symmetric(
                vertical: SizeUtil.getAppHeight(20),
                horizontal: SizeUtil.getAppWidth(20)
            ),
            child: Text("网盘名称：${widget.panData.name}，共计${widget.panData.imagenum}张图片",style: Constant.smallTitleTextStyle,),
          ),
        )
      ],
    );
  }

  /**
   * 左右滑动加载更多
   */
  @override
  void loadData() {
    queryPanImageList(pagenum,pagesize);
  }

  @override
  void pageChange() {

  }

  /**
   * 上下滑动加载更多
   */
  @override
  void loadmore() {

  }

  @override
  void refresh() {

  }
  
}
