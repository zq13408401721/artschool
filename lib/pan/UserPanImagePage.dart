import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:yhschool/BaseCoustRefreshState.dart';
import 'package:yhschool/BaseRefreshState.dart';
import 'package:yhschool/bean/pan_addlike_bean.dart' as A;
import 'package:yhschool/bean/pan_list_bean.dart' as P;
import 'package:yhschool/utils/DataUtils.dart';
import 'package:yhschool/utils/SizeUtil.dart';
import 'package:yhschool/widgets/CoustSizeImage.dart';

import '../GalleryBig.dart';
import '../bean/pan_file_bean.dart';
import '../utils/Constant.dart';
import '../utils/HttpUtils.dart';
import '../utils/ImageType.dart';
import 'PanImageDetail.dart';

class UserPanImagePage extends StatefulWidget{

  dynamic data;
  UserPanImagePage({Key key,@required this.data}):super(key: key);

  @override
  State<StatefulWidget> createState() {
    return UserPanImagePageState();
  }

}

class UserPanImagePageState extends BaseRefreshState<UserPanImagePage>{

  ScrollController _scrollController;
  int page = 1;
  int size = 10;
  List<Data> filesList=[];

  @override
  void initState() {
    super.initState();
    _scrollController = initScrollController(isfresh: false);
    getUserPanImage();
  }

  void getUserPanImage(){
    var param = {
      "uid":widget.data.uid,
      "page":page,
      "size":size
    };
    httpUtil.post(DataUtils.api_querypanimagebyuser,data: param).then((value){
      print("pan image: ${page} $value");
      hideLoadMore();
      if(value != null){
        PanFileBean panFileBean = PanFileBean.fromJson(json.decode(value));
        if(panFileBean.errno == 0 && panFileBean.data.length > 0){
          filesList.addAll(panFileBean.data);
          page ++;
        }
      }
      setState(() {
      });
    });
  }

  /**
   * 添加喜欢的网盘图片
   */
  void addPanImageLike(int fileid){
    var param = {
      "panid":widget.data.panid,
      "fileid":fileid
    };
    httpUtil.post(DataUtils.api_addpanfilelike,data: param).then((value){
      print("pan file like:$value");
      hideLoadMore();
      if(value != null){
        A.PanAddlikeBean addlikeBean = A.PanAddlikeBean.fromJson(json.decode(value));
        if(addlikeBean.errno == 0){
          if(addlikeBean.data.type == "add"){
            showToast("收藏成功");
          }else{
            showToast("已经收藏");
          }
        }
      }
    });
  }

  Widget panItem(Data item){
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(SizeUtil.getAppWidth(10)),
              bottomRight: Radius.circular(SizeUtil.getAppWidth(10))
          )
      ),
      child: InkWell(
        onTap: (){
          //进入网盘图片详情页面
          Navigator.push(context, MaterialPageRoute(builder: (context){
            return PanImageDetail(panData: P.Data(
              id: item.id,
              date: item.date,
              name: item.panname,
              imagenum: item.imgnum,
              uid: widget.data.uid,
              avater: widget.data.avater,
              nickname:widget.data.nickname,
              username: widget.data.username,
              url: item.url
            ),imgUrl: item.url,imgData: item,fileid: item.id,);
          })).then((value){

          });
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CoustSizeImage(Constant.parsePanSmallString(item.url), mWidth: item.width, mHeight: item.height),
            Padding(padding: EdgeInsets.only(
              left: SizeUtil.getAppWidth(20),
              right: SizeUtil.getAppWidth(20),
              top: SizeUtil.getAppWidth(20),
              bottom: SizeUtil.getAppWidth(20),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text("${item.name}",style: Constant.smallTitleTextStyle,maxLines: 1,overflow: TextOverflow.ellipsis,),
                  ),
                  /*Offstage(
                    offstage: m_uid == widget.data.uid,
                    child: InkWell(
                      onTap: (){
                        //点赞
                        addPanImageLike(item.id);
                      },
                      child: Image.asset("image/ic_pan_unlike.png",width: SizeUtil.getAppWidth(40),height: SizeUtil.getAppWidth(40),),
                    ),
                  )*/
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget addChildren() {
    return Container(
      child:StaggeredGridView.countBuilder(
        crossAxisCount: Constant.isPad ? 3 : 2,
        itemCount: filesList.length,
        primary: false,
        crossAxisSpacing: SizeUtil.getAppWidth(Constant.DIS_LIST),
        controller: _scrollController,
        addAutomaticKeepAlives: false,
        mainAxisSpacing: SizeUtil.getAppHeight(20),
        padding: EdgeInsets.only(left: SizeUtil.getAppWidth(Constant.DIS_LIST),right: SizeUtil.getAppWidth(Constant.DIS_LIST)),
        staggeredTileBuilder: (int index) => StaggeredTile.fit(1),
        //StaggeredTile.count(3,index==0?2:3),

        itemBuilder: (context,index){
          return panItem(filesList[index]);
        },
      ),
    );
  }

  @override
  void loadmore() {
    getUserPanImage();
  }

  @override
  void refresh() {

  }

}