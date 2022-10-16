import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:yhschool/BaseRefreshState.dart';
import 'package:yhschool/bean/pan_list_bean.dart' as P;
import 'package:yhschool/utils/DataUtils.dart';
import 'package:yhschool/utils/SizeUtil.dart';

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
      print("pan image:$value");
      if(value != null){
        PanFileBean panFileBean = PanFileBean.fromJson(json.decode(value));
        filesList.addAll(panFileBean.data);
        page ++;
      }
      setState(() {
        hideLoadMore();
      });
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
              uid: widget.data.uid,
              avater: widget.data.avater,
              nickname:widget.data.nickname,
              username: widget.data.username,
              url: item.url
            ));
          }));
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CachedNetworkImage(imageUrl: item.url),
            Padding(padding: EdgeInsets.only(
              left: SizeUtil.getAppWidth(20),
              right: SizeUtil.getAppWidth(20),
              top: SizeUtil.getAppWidth(10),
              bottom: SizeUtil.getAppWidth(5),
            ),
                child:widget.data.uid == m_uid ?
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text("${item.name}",style: Constant.smallTitleTextStyle,maxLines: 1,overflow: TextOverflow.ellipsis,),
                    ),
                    InkWell(
                      onTap: (){
                        //点赞
                      },
                      child: Image.asset("image/ic_pan_unlike.png",width: SizeUtil.getAppWidth(40),height: SizeUtil.getAppWidth(40),),
                    )
                  ],
                ) :
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: (){
                        //网盘置顶
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: SizeUtil.getAppWidth(10),
                          vertical: SizeUtil.getAppHeight(10),
                        ),
                        child: Image.asset("image/ic_pan_top.png",width: SizeUtil.getAppWidth(40),height: SizeUtil.getAppWidth(40),),
                      ),
                    ),
                    InkWell(
                      onTap: (){
                        //点赞
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: SizeUtil.getAppWidth(10),
                          vertical: SizeUtil.getAppHeight(10),
                        ),
                        child: Image.asset("image/ic_pan_unlike.png",width: SizeUtil.getAppWidth(40),height: SizeUtil.getAppWidth(40),),
                      ),
                    )
                  ],
                )
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