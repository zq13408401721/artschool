
import 'dart:convert';

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

import '../gallery/GalleryTile.dart';
import '../utils/SizeUtil.dart';
import '../widgets/BackButtonWidget.dart';

/**
 * 官方图库
 */
class BookImageListPageView extends StatefulWidget{

  int bookid;
  String bookname;

  BookImageListPageView({Key key,@required this.bookid,@required this.bookname}):super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new BookImageListPageViewState();
  }
}

class BookImageListPageViewState extends BaseCacheListRefresh<BookImageListPageView> {

  var page = 1;
  var size = 10;
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
      //分类列表
      SizedBox(height: ScreenUtil().setHeight(SizeUtil.getHeight(20)),),
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
                  child:GalleryTile(data: bookImageList[index],hideWord: true,), //GalleryCover(category: coverGridList[index],),
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