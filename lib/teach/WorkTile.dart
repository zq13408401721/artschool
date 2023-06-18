import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yhschool/bean/work_list_bean.dart';
import 'package:yhschool/utils/Constant.dart';
import 'package:yhschool/utils/SizeUtil.dart';
import 'package:yhschool/bean/user_search.dart' as S;

import '../pan/PanUserDetail.dart';

class WorkTile extends StatelessWidget{

  Works data;
  String smallUrl;
  bool ismark; //是否带有标记功能
  Function clickMark;
  Function clickDelete;
  bool isself;
  bool isInClass;
  String avater;

  WorkTile({@required this.data,@required this.ismark=false,@required this.clickMark,@required this.clickDelete,@required this.isself,@required this.isInClass,@required this.avater}){
    smallUrl = Constant.parseNewWorkListIconString(data.url,data.width,data.height);
  }

  bool isShowDelete(){
    if(this.isself){
      return false;
    }
    if(this.isInClass){
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    double _height = ScreenUtil().setHeight(SizeUtil.getHeight(Constant.getScaleH(data.width.toDouble(), data.height.toDouble())));
    return Card(
      color: Colors.white,
      elevation: 0.0,
      child: Stack(
        alignment: Alignment(1,-1),
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  height: _height,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Constant.getColor(),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: smallUrl,
                    //height: ScreenUtil().setHeight(height),
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
              InkWell(
                onTap: (){
                  var param = new S.Result(
                    uid: data.uid,
                    username:data.author,
                    nickname:data.author,
                    avater:avater,
                    role:data.role,
                  );
                  param.panid = "";
                  //进入用户详情页
                  Navigator.push(context, MaterialPageRoute(builder: (context){
                    return PanUserDetail(data: param,);
                  }));
                },
                child: Padding(
                  padding: EdgeInsets.only(top: ScreenUtil().setHeight(SizeUtil.getHeight(20)),left: ScreenUtil().setWidth(SizeUtil.getWidth(20)),right: ScreenUtil().setWidth(SizeUtil.getWidth(40))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ClipOval(
                        child: (avater == null || avater.length == 0)
                            ? Image.asset("image/ic_head.png",width: SizeUtil.getAppWidth(50),height: SizeUtil.getAppWidth(50),fit: BoxFit.cover,)
                            : CachedNetworkImage(imageUrl: avater,width: SizeUtil.getAppWidth(50),height: SizeUtil.getAppWidth(50),fit: BoxFit.cover),
                      ),
                      SizedBox(width: SizeUtil.getAppWidth(10),),
                      Text(
                        '${data.author}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Constant.titleTextStyleNormal,

                      )
                    ],
                  ),
                )
              ),
              Padding(
                padding: EdgeInsets.only(top: ScreenUtil().setHeight(SizeUtil.getHeight(0)),bottom: ScreenUtil().setHeight(SizeUtil.getHeight(10)),left: ScreenUtil().setWidth(SizeUtil.getWidth(20)),right: ScreenUtil().setWidth(SizeUtil.getWidth(20))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '上传时间${Constant.getHourFormatByString(data.createtime)}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Constant.smallTitleTextStyle
                    ),
                    Offstage(
                      offstage: isShowDelete(),
                      child: InkWell(
                        onTap: (){
                          //删除作业
                          if(this.clickDelete != null){
                            this.clickDelete();
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(20),vertical: ScreenUtil().setHeight(10)),
                          child: Image.asset("image/ic_pan_delete.png",color: Colors.black12,width: ScreenUtil().setWidth(20),height: ScreenUtil().setWidth(20),),
                        )
                      ),
                    )
                  ],
                ),
              ),
              Offstage(
                offstage: !ismark,
                child: InkWell(
                  onTap: (){
                    //标记当前的作业是否是优秀作品
                    clickMark();
                  },
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: ScreenUtil().setWidth(SizeUtil.getWidth(20)),
                      bottom: ScreenUtil().setWidth(SizeUtil.getWidth(10))
                    ),
                    child: data.grade == 0 ?
                    Row(
                      children: [
                        Image.asset("image/ic_comment.png",width: ScreenUtil().setWidth(SizeUtil.getWidth(32)),height: ScreenUtil().setHeight(SizeUtil.getWidth(32)),),
                        Padding(padding: EdgeInsets.only(left: ScreenUtil().setSp(10)),
                          child: Text("评优秀",style: TextStyle(fontSize: ScreenUtil().setSp(SizeUtil.getFontSize(30))),),
                        )
                      ],
                    ) :
                    Text("取消标记",style: TextStyle(fontSize: ScreenUtil().setSp(SizeUtil.getFontSize(30))),),
                  )
                ),
              )
            ],
          ),
          //分数
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Offstage(
                offstage: data.score == null || data.score == 0,
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.blueAccent
                  ),
                  padding: EdgeInsets.all(ScreenUtil().setWidth(SizeUtil.getWidth(10))),
                  child: Text("${data.score}分",style: TextStyle(fontSize: ScreenUtil().setSp(SizeUtil.getFontSize(30)),color: Colors.white,),),
                ),
              ),
              Offstage(
                offstage: data.correct == null,
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.purple
                  ),
                  padding: EdgeInsets.all(ScreenUtil().setWidth(SizeUtil.getWidth(10))),
                  child: Text("已评",style: TextStyle(fontSize: ScreenUtil().setSp(SizeUtil.getFontSize(30)),color: Colors.white),),
                ),
              ),
              Offstage(
                offstage: data.grade == 0,
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.red
                  ),
                  padding: EdgeInsets.all(ScreenUtil().setWidth(SizeUtil.getWidth(10))),
                  child: Text("优秀",style: TextStyle(fontSize: ScreenUtil().setSp(SizeUtil.getFontSize(30)),color: Colors.white,),),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

}