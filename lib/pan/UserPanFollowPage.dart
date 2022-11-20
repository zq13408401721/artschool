import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:yhschool/BaseRefreshState.dart';
import 'package:yhschool/utils/DataUtils.dart';
import 'package:yhschool/utils/SizeUtil.dart';
import 'package:yhschool/bean/user_search.dart' as S;

import '../bean/user_fans_bean.dart';
import '../utils/Constant.dart';
import '../utils/HttpUtils.dart';
import 'PanUserDetail.dart';

class UserPanFollowPage extends StatefulWidget{

  String uid;
  String panid;
  UserPanFollowPage({Key key,@required this.uid,@required this.panid}):super(key: key);

  @override
  State<StatefulWidget> createState() {
    return UserPanFollowPageState();
  }

}

class UserPanFollowPageState extends BaseRefreshState<UserPanFollowPage>{

  ScrollController _scrollController;
  int page = 1;
  int size = 10;
  int type = 2;
  List<Data> followsList = [];

  @override
  void initState() {
    super.initState();
    _scrollController = initScrollController(isfresh: false);
    getUserFollow();
  }

  void getUserFollow(){
    var param = {
      "uid":widget.uid,
      "page":page,
      "size":size,
      "type":type
    };
    httpUtil.post(DataUtils.api_queryuserfollow,data: param).then((value){
      print("pan:$value");
      hideLoadMore();
      if(value != null){
        UserFansBean userFansBean = UserFansBean.fromJson(json.decode(value));
        if(userFansBean.errno == 0 && userFansBean.data.length > 0){
          followsList.addAll(userFansBean.data);
          page++;
          setState(() {
          });
        }
      }
    });
  }

  Widget userItem(Data item){
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(
                horizontal: SizeUtil.getAppWidth(40),
                vertical: SizeUtil.getAppHeight(80)
            ),
            child: ClipOval(
                child: item.avater != null ? CachedNetworkImage(imageUrl: item.avater,width: SizeUtil.getAppWidth(100),height: SizeUtil.getAppWidth(100),fit: BoxFit.cover,)
                    : Image.asset("image/ic_head.png",height: SizeUtil.getAppWidth(100),width: SizeUtil.getAppWidth(100),fit:BoxFit.cover)
            ),
          ),
          Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: SizeUtil.getAppWidth(20)
              ),
              child: Text("${item.nickname != null ? item.nickname : item.username}",style: TextStyle(fontSize: SizeUtil.getAppFontSize(30)),)
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: SizeUtil.getAppWidth(20),
                vertical: SizeUtil.getAppHeight(20)
            ),
            child: Text("${item.num} 粉丝",style: TextStyle(fontSize: SizeUtil.getAppFontSize(25),color: Colors.grey),),
          )
        ],
      ),
    );
  }

  @override
  Widget addChildren() {
    return Container(
      child:StaggeredGridView.countBuilder(
        crossAxisCount: Constant.isPad ? 3 : 2,
        itemCount: followsList.length,
        primary: false,
        crossAxisSpacing: SizeUtil.getAppWidth(Constant.DIS_LIST),
        controller: _scrollController,
        addAutomaticKeepAlives: false,
        padding: EdgeInsets.only(left: SizeUtil.getAppWidth(Constant.DIS_LIST),right: SizeUtil.getAppWidth(Constant.DIS_LIST)),
        staggeredTileBuilder: (int index) => StaggeredTile.fit(1),
        //StaggeredTile.count(3,index==0?2:3),

        itemBuilder: (context,index){
          return GestureDetector(
            onTap: (){
              //关注列表进入个人详情
              var param = new S.Result(
                uid: followsList[index].uid,
                username:followsList[index].username,
                nickname:followsList[index].nickname,
                avater:followsList[index].avater,
                role:followsList[index].role,
              );
              param.panid = widget.panid;
              //进入用户详情页
              Navigator.of(context).push(MaterialPageRoute(builder: (_cxt) => PanUserDetail(data: param)));
            },
            child: userItem(followsList[index])
          );
        },
      ),
    );
  }

  @override
  void loadmore() {
    getUserFollow();
  }

  @override
  void refresh() {

  }

}