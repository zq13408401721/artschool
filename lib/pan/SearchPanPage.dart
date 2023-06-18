import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:yhschool/BaseHeaderRefreshState.dart';
import 'package:yhschool/pan/PanUserDetail.dart';
import 'package:yhschool/utils/Constant.dart';
import 'package:yhschool/utils/DataUtils.dart';
import 'package:yhschool/utils/HttpUtils.dart';
import 'package:yhschool/bean/pan_list_bean.dart' as P;


import '../bean/pan_search.dart';
import '../bean/user_search.dart' as U;
import '../utils/SizeUtil.dart';
import 'PanDetailPage.dart';

class SearchPanPage extends StatefulWidget{

  Function callback;

  SearchPanPage({@required this.callback,Key key}):super(key: key);

  @override
  State<StatefulWidget> createState() {
    return SearchPanPageState();
  }

}

class SearchPanPageState extends BaseHeaderRefresh<SearchPanPage>{

  ScrollController _scrollController;

  String searchword;
  List<String> searchTypes = ["相册","用户"];
  String searchType = "相册";
  String searchReslt = "";
  int page = 1;
  int size = 10;
  int total = 0;
  bool isShowResult = false;

  List<Result> searchList = [];
  List<String> historyList = [];
  List<U.Result> searchUsers = [];

  @override
  void initState() {
    super.initState();
    _scrollController = initScrollController(isfresh: false);
  }

  /**
   * 搜索
   */
  void search(){
    if(searchword != null){
      page=1;
      searchList = [];
      querySearch();
    }
  }

  void querySearch(){
    var option = {
      "word":searchword,
      "page":page,
      "size":size
    };
    if(searchType != null && searchType == "用户"){
      option["type"] = "1";
      option["size"] = 30;
    }
    httpUtil.post(DataUtils.api_searchpan,data: option).then((value){
      hideRefreshing();
      hideLoadMore();
      if(value != null){
        print("search result:$value");
        page++;
        if(option["type"] != null){
          U.UserSearch userSearch = U.UserSearch.fromJson(json.decode(value));
          total = userSearch.data.total;
          searchUsers.addAll(userSearch.data.result);
          searchReslt = "共有$total个相关用户";
        }else{
          PanSearch panSearch = PanSearch.fromJson(json.decode(value));
          total = panSearch.data.total;
          searchList.addAll(panSearch.data.result);
          searchReslt = "共有$total个相关相册";
        }
      }
      setState(() {
        isShowResult = true;
      });
    });
  }

  void clearList(){
    if(searchType == null || searchType == "相册"){
      searchList.clear();
    }else{
      searchUsers.clear();
    }
    total = 0;
    page = 1;
    setState(() {
      isShowResult = false;
    });
  }

  //panitem
  Widget panItem(Result data){
    return InkWell(
      onTap: (){
        P.Data item = new P.Data(
          panid: data.panid,
          name: data.name,
          uid: data.uid,
          avater: data.avater,
          username: data.username,
          nickname: data.nickname,
          imagenum: data.num,
          date: data.date,
          url: data.url
        );
        print("marknames:${item.marknames}");
        //进入网盘详情页面
        Navigator.push(context, MaterialPageRoute(builder: (context){
          return PanDetailPage(panData: item,isself: item.uid == m_uid,marknames: data.marknames,classifyname: data.classifyname,fromSreach: true,);
        }));
      },
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(SizeUtil.getAppWidth(5)),
            color: Colors.white
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CachedNetworkImage(imageUrl: Constant.parsePanSmallString(data.url)),
            Container(
              padding: EdgeInsets.symmetric(
                  vertical: SizeUtil.getAppHeight(10),
                  horizontal: SizeUtil.getAppWidth(20)
              ),
              child: Text(data.name,style: Constant.titleTextStyleNormal,),
            ),
            Container(
              padding: EdgeInsets.symmetric(
                  vertical: SizeUtil.getAppHeight(10),
                  horizontal: SizeUtil.getAppWidth(20)
              ),
              child: Text(data.nickname != null ? data.nickname : data.username,style: Constant.smallTitleTextStyle,),
            ),
            Container(
              padding: EdgeInsets.symmetric(
                  vertical: SizeUtil.getAppHeight(10),
                  horizontal: SizeUtil.getAppWidth(20)
              ),
              child: Text("P${data.num}",style: TextStyle(color: Colors.grey[300],fontSize: SizeUtil.getAppFontSize(36),fontWeight: FontWeight.bold),),
            ),
          ],
        ),
      ),
    );
  }

  Widget userItem(U.Result data){
    return InkWell(
      onTap: (){
        //进入用户详情页
        Navigator.push(context, MaterialPageRoute(builder: (context){
          return PanUserDetail(data: data,);
        }));
      },
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(SizeUtil.getAppWidth(5)),
            //border: Border.all(color: Colors.grey[400],width: SizeUtil.getAppWidth(1))
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: SizeUtil.getAppHeight(40)
                  ),
                  child: ClipOval(
                    child: (data.avater == null || data.avater.length == 0)
                        ? Image.asset("image/ic_head.png",width: ScreenUtil().setWidth(120),height: ScreenUtil().setWidth(120),fit: BoxFit.cover,)
                        : CachedNetworkImage(imageUrl: data.avater,width: ScreenUtil().setWidth(120),height: ScreenUtil().setWidth(120),fit: BoxFit.cover),
                  ),
                )
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: SizeUtil.getAppWidth(20),
                  right: SizeUtil.getAppWidth(20),
                  top: SizeUtil.getAppHeight(10),
                  bottom: SizeUtil.getAppHeight(5)
              ),
              child: Text(data.nickname != null ? data.nickname : data.username,style: TextStyle(fontSize: SizeUtil.getAppFontSize(30),fontWeight: FontWeight.bold),),
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: SizeUtil.getAppWidth(20),
                  right: SizeUtil.getAppWidth(20),
                  bottom: SizeUtil.getAppHeight(10)
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("${data.fansnum == null ? 0 : data.fansnum}粉丝",style: TextStyle(fontSize: SizeUtil.getAppFontSize(30),color: Colors.black54),),
                  Text("查看主页",style: Constant.smallTitleTextStyle,)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget addHeaderWidget() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(
        horizontal: SizeUtil.getAppWidth(20),
        vertical: SizeUtil.getAppHeight(40)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: (){
              Navigator.pop(context);
            },
            child: Container(
              padding: EdgeInsets.symmetric(
                vertical: SizeUtil.getAppHeight(40)
              ),
              child: backArrowWidget(),
              //child: Image.asset("image/ic_arrow_left.png",width: SizeUtil.getAppWidth(60),height: SizeUtil.getAppWidth(60),),
            ),
          ),
          //搜索框
          Row(
            children: [
              Expanded(
                child: Container(
                  height: SizeUtil.getAppHeight(100),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.all(Radius.circular(SizeUtil.getAppWidth(10)))
                  ),
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(
                    horizontal: SizeUtil.getAppWidth(20)
                  ),
                  child: TextField(
                    maxLength: 20,
                    maxLines: 1,
                    decoration: InputDecoration(
                      hintText: "请输入关键字",
                      hintStyle: TextStyle(fontSize: SizeUtil.getAppFontSize(30),color: Colors.grey),
                      counterText: "",
                      labelStyle: TextStyle(fontSize: SizeUtil.getAppFontSize(30),color: Colors.grey),
                      border:InputBorder.none,
                      isCollapsed: true
                      //contentPadding: EdgeInsets.all( ScreenUtil().setHeight(SizeUtil.getHeight(20))),
                      /*enabledBorder:OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black12)
                      )*/
                    ),
                    onChanged: (value){
                      searchword = value;
                      if(searchword.length == 0){
                        clearList();
                      }
                    },
                  ),
                ),
              ),
              SizedBox(width: SizeUtil.getAppWidth(20),),
              Center(
                child: Container(
                  height: SizeUtil.getAppHeight(100),
                  width: ScreenUtil().setWidth(SizeUtil.getWidth(200)),
                  padding: EdgeInsets.only(
                      left:ScreenUtil().setWidth(SizeUtil.getWidth(20))
                  ),
                  decoration: BoxDecoration(
                      color:Colors.grey[100],
                      //border: Border.all(color: Colors.black12,width: 1),
                      borderRadius: BorderRadius.vertical(
                          top: Radius.elliptical(4,4,),
                          bottom: Radius.elliptical(4, 4)
                      )
                  ),
                  child: DropdownButton(
                    isExpanded: true,
                    hint: Text("搜索项",style: TextStyle(color: Colors.grey,fontSize: SizeUtil.getAppFontSize(30)),),
                    underline: Container(),
                    icon: Icon(Icons.keyboard_arrow_down,color: Colors.grey,),
                    items: searchTypes.map((e) => DropdownMenuItem(
                      child: Text(e,style: TextStyle(color: Colors.grey,fontSize: SizeUtil.getAppFontSize(30)),),
                      value: e,
                    )).toList(),
                    value: searchType,
                    onChanged: (item){
                      setState(() {
                        isShowResult = false;
                        searchType = item;
                      });
                    },
                  ),
                ),
              ),
              InkWell(
                onTap: (){
                  FocusScope.of(context).unfocus();
                  //搜索
                  search();
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    vertical: SizeUtil.getAppHeight(10),
                    horizontal: SizeUtil.getAppWidth(40)
                  ),
                  child: Text("搜索",style: TextStyle(color: Colors.black87,fontSize: SizeUtil.getAppFontSize(36)),)
                  //Image.asset("image/ic_search.png",width: SizeUtil.getAppWidth(60),height: SizeUtil.getAppHeight(60),),
                ),
              )
            ],
          )

        ],
      ),
    );
  }

  /**
   * 搜索历史记录
   */
  Widget searchHistory(){
    return Column(
      children: [
        StaggeredGridView.countBuilder(
          crossAxisCount: Constant.isPad ? 3 : 2,
          itemCount: historyList.length,
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
            return InkWell(
              onTap: (){

              },
              child: Text(historyList[index]),
            );
          },
        )
      ],
    );
  }

  @override
  Widget addChildren() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: SizeUtil.getAppWidth(40)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Offstage(
            offstage: !isShowResult,
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: SizeUtil.getAppHeight(20),
                horizontal: SizeUtil.getAppWidth(20)
              ),
              child: Text("共有$total个相关相册",style: Constant.smallTitleTextStyle,),
            )
          ),
          Expanded(
            child: StaggeredGridView.countBuilder(
              crossAxisCount: Constant.isPad ? 3 : 2,
              itemCount: searchType == "用户" ? searchUsers.length : searchList.length,
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
                return searchType == "用户" ? userItem(searchUsers[index]) : panItem(searchList[index]);
              },
            ),
          )

        ],
      ),
    );
  }

  @override
  void loadmore() {
    querySearch();
  }

  @override
  void refresh() {

  }
}