import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yhschool/BaseState.dart';
import 'package:yhschool/bean/column_subscrible_common_bean.dart' as M;
import 'package:yhschool/bean/column_subscrible_list_bean.dart';
import 'package:yhschool/utils/Constant.dart';
import 'package:yhschool/utils/DataUtils.dart';
import 'package:yhschool/utils/HttpUtils.dart';
import 'package:yhschool/utils/SizeUtil.dart';

class ColumnSubscribleTile extends StatefulWidget{

  Data data;
  Function(int id) click;
  ColumnSubscribleTile({Key key,@required this.data,@required this.click}):super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ColumnSubscribleTileState();
  }
}

class ColumnSubscribleTileState extends BaseState<ColumnSubscribleTile>{
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  /**
   * 取消订阅
   */
  void _cancelSubscrible(){
    var option = {
      "columnid":widget.data.columnid
    };
    httpUtil.post(DataUtils.api_removecolumnsubscrible,data: option).then((value){
      M.ColumnSubscribleCommonBean bean = M.ColumnSubscribleCommonBean.fromJson(json.decode(value));
      if(bean.errno == 0){
        widget.click(bean.data.columnid);
      }else{
        showToast(bean.errmsg);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double _height = 500;
    if(widget.data.width != null && widget.data.height != null){
      _height = ScreenUtil().setHeight(SizeUtil.getHeight(Constant.getScaleH(widget.data.width.toDouble(), widget.data.height.toDouble())));
    }
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(ScreenUtil().setWidth(SizeUtil.getWidth(10)))
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                  height: _height,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Constant.getColor(),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: Constant.parseNewColumnListIconString(widget.data.url,widget.data.width,widget.data.height),
                    /*placeholder: (_context, _url) =>
                        Stack(
                          alignment: Alignment(0,0),
                          children: [
                            Image.network(_url,width:double.infinity,height:_height,fit: BoxFit.cover,),
                            Container(
                              width: ScreenUtil().setWidth(40),
                              height: ScreenUtil().setWidth(40),
                              child: CircularProgressIndicator(color: Colors.red,),
                            ),
                          ],
                        ),*/
                    fit: BoxFit.cover,
                  )
              ),
              Positioned(
                top: SizeUtil.getHeight(10),
                right: SizeUtil.getWidth(10),
                child: Text("${widget.data.count.toString()}张图片",style: TextStyle(fontSize: ScreenUtil().setSp(SizeUtil.getFontSize(25))),),
              )
            ],
          ),
          Padding(padding: EdgeInsets.only(
            left:ScreenUtil().setWidth(SizeUtil.getWidth(26)),
            right:ScreenUtil().setWidth(SizeUtil.getWidth(26)),
            top: ScreenUtil().setHeight(SizeUtil.getHeight(20)),
          ),child: Text((widget.data.columnname != null && widget.data.columnname.length > 12) ? widget.data.columnname.substring(0,12) : widget.data.columnname,
            style: Constant.titleTextStyleNormal,),),
          Padding(padding: EdgeInsets.only(
            left: ScreenUtil().setWidth(SizeUtil.getWidth(26)),
            right: ScreenUtil().setWidth(SizeUtil.getWidth(26)),
            top: ScreenUtil().setHeight(SizeUtil.getHeight(10)),
            bottom: ScreenUtil().setHeight(SizeUtil.getHeight(20)),
          ),child:Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(widget.data.nickname == null ? widget.data.username : widget.data.nickname,style: Constant.smallTitleTextStyle,),
              Expanded(
                child: InkWell(
                  onTap: (){
                    if(this.ishttp) return;
                    this.ishttp = true;
                    _cancelSubscrible();
                  },
                  child: Text("取消收藏",textAlign: TextAlign.end,),
                ),
              )
            ],
          ),)
        ],
      ),
    );
  }
}