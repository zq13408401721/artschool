
import 'dart:convert';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:photo_view/photo_view.dart';
import 'package:yhschool/BaseState.dart';
import 'package:yhschool/bean/CollectDB.dart';
import 'package:yhschool/bean/CollectDateDB.dart';
import 'package:yhschool/bean/collect_add_bean.dart';
import 'package:yhschool/bean/collect_date_bean.dart';
import 'package:yhschool/bean/collect_delete_bean.dart';
import 'package:yhschool/utils/Constant.dart';
import 'package:yhschool/utils/DBUtils.dart';
import 'package:yhschool/utils/DataUtils.dart';
import 'package:yhschool/utils/HttpUtils.dart';
import 'package:yhschool/utils/ImageType.dart';
import 'package:yhschool/widgets/BackButtonWidget.dart';
import 'package:yhschool/widgets/CollectButton.dart';
import 'package:yhschool/widgets/PushButtonWidget.dart';

import '../BaseDialogState.dart';
import '../GalleryBig.dart';

/**
 * 进入教学图片详情展示
 */
class TodayTeachGalleryDetail extends StatefulWidget{

  String name;
  String url;
  String smallUrl;
  String comments;
  String markname;
  String title;
  int id,width,height;
  TodayTeachGalleryDetail({Key key,@required this.name,@required this.url,@required this.smallUrl,@required this.comments,@required this.markname,@required this.title,@required this.id,@required this.width=0,@required this.height=0}):super(key: key);

  @override
  State<StatefulWidget> createState() {
    return TodayTeachGalleryDetailState()
    ..name = name
    ..url = url
    ..smallUrl = smallUrl
    ..comments = comments
    ..markname = markname
    ..title = title
    ..id = id
    ..width = width
    ..height = height;
  }

}

class TodayTeachGalleryDetailState extends BaseDialogState{

  String name;
  String url;
  String smallUrl;
  String comments;
  String markname;
  String title;
  int id,width,height;
  bool waiting = false;
  String uid;
  bool iscollect = false;

  @override
  void initState(){
    super.initState();
    getUid().then((value){
      uid = value;
      DBUtils.dbUtils.then((value){
        value.checkCollect(uid, Constant.COLLECT_CLASS, id).then((value){
          setState(() {
            this.iscollect = value;
          });
        });
      });
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: ScreenUtil().setWidth(40)
          ),
          child:Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: ScreenUtil().setHeight(Constant.SIZE_TOP_HEIGHT),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    BackButtonWidget(cb: (){
                      Navigator.pop(context);
                    }, title: name),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: ScreenUtil().setWidth(30)
                            ),
                            child: InkWell(
                              onTap: (){
                                Navigator.pushAndRemoveUntil(context, new MaterialPageRoute(builder: (BuildContext context){
                                  return GalleryBig(imgUrl: url,imageType: BigImageType.issue,width: width,height: height,);
                                }), (route) => true);
                              },
                              child: Text.rich(
                                  TextSpan(
                                      children: [
                                        WidgetSpan(
                                          alignment:PlaceholderAlignment.middle,
                                          child: Image.asset("image/ic_gallery.png",width: ScreenUtil().setWidth(50),height: ScreenUtil().setHeight(50),),
                                        ),
                                        TextSpan(
                                            text:"全屏查看"
                                        )
                                      ]
                                  )
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: ScreenUtil().setWidth(30)
                            ),
                            child: CollectButton(
                              from: Constant.COLLECT_CLASS,
                              fromid: id,
                              name: name,
                              url: url,
                              width: width,
                              height: height,
                            ),
                          ),
                          //推送
                          m_role == 1 ? PushButtonWidget(cb: (){
                            pushGallery(context, {
                              "name":m_username == null ? m_nickname : m_username,
                              "url":url,
                              "from":Constant.PUSH_FROM_TEACH,
                              "width":width,
                              "height":height,
                            });
                          },title: "推送",) : SizedBox(),
                        ],
                      ),
                    ),

                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CachedNetworkImage(
                        imageUrl: url,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        placeholder: (_context,_url)=>
                            Stack(
                              alignment: Alignment(0,0),
                              children: [
                                Image.network(smallUrl,fit: BoxFit.cover,width: double.infinity,),
                                Container(
                                  width: ScreenUtil().setWidth(40),
                                  height: ScreenUtil().setWidth(40),
                                  child: CircularProgressIndicator(color: Colors.red,),
                                ),
                              ],
                            ),
                      ),
                      SizedBox(height: ScreenUtil().setHeight(40),),
                      Offstage(
                        offstage: markname == null || markname.length == 0,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: ScreenUtil().setWidth(30),
                              vertical: ScreenUtil().setHeight(10)
                          ),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Color.fromARGB(1, 255, 202, 220)
                          ),
                          child: Text(markname == null?"":markname,style: TextStyle(color: Colors.red,fontSize: ScreenUtil().setSp(36)),),
                        ),
                      ),
                      SizedBox(height: ScreenUtil().setHeight(20),),
                      Offstage(
                          offstage: comments == null || comments.length == 0,
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(10)
                            ),
                            padding: EdgeInsets.all(ScreenUtil().setHeight(20)),
                            child: Text(
                              comments != null ? comments : "",
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: Constant.isPad ? ScreenUtil().setSp(36) : ScreenUtil().setSp(42)),
                            ),
                          )
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}