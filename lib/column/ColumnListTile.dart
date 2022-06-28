import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yhschool/BaseState.dart';
import 'package:yhschool/bean/column_list_bean.dart';
import 'package:yhschool/bean/column_subscrible_common_bean.dart' as M;
import 'package:yhschool/utils/Constant.dart';
import 'package:yhschool/utils/DataUtils.dart';
import 'package:yhschool/utils/HttpUtils.dart';
import 'package:yhschool/utils/SizeUtil.dart';
import 'package:yhschool/widgets/ImagePlaceHolder.dart';

class ColumnListTile extends StatefulWidget{

  Data data;
  ColumnListTile({Key key,@required this.data}):super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ColumnListTileState();
  }

}

class ColumnListTileState extends BaseState<ColumnListTile>{
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }


  /**
   * 订阅当前专栏
   */
  void  _commonSubscrible(){
    var option = {
      "columnid":widget.data.id
    };
    var url = DataUtils.api_addcolumnsubscrible;
    if(widget.data.subscrible > 0){
      url = DataUtils.api_removecolumnsubscrible;
    }
    httpUtil.post(url,data:option).then((value){
      this.ishttp = false;
      M.ColumnSubscribleCommonBean bean = M.ColumnSubscribleCommonBean.fromJson(json.decode(value));
      if(bean.errno == 0){
        setState(() {
          if(widget.data.subscrible > 0){
            widget.data.subscrible = 0;
            showToast("取消收藏成功");
          }else{
            widget.data.subscrible = 1;
            showToast("收藏成功");
          }
        });
      }else{
        showToast(bean.errmsg);
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    double _height = ScreenUtil().setHeight(SizeUtil.getHeight(Constant.getScaleH(widget.data.width.toDouble(), widget.data.height.toDouble())));
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
              /*Container(
                  height: _height,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Constant.getColor(),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: Constant.parseColumnSmallString(widget.data.url),
                    placeholder: (_context, _url) =>
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
                        ),
                    fit: BoxFit.cover,
                  )
              ),*/
              ImagePlaceHolder(url: Constant.parseNewColumnListIconString(widget.data.url,widget.data.width,widget.data.height), width: double.infinity, height: _height),
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
          ),child: Text("${(!Constant.isPad && widget.data.name != null && widget.data.name.length > 12)?widget.data.name.substring(0,12):widget.data.name}",style: Constant.titleTextStyleNormal,maxLines: 1,),),
          Padding(padding: EdgeInsets.only(
            left: ScreenUtil().setWidth(SizeUtil.getWidth(26)),
            right: ScreenUtil().setWidth(SizeUtil.getWidth(26)),
            top: ScreenUtil().setHeight(SizeUtil.getHeight(10)),
            bottom: ScreenUtil().setHeight(SizeUtil.getHeight(20)),
          ),child:Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(widget.data.nickname != null ? widget.data.nickname : widget.data.username,style: Constant.smallTitleTextStyle,),
              Expanded(
                child: InkWell(
                  onTap: (){
                    if(this.ishttp) return;
                    this.ishttp = true;
                    _commonSubscrible();
                  },
                  child: Text(widget.data.subscrible > 0 ? "取消收藏" : "收藏",textAlign: TextAlign.end,style: TextStyle(
                      color: Colors.purpleAccent,fontSize: ScreenUtil().setSp(SizeUtil.getFontSize(30))
                  ),),
                ),
              )
            ],
          ))
        ],
      ),
    );
  }
}
