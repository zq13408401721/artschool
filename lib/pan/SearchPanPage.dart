import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:yhschool/BaseHeaderRefreshState.dart';
import 'package:yhschool/utils/Constant.dart';
import 'package:yhschool/utils/DataUtils.dart';
import 'package:yhschool/utils/HttpUtils.dart';

import '../bean/pan_search.dart';
import '../bean/user_search.dart' as U;
import '../utils/SizeUtil.dart';

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
  List<String> searchTypes = ["网盘","用户"];
  String searchType;
  int page = 1;
  int size = 10;
  int total = 0;

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
        }else{
          PanSearch panSearch = PanSearch.fromJson(json.decode(value));
          total = panSearch.data.total;
          searchList.addAll(panSearch.data.result);
        }
      }
      setState(() {
      });
    });
  }

  void clearList(){
    if(searchType == null || searchType == "网盘"){
      searchList.clear();
    }else{
      searchUsers.clear();
    }
    total = 0;
    page = 1;
    setState(() {
    });
  }

  //panitem
  Widget panItem(Result data){
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(SizeUtil.getAppWidth(5)),
        color: Colors.white
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CachedNetworkImage(imageUrl: data.url),
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
          Align(
            alignment:Alignment.centerRight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                //copy
                InkWell(
                  onTap: (){

                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: SizeUtil.getAppWidth(20),
                      vertical: SizeUtil.getAppHeight(10)
                    ),
                    child: Image.asset("image/ic_pan_copy.png",width: SizeUtil.getAppWidth(40),height: SizeUtil.getAppHeight(40),),
                  ),
                ),
                //关注
                InkWell(
                  onTap: (){

                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: SizeUtil.getAppWidth(20),
                        vertical: SizeUtil.getAppHeight(10)
                    ),
                    child: Image.asset("image/ic_pan_like.png",width: SizeUtil.getAppWidth(40),height: SizeUtil.getAppHeight(40),),
                  ),
                )

              ],
            ),
          )
        ],
      ),
    );
  }

  Widget userItem(U.Result data){
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(SizeUtil.getAppWidth(5)),
        border: Border.all(color: Colors.grey[400],width: SizeUtil.getAppWidth(1))
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
            padding: EdgeInsets.symmetric(
              horizontal: SizeUtil.getAppWidth(20),
              vertical: SizeUtil.getAppHeight(10)
            ),
            child: Text(data.nickname != null ? data.nickname : data.username,style: TextStyle(fontSize: SizeUtil.getAppFontSize(30),fontWeight: FontWeight.bold),),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: SizeUtil.getAppWidth(20),
              vertical: SizeUtil.getAppHeight(10)
            ),
            child: Text("${data.fansnum}粉丝",style: Constant.smallTitleTextStyle,),
          )
        ],
      ),
    );
  }

  @override
  Widget addHeaderWidget() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: SizeUtil.getAppWidth(40),
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
                vertical: SizeUtil.getAppHeight(20)
              ),
              child: Image.asset("image/ic_arrow_left.png",width: SizeUtil.getAppWidth(40),height: SizeUtil.getAppWidth(40),),
            ),
          ),
          //搜索框
          Row(
            children: [
              Expanded(
                child: TextField(
                  maxLength: 20,
                  maxLines: 1,
                  decoration: InputDecoration(
                      hintText: "输入搜索词",
                      counterText: "",
                      border:InputBorder.none,
                      fillColor: Colors.white,
                      filled: true,
                      contentPadding: EdgeInsets.all( ScreenUtil().setHeight(SizeUtil.getHeight(20))),
                      enabledBorder:OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black12)
                      )
                  ),
                  onChanged: (value){
                    searchword = value;
                    if(searchword.length == 0){
                      clearList();
                    }
                  },
                ),
              ),
              SizedBox(width: SizeUtil.getAppWidth(20),),
              Center(
                child: Container(
                  width: ScreenUtil().setWidth(SizeUtil.getWidth(200)),
                  padding: EdgeInsets.only(
                      left:ScreenUtil().setWidth(SizeUtil.getWidth(20))
                  ),
                  decoration: BoxDecoration(
                      color:Colors.white,
                      border: Border.all(color: Colors.black12,width: 1),
                      borderRadius: BorderRadius.vertical(
                          top: Radius.elliptical(4,4,),
                          bottom: Radius.elliptical(4, 4)
                      )
                  ),
                  child: DropdownButton(
                    isExpanded: true,
                    hint: Text("搜索项"),
                    underline: Container(),
                    icon: Icon(Icons.arrow_right),
                    items: searchTypes.map((e) => DropdownMenuItem(
                      child: Text(e),
                      value: e,
                    )).toList(),
                    value: searchType,
                    onChanged: (item){
                      setState(() {
                        searchType = item;
                      });
                    },
                  ),
                ),
              ),
              InkWell(
                onTap: (){
                  //搜索
                  search();
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    vertical: SizeUtil.getAppHeight(10),
                    horizontal: SizeUtil.getAppWidth(20)
                  ),
                  child: Image.asset("image/ic_search.png",width: SizeUtil.getAppWidth(60),height: SizeUtil.getAppHeight(60),),
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
          Text("共有$total个相关网盘",style: Constant.smallTitleTextStyle,),
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