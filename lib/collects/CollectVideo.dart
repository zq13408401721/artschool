import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yhschool/BaseRefreshState.dart';
import 'package:yhschool/BaseState.dart';
import 'package:yhschool/bean/collect_video_bean.dart';
import 'package:yhschool/utils/Constant.dart';
import 'package:yhschool/utils/DataUtils.dart';
import 'package:yhschool/utils/HttpUtils.dart';
import 'package:yhschool/utils/SizeUtil.dart';

import '../TileCard.dart';
import '../VideoWeb.dart';

class CollectVideo extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return CollectVideoState();
  }

}

class CollectVideoState extends BaseRefreshState<CollectVideo>{

  ScrollController _scrollController;
  int page=1,size=20;

  List<Data> videoList = [];

  @override
  void initState() {
    super.initState();
    _scrollController = initScrollController(isfresh: false);
    _queryVideoCollect();
  }

  @override
  void refresh(){

  }

  @override
  void loadmore() {
    if(!isloading){
      _queryVideoCollect();
    }
  }

  void _queryVideoCollect(){
    var option = {
      "page":page,
      "size":size
    };
    httpUtil.post(DataUtils.api_collectvideolist,data:option).then((value){
      page++;
      hideLoadMore();
      CollectVideoBean bean = CollectVideoBean.fromJson(json.decode(value));
      if(bean.errno == 0){
        setState(() {
          videoList.addAll(bean.data);
        });
      }
    });
  }


  @override
  Widget addChildren() {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.only(
            left: ScreenUtil().setWidth(SizeUtil.getWidth(30)),
            right: ScreenUtil().setWidth(SizeUtil.getWidth(30)),
            top: ScreenUtil().setHeight(SizeUtil.getHeight(10))
        ),
        child: GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: videoList.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: ScreenUtil().setWidth(SizeUtil.getWidth(Constant.PADDING_GALLERY_CROSS)),
                crossAxisSpacing: ScreenUtil().setHeight(SizeUtil.getHeight(Constant.GARRERY_GRID_CROSSAXISSPACING)),
                childAspectRatio: Constant.isPad ? 0.86 : 0.8
            ),
            itemBuilder: (BuildContext context,int index){
              return InkWell(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(ScreenUtil().setWidth(SizeUtil.getWidth(20))),
                        bottomRight: Radius.circular(ScreenUtil().setWidth(SizeUtil.getWidth(20)))
                    ),
                  ),
                  padding: EdgeInsets.only(bottom: SizeUtil.getWidth(5)),
                  child: TileCard(url: videoList[index].cover,title: videoList[index].name,width: double.infinity,height: Constant.GARRERY_ITEM_HEIGHT),
                ),
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) =>
                      VideoWeb(classify: videoList[index].subject, section: videoList[index].section, category: videoList[index].name,
                        categoryid: videoList[index].categoryid,description: videoList[index].description,step: [],)
                  ));
                },
              );
            }
        ),
      ),
    );
  }


}