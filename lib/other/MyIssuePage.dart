import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:yhschool/BaseRefreshState.dart';
import 'package:yhschool/collects/CollectGalleryPageView.dart';
import 'package:yhschool/collects/CollectTile.dart';
import 'package:yhschool/utils/Constant.dart';
import 'package:yhschool/utils/DataUtils.dart';
import 'package:yhschool/utils/HttpUtils.dart';
import 'package:yhschool/bean/my_issue_bean.dart';
import 'package:yhschool/utils/SizeUtil.dart';
import 'package:yhschool/widgets/BackButtonWidget.dart';

class MyIssuePage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return MyIssuePageState();
  }
}

class MyIssuePageState extends BaseRefreshState{

  ScrollController _scrollController;
  int page=1,size=20;
  List<Data> list=[];

  @override
  void initState() {
    super.initState();
    _scrollController = initScrollController(isfresh: false);
    _getMyIssueList();
  }

  @override
  Widget addChildren() {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          color: Colors.grey[100],
          child: Column(
            children: [
              BackButtonWidget(cb: (){
                Navigator.pop(context);
              }, title: "我的资料"),
              SizedBox(height: ScreenUtil().setHeight(SizeUtil.getHeight(20)),),
              Expanded(child:  StaggeredGridView.countBuilder(
                crossAxisCount: Constant.isPad ? 3 : 2,
                itemCount: list.length,
                primary: false,
                mainAxisSpacing: ScreenUtil().setWidth(SizeUtil.getWidth(Constant.DIS_LIST)),
                crossAxisSpacing: ScreenUtil().setHeight(SizeUtil.getHeight(Constant.DIS_LIST)),
                controller: _scrollController,
                addAutomaticKeepAlives: false,
                padding: EdgeInsets.only(left: ScreenUtil().setWidth(SizeUtil.getWidth(Constant.DIS_LIST)),right: ScreenUtil().setWidth(SizeUtil.getWidth(Constant.DIS_LIST))),
                staggeredTileBuilder: (int index) => StaggeredTile.fit(1),
                //StaggeredTile.count(3,index==0?2:3),
                itemBuilder: (context,index){
                  return GestureDetector(
                    child: CollectTile(
                      smallurl: Constant.parseNewIssueSmallString(list[index].url,list[index].width,list[index].height),
                      url:list[index].url,
                      title: "",
                      name:list[index].name,
                      width:list[index].width,
                      height:list[index].height,
                      ispush: true,
                    ),
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>CollectGalleryPageView(list: list, position: index)));
                    },
                  );
                },
              ))
            ],
          ),
        )
      ),
    );
  }

  @override
  void loadmore() {
    if(!this.isloading){
      _getMyIssueList();
    }
  }

  @override
  void refresh() {
    // TODO: implement refresh
  }


  void _getMyIssueList(){
    var option = {
      "page":page,
      "size":size
    };
    httpUtil.post(DataUtils.api_issuelistbyteacher,data:option).then((value){
      page++;
      hideLoadMore();
      MyIssueBean bean = MyIssueBean.fromJson(json.decode(value));
      if(bean.errno == 0){
        list.addAll(bean.data);
      }else{
        showToast(bean.errmsg);
      }
    });
  }

}