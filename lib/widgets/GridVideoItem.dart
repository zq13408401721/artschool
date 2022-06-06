import 'dart:js';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yhschool/utils/Constant.dart';
import 'package:yhschool/widgets/ClickCallback.dart';

class GridVideoItem extends Container{

  ItemClick itemClick; //接口回调

  int pos; //当前的下标
  String url; //当前图片地址
  String name; //图片显示的名字
  int width,height; //设置当前图片的显示宽高

  GridVideoItem({this.pos,this.url,this.name,this.width,this.height,this.itemClick});

  Widget createImage(BuildContext context){
    return (this.width > 0 && this.height > 0) ?
      CachedNetworkImage(
        imageUrl: '$url',
        fit: BoxFit.cover,
        height: this.height > 0 ? this.height : MediaQuery.of(context).size.height,
        width: this.width > 0 ? this.width : MediaQuery.of(context).size.width,
      ) :
      CachedNetworkImage(
          imageUrl: '$url',
          fit: BoxFit.cover
      );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Card(
        child: Column(
          children: [
            createImage(context),
            Padding(
              padding: EdgeInsets.only(left:2,top: 5,right: 0,bottom: 5),
              child: Text('$name',style: TextStyle(fontSize: Constant.FONT_GRID_NAME_SIZE,color: Constant.COLOR_TITLE),),
            ),
          ],
        ),
      ),
      onTap: (){
        if(this.itemClick != null){
          this.itemClick(pos);
        }
      },
    );
  }

}