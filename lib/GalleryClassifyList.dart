
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yhschool/BaseState.dart';
import 'package:yhschool/GalleryListPage.dart';
import 'package:yhschool/bean/entity_gallery_classify.dart';
import 'package:yhschool/bean/entity_gallery_more.dart';
import 'package:yhschool/utils/Constant.dart';
import 'package:yhschool/utils/DataUtils.dart';
import 'package:yhschool/utils/HttpUtils.dart';
import 'package:yhschool/utils/ImageType.dart';

import 'TileCard.dart';

class GalleryClassifyList extends StatefulWidget{

  int pid = 0; //上一级的分类id
  String section;
  String category;

  GalleryClassifyList({Key key,@required this.pid,@required this.section,@required this.category}):super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new GalleryClassifyState()
        ..pid=pid
        ..section=section
        ..category=category;
  }
}

class GalleryClassifyState extends BaseState<GalleryClassifyList>{

  String section,category;
  int pid;
  List<GalleryMoreDataData> list = [];
  int page=1,size=20;

  @override
  void initState(){
    getClassifyList();
  }

  getClassifyListReturn(GalleryMore result){
    if(result.errno != 0){
      return showToast(result.errmsg);
    }
    if(result.data.data.length > 0){
      setState(() {
        this.list.addAll(result.data.data);
      });
    }
  }

  /**
   * 获取分类数据
   */
  getClassifyList(){
    var option = {
      "pid":this.pid,
      "page":this.page,
      "size":this.size
    };
    httpUtil.post(DataUtils.api_gallery_more,data: option).then((value){
       String result = checkLoginExpire(value);
       if(result.isNotEmpty){
         getClassifyListReturn(new GalleryMore.fromJson(json.decode(value)));
       }
    }).catchError((err)=>{
      print(err)
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(top: ScreenUtil().setHeight(10),bottom: ScreenUtil().setHeight(10),left: ScreenUtil().setWidth(10)),
                    child: GestureDetector(
                      child: Text(
                        "返回",
                        style: TextStyle(fontSize: ScreenUtil().setSp(42)),
                      ),
                      onTap: (){
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.only(top: ScreenUtil().setHeight(10),bottom: ScreenUtil().setHeight(10),left: ScreenUtil().setWidth(10)),
                    child: Text(this.section + " | " + this.category, style: TextStyle(
                        fontSize: Constant.FONT_TITLE_SIZE,
                        color: Constant.COLOR_TITLE),),
                  )
                ],
              ),
              GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: this.list.length,
                  padding: EdgeInsets.only(top: ScreenUtil().setHeight(20)),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisSpacing: Constant.GARRERY_GRID_CROSSAXISSPACING,
                      mainAxisSpacing: ScreenUtil().setWidth(Constant.PADDING_GALLERY_CROSS),
                      crossAxisCount: 3,
                      childAspectRatio: Constant.isPad ? 1.22 : 1.15
                  ),
                  itemBuilder: (context,index){
                    return GestureDetector(
                      onTap: (){
                        //点击事件
                        Navigator.push(context, MaterialPageRoute(builder: (context) =>
                            GalleryListPage(categoryid: this.list[index].id,section: this.section,categroyname: this.category,imageType: ImageType.smallOffical,)
                        ));
                      },
                      child: Container(
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(ScreenUtil().radius(20.0))),
                          ),
                          child: TileCard(url: this.list[index].cover,title: this.list[index].name,width: double.infinity,height: Constant.GARRERY_ITEM_HEIGHT),
                        ),
                      ),
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }
}