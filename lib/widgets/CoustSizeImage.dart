import 'dart:ffi';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:yhschool/utils/Constant.dart';
import 'package:yhschool/utils/SizeUtil.dart';

class CoustSizeImage extends Container{

  int mWidth,mHeight;
  String url;

  CoustSizeImage(@required this.url,{@required mWidth,@required mHeight}):
        super(color: Constant.getColor(),
        width: mWidth == null ? SizeUtil.getAppWidth(500) : double.infinity,
        height: mHeight == null ? SizeUtil.getAppHeight(500) : SizeUtil.getAppHeight(Constant.getScaleH(mWidth.toDouble(), mHeight.toDouble()))){
  }

  @override
  Widget get child => (mWidth == null || mHeight == null) ?
      CachedNetworkImage(
        imageUrl: url,
        fit: BoxFit.cover,
        memCacheWidth: SizeUtil.getAppWidth(1000).toInt()
      ) :
      CachedNetworkImage(
        imageUrl: url,
        fit: BoxFit.cover,
        memCacheWidth: mWidth,
        memCacheHeight: mHeight
      );
}