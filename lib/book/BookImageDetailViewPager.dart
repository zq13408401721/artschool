import 'dart:convert';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/shims/dart_ui_real.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:yhschool/bean/BookImageBean.dart';
import 'package:yhschool/widgets/BaseRefreshViewPagerState.dart';

import '../GalleryBig.dart';
import '../bean/LocalFile.dart';
import '../popwin/DialogManager.dart';
import '../utils/Constant.dart';
import '../utils/DataUtils.dart';
import '../utils/HttpUtils.dart';
import '../utils/ImageType.dart';
import '../utils/SizeUtil.dart';
import '../widgets/BackButtonWidget.dart';

class BookImageDetailViewPager extends StatefulWidget{

  int bookid;
  int start;
  List<Data> bookImageList=[];

  BookImageDetailViewPager({Key key,@required this.bookid,@required this.start=0}):super(key: key);

  @override
  State<StatefulWidget> createState() {
    return BookImageDetailViewPagerState(key: key,bookImageList:bookImageList,start:start);
  }
}

class BookImageDetailViewPagerState extends BaseRefreshViewPagerState<Data,BookImageDetailViewPager>{


  int pagenum=1,pagesize=20;
  List<Data> bookImageList=[];
  dynamic imgData;
  int fileid; //对应的文件id
  bool isself = false;
  int start;


  BookImageDetailViewPagerState({Key key,@required this.bookImageList,@required this.start=0}):super(key: key,data: bookImageList,start: start);

  @override
  void initState() {
    super.initState();
    print("PanImageDetailViewPager initState");
    // 计算初始化的页码
    pagenum = ((start+1)/pagesize).ceil();
    int mSize = pagenum*pagesize;
    // 初始化从1开始
    queryBookImageList(1,mSize);
  }


  void queryBookImageList(int page,int size){
    var param = {
      "bookid":widget.bookid,
      "page":page,
      "size":size
    };
    httpUtil.post(DataUtils.api_bookimagelist,data:param).then((value){
      hideLoadMore();
      if(value != null){
        print("panimagelist ${value}");
        int currentPage = 0;
        if(page == 1){
          currentPage = start;
          super.data.clear();
        }
        BookImageBean bookImageBean = BookImageBean.fromJson(json.decode(value));
        if(bookImageBean.errno == 0){
          if(bookImageBean.data.length > 0){
            pagenum++;
            //如果是初始当前页就是start
            if(page == 1){
              currentPage = start;
            }else{
              //加载更多页的时候直接跳转到下一页的第一个
              currentPage = super.data.length;
            }
            print("currentPage:${currentPage}");
            super.data.addAll(bookImageBean.data);
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

      });
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
              /*Offstage(
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
              ),*/
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
              )
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
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //图片
                Container(
                    child: InkWell(
                      onTap: (){
                        Navigator.pushAndRemoveUntil(context, new MaterialPageRoute(builder: (BuildContext context){
                          print("width ${data.width} height ${data.height} maxwidth ${data.maxwidth}");
                          return GalleryBig(imgUrl: data.url,imageType: BigImageType.gallery,width:data.maxwidth,height:data.maxheight);
                        }), (route) => true);
                      },
                      child: Stack(
                        children: [
                          CachedNetworkImage(
                            imageUrl: Constant.parseBookSmallString(data.url),
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
                )
              ],
            ),
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
    queryBookImageList(pagenum,pagesize);
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
