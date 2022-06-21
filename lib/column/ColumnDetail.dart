import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:yhschool/BaseCoustPageRefreshState.dart';
import 'package:yhschool/BaseDialogState.dart';
import 'package:yhschool/BaseRefreshState.dart';
import 'package:yhschool/BaseState.dart';
import 'package:yhschool/bean/column_gallery_list_bean.dart';
import 'package:yhschool/bean/column_subscrible_common_bean.dart' as M;
import 'package:yhschool/column/ColumnGalleryPageView.dart';
import 'package:yhschool/column/ColumnImageDetail.dart';
import 'package:yhschool/column/ColumnImageTile.dart';
import 'package:yhschool/utils/Constant.dart';
import 'package:yhschool/utils/DataUtils.dart';
import 'package:yhschool/utils/HttpUtils.dart';
import 'package:yhschool/utils/SizeUtil.dart';
import 'package:yhschool/widgets/BackButtonWidget.dart';
import 'package:yhschool/widgets/BaseTitleBar.dart';
import 'package:yhschool/widgets/RoundedButton.dart';
import 'package:yhschool/bean/column_gallery_delete_bean.dart';

import 'ColumnListTile.dart';

class ColumnDetail extends StatefulWidget{

  String columnname;
  int columnid;
  String author;
  String avater;
  String uid;
  int count;
  bool issubscrible; //是否订阅
  int visible; //是否仅本校看
  bool iscommon; //是否可以删除
  Function(int id,int subscrible) cb; //订阅或取消订阅以后同步外面的列表
  
  ColumnDetail({@required this.columnname,@required this.columnid,@required this.author,@required this.avater,@required this.uid,@required this.count,
    @required this.issubscrible=false,@required this.cb,@required this.visible,@required this.iscommon=false});

  @override
  State<StatefulWidget> createState() {
    return ColumnDetailState()
    ..columnname = columnname
    ..columnid = columnid
    ..author = author
    ..avater = avater
    ..uid = uid
    ..count = count
    ..issubscrible = issubscrible;
  }
}

class ColumnDetailState extends BaseCoustPageRefreshState<ColumnDetail>{

  String columnname;
  int columnid;
  String author;
  String avater;
  String uid;
  int count;
  bool issubscrible;
  int oldid;

  List<Data> list = [];
  ScrollController _scrollController;
  
  bool isself = false;
  int page=1,size=20;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController = initScrollController(isfresh: false);
    _getColumnGalleryList();
    getUserInfo().then((value){
      setState(() {
        if(uid == value["uid"]){
          this.isself = true;
        }
      });
    });
  }

  /**
   * 获取专栏图片列表
   */
  void _getColumnGalleryList(){
    var option={
      "columnid":columnid,
      "page":page,
      "size":size
    };
    httpUtil.post(DataUtils.api_gallerylistbycolumn,data:option).then((value){
      ColumnGalleryListBean bean = ColumnGalleryListBean.fromJson(json.decode(value));
      if(bean.errno == 0){
        if(bean.data.length > 0){
          oldid = bean.data[bean.data.length-1].id;
          setState(() {
            list.addAll(bean.data);
          });
        }
      }else{
        showToast(bean.errmsg);
      }
    });
  }

  /**
   * 获取更多专栏图片
   */
  void _getColumnGalleryListMore(){
    var option={
      "columnid":columnid,
      "id":oldid,
      "size":size
    };
    httpUtil.post(DataUtils.api_gallerylistbycolumn,data:option).then((value){
      hideLoadMore();
      ColumnGalleryListBean bean = ColumnGalleryListBean.fromJson(json.decode(value));
      if(bean.errno == 0){
        if(bean.data.length > 0){
          oldid = bean.data[bean.data.length-1].id;
          setState(() {
            list.addAll(bean.data);
          });
        }
      }else{
        showToast(bean.errmsg);
      }
    });
  }


  /**
   * 添加订阅
   */
  void _addSubscrible(){
    var option = {
      "columnid":columnid
    };
    httpUtil.post(DataUtils.api_addcolumnsubscrible,data:option).then((value){
      M.ColumnSubscribleCommonBean bean = M.ColumnSubscribleCommonBean.fromJson(json.decode(value));
      if(bean.errno == 0){
        (widget as ColumnDetail).cb(columnid,1);
        setState(() {
          this.issubscrible = true;
        });
      }else{
        showToast(bean.errmsg);
      }
    });
  }

  /**
   * 取消订阅
   */
  void _cancelSubscrible(){
    var option = {
      "columnid":columnid
    };
    httpUtil.post(DataUtils.api_removecolumnsubscrible,data:option).then((value){
      M.ColumnSubscribleCommonBean bean = M.ColumnSubscribleCommonBean.fromJson(json.decode(value));
      if(bean.errno == 0){
        (widget as ColumnDetail).cb(columnid,0);
        setState(() {
          this.issubscrible = false;
        });
      }else{
        showToast(bean.errmsg);
      }
    });
  }

  /**
   * 删除专栏图片
   */
  void _deleteColumnGallery(Data _data){
    var option = {
      "id":_data.id,
      "columnid":_data.columnid
    };
    httpUtil.post(DataUtils.api_deletegallerybycolumn,data:option).then((value){
      print(value);
      ColumnGalleryDeleteBean bean = ColumnGalleryDeleteBean.fromJson(json.decode(value));
      if(bean.errno == 0){
        setState(() {
          for(var i=0; i<list.length; i++){
            if(list[i].id==_data.id){
              list.removeAt(i);
              break;
            }
          }
        });
      }else{
        showToast(bean.errmsg);
      }
    });
  }

  @override
  void refresh(){}

  @override
  void loadmore(){
    if(!isloading){
      _getColumnGalleryListMore();
    }
  }


  @override
  List<Widget> addChildren(){
    return [
      Container(
        height: ScreenUtil().setHeight(SizeUtil.getHeight(100)),
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            BackButtonWidget(cb: (){
              Navigator.pop(context,list.length == 0 ? true : false);
            }, title:"返回"),
            isself ? InkWell(
              onTap: (){
                showEditorColumn(context,this.columnid,this.columnname,(widget as ColumnDetail).visible).then((value) => {
                  if(value != null){
                    //修改专栏
                    setState(() {
                      if(value["name"] != null){
                        this.columnname = value["name"];
                      }
                    })
                  }
                });
              },
              child: Container(
                padding: EdgeInsets.only(right: ScreenUtil().setWidth(SizeUtil.getWidth(20))),
                child: Text("编辑",style: TextStyle(color: Colors.red,fontSize: ScreenUtil().setSp(SizeUtil.getFontSize(30))),),
              ),
            )
                : InkWell(
              onTap:(){
                //订阅
                if(this.issubscrible){
                  _cancelSubscrible();
                }else{
                  _addSubscrible();
                }
              },
              child: Container(
                padding: EdgeInsets.only(right: ScreenUtil().setWidth(SizeUtil.getWidth(20))),
                child: Text(this.issubscrible ? "取消收藏" : "+ 收藏",style: TextStyle(color: Colors.red,fontSize: ScreenUtil().setSp(SizeUtil.getFontSize(30))),),
              ),
            )
          ],
        ),
      ),
      Container(
        width:double.infinity,
        padding: EdgeInsets.only(
            top: ScreenUtil().setHeight(SizeUtil.getHeight(40)),
            bottom: ScreenUtil().setHeight(SizeUtil.getHeight(40)),
            left: ScreenUtil().setWidth(SizeUtil.getWidth(40))
        ),
        decoration: BoxDecoration(
            color: Colors.white
        ),
        child: Text(columnname,style: TextStyle(fontSize: ScreenUtil().setSp(SizeUtil.getFontSize(40)),fontWeight: FontWeight.bold),),
      ),
      Divider(height: ScreenUtil().setHeight(2),color: Colors.grey[100],),
      Container(
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.white
        ),
        padding: EdgeInsets.symmetric(
            vertical: ScreenUtil().setHeight(SizeUtil.getHeight(20)),
            horizontal: ScreenUtil().setWidth(SizeUtil.getWidth(40))
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            RichText(
              text: TextSpan(
                  children: [
                    WidgetSpan(
                      alignment: PlaceholderAlignment.middle,
                      child: Container(
                          margin: EdgeInsets.only(right: ScreenUtil().setWidth(SizeUtil.getWidth(20))),
                          child: ClipOval(
                            child: (avater == null || avater.length == 0)
                                ? Image.asset("image/ic_head.png",width: ScreenUtil().setWidth(50),height: ScreenUtil().setWidth(50),fit: BoxFit.cover,)
                                : CachedNetworkImage(imageUrl: avater,width: ScreenUtil().setWidth(50),height: ScreenUtil().setWidth(50),fit: BoxFit.cover),
                          )),
                    ),
                    TextSpan(
                      text: author,
                      style: TextStyle(fontSize: ScreenUtil().setSp(SizeUtil.getFontSize(30)),color: Colors.black87),
                    )
                  ]
              ),
            ),
            Text("${count}张作品")
          ],),
      ),
      // 如果是自己的专栏，显示上传图片
      Offstage(
        offstage: !isself,
        child: InkWell(
          onTap: (){
            //往自己的专栏中上传图片
            openColumnGallery(context, columnid, (bool value){
              if(value){
                print("上传完成");
                //重新请求我的专栏数据
                list.clear();
                _getColumnGalleryList();
              }
            });
          },
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(ScreenUtil().setWidth(SizeUtil.getWidth(10))),
                color: Colors.white
            ),
            padding: EdgeInsets.only(
                left: ScreenUtil().setWidth(SizeUtil.getWidth(40)),
                top: ScreenUtil().setHeight(SizeUtil.getHeight(20)),
                bottom: ScreenUtil().setHeight(SizeUtil.getHeight(20))
            ),
            margin: EdgeInsets.symmetric(
                horizontal: ScreenUtil().setWidth(SizeUtil.getWidth(20)),
                vertical: ScreenUtil().setHeight(SizeUtil.getHeight(20))
            ),
            child: Text("+ 上传图片",style: TextStyle(fontSize: ScreenUtil().setSp(SizeUtil.getFontSize(36)),fontWeight: FontWeight.bold),),
          ),
        ),
      ),
      Expanded(child: StaggeredGridView.countBuilder(
        crossAxisCount: Constant.isPad ? 3 : 2,
        itemCount: list.length,
        primary: false,
        mainAxisSpacing: ScreenUtil().setWidth(Constant.DIS_LIST),
        crossAxisSpacing: ScreenUtil().setWidth(Constant.DIS_LIST),
        controller: _scrollController,
        addAutomaticKeepAlives: false,
        padding: EdgeInsets.only(left: ScreenUtil().setWidth(SizeUtil.getWidth(Constant.DIS_LIST)),right: ScreenUtil().setWidth(SizeUtil.getWidth(Constant.DIS_LIST)),top: ScreenUtil().setHeight(20)),
        staggeredTileBuilder: (int index) => StaggeredTile.fit(1),
        //StaggeredTile.count(3,index==0?2:3),
        itemBuilder: (context,index){
          return GestureDetector(
            child: ColumnImageTile(data: list[index],deleteClick: (){
              _deleteColumnGallery(list[index]);
            },isdelete: (widget as ColumnDetail).iscommon,),
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>
                  ColumnGalleryPageView(list: list, position: index)
              ));
            },
          );
        },
      )),
      //loadmore widget
      isloading ? loadmoreWidget() : SizedBox()
    ];
  }


}