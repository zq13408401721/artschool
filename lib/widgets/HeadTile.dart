
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HeadTile extends StatelessWidget{

  String avater;
  String label;

  HeadTile({@required this.avater,@required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipOval(
            child: (avater == null || avater.length == 0) ? Image.asset("image/ic_head.png",width: ScreenUtil().setWidth(40),height: ScreenUtil().setHeight(40),)
                : CachedNetworkImage(imageUrl: avater,width: ScreenUtil().setWidth(40),height: ScreenUtil().setHeight(40)),
          ),
          SizedBox(width: ScreenUtil().setWidth(20),),
          Text(label,style: TextStyle(fontSize: ScreenUtil().setSp(30)),)
        ],
      ),
    );
  }
}