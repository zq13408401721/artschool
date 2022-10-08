import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:yhschool/BaseRefreshState.dart';
import 'package:yhschool/BaseState.dart';

import '../utils/Constant.dart';
import '../utils/SizeUtil.dart';

class SearchUserPage extends StatefulWidget{

  Function callback;

  SearchUserPage({Key key,@required this.callback}):super(key: key);

  @override
  State<StatefulWidget> createState() {
    return SearchUserPageState();
  }

}

class SearchUserPageState extends BaseRefreshState<SearchUserPage>{

  ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = initScrollController();
  }

  Widget userItem(){
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ScreenUtil().setWidth(SizeUtil.getWidth(20))
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(ScreenUtil().setWidth(SizeUtil.getWidth(10)))),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: ScreenUtil().setWidth(40),
              vertical: ScreenUtil().setHeight(40)
            ),
            child: ClipOval(
                child: CachedNetworkImage(imageUrl: "",width: ScreenUtil().setWidth(60),height: ScreenUtil().setWidth(60),)
            ),
          ),
          Text("",style: TextStyle(fontSize: ScreenUtil().setSp(30)),),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("45 粉丝",style: TextStyle(fontSize: ScreenUtil().setSp(25),color: Colors.grey),),
              InkWell(
                onTap: (){

                },
                child: Text("+关注"),
              )
            ],
          )
        ],
      ),
    );
  }

  @override
  Widget addChildren() {
    return Column(
      children: [
        StaggeredGridView.countBuilder(
          crossAxisCount: Constant.isPad ? 3 : 2,
          itemCount: 0,
          //primary: false,
          physics: BouncingScrollPhysics(),
          mainAxisSpacing: ScreenUtil().setWidth(SizeUtil.getWidth(Constant.DIS_LIST)),
          crossAxisSpacing: ScreenUtil().setHeight(SizeUtil.getHeight(Constant.DIS_LIST)),
          controller: _scrollController,
          //addAutomaticKeepAlives: false,
          padding: EdgeInsets.only(left: ScreenUtil().setWidth(SizeUtil.getWidth(Constant.DIS_LIST)),right: ScreenUtil().setWidth(SizeUtil.getWidth(Constant.DIS_LIST))),
          staggeredTileBuilder: (int index) => StaggeredTile.fit(1),
          //StaggeredTile.count(3,index==0?2:3),
          itemBuilder: (context,index){
            return GestureDetector(
              child: userItem(),
              onTap:(){

              },
            );
          },
        )
      ],
    );
  }

  @override
  void loadmore() {

  }

  @override
  void refresh() {

  }
}
