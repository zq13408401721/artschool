
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:yhschool/BaseState.dart';
import 'package:yhschool/utils/HttpUtils.dart';

class ImageCacheFile extends StatefulWidget{

  String url;

  ImageCacheFile(@required this.url);

  @override
  State<StatefulWidget> createState() {
    return _ImageCacheFileState()..isShow = false;
  }
}

class _ImageCacheFileState extends BaseState<ImageCacheFile>{

  String path;
  bool isShow;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void loadUrl(){
    saveImage(widget.url).then((_path){
      print("图片url:${widget.url} _path:${_path}");
      setState(() {
        path = _path;
        isShow = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if(!isShow){
      loadUrl();
    }
    return Container(
      child: path != null ? Image.file(File(path)) : SizedBox(),
    );
  }
}