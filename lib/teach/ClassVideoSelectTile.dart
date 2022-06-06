
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yhschool/BaseState.dart';
import 'package:yhschool/bean/class_room_datelist_bean.dart';
import 'package:yhschool/bean/video_category.dart' as M;
import 'package:yhschool/utils/Constant.dart';
import 'package:yhschool/utils/SizeUtil.dart';

class ClassVideoSelectTile extends StatefulWidget{

  M.Data categoryData;
  Function callback;

  ClassVideoSelectTile({Key key,@required this.categoryData,@required this.callback=null}):super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ClassVideoSelectTileState();
  }

}

class ClassVideoSelectTileState extends BaseState<ClassVideoSelectTile>{

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(ScreenUtil().setWidth(SizeUtil.getWidth(20))),
          bottomRight: Radius.circular(ScreenUtil().setWidth(SizeUtil.getWidth(20)))
        ),
        color: Colors.white
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              CachedNetworkImage(imageUrl: widget.categoryData.cover),
              Align(
                alignment: Alignment(1,-1),
                child:InkWell(
                  onTap: (){
                    if(!widget.categoryData.select){
                      setState(() {
                        widget.categoryData.select = !widget.categoryData.select;
                        if(widget.callback != null){
                          widget.callback(widget.categoryData.id);
                        }
                      });
                    }else{
                      showToast("当前课程已经添加");
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: ScreenUtil().setWidth(SizeUtil.getWidth(20)),
                        vertical: ScreenUtil().setHeight(SizeUtil.getHeight(10))
                    ),
                    child: Image.asset(widget.categoryData.select ? "image/ic_video_select.png" : "image/ic_video_add.png",width: ScreenUtil().setWidth(SizeUtil.getWidth(60)),height: ScreenUtil().setHeight(SizeUtil.getHeight(60)),),
                  ),
                ),
              )
            ],
          ),
          Spacer(),
          Padding(
            padding: EdgeInsets.only(
                left: ScreenUtil().setWidth(SizeUtil.getWidth(30)),
                right: ScreenUtil().setWidth(SizeUtil.getWidth(30)),
                top: ScreenUtil().setHeight(SizeUtil.getHeight(20)),
                bottom: ScreenUtil().setHeight(SizeUtil.getHeight(10))
            ),
            child: Text(widget.categoryData.name,style: TextStyle(fontSize: ScreenUtil().setSp(SizeUtil.getFontSize(30))),maxLines: 1,),
          ),
        ],
      ),
    );
  }

}