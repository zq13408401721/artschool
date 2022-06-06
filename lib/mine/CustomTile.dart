import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yhschool/utils/EnumType.dart';
import 'package:yhschool/utils/SizeUtil.dart';

import '../BaseState.dart';

class CustomTile extends StatelessWidget{

  TileType tileType;
  Function cb;
  double leading_w,leading_h;
  String startString,endString;
  double divider;
  double horizontalpadding,verticalpadding;
  String label; //图片紧跟的文本
  CustomTile({@required this.tileType,@required this.leading_w,@required this.leading_h,
    @required this.startString,@required this.endString,@required this.divider,
    @required this.horizontalpadding=20,@required this.verticalpadding=20,@required this.label,@required this.cb});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalpadding,
        vertical: verticalpadding
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey[200],width: this.divider)
        )
      ),
      child: InkWell(
        onTap: cb,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            tileType == TileType.IMAGE ? _imageWidget() : _wordWidget(),
            _endWidget()
          ],
        ),
      ),
    );
  }

  /**
   * 左边图片组件
   */
  Widget _imageWidget(){
    return Row(
      children: [
        ClipOval(
          child: startString.length > 0 ? CachedNetworkImage(imageUrl: startString,width: leading_w-horizontalpadding,height: leading_w-verticalpadding,fit: BoxFit.cover,) :
          Image.asset("image/ic_head.png",width: leading_w-horizontalpadding,height: leading_w-verticalpadding,fit: BoxFit.cover,),
        ),
        SizedBox(width: ScreenUtil().setWidth(SizeUtil.getWidth(20)),),
        (label != null && label.length > 0) ? Text(label) : SizedBox()
      ],
    );
  }

  /**
   * 左边文本组件
   */
  Widget _wordWidget(){
    return Text(startString);
  }

  /**
   * 右边组件
   */
  Widget _endWidget(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(endString,style: TextStyle(color: Colors.grey),),
        Icon(Icons.keyboard_arrow_right)
      ],
    );
  }

}
