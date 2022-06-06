import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yhschool/bean/CollectDB.dart';
import 'package:yhschool/bean/CollectDateDB.dart';
import 'package:yhschool/bean/collect_add_bean.dart';
import 'package:yhschool/bean/collect_date_bean.dart';
import 'package:yhschool/bean/collect_delete_bean.dart';
import 'package:yhschool/bean/entity_gallery_list.dart';
import 'package:yhschool/utils/Constant.dart';
import 'package:yhschool/utils/DBUtils.dart';
import 'package:yhschool/utils/DataUtils.dart';
import 'package:yhschool/utils/HttpUtils.dart';
import 'package:yhschool/utils/ImageType.dart';
import 'package:yhschool/utils/SizeUtil.dart';
import 'package:yhschool/widgets/BackButtonWidget.dart';
import 'package:yhschool/widgets/BaseViewPagerState.dart';
import 'package:yhschool/widgets/PushButtonWidget.dart';

import '../GalleryBig.dart';

class CollectGalleryPageView extends StatefulWidget{

  List<dynamic> list;
  int position;
  CollectGalleryPageView({Key key,@required this.list,@required this.position=0}):super(key: key);

  @override
  State<StatefulWidget> createState() {
    return CollectGalleryPageViewState(list: list,position: position);
  }
}

class CollectGalleryPageViewState extends BaseViewPagerState<dynamic,CollectGalleryPageView>{

  List<dynamic> list;
  int position;

  CollectGalleryPageViewState({Key key,@required this.list,@required this.position}):super(key: key,data: list,start: position,physics:ClampingScrollPhysics());

  /**
   * 页面切换
   */
  @override
  void pageChange() {

  }

  @override
  Widget initChildren(BuildContext context, dynamic data) {
    return Container(
      decoration: BoxDecoration(
        color:Colors.white
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: ScreenUtil().setHeight(SizeUtil.getHeight(Constant.SIZE_TOP_HEIGHT)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BackButtonWidget(
                  cb: (){
                    Navigator.pop(context);
                  },
                  title: data.name,
                ),
                m_role == 1 ? PushButtonWidget(cb: (){
                  pushGallery(context, {
                    "name":m_username == null ? m_nickname : m_username,
                    "url":data.url,
                    "from":data.from,
                    "width":data.width,
                    "height":data.height
                  });
                }, title: "推送") : SizedBox()
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                left: ScreenUtil().setWidth(SizeUtil.getWidth(40)),
                right: ScreenUtil().setWidth(SizeUtil.getWidth(40)),
                top: ScreenUtil().setHeight(SizeUtil.getHeight(40)),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: (){
                        Navigator.pushAndRemoveUntil(context, new MaterialPageRoute(builder: (BuildContext context){
                          return GalleryBig(imgUrl: data.url,imageType: BigImageType.gallery,);
                        }), (route) => true);
                      },
                      child: CachedNetworkImage(
                        imageUrl: data.url,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        /*placeholder: (_context,_url)=>
                            Stack(
                              alignment: Alignment(0,0),
                              children: [
                                Image.network(data,fit: BoxFit.cover,width: double.infinity,),
                                CircularProgressIndicator(
                                  color: Colors.red,
                                  strokeWidth: 2,
                                )
                              ],
                            ),*/
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

}