
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http_parser/http_parser.dart';
import 'package:yhschool/BaseState.dart';
import 'package:yhschool/bean/LocalFile.dart';
import 'package:yhschool/utils/DataUtils.dart';
import 'package:yhschool/utils/HttpUtils.dart';

class PanUploadDialog extends StatefulWidget{
  
  List<LocalFile> list;
  int folderid; //文件上传的文件夹id
  
  PanUploadDialog({Key key,@required this.list,@required this.folderid}):super(key: key);
  
  
  @override
  State<StatefulWidget> createState() {
    return PanUploadState()
      ..list = list
      ..folderid = folderid;
  }
  
}

class PanUploadState extends BaseState<PanUploadDialog>{
  
  List<LocalFile> list;
  int folderid;
  int current = 1;
  int total;
  
  @override
  void initState() {
    super.initState();
    total = list.length;
    _submitData();
  }

  //提交数据
  void _submitData() async {
    List<MultipartFile> imageList = new List<MultipartFile>();
    String uid = await getUid();
    int loaded = 0;
    int index = 0;
    int time = DateTime.now().millisecondsSinceEpoch;
    for (LocalFile localFile in list) {
      index ++;
      //将图片转化为二进制
      File file = new File(localFile.path);
      //ByteData byteData =  await file.readAsBytesSync();
      //ByteData byteData = await rootBundle.load(localFile.path);
      List<int> imageData = file.readAsBytesSync();
      List<String> tmpList = localFile.path.split(".");
      MultipartFile multipartFile = new MultipartFile.fromBytes(
          imageData,
          filename: localFile.filename,
          contentType: MediaType("image", "png")
      );
      imageList.add(multipartFile);
      // 开启上传
      FormData formdata = new FormData.fromMap({
        "file": multipartFile,
        "uid": uid,
        "folderid":folderid,
        "sort":time+index,
        "date":localFile.date
      });
      //上传图片
      httpPanUpload.post(DataUtils.api_panupload, data: formdata).then((value) {
        print(value);
        loaded++;
        this.updateUpload(loaded);
      }).catchError((err){
        loaded++;
        showToast(err.toString());
        this.updateUpload(loaded);
      });
    }
  }

  updateUpload(int loaded){
    setState(() {
      if(current < total){
        current ++;
      }
      //上传完成
      if(loaded >= list.length){
        Navigator.pop(context);
      }
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text("图片上传$current/$total"),
      children: [
        Container(
          height: ScreenUtil().setWidth(40),
          width: ScreenUtil().setWidth(40),
          child: Center(child: CircularProgressIndicator(color: Colors.red,)),
        )
      ],
    );
  }
  
}