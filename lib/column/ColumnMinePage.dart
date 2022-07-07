import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:yhschool/BaseRefreshState.dart';
import 'package:yhschool/BaseState.dart';
import 'package:yhschool/bean/column_mine_bean.dart';
import 'package:yhschool/column/ColumnBuildPage.dart';
import 'package:yhschool/column/ColumnMineTile.dart';
import 'package:yhschool/column/ColumnMineTileAdd.dart';
import 'package:yhschool/utils/Constant.dart';
import 'package:yhschool/utils/DataUtils.dart';
import 'package:yhschool/utils/EventBusUtils.dart';
import 'package:yhschool/utils/HttpUtils.dart';
import 'package:yhschool/utils/SizeUtil.dart';

import '../WebStage.dart';

class ColumnMinePage extends StatefulWidget{

  ColumnMinePage({Key key}):super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ColumnMinePageState();
  }

}

class ColumnMinePageState extends BaseRefreshState<ColumnMinePage>{

  List<Data> columnList = [];

  int currentType=0; //当前的分类

  Map _map = new Map();
  int newid=0,oldid=0; //当前最新和最老的列表id

  @override
  void initState() {
    super.initState();
    columnList.add(Data(id: 0));
    _queryColumnList();
    EventBusUtils.instance.getEventBus().on<int>().listen((event) {
      for(Data item in columnList){
        if(item.id == event){
          columnList.remove(item);
          break;
        }
      }
      setState(() {
      });
    });
  }

  @override
  void refresh(){
    var option = {
      "columnid":newid
    };
    if(currentType > 0){
      option["type"] = currentType;
    }
    var key = "minecolumn"+currentType.toString();
    httpUtil.post(DataUtils.api_querycolumnmine,data:option).then((value) {
      String result = checkLoginExpire(value);
      if(result.isNotEmpty){
        ColumnMineBean bean = ColumnMineBean.fromJson(json.decode(value));
        if(bean.errno == 0){
          if(bean.data.length > 0){
            newid = bean.data[0].id;
            oldid = bean.data[bean.data.length-1].id;
            if(_map.containsKey(key)){
              _map[key].addAll(bean.data);
            }else{
              _map[key] = bean.data;
            }
            setState(() {
              //先对数据进行排序
              columnList.addAll(bean.data);
            });
          }
        }else{
          showToast(bean.errmsg);
        }
      }
    });
  }

  @override
  void loadmore(){

  }

  /**
   * 更新我的订阅页面
   */
  void updateMineColumn(int type){
    currentType = type;
    setState(() {
      columnList.clear();
    });
    if(type == 0){
      //添加一条数据占位用来表示对应的数据条目为添加
      setState(() {
        columnList.add(Data(id: 0));
      });
    }
    _queryColumnList();
  }

  /**
   *查询我的专栏数据
   */
  void _queryColumnList(){

    var option = {};
    if(currentType > 0){
      option["type"] = currentType;
    }
    var key = "minecolumn"+currentType.toString();
    httpUtil.post(DataUtils.api_querycolumnmine,data:option).then((value) {
      String result = checkLoginExpire(value);
      if(result.isNotEmpty){
        ColumnMineBean bean = ColumnMineBean.fromJson(json.decode(value));
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
                //先对数据进行排序
                columnList.addAll(bean.data);
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
    print("ColumnMinePage length:${columnList.length}");
    return Column(
      children: [
        Container(
          height: ScreenUtil().setHeight(SizeUtil.getHeight(300)),
          width: double.infinity,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(ScreenUtil().setWidth(10)),
              color: Colors.white
          ),
          margin: EdgeInsets.only(
            left: ScreenUtil().setWidth(SizeUtil.getWidth(20)),
            right: ScreenUtil().setWidth(SizeUtil.getWidth(20)),
            top: ScreenUtil().setHeight(SizeUtil.getHeight(10)),
            bottom: ScreenUtil().setHeight(SizeUtil.getHeight(20))
          ),
          child: InkWell(
            onTap: (){
              //
              Navigator.push(context, MaterialPageRoute(builder: (context) =>
                  WebStage(url: 'https://support.qq.com/products/326279/faqs/121943', title: "")
              ));
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Image.network("http://res.yimios.com:9050/videos/advert/ic_advert_column.jpg",fit:BoxFit.cover),
            ),
          ),
        ),
        Expanded(
          child: Container(
            margin: EdgeInsets.only(top: ScreenUtil().setHeight(10)),
            child: StaggeredGridView.countBuilder(
              crossAxisCount: Constant.isPad ? 3 : 2,
              itemCount: columnList.length,
              //primary: false,
              mainAxisSpacing: ScreenUtil().setWidth(SizeUtil.getWidth(Constant.DIS_LIST)),
              crossAxisSpacing: ScreenUtil().setHeight(SizeUtil.getHeight(Constant.DIS_LIST)),
              //controller: _scrollController,
              //addAutomaticKeepAlives: false,
              padding: EdgeInsets.only(left: ScreenUtil().setWidth(SizeUtil.getWidth(Constant.DIS_LIST)),right: ScreenUtil().setWidth(SizeUtil.getWidth(Constant.DIS_LIST))),
              staggeredTileBuilder: (int index) =>
                  StaggeredTile.fit(1),
              //StaggeredTile.count(3,index==0?2:3),
              itemBuilder: (context,index){
                return columnList[index].id > 0 ? InkWell(
                  onTap: (){
                    print("点击收藏的网盘");
                  },
                  child: ColumnMineTile(data: columnList[index],cb: (value){
                    //处理图片上传完成以后列表的刷新
                    if(value){
                      columnList.clear();
                      columnList.add(Data(id: 0));
                      _queryColumnList();
                    }
                  },),
                ) : ColumnMineTileAdd(cb: (){
                  //新建专栏
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context)=>ColumnBuildPage()
                  )).then((value){
                    //创建专栏成功，然后重新请求专栏数据
                    if(value != null){
                      columnList.clear();
                      columnList.add(Data(id: 0));
                      _queryColumnList();
                    }
                  });
                });
              },
            ),
          ),
        )
      ],
    );
  }

  @override
  void dispose() {
    print("columnmine dispose");
    super.dispose();
  }

}