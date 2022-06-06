import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yhschool/bean/work_list_bean.dart';
import 'package:yhschool/utils/Constant.dart';
import 'package:yhschool/utils/SizeUtil.dart';

class WorkTile extends StatelessWidget{

  Works data;
  String smallUrl;
  bool ismark; //是否带有标记功能
  Function clickMark;

  WorkTile({@required this.data,@required this.ismark=false,@required this.clickMark}){
    smallUrl = Constant.parseNewWorkListIconString(data.url,data.width,data.height);
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
              Padding(
                padding: EdgeInsets.only(top: ScreenUtil().setHeight(SizeUtil.getHeight(20)),left: ScreenUtil().setWidth(SizeUtil.getWidth(20)),right: ScreenUtil().setWidth(SizeUtil.getWidth(40))),
                child: Text(
                  '${data.author}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Constant.titleTextStyleNormal,

                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: ScreenUtil().setHeight(SizeUtil.getHeight(5)),bottom: ScreenUtil().setHeight(SizeUtil.getHeight(18)),left: ScreenUtil().setWidth(SizeUtil.getWidth(20)),right: ScreenUtil().setWidth(SizeUtil.getWidth(20))),
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
                      offstage: !ismark,
                      child: InkWell(
                        onTap: (){
                          //标记当前的作业是否是优秀作品
                          clickMark();
                        },
                        child: Text(data.grade == 0 ? "标记优秀作业" : "取消标记",style: TextStyle(fontSize: ScreenUtil().setSp(SizeUtil.getFontSize(30))),),
                      ),
                    )
                  ],
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
              padding: EdgeInsets.all(ScreenUtil().setWidth(SizeUtil.getWidth(10))),
              child: Text("优秀作业",style: TextStyle(fontSize: ScreenUtil().setSp(SizeUtil.getFontSize(30)),color: Colors.white,),),
            ),
          )
        ],
      ),
    );
  }

}