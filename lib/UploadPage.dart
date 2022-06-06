
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:http_parser/http_parser.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:yhschool/BaseState.dart';
import 'package:yhschool/utils/Constant.dart';

class UploadPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return new UploadPageState();
  }
}

class UploadPageState extends BaseState<UploadPage>{

  List<Asset> _imgs = new List<Asset>();

  @override
  void initState() {
    super.initState();
    _openGallery();
  }

  /*相册*/
  _openGallery() async {
    MultiImagePicker.pickImages(
        maxImages: 9,
        enableCamera: true,
        selectedAssets: _imgs,
        materialOptions: MaterialOptions(
            startInAllView: true,
            allViewTitle: '所有照片',
            actionBarColor: '#2196f3',
            textOnNothingSelected: '没有选择照片',
            selectionLimitReachedText: '最多选择9张照片'
        )
    ).then((value){
      if(!mounted) return;
      setState(() async {
        for(var item in value){
          //图片内存大小判断
          ByteData _data = await item.getByteData();
          print("图片"+item.name+"size:"+_data.lengthInBytes.toString() + "图片上限："+Constant.MAX_IMAGE.toString());
          if(_data.lengthInBytes < Constant.MAX_IMAGE){
            _imgs.add(item);
          }else{

          }
        }
      });
    });
  }

  //图片的多次采样



  //提交数据
  void _submitData() async {
    List<MultipartFile> imageList = new List<MultipartFile>();
    for (Asset asset in _imgs) {
      //将图片转化为二进制
      ByteData byteData = await asset.getByteData();
      List<int> imageData = byteData.buffer.asUint8List();
      MultipartFile multipartFile = new MultipartFile.fromBytes(
          imageData,
          filename: "load_image",
          contentType: MediaType("image", "ipg")
      );
      imageList.add(multipartFile);
    }
    //表单提交
    FormData formData = new FormData.fromMap({
      // 后端shiyong multipartFiles接收参数
      "multipartFiles": imageList
    });
    //提交图片到后台

    @override
    Widget build(BuildContext context) {
      return Material(
        child: SafeArea(
          child: Column(
            children: [

            ],
          ),
        ),
      );
    }
  }
}