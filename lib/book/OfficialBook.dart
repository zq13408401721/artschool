
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:yhschool/BaseCacheListRefresh.dart';
import 'package:yhschool/bean/BookListBean.dart' as B;
import 'package:yhschool/bean/BookTabBean.dart';
import 'package:yhschool/book/BookImageListPageView.dart';
import 'package:yhschool/utils/Constant.dart';
import 'package:yhschool/utils/DataUtils.dart';
import 'package:yhschool/utils/HttpUtils.dart';

import '../gallery/GalleryTile.dart';
import '../utils/SizeUtil.dart';

/**
 * 官方图库
 */
class OfficialBook extends StatefulWidget{

  OfficialBook({Key key}):super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new OfficialBookState();
  }
}

class OfficialBookState extends BaseCacheListRefresh<OfficialBook> {

  var currentPid = 0;
  var page = 1;
  var size = 10;
  var selectBookTabId = 0;

  List<Data> tabOneList = [];
  List<Data> tabTwoList = [];
  List<B.Data> bookList = [];
  ScrollController _scrollController;

  TextStyle categorySelect;
  TextStyle categoryNormal;

  TextStyle categorySelect2;
  TextStyle categoryNormal2;

  @override
  void initState() {
    super.initState();
    _scrollController = initScrollController(isfresh:false);
    categorySelect = TextStyle(fontSize: ScreenUtil().setSp(30),color: Colors.white);
    categoryNormal = TextStyle(fontSize: ScreenUtil().setSp(30),color: Colors.black87);
    categorySelect2 = TextStyle(fontSize: ScreenUtil().setSp(25),color: Colors.red,fontWeight: FontWeight.bold);
    categoryNormal2 = TextStyle(fontSize: ScreenUtil().setSp(25),color: Colors.black87);
    getBookTab(0);
  }

  /**
   * 获取书籍分类
   */
  void getBookTab(int pid){
    httpUtil.post(DataUtils.api_booktab,data: {"pid":pid,"page":page,"size":size}).then((value){
      print("booktab:$value");
      if(value != null){
        BookTabBean bookTabBean = BookTabBean.fromJson(json.decode(value));
        tabOneList.addAll(bookTabBean.data);
        currentPid = tabOneList[0].id;
        tabTwoList = [];
        getBookTabTwo(tabOneList[0].id);
        setState(() {
        });
      }
    });
  }

  /**
   * 获取第二级分类的数据
   */
  void getBookTabTwo(int pid){
    httpUtil.post(DataUtils.api_booktab,data: {"pid":pid,"page":page,"size":size}).then((value){
      print("booktab:$value");
      if(value != null){
        BookTabBean bookTabBean = BookTabBean.fromJson(json.decode(value));
        setState(() {
          tabTwoList.addAll(bookTabBean.data);
          bookList = [];
          selectBookTabId = tabTwoList[0].id;
          getBookList(selectBookTabId);
        });
      }
    });
  }

  /**
   * 获取书籍列表
   */
  void getBookList(int tabid){
    httpUtil.post(DataUtils.api_booklist,data:{"tabid":tabid,"page":page,"size":size}).then((value){
      print("booklist$value");
      if(value != null){
        B.BookListBean bookListBean = B.BookListBean.fromJson(json.decode(value));
        if(bookListBean.errno == 0 && bookListBean.data.length > 0){
          page ++;
          bookList.addAll(bookListBean.data);
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
    httpUtil.post(DataUtils.api_booklist,data:{"tabid":selectBookTabId,"page":page,"size":size}).then((value){
      print("loadMoreBookList$value");
      hideLoadMore();
      if(value != null){
        B.BookListBean bookListBean = B.BookListBean.fromJson(json.decode(value));
        if(bookListBean.errno == 0 && bookListBean.data.length > 0){
          page ++;
          bookList.addAll(bookListBean.data);
        }
        setState(() {
        });
      }
    });
  }


  Widget createTabItems(Data _data){
    return InkWell(
      onTap: (){
        if(currentPid != _data.id){
          page = 1;
          currentPid = _data.id;
          tabTwoList = [];
          getBookTabTwo(_data.id);
          setState(() {
          });
        }

      },
      child: Container(
        decoration: BoxDecoration(
            color: currentPid == _data.id ? Colors.red : Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(ScreenUtil().setWidth(SizeUtil.getWidth(20)),),
              topRight: Radius.circular(ScreenUtil().setWidth(SizeUtil.getWidth(10)),),
              bottomLeft: Radius.circular(ScreenUtil().setWidth(SizeUtil.getWidth(10)),),
              bottomRight: Radius.circular(ScreenUtil().setWidth(SizeUtil.getWidth(20)),),
            ),
            border: Border.all(width: 1.0,color: currentPid == _data.id ? Colors.red : Colors.grey[200],)
        ),
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(
            horizontal: ScreenUtil().setWidth(40),
            vertical: ScreenUtil().setHeight(10)
        ),
        margin: EdgeInsets.symmetric(
            horizontal: ScreenUtil().setWidth(SizeUtil.getWidth(10))
        ),
        child: Text(_data.name,style: TextStyle(color: currentPid == _data.id ? Colors.white : Colors.black87,fontSize: ScreenUtil().setSp(SizeUtil.getFontSize(30))),),
      ),
    );
  }

  Widget getBookItem(Data _data){
    return InkWell(
      onTap: (){
        if(selectBookTabId != _data.id){
          setState(() {
            page = 1;
            this.selectBookTabId = _data.id;
            this.hasData = true;
            bookList = [];
            //获取列表的封面
            getBookList(_data.id);
          });
        }
      },
      child: Container(
        /*decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(ScreenUtil().setWidth(SizeUtil.getWidth(10))),
            color: curCategoryId == _data.id ? Colors.red : Colors.white
        ),*/
        margin: EdgeInsets.symmetric(
            horizontal: ScreenUtil().setWidth(SizeUtil.getWidth(10))
        ),
        padding: EdgeInsets.symmetric(
            horizontal: ScreenUtil().setWidth(SizeUtil.getWidth(20)),
            vertical: ScreenUtil().setHeight(SizeUtil.getHeight(10))
        ),
        child: Text(
          _data.name,style: selectBookTabId == _data.id ? categorySelect2 : categoryNormal2,
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
            Expanded(
              child: Container(
                height: ScreenUtil().setHeight(SizeUtil.getHeight(105)),
                decoration: BoxDecoration(
                    color: Colors.white
                ),
                padding: EdgeInsets.only(
                  left: ScreenUtil().setWidth(SizeUtil.getWidth(20)),
                  right: ScreenUtil().setWidth(SizeUtil.getWidth(20)),
                  bottom: ScreenUtil().setHeight(SizeUtil.getHeight(20)),
                  //top: ScreenUtil().setHeight(SizeUtil.getHeight(25))
                ),
                child: ListView.builder(itemCount:tabOneList.length,scrollDirection:Axis.horizontal,itemBuilder: (_context,_index){
                  return createTabItems(tabOneList[_index]);
                }),
              ),
            )
          ],
        ),
      ),
      //分类列表
      Container(
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.white
        ),
        child: Container(
          height: ScreenUtil().setHeight(SizeUtil.getHeight(70)),
          margin: EdgeInsets.only(
            //top: ScreenUtil().setHeight(SizeUtil.getHeight(20)),
              bottom: ScreenUtil().setHeight(SizeUtil.getHeight(20)),
              left: ScreenUtil().setWidth(SizeUtil.getWidth(20)),
              right: ScreenUtil().setWidth(SizeUtil.getWidth(20))
          ),
          child: ListView.builder(
            itemCount: this.tabTwoList.length,//this.officialCoverList.length,
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemBuilder: (context,index){
              return getBookItem(this.tabTwoList[index]);
            },
          ),
        ),
      ),
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
              itemCount: bookList.length,
              controller: _scrollController,
              primary: false,
              mainAxisSpacing: ScreenUtil().setWidth(SizeUtil.getWidth(6)),
              crossAxisSpacing: ScreenUtil().setWidth(SizeUtil.getWidth(6)),
              addAutomaticKeepAlives: false,
              staggeredTileBuilder: (int index) =>
                  StaggeredTile.fit(1),
              itemBuilder: (context,index){
                return GestureDetector(
                  child:GalleryTile(data: bookList[index]), //GalleryCover(category: coverGridList[index],),
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>
                        BookImageListPageView(bookid: bookList[index].id,bookname: bookList[index].name,)
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