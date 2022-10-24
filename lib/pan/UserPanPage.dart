import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:yhschool/BaseRefreshState.dart';
import 'package:yhschool/bean/pan_list_bean.dart' as P;
import 'package:yhschool/bean/pan_user_bean.dart';
import 'package:yhschool/utils/DataUtils.dart';
import 'package:yhschool/utils/SizeUtil.dart';

import '../utils/Constant.dart';
import '../utils/HttpUtils.dart';
import 'PanDetailPage.dart';
import 'PanPage.dart';

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
      if(value != null){
        PanUserBean panUserBean = PanUserBean.fromJson(json.decode(value));
        panList.addAll(panUserBean.data);
        setState(() {
          page ++;
          hideLoadMore();
        });
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
            return PanDetailPage(panData: bean,isself: false,);
          }));
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CachedNetworkImage(imageUrl: item.url != null ? item.url : "",memCacheWidth: item.width,memCacheHeight: item.height,fit: BoxFit.cover,),
            Padding(padding: EdgeInsets.only(
              left: SizeUtil.getAppWidth(20),
              right: SizeUtil.getAppWidth(20),
              top: SizeUtil.getAppWidth(20),
              bottom: SizeUtil.getAppWidth(5),
            ),child:Text("${item.name}"),),
            Padding(padding: EdgeInsets.only(
              left: SizeUtil.getAppWidth(20),
              right: SizeUtil.getAppWidth(20),
              top: SizeUtil.getAppWidth(5),
              bottom: SizeUtil.getAppWidth(5),
            ),child: Text("${item.nickname != null ? item.nickname : item.username}",style: Constant.smallTitleTextStyle,),),
            Padding(padding: EdgeInsets.only(
                left: SizeUtil.getAppWidth(20),
                right: SizeUtil.getAppWidth(20),
                top: SizeUtil.getAppWidth(5)
            ),child: Text("P${item.imagenum}",style: TextStyle(color: Colors.grey,fontSize: SizeUtil.getAppFontSize(30)),),),
            SizedBox(height: SizeUtil.getAppHeight(10),),
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
                              top:SizeUtil.getAppWidth(5),
                              bottom:SizeUtil.getAppWidth(10)
                          ),
                          child: Image.asset("image/ic_pan_copy.png",width: SizeUtil.getAppWidth(40),height: SizeUtil.getAppWidth(40),),
                        )
                    ),
                  ],
                ),
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
        itemCount: panList.length,
        primary: false,
        crossAxisSpacing: SizeUtil.getAppWidth(Constant.DIS_LIST),
        controller: _scrollController,
        addAutomaticKeepAlives: false,
        padding: EdgeInsets.only(left: SizeUtil.getAppWidth(Constant.DIS_LIST),right: SizeUtil.getAppWidth(Constant.DIS_LIST)),
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