import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:yhschool/BaseRefreshState.dart';
import 'package:yhschool/BaseState.dart';
import 'package:yhschool/bean/column_list_bean.dart';
import 'package:yhschool/column/ColumnDetail.dart';
import 'package:yhschool/column/ColumnListTile.dart';
import 'package:yhschool/utils/Constant.dart';
import 'package:yhschool/utils/DataUtils.dart';
import 'package:yhschool/utils/HttpUtils.dart';
import 'package:yhschool/utils/SizeUtil.dart';

import 'ColumnSubscribleTile.dart';

class ColumnSchoolPage extends StatefulWidget{

  ColumnSchoolPage({Key key}):super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ColumnSchoolPageState();
  }
}

class ColumnSchoolPageState extends BaseRefreshState<ColumnSchoolPage>{

  ScrollController _scrollController;
  List<Data> list = [];
  int page=1,size=20;
  int type = 0;
  int newid=0,oldid=0; //当前最新和最老的列表id
  Map _map = new Map(); //缓存所有的专栏数据
  bool showonlyteacher=false; //是否只显示老师

  @override
  void initState() {
    super.initState();
    print("ColumnListPage initState");
    isShowAdvert = true;
    super.advertData = {
      "url":"http://res.yimios.com:9050/videos/advert/ic_advert_column.jpg",
      "weburl":"https://support.qq.com/products/326279/faqs/121943",
      "height":Constant.ADVERT_COLUMN_HEIGHT
    };
    _scrollController = initScrollController();
    _getColumnList(0);
  }

  @override
  void dispose() {
    super.dispose();
    print("ColumnListPage dispose");
  }

  /**
   * 刷新学校专栏列表
   */
  @override
  void refresh(){
    var option = {
      "columnid":newid,
      "size":size,
      "type":type,
      "visible":showonlyteacher ? 1 : 0
    };
    var key = "columnlist"+type.toString();
    httpUtil.post(DataUtils.api_refreshspecialcolumnlist,data: option,context: context).then((value){
      ColumnListBean bean = ColumnListBean.fromJson(json.decode(value));
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
          setState(() {
            list.insertAll(0,_list);
          });
        }else{
         showToast("暂时没有新数据");
        }
      }else{
        hideRefreshing();
        showToast(bean.errmsg);
      }
    });
  }

  /**
   * 加载更多专栏列表
   */
  @override
  void loadmore(){
    var option = {
      "columnid":oldid,
      "size":size,
      "type":type,
      "visible":showonlyteacher ? 1 : 0
    };
    var key = "columnlist"+type.toString();
    httpUtil.post(DataUtils.api_loadmorespecialcolumnlist,data: option,context: context).then((value){
      ColumnListBean bean = ColumnListBean.fromJson(json.decode(value));
      if(bean.errno == 0){
        hideLoadMore();
        if(bean.data.length > 0){
          oldid = bean.data[bean.data.length-1].id;
          if(_map.containsKey(key)){
            _map[key].addAll(bean.data);
          }else{
            _map[key] = bean.data;
          }
          setState(() {
            list.addAll(bean.data);
          });
        }else{
          hasData = false;
          showToast("没有更多数据");
        }
      }else{
        hideLoadMore();
        showToast(bean.errmsg);
      }
    });
  }

  /**
   * 更新专栏列表订阅状态
   */
  void updateColumnSubscrible(int id){
    setState(() {
      for(var i=0; i<list.length; i++){
        if(list[i].id == id){
          list[i].subscrible = 0;
        }
      }
    });
  }

  /**
   * 切换专题列表分类
   */
  void updateColumnSchool(int type){
    this.type = type;
    setState(() {
      list.clear();
    });
    var key = "columnlist"+type.toString();
    if(_map.containsKey(key) && _map[key].length > 0){
      setState(() {
        list.addAll(_map[key]);
      });
    }else{
      _getColumnList(type);
    }
  }

  /**
   * 更新学校专栏显示 true 只看老师
   */
  void updateSchoolColumnShow(bool _bool){
    showonlyteacher = _bool;
    _getColumnList(type);
  }

  void _getColumnList(int type){
    var option = {
      "page":page,
      "size":size,
      "visible":showonlyteacher ? 1 : 0
    };
    if(type > 0){
      option["type"] = type;
    }
    var key = "columnschool"+type.toString();
    httpUtil.post(DataUtils.api_columnlist,data: option,context: context).then((value){
      String result = checkLoginExpire(value);
      if(result.isNotEmpty){
        ColumnListBean bean = ColumnListBean.fromJson(json.decode(value));
        if(bean.errno == 0){
          if(bean.data.length > 0){
            newid = bean.data[0].id;
            oldid = bean.data[bean.data.length-1].id;
            if(_map.containsKey(key)){
              _map[key].addAll(bean.data);
            }else{
              _map[key] = bean.data;
            }
            if(mounted){
              setState(() {
                list.addAll(bean.data);
              });
            }
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
      itemCount: list.length,
      physics: BouncingScrollPhysics(),
      mainAxisSpacing: ScreenUtil().setWidth(SizeUtil.getWidth(Constant.DIS_LIST)),
      crossAxisSpacing: ScreenUtil().setHeight(SizeUtil.getHeight(Constant.DIS_LIST)),
      controller: _scrollController,
      //addAutomaticKeepAlives: false,
      padding: EdgeInsets.only(left: ScreenUtil().setWidth(SizeUtil.getWidth(Constant.DIS_LIST)),right: ScreenUtil().setWidth(SizeUtil.getWidth(Constant.DIS_LIST))),
      staggeredTileBuilder: (int index) => StaggeredTile.fit(1),
      //StaggeredTile.count(3,index==0?2:3),
      itemBuilder: (context,index){
        return GestureDetector(
          child: ColumnListTile(data: list[index],),
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>ColumnDetail(
              columnname: list[index].name,
              columnid: list[index].id,
              author: list[index].nickname == null ? list[index].username : list[index].nickname,
              uid: list[index].uid,
              count: list[index].count,
              avater: list[index].avater,
              issubscrible: list[index].subscrible > 0 ? true : false,
              cb: (id,subscrible){
                setState(() {
                  for(var i=0; i<list.length; i++){
                    if(id == list[i].id){
                      list.removeAt(i);
                      return;
                    }
                  }
                });
              },
            )));
          },
        );
      },
    );
  }

}