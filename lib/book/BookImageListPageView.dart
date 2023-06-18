
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:yhschool/BaseCacheListRefresh.dart';
import 'package:yhschool/bean/BookImageBean.dart';
import 'package:yhschool/book/BookImageDetailViewPager.dart';
import 'package:yhschool/utils/Constant.dart';
import 'package:yhschool/utils/DataUtils.dart';
import 'package:yhschool/utils/HttpUtils.dart';
import 'package:yhschool/utils/ImageType.dart';

import '../gallery/GalleryTile.dart';
import '../utils/SizeUtil.dart';
import '../widgets/BackButtonWidget.dart';

/**
 * 官方图库
 */
class BookImageListPageView extends StatefulWidget{

  int bookid;
  String bookname;
  String tab1name,tab2name;
  String icon;

  BookImageListPageView({Key key,@required this.bookid,@required this.bookname,@required this.tab1name,@required this.tab2name,
    @required this.icon}):super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new BookImageListPageViewState();
  }
}

class BookImageListPageViewState extends BaseCacheListRefresh<BookImageListPageView> {

  var page = 1;
  var size = 20;
  var currentBookImageId;

  List<Data> bookImageList = [];
  ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = initScrollController(isfresh:false);
    getBookImageList(0);
  }

  /**
   * 获取书籍分类
   */
  void getBookImageList(int pid){
    httpUtil.post(DataUtils.api_bookimagelist,data: {"bookid":widget.bookid,"page":page,"size":size}).then((value){
      print("bookimage :$value");
      if(value != null){
        BookImageBean bookImageBean = BookImageBean.fromJson(json.decode(value));
        if(bookImageBean.errno == 0 && bookImageBean.data.length > 0){
          page ++;
          bookImageList.addAll(bookImageBean.data);
          setState(() {
          });
        }
      }
    });
  }

  /**
   * 书籍更多数据
   */
  void loadMoreBookList(){
    print("loadMoreBook page ${page}");
    httpUtil.post(DataUtils.api_bookimagelist,data:{"bookid":widget.bookid,"page":page,"size":size}).then((value){
      print("loadMoreBookList$value");
      hideLoadMore();
      if(value != null){
        BookImageBean bookImageBean = BookImageBean.fromJson(json.decode(value));
        if(bookImageBean.errno == 0 && bookImageBean.data.length > 0){
          page ++;
          bookImageList.addAll(bookImageBean.data);
        }
        setState(() {
        });
      }
    });
  }




  Widget getBookImageItem(Data _data){
    return InkWell(
      onTap: (){

      },
      child: Container(
        margin: EdgeInsets.symmetric(
            horizontal: ScreenUtil().setWidth(SizeUtil.getWidth(10))
        ),
        padding: EdgeInsets.symmetric(
            horizontal: ScreenUtil().setWidth(SizeUtil.getWidth(20)),
            vertical: ScreenUtil().setHeight(SizeUtil.getHeight(10))
        ),
        child: Text(
          _data.name,
        ),
      ),
    );
  }

  @override
  List<Widget> addChildren() {
    return [
      Container(
        color:Colors.white,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BackButtonWidget(cb: (){
              Navigator.pop(context);
            }, title: widget.bookname)
          ],
        ),
      ),
      Container(
        width: double.infinity,
        color: Colors.white,
        padding: EdgeInsets.only(
            left: SizeUtil.getAppWidth(20),
            right: SizeUtil.getAppWidth(20),
            bottom: SizeUtil.getAppHeight(40),
          top: SizeUtil.getAppHeight(20)
        ),
        margin: EdgeInsets.only(
            bottom: SizeUtil.getAppHeight(20)
        ),
        child: Row(
          children: [
            Container(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(SizeUtil.getAppWidth(10)),
                child: CachedNetworkImage(imageUrl: widget.icon,fit: BoxFit.cover,width: SizeUtil.getAppWidth(200),height: SizeUtil.getAppWidth(180),),
              )
            ),
            SizedBox(width: SizeUtil.getAppWidth(20),),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("${subWord(widget.bookname, 8)}",style: TextStyle(fontSize: SizeUtil.getAppFontSize(60),color: Colors.black87),),
                  SizedBox(height: SizeUtil.getAppHeight(10),),
                  RichText(
                    text: TextSpan(
                        children: [
                          TextSpan(text: "${widget.tab1name} / ${widget.tab2name}",style: TextStyle(fontSize: SizeUtil.getAppFontSize(25),color: Colors.grey)),
                          //TextSpan(text: "，已更新",style: TextStyle(fontSize: SizeUtil.getAppFontSize(25),color: Colors.grey)),
                          //TextSpan(text: "$total",style: TextStyle(fontSize: SizeUtil.getAppFontSize(25),color: Colors.black87)),
                          //TextSpan(text: "个视频",style: TextStyle(fontSize: SizeUtil.getAppFontSize(25),color: Colors.grey))
                        ]
                    ),
                  ),
                  SizedBox(height: SizeUtil.getAppHeight(20),),
                  //Text("本组视频主要应用于央美、清华等学校的校考训练，每位同学至少要熟练掌握1000张范画。",style: TextStyle(fontSize: SizeUtil.getAppFontSize(20),color: Colors.grey,),softWrap: true,)
                ],
              ),
            )
          ],
        ),
      ),
      //SizedBox(height: ScreenUtil().setHeight(SizeUtil.getHeight(20)),),
      //瀑布流显示分组中的第一张图片
      Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              left: ScreenUtil().setWidth(SizeUtil.getWidth(20)),
              right: ScreenUtil().setWidth(SizeUtil.getWidth(20)),
            ),
            child:  StaggeredGridView.countBuilder(
              crossAxisCount: Constant.isPad ? 3 : 2,
              itemCount: bookImageList.length,
              controller: _scrollController,
              primary: false,
              mainAxisSpacing: ScreenUtil().setWidth(SizeUtil.getWidth(6)),
              crossAxisSpacing: ScreenUtil().setWidth(SizeUtil.getWidth(6)),
              addAutomaticKeepAlives: false,
              staggeredTileBuilder: (int index) =>
                  StaggeredTile.fit(1),
              itemBuilder: (context,index){
                return GestureDetector(
                  child:GalleryTile(data: bookImageList[index],hideWord: true,tileType: BigImageType.book,), //GalleryCover(category: coverGridList[index],),
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>
                        BookImageDetailViewPager(bookid: widget.bookid,start: index,)
                    ));
                  },
                );
              },
            ),
          )
      ),
      this.isloading ? loadmoreWidget() : SizedBox()
    ];
  }

  @override
  void loadmore() {
    Future.delayed(Duration(milliseconds: 500),(){
      loadMoreBookList();
    });
  }

  @override
  void refresh() {

  }


}