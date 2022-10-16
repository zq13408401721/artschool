import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yhschool/BaseState.dart';
import 'package:yhschool/bean/pan_userdetail_bean.dart';
import 'package:yhschool/pan/UserPanCoursePage.dart';
import 'package:yhschool/pan/UserPanFollowPage.dart';
import 'package:yhschool/pan/UserPanImagePage.dart';
import 'package:yhschool/pan/UserPanLikePage.dart';
import 'package:yhschool/pan/UserPanPage.dart';
import 'package:yhschool/utils/Constant.dart';
import 'package:yhschool/utils/DataUtils.dart';
import 'package:yhschool/utils/SizeUtil.dart';

import '../utils/HttpUtils.dart';

class PanUserDetail extends StatefulWidget{

  //用户相关信息{id,username,nickname,avater}
  dynamic data;

  PanUserDetail({Key key,@required this.data}):super(key: key);

  @override
  State<StatefulWidget> createState() {
    return PanUserDetailState();
  }

}

class PanUserDetailState extends BaseState<PanUserDetail>{

  TextStyle selectStyle = TextStyle(color: Colors.red,fontSize: SizeUtil.getAppFontSize(25));
  TextStyle normalStyle = TextStyle(color: Colors.black54,fontSize: SizeUtil.getAppFontSize(25));
  int tabIndex = 0;
  Data panUserDetail;

  

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    queryUserDetail();
  }

  void queryUserDetail(){
    var param = {
      "uid":widget.data.uid
    };
    httpUtil.post(DataUtils.api_queryuserdetail,data: param).then((value){
      print("user $value");
      if(value != null){
        PanUserdetailBean userdetailBean = PanUserdetailBean.fromJson(json.decode(value));
        panUserDetail = userdetailBean.data[0];
        setState(() {
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: SizeUtil.getAppHeight(40),
                horizontal: SizeUtil.getAppWidth(20)
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: (){
                      Navigator.pop(context);
                    },
                    child: Image.asset("image/ic_arrow_left.png",width: SizeUtil.getAppWidth(40),height: SizeUtil.getAppHeight(40),),
                  ),
                  InkWell(
                    onTap: (){

                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        vertical: SizeUtil.getAppHeight(10),
                        horizontal: SizeUtil.getAppWidth(20)
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(SizeUtil.getAppWidth(5))
                      ),
                      child: Text("+关注",style: TextStyle(fontSize: SizeUtil.getAppFontSize(25),color: Colors.white),),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: SizeUtil.getAppWidth(20)
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipOval(
                    child: (panUserDetail == null || panUserDetail.avater == null)
                        ? Image.asset("image/ic_head.png",width: SizeUtil.getAppWidth(80),height: SizeUtil.getAppWidth(80),fit: BoxFit.cover,)
                        : CachedNetworkImage(imageUrl: panUserDetail.avater,width: SizeUtil.getAppWidth(80),height: SizeUtil.getAppWidth(80),fit: BoxFit.cover),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(padding: EdgeInsets.symmetric(
                              vertical: SizeUtil.getAppHeight(5),
                            horizontal: SizeUtil.getAppWidth(20)
                          ),child:Text(widget.data.nickname != null ? widget.data.nickname : widget.data.username,style: Constant.titleTextStyleNormal,),),
                          Padding(padding: EdgeInsets.symmetric(
                              vertical: SizeUtil.getAppHeight(5),
                            horizontal: SizeUtil.getAppWidth(20)
                          ),child: Text(Constant.parseRole(widget.data.role),style: Constant.smallTitleTextStyle,),)
                        ],
                      ),
                      Padding(padding: EdgeInsets.symmetric(
                        horizontal: SizeUtil.getAppWidth(20)
                      ),child: Text("色彩"),),
                      Padding(padding: EdgeInsets.symmetric(
                        horizontal: SizeUtil.getAppWidth(20)
                      ),child: Text("${panUserDetail == null ? 0 : panUserDetail.fansnum} 粉丝 >",style: Constant.smallTitleTextStyle,),)

                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: SizeUtil.getAppHeight(20),),
            //top bar
            Container(
              decoration: BoxDecoration(
                  color: Colors.white
              ),
              child:Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  //网盘
                  Container(
                    child:InkWell(
                      onTap: (){
                        setState(() {
                          tabIndex = 0;
                        });
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(panUserDetail == null ? "0" : "${panUserDetail.pannum}",style: tabIndex == 0 ? selectStyle : normalStyle,),
                          Text("网盘",style: tabIndex == 0 ? selectStyle : normalStyle,),
                        ],
                      ),
                    ),
                  ),
                  //网盘图片
                  Container(
                    child: InkWell(
                      onTap: (){
                        setState(() {
                          tabIndex = 1;
                        });
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(panUserDetail == null ? "" : "${panUserDetail.imagenum}",style: tabIndex == 1 ? selectStyle : normalStyle,),
                          Text("网盘图片",style: tabIndex == 1 ? selectStyle : normalStyle,),
                        ],
                      ),
                    ),
                  ),
                  //课件
                  Container(
                    child: InkWell(
                      onTap: (){
                        setState(() {
                          tabIndex = 2;
                        });
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(panUserDetail == null ? "" : "0",style: tabIndex == 2 ? selectStyle : normalStyle,),
                          Text("课件",style: tabIndex == 2 ? selectStyle : normalStyle,),
                        ],
                      ),
                    ),
                  ),
                  //喜欢
                  Container(
                    child: InkWell(
                      onTap: (){
                        setState(() {
                          tabIndex = 3;
                        });
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(panUserDetail == null ? "" : "${panUserDetail.likenum}",style: tabIndex == 3 ? selectStyle : normalStyle,),
                          Text("喜欢",style: tabIndex == 3 ? selectStyle : normalStyle,),
                        ],
                      ),
                    ),
                  ),
                  //关注
                  Container(
                    child: InkWell(
                      onTap: (){
                        setState(() {
                          tabIndex = 4;
                        });
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(panUserDetail == null ? "" : "${panUserDetail.follownum}",style: tabIndex == 4 ? selectStyle : normalStyle,),
                          Text("关注",style: tabIndex == 4 ? selectStyle : normalStyle,),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: Container(
                child: IndexedStack(
                  index: tabIndex,
                  children: [
                    UserPanPage(uid: widget.data.uid),
                    UserPanImagePage(data: widget.data),
                    UserPanCoursePage(uid: widget.data.uid),
                    UserPanLikePage(uid: widget.data.uid),
                    UserPanFollowPage(uid: widget.data.uid)
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}