import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:yhschool/BaseCoustRefreshState.dart';
import 'package:yhschool/BaseRefreshState.dart';
import 'package:yhschool/bean/pan_list_bean.dart' as P;
import 'package:yhschool/bean/pan_user_bean.dart';
import 'package:yhschool/utils/DataUtils.dart';
import 'package:yhschool/utils/SizeUtil.dart';
import 'package:yhschool/widgets/CoustSizeImage.dart';

import '../utils/Constant.dart';
import '../utils/HttpUtils.dart';
import 'PanDetailPage.dart';
import 'PanPage.dart';
import 'PanUserDetail.dart';
import 'package:yhschool/bean/user_search.dart' as S;

class UserPanPage extends StatefulWidget{

  String uid;
  UserPanPage({Key key,@required this.uid}):super(key: key);

  @override
  State<StatefulWidget> createState() {
    return UserPanPageState();
  }

}

class UserPanPageState extends BaseRefreshState<UserPanPage>{

  ScrollController _scrollController;
  int page = 1;
  int size = 10;
  List<Data> panList = [];

  @override
  void initState() {
    super.initState();
    _scrollController = initScrollController(isfresh: false);
    initUserPan();
  }

  void initUserPan(){
    getUserPan();
  }

  void getUserPan(){
    var param = {
      "uid":widget.uid,
      "page":page,
      "size":size
    };
    httpUtil.post(DataUtils.api_queryuserpan,data: param).then((value){
      print("userpan: ${page} $value");
      hideLoadMore();
      if(value != null){
        PanUserBean panUserBean = PanUserBean.fromJson(json.decode(value));
        if(panUserBean.errno == 0 && panUserBean.data.length > 0){
          panList.addAll(panUserBean.data);
          setState(() {
            page ++;
          });
        }
      }
    });
  }

  //panitem
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
          //进入网盘详情页面
          Navigator.push(context, MaterialPageRoute(builder: (context){
            P.Data bean = new P.Data(
              id: item.id,
              panid: item.panid,
              name: item.name,
              date: item.date,
              uid: item.uid,
              imagename: item.imagename,
              url: item.url,
              username: item.username,
              nickname: item.nickname,
              imagenum: item.imagenum
            );
            return PanDetailPage(panData: bean,isself: item.uid == m_uid,classifyname:item.classifyname,marknames: item.marknames,);
          }));
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CoustSizeImage(item.url != null ? Constant.parsePanSmallString(item.url) : "", mWidth: item.width, mHeight: item.height),
            Padding(padding: EdgeInsets.only(
              left: SizeUtil.getAppWidth(20),
              right: SizeUtil.getAppWidth(20),
              top: SizeUtil.getAppWidth(20),
              bottom: SizeUtil.getAppWidth(5),
            ),child:Text("${item.name}"),),
            Padding(padding: EdgeInsets.only(
                left: SizeUtil.getAppWidth(20),
                right: SizeUtil.getAppWidth(20),
                top: SizeUtil.getAppHeight(10),
                bottom: SizeUtil.getAppHeight(10)
            ),child: InkWell(
              onTap: (){
                var param = new S.Result(
                  uid: item.uid,
                  username:item.username,
                  nickname:item.nickname,
                  avater:item.avater,
                  role:item.role,
                );
                param.panid = item.panid;
                //进入用户详情页
                Navigator.push(context, MaterialPageRoute(builder: (context){
                  return PanUserDetail(data: param,);
                }));
              },
              child: Row(
                children: [
                  ClipOval(
                    child: (item.avater == null || item.avater.length == 0)
                        ? Image.asset("image/ic_head.png",width: SizeUtil.getAppWidth(50),height: SizeUtil.getAppWidth(50),fit: BoxFit.cover,)
                        : CachedNetworkImage(imageUrl: item.avater,width: SizeUtil.getAppWidth(50),height: SizeUtil.getAppWidth(50),fit: BoxFit.cover),
                  ),
                  SizedBox(width: SizeUtil.getAppWidth(20),),
                  Text(item.nickname != null ? item.nickname : item.username,style: Constant.smallTitleTextStyle,)
                ],
              ),
            )),
            Padding(padding: EdgeInsets.only(
                left: SizeUtil.getAppWidth(20),
                right: SizeUtil.getAppWidth(20),
                top: SizeUtil.getAppWidth(5),
                bottom: SizeUtil.getAppHeight(20)
            ),child: Text("P${item.imagenum}",style: TextStyle(color: Colors.grey,fontSize: SizeUtil.getAppFontSize(30)),),),
            /*SizedBox(height: SizeUtil.getAppHeight(10),),
            Offstage(
              offstage: item.uid == m_uid,
              child: Align(
                alignment:Alignment.centerRight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    //copy
                    InkWell(
                        onTap: (){
                          //复制网盘
                          //copyPan(item.panid);
                          //PanPageState _state = widget.getBaseState();
                          //_state.changeTab(2);
                        },
                        child: Container(
                          padding: EdgeInsets.only(
                              left:SizeUtil.getAppWidth(20),
                              right: SizeUtil.getAppWidth(20),
                              top:SizeUtil.getAppWidth(20),
                              bottom:SizeUtil.getAppWidth(20)
                          ),
                          child: Image.asset("image/ic_pan_copy.png",width: SizeUtil.getAppWidth(40),height: SizeUtil.getAppWidth(40),),
                        )
                    ),
                  ],
                ),
              ),
            )*/

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
        itemCount: panList.length,
        primary: false,
        crossAxisSpacing: SizeUtil.getAppWidth(Constant.DIS_LIST),
        controller: _scrollController,
        addAutomaticKeepAlives: false,
        padding: EdgeInsets.only(left: SizeUtil.getAppWidth(Constant.DIS_LIST),right: SizeUtil.getAppWidth(Constant.DIS_LIST)),
        mainAxisSpacing: SizeUtil.getAppHeight(20),
        staggeredTileBuilder: (int index) => StaggeredTile.fit(1),
        //StaggeredTile.count(3,index==0?2:3),

        itemBuilder: (context,index){
          return panItem(panList[index]);
        },
      ),
    );
  }

  @override
  void loadmore() {
    getUserPan();
  }

  @override
  void refresh() {

  }

}