import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:yhschool/BaseCoustRefreshState.dart';
import 'package:yhschool/BaseListRefresh.dart';
import 'package:yhschool/BaseRefreshState.dart';
import 'package:yhschool/BaseState.dart';
import 'package:yhschool/bean/column_subscrible_list_bean.dart';
import 'package:yhschool/column/ColumnSubscribleTile.dart';
import 'package:yhschool/utils/Constant.dart';
import 'package:yhschool/utils/DataUtils.dart';
import 'package:yhschool/utils/HttpUtils.dart';
import 'package:yhschool/widgets/YStaggeredGridView.dart';

import '../bean/special_type_bean.dart' as M;
import '../utils/SizeUtil.dart';
import '../widgets/BackButtonWidget.dart';
import '../widgets/HorizontalListTab.dart';
import 'ColumnDetail.dart';
import 'ColumnImageDetail.dart';

class ColumnSubscriblePage extends StatefulWidget{

  Function cb;

  ColumnSubscriblePage({Key key,@required this.cb}):super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ColumnSubscriblePageState();
  }

}

class ColumnSubscriblePageState extends BaseListRefresh<ColumnSubscriblePage>{

  int page=1,size=20;
  List<Data> list=[];
  ScrollController scrollController;
  List<M.Data> types=[];

  String oldtime=""; //作为分页获取的一个起点

  /**
   * 用来存储对应的页码数据
   */
  Map<String,List<Data>> mapCache = new Map();

  int currenttype=0; //当前的分类

  @override
  void initState() {
    super.initState();
    print("ColumnSubscriblePage initState");
    scrollController = initScrollController(isfresh:false);
    _getColumnType();
    _columnSubscribleList(currenttype);
  }

  void _getColumnType(){
    types.clear();
    types.add(M.Data(id: 0,name: "全部",sort: 0)
      ..select = true);
    httpUtil.post(DataUtils.api_querycolumntype,data: {}).then((value) {
      print("ColumnPage mounted:$mounted value:$value");
      String result = checkLoginExpire(value);
      if(result.isNotEmpty){
        M.SpecialTypeBean bean = M.SpecialTypeBean.fromJson(json.decode(value));
        if(bean.errno == 0){
          setState(() {
            types.addAll(bean.data);
          });
        }else{
          //showToast(bean.errmsg);
        }
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    print("ColumnSubscriblePage dispose");
  }

  @override
  void refresh(){

  }

  @override
  void loadmore(){
    if(!isloading){
      _columnSubscribleListLoadMore(currenttype);
    }
  }

  /**
   * 切换类别更新对应订阅列表
   */
  void updateSubscrible(int type){
    currenttype = type;
    setState(() {
      list.clear();
    });
    this._columnSubscribleList(type);
  }

  /**
   * 获取专栏的订阅列表
   */
  void _columnSubscribleList(int type){
    var option = {
      "page":page,
      "size":size
    };
    if(type > 0){
      option["type"] = type;
    }
    String key = "list"+type.toString();
    //读取缓存
    var _cachelist = mapCache[key];
    if(_cachelist != null){
      oldtime = _cachelist[_cachelist.length-1].createtime;
      setState((){
        for(var i=0; i<_cachelist.length; i++){
          if(_cachelist[i].url != null && _cachelist[i].url.isNotEmpty){
            list.add(_cachelist[i]);
          }
        }
      });
    }else{
      //从网络获取
      httpUtil.post(DataUtils.api_columnsubscriblelist,data:option).then((value){
        String result = checkLoginExpire(value);
        if(result.isNotEmpty){
          ColumnSubscribleListBean bean  = ColumnSubscribleListBean.fromJson(json.decode(value));
          if(bean.errno == 0){
            oldtime = bean.data[bean.data.length-1].createtime;
            var _cachelist = mapCache[key];
            if(_cachelist == null){
              _cachelist = [];
            }
            setState(() {
              for(var i=0; i<bean.data.length; i++){
                if(bean.data[i].url != null && bean.data[i].url.isNotEmpty){
                  _cachelist.add(bean.data[i]);
                  list.add(bean.data[i]);
                }
              }
            });
          }else{
            //showToast(bean.errmsg);
          }
        }
      });
    }
  }

  /**
   * 我的订阅列表加载更多
   */
  void _columnSubscribleListLoadMore(int type){
    var option = {
      "createtime":oldtime,
      "size":size
    };
    if(type > 0){
      option["type"] = type;
    }
    httpUtil.post(DataUtils.api_columnsubscriblelist,data:option).then((value){
      hideLoadMore();
      String result = checkLoginExpire(value);
      if(result.isNotEmpty){
        ColumnSubscribleListBean bean  = ColumnSubscribleListBean.fromJson(json.decode(value));
        if(bean.errno == 0){
          String key = "list"+type.toString();
          oldtime = bean.data[bean.data.length-1].createtime;
          var cachelist = mapCache[key];
          if(cachelist == null){
            cachelist = [];
          }
          setState(() {
            for(var i=0; i<bean.data.length; i++){
              if(bean.data[i].url != null && bean.data[i].url.isNotEmpty){
                cachelist.add(bean.data[i]);
                list.add(bean.data[i]);
              }
            }
          });
        }else{
          showToast(bean.errmsg);
        }
      }
    });
  }

  @override
  Widget addChildren(){
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          color: Colors.grey[100],
          child: Column(
            children: [
              Container(
                //height: ScreenUtil().setHeight(SizeUtil.getHeight(Constant.SIZE_TOP_HEIGHT)),
                decoration: BoxDecoration(
                    color: Colors.white
                ),
                padding: EdgeInsets.only(top: ScreenUtil().setHeight(20)),
                child:BackButtonWidget(
                  cb: (){
                    Navigator.pop(context);
                  },title: "收藏的相册",
                ),
              ),
              //分类
              Container(
                decoration: BoxDecoration(
                    color: Colors.white
                ),
                padding: EdgeInsets.only(
                    left:ScreenUtil().setWidth(SizeUtil.getWidth(30)),
                    right: ScreenUtil().setWidth(SizeUtil.getWidth(30))
                ),
                margin: EdgeInsets.only(
                    bottom: ScreenUtil().setHeight(SizeUtil.getHeight(10))
                ),
                child: HorizontalListTab(datas: types, click: (dynamic _data){
                  print("${_data.id}");
                  updateSubscrible(_data.id);
                }),
              ),
              Expanded(
                child: StaggeredGridView.countBuilder(
                  crossAxisCount: Constant.isPad ? 3 : 2,
                  itemCount: list.length,
                  //primary: false,
                  mainAxisSpacing: ScreenUtil().setWidth(Constant.DIS_LIST),
                  crossAxisSpacing: ScreenUtil().setWidth(Constant.DIS_LIST),
                  controller: scrollController,
                  //addAutomaticKeepAlives: false,
                  padding: EdgeInsets.only(left: ScreenUtil().setWidth(Constant.DIS_LIST),right: ScreenUtil().setWidth(Constant.DIS_LIST)),
                  staggeredTileBuilder: (int index) => StaggeredTile.fit(1),
                  //StaggeredTile.count(3,index==0?2:3),
                  itemBuilder: (context,index){
                    return InkWell(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>ColumnDetail(
                          columnname: list[index].columnname,
                          columnid: list[index].columnid,
                          author: list[index].nickname == null ? list[index].username : list[index].nickname,
                          uid: list[index].subscribleuid,
                          count: list[index].count,
                          issubscrible: true,
                          cb: (id,subscrible){
                            setState(() {
                              for(var i=0; i<list.length; i++){
                                if(id == list[i].columnid){
                                  list.removeAt(i);
                                  //刷新全部专栏的状态
                                  if(widget.cb != null){
                                    widget.cb(id);
                                  }
                                  return;
                                }
                              }
                            });
                          },
                        )));
                      },
                      child: ColumnSubscribleTile(data:list[index],click: (int id){
                        print("click:${list[index].columnname}");
                        setState(() {
                          for(var i=0; i<list.length; i++){
                            if(id == list[i].columnid){
                              list.removeAt(i);
                              if(widget.cb != null){
                                widget.cb(id);
                              }
                              return;
                            }
                          }
                        });
                      },),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      )
    );

  }

}