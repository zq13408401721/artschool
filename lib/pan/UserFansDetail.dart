import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:yhschool/BaseCoustRefreshState.dart';
import 'package:yhschool/BaseRefreshState.dart';
import 'package:yhschool/BaseState.dart';
import 'package:yhschool/bean/user_fans_bean.dart';
import 'package:yhschool/utils/Constant.dart';
import 'package:yhschool/utils/DataUtils.dart';
import 'package:yhschool/utils/HttpUtils.dart';
import 'package:yhschool/bean/user_search.dart' as S;



import '../bean/user_fans_bean.dart';
import '../utils/SizeUtil.dart';
import 'PanUserDetail.dart';

class UserFansDetail extends StatefulWidget{

  //用户{uid,username,nickname,fansnum}
  dynamic data;

  UserFansDetail({Key key,@required this.data}):super(key: key);

  @override
  State<StatefulWidget> createState() {
    return UserFansDetailState();
  }

}

class UserFansDetailState extends BaseCoustRefreshState<UserFansDetail>{

  ScrollController _scrollController;

  int page=1,size=10;
  int type = 1; //粉丝
  List<Data> fansList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController = initScrollController(isfresh: false);
    queryUserFansList();
  }

  void queryUserFansList(){
    var param = {
      "uid":widget.data["uid"],
      "page":page,
      "size":size,
      "type":type
    };
    httpUtil.post(DataUtils.api_queryuserfollow,data:param).then((value){
      print("fanslist:${value}");
      hideLoadMore();
      if(value != null){
        UserFansBean userFansBean = UserFansBean.fromJson(json.decode(value));
        if(userFansBean.errno == 0){
          fansList.addAll(userFansBean.data);
          page++;
          setState(() {
          });
        }
      }
    });
  }

  Widget userItem(Data item){
    return Card(
      shadowColor:Colors.transparent,
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
                    : Image.asset("image/ic_head.png",height: ScreenUtil().setWidth(SizeUtil.getWidth(100)),width: ScreenUtil().setWidth(SizeUtil.getWidth(100)),fit:BoxFit.cover)
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
  List<Widget> addChildren() {
    return <Widget>[
      Container(
        padding: EdgeInsets.symmetric(
          vertical: SizeUtil.getAppHeight(20),
          horizontal: SizeUtil.getAppWidth(20)
        ),
        decoration: BoxDecoration(
          color: Colors.white
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: (){
                Navigator.pop(context);
              },
              child: Container(
                padding: EdgeInsets.only(
                    right: SizeUtil.getAppWidth(40)
                ),
                child: backArrowWidget(),
                //child: Image.asset("image/ic_arrow_left.png",width: SizeUtil.getAppWidth(60),height: SizeUtil.getAppHeight(60),),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  vertical: SizeUtil.getAppHeight(20),
                  horizontal: SizeUtil.getAppWidth(20)
              ),
              child: Row(
                children: [
                  Text("${widget.data["nickname"] != null ? widget.data["nickname"] : widget.data["username"]}",style: Constant.titleTextStyleNormal,),
                  SizedBox(width: SizeUtil.getAppWidth(20),),
                  Text("共有${widget.data["fansnum"]}个粉丝",style: Constant.smallTitleTextStyle,)
                ],
              ),
            )
          ],
        ),
      ),
      Expanded(
        child: Padding(
            padding: EdgeInsets.symmetric(
                vertical: SizeUtil.getAppHeight(20),
                horizontal: SizeUtil.getAppWidth(20)
            ),
            child: StaggeredGridView.countBuilder(
              crossAxisCount: Constant.isPad ? 3 : 2,
              itemCount: fansList.length,
              primary: false,
              crossAxisSpacing: SizeUtil.getAppWidth(Constant.DIS_LIST),
              mainAxisSpacing: SizeUtil.getAppWidth(Constant.DIS_LIST),
              controller: _scrollController,
              addAutomaticKeepAlives: false,
              padding: EdgeInsets.only(left: SizeUtil.getAppWidth(Constant.DIS_LIST),right: SizeUtil.getAppWidth(Constant.DIS_LIST)),
              staggeredTileBuilder: (int index) => StaggeredTile.fit(1),
              itemBuilder: (_context,index){
                return InkWell(
                  onTap: (){
                    print("click fans uid:${fansList[index].uid}");
                    //粉丝列表进入个人详情
                    var param = new S.Result(
                      uid: fansList[index].uid,
                      username:fansList[index].username,
                      nickname:fansList[index].nickname,
                      avater:fansList[index].avater,
                      role:fansList[index].role,
                    );
                    param.panid = widget.data["panid"];
                    //进入用户详情页
                    Navigator.of(context).push(MaterialPageRoute(builder: (_cxt) => PanUserDetail(data: param)));
                  },
                  child: userItem(fansList[index]),
                );
              },
            )
        ),
      )
    ];
  }

  @override
  void loadmore() {
    queryUserFansList();
  }

  @override
  void refresh() {

  }

}