import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:yhschool/BaseDialogState.dart';
import 'package:yhschool/BaseRefreshState.dart';
import 'package:yhschool/BaseState.dart';
import 'package:yhschool/bean/CollectPush.dart';
import 'package:yhschool/bean/collect_push_return_bean.dart' as P;
import 'package:yhschool/collects/CollectGalleryPageView.dart';
import 'package:yhschool/collects/CollectTile.dart';
import 'package:yhschool/gallery/SingleGalleryPageView.dart';
import 'package:yhschool/teach/TeachTile.dart';
import 'package:yhschool/utils/Constant.dart';
import 'package:yhschool/utils/DataUtils.dart';
import 'package:yhschool/utils/HttpUtils.dart';
import 'package:yhschool/bean/collect_bean.dart';
import 'package:yhschool/utils/SizeUtil.dart';

class CollectGallery extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return CollectGalleryState();
  }

}

class CollectGalleryState extends BaseRefreshState<CollectGallery>{


  int page=1,size=20;
  List<Data> list=[]; //收藏日期列表
  bool ispush = false;
  String username;
  ScrollController _scrollController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController = initScrollController(isfresh: false);
    getUsername().then((value) => username=value);
    getCollectList();
  }

  @override
  void refresh(){

  }

  @override
  void loadmore(){
    if(!isloading){
      getCollectList();
    }
  }

  @override
  Widget addChildren() {
    return StaggeredGridView.countBuilder(
      crossAxisCount: Constant.isPad ? 3 : 2,
      itemCount: list.length,
      primary: false,
      mainAxisSpacing: ScreenUtil().setWidth(SizeUtil.getWidth(Constant.DIS_LIST)),
      crossAxisSpacing: ScreenUtil().setWidth(SizeUtil.getHeight(Constant.DIS_LIST)),
      controller: _scrollController,
      padding: EdgeInsets.only(left: ScreenUtil().setWidth(SizeUtil.getWidth(Constant.DIS_LIST)),right: ScreenUtil().setWidth(SizeUtil.getWidth(Constant.DIS_LIST))),
      staggeredTileBuilder: (int index) => StaggeredTile.fit(1),
      //StaggeredTile.count(3,index==0?2:3),
      itemBuilder: (context,index){
        return GestureDetector(
          child: CollectTile(
            smallurl: Constant.parseCollectSmallString(list[index].from, list[index].url),
            url:list[index].url,
            title: list[index].title,
            name:list[index].name,
            width:list[index].width,
            height:list[index].height,
            ispush: true,
          ),
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>CollectGalleryPageView(list: list, position: index)));
          },
        );
      },
    );
  }

  void getCollectList(){
    var option = {
      'page':page,
      'size':size
    };
    httpUtil.post(DataUtils.api_collectData,data: option).then((value){
      page++;
      hideLoadMore();
      CollectBean listBean = CollectBean.fromJson(json.decode(value));
      if(listBean.errno == 0){
        setState(() {
          list.addAll(listBean.data);
        });
      }else{
        showToast(listBean.errmsg);
      }
    }).catchError((err){
      showToast(err.toString());
    });
  }
}