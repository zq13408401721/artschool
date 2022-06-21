import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yhschool/BasePhotoState.dart';
import 'package:yhschool/BaseState.dart';
import 'package:yhschool/bean/column_mine_bean.dart';
import 'package:yhschool/utils/Constant.dart';
import 'package:yhschool/utils/SizeUtil.dart';

import 'ColumnDetail.dart';

class ColumnMineTile extends StatefulWidget{

  Data data;
  Function cb;
  ColumnMineTile({Key key,@required this.data,@required this.cb}):super(key: key){
    if(data.width == null) data.width = SizeUtil.getWidth(200).toInt();
    if(data.height == null) data.height = SizeUtil.getHeight(200).toInt();
    if(data.url == null) data.url = "";
    this.cb = cb;
  }

  @override
  State<StatefulWidget> createState() {
    return ColumnMineTileState();
  }

}

class ColumnMineTileState extends BasePhotoState<ColumnMineTile>{
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  /**
   * 编辑专栏
   */
  void _editorColumn(){
    /*showDialog(context: context, builder: (context){
      return StatefulBuilder(
          builder: (_context,_state){
            return DialogPush(classesList: classes,);
          }
      );
    })*/
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
          Offstage(
            offstage: widget.data.url.length != 0,
            child: InkWell(
              onTap: (){
                print("请上传作品");
                /*openColumnGallery(context, widget.data.id, (bool value){
                  if(value){
                    print("上传完成");
                    widget.cb(value);
                  }
                });*/
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>ColumnDetail(
                  columnname: widget.data.name,
                  columnid: widget.data.id,
                  author: widget.data.nickname == null ? widget.data.username : widget.data.nickname,
                  uid: widget.data.uid,
                  count: widget.data.number,
                  avater: widget.data.avater,
                  issubscrible: true,
                  visible: widget.data.visible,
                  iscommon:true,
                  cb: (id,subscrible){

                  },
                ))).then((value){
                  //没有图片是否刷新
                  if(value){
                    //图片删除完，刷新列表
                    widget.data.url = "";
                    widget.cb(true);
                  }
                });
              },
              child: Container(
                height: ScreenUtil().setHeight(SizeUtil.getHeight(300)),
                color: Constant.getColor(),
                child: Center(
                  child: Text("请上传作品"),
                ),
              ),
            ),
          ),
          Stack(
            children: [
              Offstage(
                offstage: widget.data == null || widget.data.url == null || widget.data.url.length == 0,
                child: InkWell(
                  onTap: (){
                    //点击专栏条目 打开专栏图片页面
                    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>ColumnDetail(
                      columnname: widget.data.name,
                      columnid: widget.data.id,
                      author: widget.data.nickname == null ? widget.data.username : widget.data.nickname,
                      uid: widget.data.uid,
                      count: widget.data.number,
                      avater: widget.data.avater,
                      issubscrible: true,
                      visible: widget.data.visible,
                      iscommon:true,
                      cb: (id,subscrible){

                      },
                    ))).then((value){
                      //没有图片是否刷新
                      if(value){
                        //图片删除完，刷新列表
                        widget.data.url = "";
                        widget.cb(true);
                      }
                    });
                  },
                  child: Container(
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
                ),
              ),
              Positioned(
                top: SizeUtil.getHeight(10),
                right: SizeUtil.getWidth(10),
                child: Text("${widget.data.number.toString()}张图片",style: TextStyle(fontSize: ScreenUtil().setSp(SizeUtil.getFontSize(25))),),
              )
            ],
          ),
          Padding(padding: EdgeInsets.only(
            left:ScreenUtil().setWidth(SizeUtil.getWidth(26)),
            right:ScreenUtil().setWidth(SizeUtil.getWidth(26)),
            top: ScreenUtil().setHeight(SizeUtil.getHeight(20)),
          ),child:Text("${widget.data.name}",style:Constant.titleTextStyleNormal,),),
          Padding(padding: EdgeInsets.only(
            left: ScreenUtil().setWidth(SizeUtil.getWidth(26)),
            right: ScreenUtil().setWidth(SizeUtil.getWidth(26)),
            top: ScreenUtil().setHeight(SizeUtil.getHeight(10)),
            bottom: ScreenUtil().setHeight(SizeUtil.getHeight(20)),
          ),child:Text(widget.data.nickname != null ? widget.data.nickname : widget.data.username,style: Constant.smallTitleTextStyle,),),
        ],
      ),
    );
  }
}