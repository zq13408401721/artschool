import 'dart:async';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:yhschool/BaseRefreshState.dart';
import 'package:yhschool/BaseState.dart';
import 'package:yhschool/bean/entity_gallery_list.dart';
import 'package:yhschool/bean/issue_delete_bean.dart';
import 'package:yhschool/bean/issue_gallery_bean.dart';
import 'package:yhschool/gallery/GalleryPageView.dart';
import 'package:yhschool/teach/TeachTile.dart';
import 'package:yhschool/teach/TodayTeachGalleryDetail.dart';
import 'package:yhschool/teach/TodayTeachGalleryPageView.dart';
import 'package:yhschool/utils/Constant.dart';
import 'package:yhschool/utils/DataUtils.dart';
import 'package:yhschool/utils/HttpUtils.dart';
import 'package:yhschool/utils/ImageType.dart';
import 'package:yhschool/utils/SizeUtil.dart';
import 'package:yhschool/widgets/XCState.dart';

import '../GalleryBig.dart';
import '../Tile.dart';

/**
 *  今日教学图库页面
 */
class TodayTeachGallery extends StatefulWidget{

  String tid;
  int dateId;
  bool isplan; //是否从排课页面进入

  TodayTeachGallery({Key key,@required this.tid,@required this.dateId,@required this.isplan=false}):super(key: key);

  @override
  State<StatefulWidget> createState() {
    return TodayTeachGalleryState()
    ..tid = tid
    ..dateId = dateId;
  }

}

class TodayTeachGalleryState extends BaseRefreshState<TodayTeachGallery>{

  int page = 1,size=7;
  String tid;
  int dateId;
  int role;
  int oldsort;

  ScrollController _scrollController;
  List<Gallery> list = [];

  @override
  void initState() {
    super.initState();
    _scrollController = initScrollController(isfresh: false);
    getRole().then((value) => {this.role = value});
    getIssueList();
  }

  @override
  void refresh(){

  }

  @override
  void loadmore(){
    if(!isloading){
      getIssueListMore();
    }
  }

  @override
  void dispose() {
    //this._scrollController.dispose();
    super.dispose();
  }


  getIssueListReturn(IssueGalleryBean data){
    if(data.errno != 0){
      return showToast(data.errmsg);
    }
    if(data.data.gallery.length > 0){
      setState(() {
        oldsort = data.data.gallery[data.data.gallery.length-1].sort;
        this.list.addAll(data.data.gallery);
      });
    }
  }

  getIssueList(){
    var option = {
      "date_id":this.dateId,
      "teacherid":this.tid,
      "page":this.page,
      "size":this.size
    };
    httpUtil.post(DataUtils.api_issuegallery,data: option).then((value) => {
      getIssueListReturn(new IssueGalleryBean.fromJson(json.decode(value)))
    }).catchError((err){
      print(err);
    });
  }

  /**
   * 获取更多的课程图片数据
   */
  getIssueListMore(){
    var option = {
      "date_id":this.dateId,
      "teacherid":this.tid,
      "sort":oldsort,
      "size":this.size
    };
    httpUtil.post(DataUtils.api_issuegallery,data: option).then((value){
      hideLoadMore();
      getIssueListReturn(new IssueGalleryBean.fromJson(json.decode(value)));
    }).catchError((err){
      print(err);
    });
  }

  /**
   * 删除资料
   */
  void deleteTile(int id){
    var option = {
      "galleryid":id
    };
    httpUtil.post(DataUtils.api_issuedeletegallery,data: option).then((value){
      IssueDeleteBean result = IssueDeleteBean.fromJson(value);
      if(result != null){
        for(Gallery item in this.list){
          if(item.id == result.data.id){
            this.list.remove(item);
            break;
          }
        }
        setState(() {
        });
      }
    }).catchError((err){
      print(err);
    });
  }

  @override
  Widget addChildren() {
    return Container(
      padding: EdgeInsets.only(
        bottom: ScreenUtil().setHeight(40)
      ),
      child: StaggeredGridView.countBuilder(
        crossAxisCount: Constant.isPad ? 3 : 2,
        itemCount: list.length,
        primary: false,
        crossAxisSpacing: ScreenUtil().setWidth(SizeUtil.getWidth(Constant.DIS_LIST)),
        controller: _scrollController,
        addAutomaticKeepAlives: false,
        padding: EdgeInsets.only(left: ScreenUtil().setWidth(SizeUtil.getWidth(Constant.DIS_LIST)),right: ScreenUtil().setWidth(SizeUtil.getWidth(Constant.DIS_LIST))),
        staggeredTileBuilder: (int index) => StaggeredTile.fit(1),
        //StaggeredTile.count(3,index==0?2:3),

        itemBuilder: (context,index){
          return GestureDetector(
            //child: TileCard(key:GlobalObjectKey(list[index].id),url: list[index].url,title: list[index].name,imgtype: ImageType.issue,width: list[index].width,height: list[index].height,),
            child: TeachTile(smallurl: Constant.parseNewIssueSmallString(list[index].url,list[index].width,list[index].height,scale: 50),
              title: Constant.getFileNameByUrl(list[index].url,list[index].filename),author: list[index].name,role: this.role,
              avater: list[index].avater,username: list[index].username,nickname: list[index].nickname,tilerole: list[index].role,tileuid: list[index].tid,
              gallery: list[index],cb: (){
                //删除图片资料
                showAlertTips(context, "确定删除？", (){
                  deleteTile(list[index].id);
                });
              },),
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context){
                List<GalleryListData> _list = [];
                list.forEach((element) {
                  _list.add(GalleryListData(
                      date: element.date,
                      name:element.name,
                      id:element.id,
                      sort:element.sort,
                      url:element.url,
                      categoryid: element.galleryid,
                      width: element.width,
                      height:element.height,
                      maxwidth: element.maxwidth,
                      maxheight: element.maxheight,
                      markname:element.markname,
                      comments:element.comments,
                      editorurl: element.eidtorurl
                  ));
                });
                return TodayTeachGalleryPageView(list: _list,position: index,from: Constant.COLLECT_CLASS,isaction: widget.isplan,);
              })).then((value){
                // 界面返回value不等于null说明图片数据有编辑，需要更新当前列表数据
                if(value != null && value["id"] != null && value["editorurl"] != null){
                  list.forEach((element) {
                    if(element.id == value["id"]){
                      element.editorurl = value["editorurl"];
                    }
                  });
                }
              });
            },
          );
        },
      ),
    );
  }
}