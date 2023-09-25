import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:yhschool/BaseCoustRefreshState.dart';
import 'package:yhschool/BaseListRefresh.dart';
import 'package:yhschool/bean/school_video_group_bean.dart';
import 'package:yhschool/bean/school_video_list_bean.dart' as L;
import 'package:yhschool/utils/SizeUtil.dart';
import 'package:yhschool/bean/choice_bean.dart' as C;
import 'package:yhschool/video/SchoolVideoPlayer.dart';

import '../FlutterPlugins.dart';
import '../utils/Constant.dart';
import '../utils/DataUtils.dart';
import '../utils/HttpUtils.dart';
import '../widgets/BackButtonWidget.dart';
import 'VideoChoiceTile.dart';

class SchoolVideoListPage extends StatefulWidget{

  Data data;
  String tab1;
  String tab2;

  SchoolVideoListPage({Key key,@required this.data,@required this.tab1,@required this.tab2}):super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new SchoolVideoListPageState();
  }
}

class SchoolVideoListPageState extends BaseCoustRefreshState<SchoolVideoListPage>{

  ScrollController _scrollController;

  int page = 1;
  int size = 20;

  List<L.Data> videoList = [];

  int total=0;

  @override
  void initState() {
    super.initState();
    _scrollController = initScrollController(isfresh: false);
    getVideoList();
    getVideoTotal();
  }

  @override
  void loadmore() {
    print("loadmore");
    getVideoList();
  }

  @override
  void refresh() {

  }

  /**
   * 视频总数
   */
  void getVideoTotal(){
    var param = {
      "groupid":widget.data.id
    };
    print("video groupid:${widget.data.id}");
    httpUtil.post(DataUtils.api_school_video_group_total,data:param,context: context).then((value){
      print("videogrouptotal $value");
      if(value != null){
        Map<String,dynamic> map = json.decode(value);
        if(map.containsKey("data")){
          total = map["data"];
          setState(() {
          });
        }
      }
    });
  }

  void getVideoList(){
    var param = {
      "groupid":widget.data.id,
      "page":page,
      "size":size
    };
    httpUtil.post(DataUtils.api_school_video_list,data:param,context: context).then((value){
      print("school video list $value");
      hideLoadMore();
      if(value != null){
        if(page == 1){
          videoList.clear();
        }
        L.SchoolVideoListBean bean = L.SchoolVideoListBean.fromJson(json.decode(value));
        if(bean.errno == 0){
          if(bean.data != null && bean.data.length > 0){
            page ++;
          }
          videoList.addAll(bean.data);
        }
        setState(() {
        });
      }
    });
  }

  @override
  List<Widget> addChildren() {
    return [
      //back
      Container(
        child: BackButtonWidget(cb: (){
          Navigator.pop(context);
        },title: "${widget.data.name}",),
      ),
      //title
      Container(
        width: double.infinity,
        color: Colors.white,
        padding: EdgeInsets.only(
          left: SizeUtil.getAppWidth(20),
          right: SizeUtil.getAppWidth(20),
          bottom: SizeUtil.getAppHeight(40),
          top: SizeUtil.getAppHeight(20),
        ),
        margin: EdgeInsets.only(
          bottom: SizeUtil.getAppHeight(20)
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius:BorderRadius.circular(5),
              child: CachedNetworkImage(imageUrl: widget.data.icon,fit: BoxFit.cover,width: SizeUtil.getAppWidth(200),height: SizeUtil.getAppWidth(140),),
            ),
            SizedBox(width: SizeUtil.getAppWidth(20),),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("${subWord(widget.data.name, 8)}",style: TextStyle(fontSize: SizeUtil.getAppFontSize(60),color: Colors.black87),),
                  SizedBox(height: SizeUtil.getAppHeight(10),),
                  RichText(
                    text: TextSpan(
                        children: [
                          TextSpan(text: "${widget.tab1} / ${widget.tab2}",style: TextStyle(fontSize: SizeUtil.getAppFontSize(25),color: Colors.grey)),
                          TextSpan(text: "，已更新",style: TextStyle(fontSize: SizeUtil.getAppFontSize(25),color: Colors.grey)),
                          TextSpan(text: "$total",style: TextStyle(fontSize: SizeUtil.getAppFontSize(25),color: Colors.black87)),
                          TextSpan(text: "个视频",style: TextStyle(fontSize: SizeUtil.getAppFontSize(25),color: Colors.grey))
                        ]
                    ),
                  ),
                  SizedBox(height: SizeUtil.getAppHeight(20),),
                  //Text("本组视频主要应用于央美、清华等学校的校考训练，每位同学至少要熟练掌握1000张范画。",style: TextStyle(fontSize: SizeUtil.getAppFontSize(20),color: Colors.grey,),softWrap: true,)
                ],
              ),
            )
          ],
        ),
      ),
      refreshUI(),
      //video list
      SizedBox(height: SizeUtil.getAppHeight(0),),
      Expanded(
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Padding(
            padding: EdgeInsets.only(
              left:SizeUtil.getAppWidth(20),
              right:SizeUtil.getAppWidth(20),
            ),
            child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: videoList.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisSpacing: SizeUtil.getAppWidth(20),
                    mainAxisSpacing: SizeUtil.getAppWidth(20),
                    crossAxisCount: 2,
                    childAspectRatio: Constant.isPad ? 1.30 : 1.2
                ),
                itemBuilder: (context,index){
                  var _data = C.Data(
                      id: videoList[index].id,
                      name:videoList[index].name,
                      cover:videoList[index].cover,
                      title:""
                  );
                  return InkWell(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>
                          SchoolVideoPlayer(url: videoList[index].url,icon: widget.data.icon,total: total,name: videoList[index].name.split(".")[0],)
                      ));
                      //FlutterPlugins.setIosVideoPlay(videoList[index].url);
                    },
                    child: VideoChoiceTile(title: videoList[index].name,data: _data,showTitle: false,),
                  );
                }
            ),
          ),
        ),
      ),
      loadmoreUI()
    ];
  }

}