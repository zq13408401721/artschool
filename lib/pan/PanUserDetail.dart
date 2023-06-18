import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yhschool/BaseState.dart';
import 'package:yhschool/bean/pan_userdetail_bean.dart';
import 'package:yhschool/bean/user_addfollow_bean.dart' as P;
import 'package:yhschool/pan/UserFansDetail.dart';
import 'package:yhschool/pan/UserPanCoursePage.dart';
import 'package:yhschool/pan/UserPanFollowPage.dart';
import 'package:yhschool/pan/UserPanImagePage.dart';
import 'package:yhschool/pan/UserPanLikePage.dart';
import 'package:yhschool/pan/UserPanPage.dart';
import 'package:yhschool/utils/Constant.dart';
import 'package:yhschool/utils/DataUtils.dart';
import 'package:yhschool/utils/SizeUtil.dart';

import '../utils/HttpUtils.dart';
import '../widgets/BackButtonWidget.dart';

class PanUserDetail extends StatefulWidget{

  //用户相关信息{id,username,nickname,avater}
  dynamic data;

  PanUserDetail({Key key,@required this.data}):super(key: key);

  @override
  State<StatefulWidget> createState() {
    print("create state ${data.uid}");
    return PanUserDetailState();
  }

}

class PanUserDetailState extends BaseState<PanUserDetail>{

  TextStyle selectStyle = TextStyle(color: Colors.red,fontSize: SizeUtil.getAppFontSize(30));
  TextStyle normalStyle = TextStyle(color: Colors.black54,fontSize: SizeUtil.getAppFontSize(30));
  int tabIndex = 0;
  Data panUserDetail;
  String classname="";

  

  @override
  void initState() {
    super.initState();
    print("user detail initState");
    queryUserDetail();
  }

  void queryUserDetail(){
    var param = {
      "uid":widget.data.uid
    };
    print("queryuserdetail uid:${widget.data.uid}");
    httpUtil.post(DataUtils.api_queryuserdetail,data: param).then((value){
      print("user $value");
      if(value != null){
        PanUserdetailBean userdetailBean = PanUserdetailBean.fromJson(json.decode(value));
        panUserDetail = userdetailBean.data[0];
        if(panUserDetail.classes != null && panUserDetail.classes.length > 0){
          panUserDetail.classes.forEach((element) {
            classname += element.name+"、";
          });
          classname = classname.substring(0,classname.length-1);
        }
        setState(() {
        });
      }
    });
  }

  /**
   * 用户关注
   */
  void addUserFollow(String uid){
    var param = {
      "followuid":uid
    };
    httpUtil.post(DataUtils.api_adduserfollow,data:param).then((value){
      print("adduserfollow ${value}");
      if(value != null){
        P.UserAddfollowBean addfollowBean = P.UserAddfollowBean.fromJson(json.decode(value));
        if(addfollowBean.errno == 0 && addfollowBean.data.type == "add"){
          showToast("关注成功");
        }else{
          showToast("已关注");
        }
        panUserDetail.isfollow = 1;
        setState(() {
        });
      }
    });
  }

  /**
   * 删除关注
   */
  void deleteUserFollow(String uid){
    var param = {
      "followuid":uid
    };
    httpUtil.post(DataUtils.api_deleteuserfollow,data:param).then((value){
      print("adduserfollow ${value}");
      if(value != null){
        panUserDetail.isfollow = 0;
        showToast("取消关注");
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
              padding: EdgeInsets.only(
                bottom: SizeUtil.getAppHeight(20),
                left: SizeUtil.getAppWidth(20),
                right: SizeUtil.getAppWidth(20)
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  BackButtonWidget(cb: (){
                    Navigator.pop(context);
                  }, title:""),
                  Offstage(
                    offstage: m_uid == widget.data.uid,
                    child: InkWell(
                      onTap: (){
                        if(panUserDetail != null && panUserDetail.isfollow == 1){
                          deleteUserFollow(widget.data.uid);
                        }else{
                          addUserFollow(widget.data.uid);
                        }
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
                        child: Text((panUserDetail != null && panUserDetail.isfollow == 1) ? "取消关注" : "+关注",style: TextStyle(fontSize: SizeUtil.getAppFontSize(25),color: Colors.white),),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: SizeUtil.getAppWidth(40)
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipOval(
                    child: (panUserDetail == null || panUserDetail.avater == null)
                        ? Image.asset("image/ic_head.png",width: SizeUtil.getAppWidth(150),height: SizeUtil.getAppWidth(150),fit: BoxFit.cover,)
                        : CachedNetworkImage(imageUrl: panUserDetail.avater,width: SizeUtil.getAppWidth(150),height: SizeUtil.getAppWidth(150),fit: BoxFit.cover),
                  ),
                  SizedBox(height: SizeUtil.getAppHeight(30),),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            child: Text(widget.data.nickname != null && widget.data.nickname.length > 0 ? widget.data.nickname : widget.data.username,style:TextStyle(
                                fontSize: SizeUtil.getAppFontSize(56),color: Colors.black87
                            ),),
                          ),
                          SizedBox(width: SizeUtil.getWidth(10),),
                          //身份
                          Container(
                            padding: EdgeInsets.only(
                              bottom: SizeUtil.getAppHeight(10)
                            ),
                            child: Text("${Constant.parseRole(widget.data.role)}",style: TextStyle(
                                fontSize: SizeUtil.getAppFontSize(30),color: Colors.grey
                            ),),
                          ),
                          SizedBox(width: SizeUtil.getWidth(20),),
                          //粉丝
                          Container(
                            padding: EdgeInsets.only(
                              bottom: SizeUtil.getAppHeight(10)
                            ),
                            child: InkWell(
                                onTap: (){
                                  if(panUserDetail == null) return;
                                  print("uid:${widget.data.uid}");
                                  Navigator.push(context, MaterialPageRoute(builder: (context){
                                    return UserFansDetail(data: {
                                      "uid":widget.data.uid,
                                      "username":panUserDetail.username,
                                      "nickname":panUserDetail.nickname,
                                      "fansnum":panUserDetail.fansnum
                                    });
                                  }));
                                },
                                child: Text("${panUserDetail == null ? 0 : panUserDetail.fansnum} 粉丝",style: TextStyle(
                                    fontSize: SizeUtil.getAppFontSize(30),color: Colors.lightBlueAccent
                                ),)
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: SizeUtil.getHeight(30),),
                      //Text("仰望星空，脚踏实地，走好每一步",style:TextStyle(fontSize: SizeUtil.getAppFontSize(36),color: Colors.black38),)
                      //班级
                     /* Padding(padding: EdgeInsets.symmetric(
                        horizontal: SizeUtil.getAppWidth(20)
                      ),child: Text("${subWord(classname,20)}",style:Constant.smallTitleTextStyle,)),*/

                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: SizeUtil.getAppHeight(60),),
            //top bar
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              padding: EdgeInsets.only(
                bottom: SizeUtil.getAppHeight(20)
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
                          Text("相册",style: tabIndex == 0 ? selectStyle : normalStyle,),
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
                          Text("相册图片",style: tabIndex == 1 ? selectStyle : normalStyle,),
                        ],
                      ),
                    ),
                  ),
                  /*//课件
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
                  ),*/
                  //喜欢
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
                          Text(panUserDetail == null ? "" : "${panUserDetail.likenum}",style: tabIndex == 2 ? selectStyle : normalStyle,),
                          Text("喜欢",style: tabIndex == 2 ? selectStyle : normalStyle,),
                        ],
                      ),
                    ),
                  ),
                  //关注
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
                          Text(panUserDetail == null ? "" : "${panUserDetail.follownum}",style: tabIndex == 3 ? selectStyle : normalStyle,),
                          Text("关注",style: tabIndex == 3 ? selectStyle : normalStyle,),
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
                    //UserPanCoursePage(uid: widget.data.uid),
                    UserPanLikePage(uid: widget.data.uid,callback: (){
                      queryUserDetail();
                    },),
                    UserPanFollowPage(uid: widget.data.uid,panid: widget.data.panid,)
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