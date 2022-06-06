import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yhschool/BaseState.dart';
import 'package:yhschool/VideoDetail.dart';
import 'package:yhschool/VideoWeb.dart';
import 'package:yhschool/bean/video_category.dart';
import 'package:yhschool/utils/Constant.dart';
import 'package:yhschool/utils/DataUtils.dart';
import 'package:yhschool/utils/HttpUtils.dart';
import 'package:yhschool/utils/PluginManager.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'TileCard.dart';

class VideoMore extends StatefulWidget{
  
  String section,categoryname;
  int pid;
  
  VideoMore({Key key,this.section,this.categoryname,this.pid}):super(key: key);
  
  @override
  State<StatefulWidget> createState() {
    return VideoMoreState()
        ..section = this.section
        ..categoryname = this.categoryname
        ..pid = this.pid;
  }
  
}

class VideoMoreState extends BaseState<VideoMore>{
  
  String section,categoryname;
  int pid,page=1,size=20;
  
  List<Data> list=[];
  
  @override
  void initState(){
    getVideoMore();
  }
  
  getVideoMoreReturn(VideoCategory result){
    if(result.errno != 0){
      return showToast(result.errmsg);
    }
    setState(() {
      list.addAll(result.data);
    });
  }
  
  getVideoMore(){
    var option = {
      "categoryid":this.pid,
      "page":this.page,
      "size":this.size
    };
    httpUtil.post(DataUtils.api_video_category_more,data: option).then((value){
      String result = checkLoginExpire(value);
      if(result.isNotEmpty){
        getVideoMoreReturn(new VideoCategory.fromJson(json.decode(value)));
      }
    }).catchError((err)=>{
      print(err)
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(Constant.PADDING_LEFT, 0, Constant.PADDING_RIGHT, 0),
          child: Column(
            children: [
              Container(
                width: ScreenUtil().setWidth(double.infinity),
                alignment: Alignment(0,0),
                decoration: BoxDecoration(
                    color:Colors.white
                ),
                padding: EdgeInsets.only(left: ScreenUtil().setWidth(Constant.PADDING_GALLERY_LEFT-40)),
                child: Padding(
                  padding: EdgeInsets.only(left: ScreenUtil().setWidth(40),right: ScreenUtil().setWidth(40),top: ScreenUtil().setHeight(15),bottom: ScreenUtil().setHeight(15)),
                  child: Text(this.section+" | "+this.categoryname,style: TextStyle(fontSize: ScreenUtil().setSp(42),color: Constant.COLOR_TITLE),),
                ),
              ),
              GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: list.length,
                  padding: EdgeInsets.only(top: ScreenUtil().setHeight(20)),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: ScreenUtil().setWidth(Constant.PADDING_GALLERY_CROSS),
                      crossAxisSpacing: Constant.GARRERY_GRID_CROSSAXISSPACING,
                      childAspectRatio: Constant.isPad ? 1.12 : 1.05
                  ),
                  itemBuilder: (context,index){
                    return InkWell(
                      child: Container(
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(ScreenUtil().radius(20.0))),
                          ),
                          child: TileCard(url: list[index].cover,title: list[index].name,width: double.infinity,height: Constant.GARRERY_ITEM_HEIGHT),
                        ),
                      ),
                      onTap: () async {
                        print("点击对应的视频");
                        //原生实现播放页面跳转
                        /*String response;
                        try {
                          var prefs = await SharedPreferences.getInstance();
                          var token = prefs.getString("token");
                          var param = {
                            "classify":this.section,
                            "section":this.categoryname,
                            "category":list[index].name,
                            "categoryid":list[index].id,
                            "token":token
                          };
                          response = await PluginManager.pushVideoActivity(param);
                        }on PlatformException{
                          response = '失败';
                        }*/

                        Navigator.push(context, MaterialPageRoute(builder: (context) =>
                            VideoWeb(classify: this.section, section: this.categoryname, category: this.list[index].name, categoryid: this.list[index].id,)
                        ));
                        /*Navigator.push(context, MaterialPageRoute(builder: (context) =>
                                VideoDetail(classify: selectTab, section: item.categoryname, category: item.categorys[index].name, categoryid: item.categorys[index].id,)
                            ))*/
                      },
                    );
                  }),
              Padding(
                padding: EdgeInsets.only(top: ScreenUtil().setHeight(20)),
                child: Divider(
                  color: Colors.grey[300],
                  thickness: ScreenUtil().setHeight(4),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}