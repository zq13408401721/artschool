import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:yhschool/BaseDialogState.dart';
import 'package:yhschool/BaseState.dart';
import 'package:yhschool/bean/column_gallery_list_bean.dart';
import 'package:yhschool/utils/Constant.dart';
import 'package:yhschool/utils/DataUtils.dart';
import 'package:yhschool/utils/HttpUtils.dart';
import 'package:yhschool/widgets/BackButtonWidget.dart';
import 'package:yhschool/widgets/CollectButton.dart';
import 'package:yhschool/widgets/HeadTile.dart';
import 'package:yhschool/widgets/ImageButton.dart';

import 'ColumnGalleryTile.dart';

class ColumnImageDetail extends StatefulWidget{

  int columnid;
  String url;
  String uid;
  String author;
  int width,height,maxwidth,maxheight;
  String avater;
  String columnname;
  bool showmore=false;

  ColumnImageDetail({@required this.columnid,@required this.url,@required this.uid,@required this.author,
  @required this.width,@required this.height,@required this.maxwidth,@required this.maxheight,@required this.avater,@required this.columnname,@required this.showmore=false});


  @override
  State<StatefulWidget> createState() {
    return ColumnImageDetailState();
  }
}

class ColumnImageDetailState extends BaseDialogState{

  ScrollController _scrollController;
  int page=1,size=20;
  List<Data> galleryList = [];

  ColumnImageDetail getWidget(){
    return widget as ColumnImageDetail;
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _getColumnGalleryList();
  }

  /**
   * 获取专栏图片列表
   */
  void _getColumnGalleryList(){
    var option={
      "columnid":getWidget().columnid,
      "page":page,
      "size":size
    };
    httpUtil.post(DataUtils.api_gallerylistbycolumn,data:option).then((value){
      String result = checkLoginExpire(value);
      if(result.isNotEmpty){
        ColumnGalleryListBean bean = ColumnGalleryListBean.fromJson(json.decode(value));
        if(bean.errno == 0){
          setState(() {
            galleryList.addAll(bean.data);
          });
        }else{
          showToast(bean.errmsg);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: ScreenUtil().setWidth(40)
          ),
          child: ListView(
            controller: getWidget().showmore ? _scrollController : null,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  BackButtonWidget(cb: (){
                    Navigator.pop(context);
                  }, title: "返回",),
                  Container(
                    decoration: BoxDecoration(
                      color:Colors.red
                    ),
                    child: Row(
                      children: [
                        CollectButton(margin_right: 30,from: Constant.COLLECT_COLUMN,),
                        //推送
                        Offstage(
                          offstage: m_role != 1,
                          child: ImageButton(icon: "image/ic_push.png",label: "推送",cb:(){
                            //推送
                            pushGallery(context, {
                              "name":m_username == null ? m_nickname : m_username,
                              "url":getWidget().url,
                              "width":getWidget().width,
                              "height":getWidget().height,
                              "maxwidth":getWidget().maxwidth,
                              "maxheight":getWidget().maxheight
                            });
                          }),
                        )
                      ],
                    ),
                  )
                ],
              ),
              Container(
                child: CachedNetworkImage(
                  imageUrl: Constant.parseNewColumnSmallString(getWidget().url,getWidget().width,getWidget().height),
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (_context,_url)=>
                      Stack(
                        alignment: Alignment(0,0),
                        children: [
                          Image.network(_url,fit: BoxFit.cover,width: double.infinity,),
                          Container(
                            width: ScreenUtil().setWidth(40),
                            height: ScreenUtil().setWidth(40),
                            child: CircularProgressIndicator(color: Colors.red,),
                          ),
                        ],
                      ),
                ),
              ),
              HeadTile(avater: getWidget().avater, label: getWidget().author),
              /*Divider(height: ScreenUtil().setHeight(10),color: Colors.grey,),
            Text("来自专栏${widget.columnname}"),
            StaggeredGridView.countBuilder(
              crossAxisCount: Constant.isPad ? 3 : 2,
              itemCount: galleryList.length,
              primary: false,
              shrinkWrap: true,
              mainAxisSpacing: ScreenUtil().setWidth(Constant.DIS_LIST),
              crossAxisSpacing: ScreenUtil().setWidth(Constant.DIS_LIST),
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.only(left: ScreenUtil().setWidth(Constant.DIS_LIST),right: ScreenUtil().setWidth(Constant.DIS_LIST)),
              staggeredTileBuilder: (int index) => StaggeredTile.fit(1),
              //StaggeredTile.count(3,index==0?2:3),
              itemBuilder: (context,index){
                return InkWell(
                  child: ColumnGalleryTile(
                    author: galleryList[index].nickname == null ? galleryList[index].username : galleryList[index].nickname,
                    url: galleryList[index].url,
                    columnname: galleryList[index].columnname,
                    avater: galleryList[index].avater,
                    width: galleryList[index].width,
                    height: galleryList[index].height,
                  ),
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>
                        ColumnImageDetail(columnid: galleryList[index].columnid,
                          url: galleryList[index].url, uid: widget.uid,
                          author: galleryList[index].nickname == null ? galleryList[index].username : galleryList[index].nickname,
                          width: galleryList[index].width, height: galleryList[index].height,avater:widget.avater,)));
                  },
                );
              },
            ),*/

            ],
          )),
        ),
    );
  }

}
