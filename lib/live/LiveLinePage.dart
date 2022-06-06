import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yhschool/BasePage.dart';
import 'package:yhschool/BaseState.dart';
import 'package:yhschool/utils/SizeUtil.dart';
import 'package:yhschool/widgets/RoundedButton.dart';

class LiveLinePage extends StatefulWidget{

  String name; //直播间名称
  String qr_url; //二维码链接
  String live_url; //直播链接
  LiveLinePage({@required this.name,@required this.qr_url,@required this.live_url});

  @override
  State<StatefulWidget> createState() {
    return LiveLinePageState();
  }
}


class LiveLinePageState extends BasePage<LiveLinePage>{

  @override
  void initState() {
    super.initState();
  }

  @override
  List<Widget> addChildren() {
    return [
      SizedBox(height: ScreenUtil().setHeight(SizeUtil.getHeight(40)),),
      Image.network(widget.qr_url,width: ScreenUtil().setWidth(SizeUtil.getWidth(300)),height: ScreenUtil().setWidth(SizeUtil.getWidth(300)),),
      SizedBox(height: ScreenUtil().setHeight(SizeUtil.getHeight(40)),),
      RoundedButton(click: (){}, label: "打开微信扫一扫",),
      SizedBox(height: ScreenUtil().setHeight(SizeUtil.getHeight(40)),),
      Text("或将直播链接复制到微信"),
      SizedBox(height: ScreenUtil().setHeight(SizeUtil.getHeight(40)),),
      Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(
          horizontal: ScreenUtil().setWidth(SizeUtil.getWidth(40)),
          vertical: ScreenUtil().setHeight(SizeUtil.getHeight(40)),
        ),
        child: Text(widget.live_url),
      ),
      SizedBox(height: ScreenUtil().setHeight(SizeUtil.getHeight(40)),),
      RoundedButton(click: (){}, label: "复制直播链接",),
    ];
  }

  @override
  String backTitle() {
    return "${widget.name}";
  }

}