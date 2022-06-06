import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:yhschool/BaseListRefresh.dart';
import 'package:yhschool/BaseRefreshState.dart';
import 'package:yhschool/BaseState.dart';
import 'package:yhschool/bean/column_gallery_bean.dart';
import 'package:yhschool/bean/column_gallery_list_bean.dart' as M;
import 'package:yhschool/column/ColumnGalleryPageView.dart';
import 'package:yhschool/column/ColumnGalleryTile.dart';
import 'package:yhschool/column/ColumnImageDetail.dart';
import 'package:yhschool/utils/Constant.dart';
import 'package:yhschool/utils/DataUtils.dart';
import 'package:yhschool/utils/HttpUtils.dart';
import 'package:yhschool/utils/SizeUtil.dart';

/**
 * 显示所有图片
 */
class ColumnGalleryPage extends StatefulWidget{

  ColumnGalleryPage({Key key}):super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ColumnGalleryPageState();
  }

}

class ColumnGalleryPageState extends BaseListRefresh<ColumnGalleryPage>{

  ScrollController _scrollController;
  int page=1,size=20;
  List<Data> galleryList = [];
  Map _map = new Map(); //缓存所有的分类数据
  int type = 0;
  int newid=0,oldid=0; //当前最新和最老的列表id

  @override
  void initState() {
    super.initState();
    print("ColumnGalleryPage initState");
    //刷新 加载更多监听初始化
    _scrollController = initScrollController();
    // 0表示全部
    _columnGalleryList(type);
  }

  @override
  void dispose() {
    super.dispose();
    print("ColumnGalleryPage dispose");
  }

  @override
  void refresh(){
    var option = {
      "galleryid":newid,
      "size":size,
      "type":type
    };
    var key = "columngallery"+type.toString();
    httpUtil.post(DataUtils.api_refreshcolumngallery,data: option).then((value){
      String result = checkLoginExpire(value);
      if(result.isNotEmpty){
        ColumnGalleryBean bean = ColumnGalleryBean.fromJson(json.decode(value));
        if(bean.errno == 0){
          hideRefreshing();
          if(bean.data.length > 0){
            var _list = bean.data.reversed.toList();
            newid = _list[0].id;
            if(_map.containsKey(key)){
              _map[key].insertAll(0,_list);
            }else{
              _map[key] = _list;
            }
            print("http api_refreshcolumngallery");
            setState(() {
              galleryList.insertAll(0,_list);
            });
          }else{
            showToast("暂时没有新数据");
          }
        }else{
          hideRefreshing();
          showToast(bean.errmsg);
        }
      }
    });
  }

  @override
  void loadmore(){
    if(!this.isloading){
      var option = {
        "galleryid":oldid,
        "size":size,
        "type":type
      };
      print("loadmore:${option}");
      var key = "columngallery"+type.toString();
      httpUtil.post(DataUtils.api_loadmorecolumngallery,data: option).then((value){
        hideLoadMore();
        String result = checkLoginExpire(value);
        if(result.isNotEmpty){
          ColumnGalleryBean bean = ColumnGalleryBean.fromJson(json.decode(value));
          if(bean.errno == 0){
            if(bean.data.length > 0){
              oldid = bean.data[bean.data.length-1].id;
              if(_map.containsKey(key)){
                _map[key].addAll(bean.data);
              }else{
                _map[key] = bean.data;
              }
              print("http api_loadmorecolumngallery");
              setState(() {
                galleryList.addAll(bean.data);
              });
            }else{
              hasData = false;
              showToast("没有更多数据");
            }
          }else{
            showToast(bean.errmsg);
          }
        }
      });
    }
  }


  /**
   * 切换分类
   */
  void updateGalleryList(int type){
    this.type = type;
    var key = "columngallery"+type.toString();
    setState(() {
      galleryList.clear();
    });
    if(_map.containsKey(key) && _map[key].length > 0){
      print("http updateGalleryList");
      setState(() {
        galleryList.addAll(_map[key]);
      });
    }else{
      _columnGalleryList(type);
    }
  }

  /**
   * 专栏图库
   */
  void _columnGalleryList(int type){
    var option = {
      "page":page,
      "size":size
    };
    if(type > 0){
      option["type"] = type;
    }
    var key = "columngallery"+type.toString();
    httpUtil.post(DataUtils.api_columngallery,data: option).then((value){
      String result = checkLoginExpire(value);
      if(result.isNotEmpty) {
        ColumnGalleryBean bean = ColumnGalleryBean.fromJson(json.decode(result));
        if(bean.errno == 0){
          if(bean.data.length > 0){
            newid = bean.data[0].id;
            oldid = bean.data[bean.data.length-1].id;
            if(_map.containsKey(key)){
              _map[key].addAll(bean.data);
            }else{
              _map[key] = bean.data;
            }
            print("http api_columngallery");
            setState(() {
              galleryList.addAll(bean.data);
            });
          }
        }else{
          //showToast(bean.errmsg);
        }
      }
    });
  }

  @override
  Widget addChildren(){
    return StaggeredGridView.countBuilder(
      crossAxisCount: Constant.isPad ? 3 : 2,
      itemCount: galleryList.length,
      mainAxisSpacing: ScreenUtil().setWidth(SizeUtil.getWidth(Constant.DIS_LIST)),
      crossAxisSpacing: ScreenUtil().setWidth(SizeUtil.getHeight(Constant.DIS_LIST)),
      controller: _scrollController,
      physics: BouncingScrollPhysics(),
      //addAutomaticKeepAlives: false,
      padding: EdgeInsets.only(left: ScreenUtil().setWidth(SizeUtil.getWidth(Constant.DIS_LIST)),right: ScreenUtil().setWidth(SizeUtil.getWidth(Constant.DIS_LIST))),
      staggeredTileBuilder: (int index) => StaggeredTile.fit(1),
      //StaggeredTile.count(3,index==0?2:3),
      itemBuilder: (context,index){
        return GestureDetector(
          child: ColumnGalleryTile(
            author: galleryList[index].nickname == null ? galleryList[index].username : galleryList[index].nickname,
            url: galleryList[index].url,
            columnname: galleryList[index].columnname,
            avater: galleryList[index].avater,
            width: galleryList[index].width,
            height: galleryList[index].height,
          ),
          onTap: (){
            List<M.Data> _list = [];
            galleryList.forEach((element) {
              _list.add(M.Data.fromJson(element.toJson()));
            });
            Navigator.push(context, MaterialPageRoute(builder: (context)=>
                ColumnGalleryPageView(list: _list, position: index)));
          },
        );
      },
    );
  }

}