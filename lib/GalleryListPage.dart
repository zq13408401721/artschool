import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:yhschool/BaseState.dart';
import 'package:yhschool/GalleryBig.dart';
import 'package:yhschool/TileCard.dart';
import 'package:yhschool/bean/entity_gallery_list.dart';
import 'package:yhschool/utils/Constant.dart';
import 'package:yhschool/utils/DataUtils.dart';
import 'package:yhschool/utils/HttpUtils.dart';
import 'package:yhschool/utils/ImageType.dart';
import 'package:yhschool/widgets/XCState.dart';

/**
 * 图库列表 瀑布流展示
 */
class GalleryListPage extends StatefulWidget{
  int categoryid;
  String section;
  String categroyname;
  ImageType imageType;

  GalleryListPage({Key key,@required this.categoryid,@required this.section,@required this.categroyname,@required this.imageType}):super(key: key);
  
  @override
  State<StatefulWidget> createState() {
    return new GalleryListState()
        ..categoryid = categoryid
        ..section = section
        ..categoryname = categroyname
        ..imageType = imageType;
  }

}

class GalleryListState extends XCState<GalleryListData,GalleryListPage>{
  
  int categoryid = 0;
  int page = 1;
  int size = 20;
  String section,categoryname;
  ScrollController _scrollController;
  ImageType imageType;

  List<GalleryListData> list=[];
  bool _hasData = true;//是否还有数据
  bool flag = true;  //是否可以加载
  bool isloading = false; //是否正在加载中

  @override
  void initState() {
    super.initState();
    _scrollController = new ScrollController();
    getGalleryMore();

    _scrollController.addListener(() {
      //print("scroll: "+_scrollController.position.pixels.toString() + " max "+_scrollController.position.maxScrollExtent.toString());
      if(_scrollController.position.pixels > _scrollController.position.maxScrollExtent-100){
        //print("flag:$flag hasData: $_hasData");
        if(this.flag && this._hasData && !this.isloading){
          //加载列表数据
          showLoading(true);
          //延迟2秒才开始加载
          Timer(Duration(seconds: 2), (){
            getGalleryMore();
          });
        }
      }
    });
  }

  @override
  void dispose(){
    this._scrollController.dispose();
    super.dispose();
  }

  @override
  bool useSubstance(){
    return true;
  }

  @override
  List<GalleryListData> substance() {
    return list;
  }

  void aFunc(){
    reload();
  }

  showLoading(bool visible){
    this.isloading = visible;
    aFunc();
  }

  getGalleryMoreReturn(GalleryList data){
    showLoading(false);
    if(data.errno != 0){
      return showToast(data.errmsg);
    }
    if(data.data.length > 0){
      if(data.data.length < this.size){
        this._hasData = false;
      }else{
        this.page ++;
        this._hasData = true;
      }
      this.list.addAll(data.data);
      aFunc();
    }
    this.flag = true;
  }
  
  getGalleryMore(){
    setState(() {
      this.flag = false; //设置加载状态
    });
    var option = {
      "categoryid":this.categoryid,
      "page":this.page,
      "size":this.size
    };
    httpUtil.post(DataUtils.api_gallery_list,data: option).then((value){
      String result = checkLoginExpire(value);
      if(result.isNotEmpty){
        getGalleryMoreReturn(new GalleryList.fromJson(json.decode(value)));
      }
    }).catchError((err){
      print(err);
    });
  }

  Widget _loadingWidget() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              width: ScreenUtil().setWidth(40),
              height: ScreenUtil().setWidth(40),
              child: CircularProgressIndicator(color: Colors.red,),
            ),
            Text('加载中...', style: TextStyle(fontSize: 16.0),)
          ],
        ),
      ),
    );
  }

  // 显示加载中的圈圈
  Widget _showMore() {
    if(isloading) {
      return this._hasData ? this._loadingWidget() : Text('---暂无其他数据了---');
    } else {
      return SizedBox();
    }
  }

  @override
  Widget shouldBuild(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(top: ScreenUtil().setHeight(10),bottom: ScreenUtil().setHeight(10),left: ScreenUtil().setWidth(20)),
                  child: GestureDetector(
                    child: Text(
                      "返回",
                      style: TextStyle(fontSize: ScreenUtil().setSp(42)),
                    ),
                    onTap: (){
                      Navigator.pop(context);
                    },
                  ),
                ),
                Container(
                  alignment: Alignment(0,0),
                  padding: EdgeInsets.only(top: ScreenUtil().setHeight(10),bottom: ScreenUtil().setHeight(10)),
                  child: Text(this.section+" | "+this.categoryname,style: TextStyle(fontSize: Constant.FONT_TITLE_SIZE,color: Constant.COLOR_TITLE),),
                )
              ],
            ),
            SizedBox(height: ScreenUtil().setHeight(30),),
            Expanded(
              child: StaggeredGridView.countBuilder(
                crossAxisCount: Constant.isPad ? 3 : 4,
                itemCount: list.length,
                primary: false,
                mainAxisSpacing: ScreenUtil().setWidth(30),
                crossAxisSpacing: ScreenUtil().setWidth(30),
                controller: _scrollController,
                addAutomaticKeepAlives: false,
                padding: EdgeInsets.only(left: ScreenUtil().setWidth(30),right: ScreenUtil().setWidth(30)),
                staggeredTileBuilder: (int index) =>
                    Constant.isPad ? StaggeredTile.fit(1) : StaggeredTile.fit(2),
                //StaggeredTile.count(3,index==0?2:3),

                itemBuilder: (context,index){
                  return GestureDetector(
                    child: TileCard(key:GlobalObjectKey(list[index].id),url: list[index].url,title: list[index].name,imgtype: this.imageType,),
                    onTap: (){
                     /* Navigator.push(context, MaterialPageRoute(builder: (context) =>
                          GalleryBig(imgUrl: list[index].url,)
                      ));*/

                      Navigator.pushAndRemoveUntil(context, new MaterialPageRoute(builder: (BuildContext context){
                        return GalleryBig(imgUrl: list[index].url,width: list[index].width,height: list[index].height,);
                      }), (route) => true);

                      //Navigator.of(context).pushNamedAndRemoveUntil("/GalleryBig",(Route route)=>false,arguments: {"imgUrl":list[index].url});
                    },
                  );
                },
              ),
            ),
            _showMore()
          ],
        ),
      )
    );
  }
}