import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yhschool/bean/my_work_bean.dart';
import 'package:yhschool/utils/Constant.dart';

class MyWorkTile extends StatelessWidget{

  Data data;
  String smallUrl;
  bool ismark; //是否带有标记功能
  Function clickMark;

  MyWorkTile({@required this.data}){
    smallUrl = Constant.parseSmallString(data.url, "res.yimios.com:9050/work");
  }

  @override
  Widget build(BuildContext context) {
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
                  height: ScreenUtil().setHeight(Constant.getScaleH(data.width.toDouble(), data.height.toDouble())),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Constant.getColor(),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: smallUrl,
                    //height: ScreenUtil().setHeight(height),
                    placeholder: (_context, _url) =>
                        Container(
                          width: 130,
                          height: 80,
                          child: Center(
                              child: Stack(
                                alignment: Alignment(0,0),
                                children: [
                                  Image.network(_url,fit: BoxFit.cover,),
                                  Container(
                                    width: ScreenUtil().setWidth(40),
                                    height: ScreenUtil().setWidth(40),
                                    child: CircularProgressIndicator(color: Colors.red,),
                                  ),
                                ],
                              )
                          ),
                        ),
                    fit: BoxFit.cover,
                  )
              ),
              Padding(
                padding: EdgeInsets.only(top: ScreenUtil().setHeight(40),left: ScreenUtil().setWidth(10),right: ScreenUtil().setWidth(10)),
                child: Text(
                  '${data.nickname == null ? data.username : data.nickname}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: Constant.isPad ? ScreenUtil().setSp(32) : ScreenUtil().setSp(42)),

                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: ScreenUtil().setHeight(10),bottom: ScreenUtil().setHeight(10),left: ScreenUtil().setWidth(10),right: ScreenUtil().setWidth(10)),
                child: Text(
                  '上传时间${data.createtime}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: Constant.isPad ? ScreenUtil().setSp(32) : ScreenUtil().setSp(42),color: Colors.grey),
                ),
              )
            ],
          ),
          Offstage(
            offstage: data.grade == 0,
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.red
              ),
              padding: EdgeInsets.all(ScreenUtil().setWidth(10)),
              child: Text("优秀作品",style: TextStyle(fontSize: ScreenUtil().setSp(30),color: Colors.white,),),
            ),
          )
        ],
      ),
    );
  }

}