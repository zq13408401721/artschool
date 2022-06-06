
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:date_format/date_format.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http_parser/http_parser.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:yhschool/BaseState.dart';
import 'package:yhschool/bean/LocalFile.dart';
import 'package:yhschool/bean/issue_date_bean.dart';
import 'package:yhschool/utils/Constant.dart';
import 'package:yhschool/utils/DataUtils.dart';
import 'package:yhschool/utils/HttpUtils.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:yhschool/utils/SizeUtil.dart';

class ColumnUploadDialog extends StatefulWidget{
  List<LocalFile> list;
  int columnid;

  ColumnUploadDialog({Key key,@required this.list,@required this.columnid}):super(key: key);
  @override
  State<StatefulWidget> createState() {
    return ColumnUploadDialogState()
    ..list = list
    ..columnid = columnid;
  }

}

class ColumnUploadDialogState extends BaseState{

  int current=1;
  int total;
  double _w=0,_h=0;
  List<LocalFile> list;
  int columnid;

  int comporessnum = 0; //已经压缩的数量

  @override
  void initState() {
    super.initState();
    total = list.length;
    _compressFile().then((value){
      if(value){
        _submitData();
      }
      setState(() {
      });
    });
  }

  /**
   * 图片压缩中
   */
  Future<bool> _compressFile() async{
    if(total > 0){
      for(var i=0; i<total; i++){
        try{
          String _path = await getFilePath(list[i].data);
          File file = new File(_path);
          Uint8List _list = file.readAsBytesSync();
          //判断图片是否超出限制
          if(_list.lengthInBytes < Constant.MAX_IMAGE){
            comporessnum++;
            list[i].path = _path;
          }else{
            String _comporessPath = await _comporessImage(_path);
            list[i].path = _comporessPath;
            comporessnum++;
          }
        }on Error catch(e){
        }
        //刷新显示
        setState(() {});
      }
    }
    return true;
  }

  /**
   * 压缩图片具体方案
   */
  Future<String> _comporessImage(String _path) async{
    //图片压缩
    File compressImg = (await FlutterNativeImage.compressImage(_path,quality: 80,percentage: 80)) as File;
    return compressImg.path;
  }

  /**
   * 获取本地文件的图片路径
   */
  Future<String> getFilePath(Asset asset) async {

    return await FlutterAbsolutePath.getAbsolutePath(asset.identifier);
  }
  
  //提交数据 只需要提交日期id 班级id已经和日期id进行绑定
  void _submitData() async {
    List<MultipartFile> imageList = new List<MultipartFile>();
    int loaded = 0;
    int index = 0;
    for (LocalFile localFile in list) {
      index++;
      print("上传文件路径：${localFile.path}");
      //将图片转化为二进制
      File file = new File(localFile.path);
      //ByteData byteData =  await file.readAsBytesSync();
      //ByteData byteData = await rootBundle.load(localFile.path);
      List<int> imageData = file.readAsBytesSync();
      MultipartFile multipartFile = new MultipartFile.fromBytes(
          imageData,
          filename: localFile.filename,
          contentType: MediaType("image", "jpg")
      );
      imageList.add(multipartFile);
      // 开启上传 一张图对应会有多个班级日期数据，这里的dateid改为多个
      FormData formdata = new FormData.fromMap({
        "file": multipartFile,
        "columnid": columnid,
        "sort":index
      });
      //上传图片
      httpIssueUpload.post(DataUtils.api_columnupload, data: formdata).then((value) {
        print(value);
        loaded++;
        setState(() {
          updateImgsState(localFile.filename, "上传成功");
          if(current < total){
            current ++;
          }
          //上传完成
          if(loaded >= list.length){
            Navigator.pop(context,true);
          }
        });
      }).catchError((err){
        showToast("文件上传err："+err.toString());
        loaded++;
        setState(() {
          updateImgsState(localFile.filename, "上传失败");
          if(current < total){
            current ++;
          }
          //上传完成
          if(loaded >= list.length){
            Navigator.pop(context,true);
          }
        });
      });
    }
  }

  /**
   * 更新上传图片状态
   */
  void updateImgsState(String name,String state){
    for(LocalFile item in list){
      if(item.filename == name){
        item.uploadState = state;
        break;
      }
    }
  }

  /**
   * 图片文件名裁剪
   */
  String _getFilename(String name){
    if(name.length > 6){
      return "${name.substring(0,6)}...";
    }else{
      return name;
    }
  }

  @override
  Widget build(BuildContext context) {
    _w = ScreenUtil().setWidth(SizeUtil.getWidth(Constant.isPad ? 800 : 600));
    _h = ScreenUtil().setHeight(SizeUtil.getHeight(Constant.isPad ? 800 : 840));
    return UnconstrainedBox(
      child: Stack(
        children: [
          Container(
            width: _w,
            height: _h,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(10),
            ),
            padding: EdgeInsets.all(ScreenUtil().setWidth(20)),
            child: comporessnum < total ? Center(
              child: Text("资源处理中：${comporessnum}/${total}"),
            ) : Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text("图片上传$current/$total",style: TextStyle(fontSize: ScreenUtil().setSp(SizeUtil.getFontSize(50)),color:Colors.black87,fontWeight:FontWeight.normal,decoration: TextDecoration.none),),
                Container(
                  height: ScreenUtil().setHeight(SizeUtil.getHeight(Constant.isPad ? 600 : 620)),
                  alignment: Alignment(0,0),
                  padding: EdgeInsets.only(
                      left: ScreenUtil().setWidth(SizeUtil.getWidth(40)),
                      right: ScreenUtil().setWidth(SizeUtil.getWidth(40))
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 3,
                        child: Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                for(LocalFile item in list) Row(
                                    children: [
                                      Expanded(
                                        flex:2,
                                        child:Text(_getFilename(item.filename),style: TextStyle(fontSize: ScreenUtil().setSp(SizeUtil.getFontSize(32)),color: Colors.black87,decoration: TextDecoration.none,fontWeight: FontWeight.normal),maxLines: 1,overflow: TextOverflow.ellipsis,),
                                      ),
                                      Expanded(
                                        flex:1,
                                        child:Text(item.uploadState,style: TextStyle(fontSize: ScreenUtil().setSp(SizeUtil.getFontSize(32)),color: Colors.red,decoration: TextDecoration.none,fontWeight: FontWeight.normal),),
                                      )
                                    ]
                                )
                              ],
                            )
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Center(child: Container(
                          width: ScreenUtil().setWidth(40),
                          height: ScreenUtil().setWidth(40),
                          child: CircularProgressIndicator(color: Colors.red,),
                        )),
                      )],
                  ),
                )
              ],
            ),
          ),
          /*Container(
            width: ScreenUtil().setWidth(SizeUtil.getWidth(600)),
            height: ScreenUtil().setHeight(SizeUtil.getHeight(600)),
            child: Text(log,style: TextStyle(color: Colors.black54),),
          )*/
        ],
      ),
    );
  }

}