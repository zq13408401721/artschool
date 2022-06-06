import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomWidget{

  /**
   * 圆形头像
   */
  static Widget CircleHeader(double size,String url){
    return CircleAvatar(
      radius: size,
      backgroundImage: NetworkImage(
        url
      )
    );
  }

  /**
   * 自定义头像组件
   */
  static Widget CircleHeadBox(double size,String url){
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
          image: NetworkImage(url)
        )
      ),
    );
  }

}