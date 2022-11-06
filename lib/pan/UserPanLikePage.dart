import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:yhschool/BaseRefreshState.dart';
import 'package:yhschool/bean/pan_like_bean.dart';
import 'package:yhschool/utils/DataUtils.dart';
import 'package:yhschool/utils/SizeUtil.dart';
import 'package:yhschool/bean/pan_list_bean.dart' as P;

import '../utils/Constant.dart';
import '../utils/HttpUtils.dart';
import 'PanImageDetail.dart';

class UserPanLikePage extends StatefulWidget{

  String uid;
  UserPanLikePage({Key key,@required this.uid}):super(key: key);

  @override
  State<StatefulWidget> createState() {
    return UserPanLikePageState();
  }

}

class UserPanLikePageState extends BaseRefreshState<UserPanLikePage>{

  ScrollController _scrollController;
  int page = 1;
  int size = 10;
  List<Data> likeList=[];

  @override
  void initState() {
    super.initState();
    _scrollController = initScrollController(isfresh: false);
    getUserPanImage();
  }

  void getUserPanImage(){
    var param = {
      "uid":widget.uid,
      "page":page,
      "size":size
    };
    httpUtil.post(DataUtils.api_queryuserlikepanimage,data: param).then((value){
      print("pan like:$value");
      if(value != null){
        PanLikeBean panLikeBean = PanLikeBean.fromJson(json.decode(value));
        if(panLikeBean.errno == 0){
          likeList.addAll(panLikeBean.data);
          page ++;
        }
        setState(() {
        });
      }
      hideLoadMore();
    });
  }

  Widget ImageItem(Data item){
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
                name:item.panname,
                imagenum:item.imgnum,
                uid: item.uid,
                avater: item.avater,
                nickname:item.nickname,
                username: item.username,
                url: item.url
            ),imgUrl: item.url,imgData: item,fileid: item.id,);
          }));
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CachedNetworkImage(imageUrl: Constant.parsePanSmallString(item.url),memCacheWidth: item.width,memCacheHeight: item.height,fit: BoxFit.cover,),
            Padding(padding: EdgeInsets.only(
              left: SizeUtil.getAppWidth(20),
              right: SizeUtil.getAppWidth(20),
              top: SizeUtil.getAppWidth(20),
              bottom: SizeUtil.getAppWidth(20),
              ),
              child: Text("${item.name}",style: Constant.smallTitleTextStyle,maxLines: 1,overflow: TextOverflow.ellipsis,),
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
        itemCount: likeList.length,
        primary: false,
        crossAxisSpacing: SizeUtil.getAppWidth(Constant.DIS_LIST),
        controller: _scrollController,
        addAutomaticKeepAlives: false,
        mainAxisSpacing: SizeUtil.getAppHeight(20),
        padding: EdgeInsets.only(left: SizeUtil.getAppWidth(Constant.DIS_LIST),right: SizeUtil.getAppWidth(Constant.DIS_LIST),),
        staggeredTileBuilder: (int index) => StaggeredTile.fit(1),
        //StaggeredTile.count(3,index==0?2:3),

        itemBuilder: (context,index){
          return ImageItem(likeList[index]);
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