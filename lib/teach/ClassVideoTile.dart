
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yhschool/BaseState.dart';
import 'package:yhschool/bean/class_room_datelist_bean.dart';
import 'package:yhschool/utils/Constant.dart';
import 'package:yhschool/utils/SizeUtil.dart';

class ClassVideoTile extends StatelessWidget{

  Videos videos;
  bool isEditor;
  Function callback;
  String uid; //自己的uid
  ClassVideoTile({Key key,@required this.videos,@required this.isEditor=false,@required this.uid,@required this.callback=null}):super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(ScreenUtil().setWidth(SizeUtil.getWidth(10))),
              bottomRight: Radius.circular(ScreenUtil().setWidth(SizeUtil.getWidth(10)))
          )
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              CachedNetworkImage(imageUrl: videos.cover),
              Positioned(
                top: 0,
                bottom: 0,
                left: 0,
                right: 0,
                child: Offstage(
                  offstage: isEditor==true,
                  child: UnconstrainedBox(
                    child: Container(
                        child: Image.asset(Constant.isPad ? "image/ic_play.png" : "image/ic_play_30.png",width: SizeUtil.getAppWidth(80),height: SizeUtil.getAppWidth(80))
                    )
                  ),
                ),
              ),
              Align(
                alignment: Alignment(1,-1),
                child: Container(
                  decoration: BoxDecoration(
                    color: videos.mark == 1 ? Colors.grey : Colors.red,
                  ),
                  padding: EdgeInsets.symmetric(
                      horizontal: ScreenUtil().setWidth(SizeUtil.getWidth(20)),
                      vertical: ScreenUtil().setHeight(SizeUtil.getHeight(10))
                  ),
                  child: Text(videos.mark == 1 ? "默认课程" : videos.teachername,style: TextStyle(color: Colors.white,fontSize: ScreenUtil().setSp(SizeUtil.getFontSize(30))),),
                ),
              ),
              Positioned(
                top:ScreenUtil().setHeight(SizeUtil.getHeight(20)),
                left: ScreenUtil().setWidth(SizeUtil.getWidth(20)),
                child: Offstage(
                  offstage: (isEditor==false || videos.tid != uid),
                  child: InkWell(
                    onTap: (){
                      //删除课程
                      if(callback != null){
                        callback(videos.id,videos.categoryid,videos.mark);
                      }
                    },
                    child: Image.asset("image/ic_round_close.png",width: ScreenUtil().setWidth(SizeUtil.getWidth(60)),height: ScreenUtil().setHeight(SizeUtil.getHeight(60)),),
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
            child: Text(videos.name != null ? videos.name : "",style: TextStyle(fontSize: ScreenUtil().setSp(SizeUtil.getFontSize(30))),maxLines: 1,),
          ),
          Padding(
            padding: EdgeInsets.only(
                left: ScreenUtil().setWidth(SizeUtil.getWidth(30)),
                right: ScreenUtil().setWidth(SizeUtil.getWidth(30)),
                bottom: ScreenUtil().setHeight(SizeUtil.getHeight(20))
            ),
            child: Text(videos.title,style: Constant.smallTitleTextStyle,maxLines: 1,),
          )
        ],
      ),
    );
  }
}
