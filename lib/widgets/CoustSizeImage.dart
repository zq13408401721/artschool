import 'dart:ffi';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:yhschool/utils/Constant.dart';
import 'package:yhschool/utils/SizeUtil.dart';

class CoustSizeImage extends Container{

  int width,height;
  String url;

  CoustSizeImage(@required this.url,{@required width,@required height}):super(color: Constant.getColor()){

  }

  @override
  Widget get child => (width == null || height == null) ?
      CachedNetworkImage(
        imageUrl: url,
        fit: BoxFit.cover,
        memCacheWidth: 1000
      ) :
      CachedNetworkImage(
        imageUrl: url,
        fit: BoxFit.cover,
        memCacheWidth: width,
        memCacheHeight: height
      );
}