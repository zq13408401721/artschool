import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:yhschool/BaseState.dart';
import 'package:yhschool/bean/LocalFile.dart';
import 'package:yhschool/bean/up_load_head_bean.dart';
import 'package:yhschool/utils/Constant.dart';
import 'package:yhschool/utils/DataUtils.dart';
import 'package:yhschool/utils/HttpUtils.dart';
import 'package:yhschool/video/VideoMorePage.dart';

import 'BackButtonWidget.dart';

class CropImageRoute extends StatefulWidget {

  LocalFile localFile;
  //File image; //原始图片路径
  String uid;


  CropImageRoute(LocalFile localFile,String uid){
    this.localFile = localFile;
    this.uid = uid;
    //image = File(localFile.path);
  }



  @override
  _CropImageRouteState createState() => new _CropImageRouteState()..localFile = localFile;
}

class _CropImageRouteState extends BaseState<CropImageRoute> {

  LocalFile localFile;

  double baseLeft; //图片左上角的x坐标
  double baseTop; //图片左上角的y坐标
  double imageWidth; //图片宽度，缩放后会变化
  double imageScale = 1; //图片缩放比例
  Image imageView;
  bool isloading=false;
  File image;

  @override
  void initState() {
    super.initState();

    _comporessAvater();

  }

  void _comporessAvater() async{
    //头像压缩
    String _path = await getFilePath(localFile.data);
    File file = new File(_path);
    Uint8List _list = file.readAsBytesSync();
    //判断图片是否超出限制
    if(_list.lengthInBytes < Constant.MAX_IMAGE_AVATER){
      String _comporessPath = await _comporessImage(_path);
      image = File(_comporessPath);
    }else{
      image = file;
    }
    setState(() {});
  }

  /**
   * 压缩图片具体方案
   */
  Future<String> _comporessImage(String _path) async{
    //图片压缩
    File compressImg = (await FlutterNativeImage.compressImage(_path,quality: 50,percentage: 50)) as File;
    return compressImg.path;
  }

  /**
   * 获取本地文件的图片路径
   */
  Future<String> getFilePath(Asset asset) async {
    return await FlutterAbsolutePath.getAbsolutePath(asset.identifier);
  }
  //final cropKey = GlobalKey<CropState>();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: Stack(
          children: [
            Column(
              children: [
                MyAppBar(
                  preferredSize: Size.fromHeight(80),
                  childView: Container(
                    padding: EdgeInsets.only(
                        top: ScreenUtil().setHeight(60)
                    ),
                    decoration: BoxDecoration(
                        color:Colors.white
                    ),
                    child: BackButtonWidget(
                      cb: (){
                        Navigator.pop(context);
                      },
                      title: "修改头像",
                    ),
                  ),
                ),
                SizedBox(height: ScreenUtil().setHeight(40),),
                Expanded(
                  child: Container(
                    //height: ScreenUtil().setHeight(size.height),
                    //width: size.width,
                    constraints: BoxConstraints(maxWidth: size.width*2/3,maxHeight: size.height/2),
                    child: Column(
                      children: <Widget>[
                        Container(
                          //height: ScreenUtil().setHeight(size.height) * 0.5,
                          child: image != null ? Image.file(image,fit: BoxFit.cover,) : SizedBox(),
                        ),
                        SizedBox(height: ScreenUtil().setHeight(40),),
                        RaisedButton(
                          color: Colors.red,
                          onPressed: () {
                            if(image != null){
                              _crop(image);
                            }
                          },
                          child: Text("裁 剪",style: TextStyle(color: Colors.white),),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
            Offstage(
              offstage: !isloading,
              child: Container(
                //margin: EdgeInsets.only(top:ScreenUtil().setHeight(40)),
                width: double.infinity,
                height:double.infinity,
                decoration: BoxDecoration(
                  color:Color(0x50000000)
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: ScreenUtil().setWidth(40),
                        height: ScreenUtil().setWidth(40),
                        child: CircularProgressIndicator(color: Colors.red,),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        )
    );
  }

  Future<void> _crop(File originalFile) async {
    File croppedFile = await ImageCropper().cropImage(
      sourcePath: originalFile.path,
      compressFormat: ImageCompressFormat.png
    );
    if (croppedFile != null) {
      print("剪切文件");
      setState(() {
        this.isloading = true;
      });
      upload(croppedFile);
    }

  }

  ///上传头像
  void upload(File file) {
    MultipartFile multipartFile = new MultipartFile.fromBytes(
        file.readAsBytesSync(),
        filename: widget.localFile.filename,
        contentType: MediaType("image", "jpg")
    );
    // 开启上传 一张图对应会有多个班级日期数据，这里的dateid改为多个
    FormData formdata = new FormData.fromMap({
      "file": multipartFile,
      "uid": widget.uid
    });
    //上传图片
    httpIssueUpload.post(DataUtils.api_headupload, data: formdata).then((value) {
      print(value);
      UpLoadHeadBean bean = UpLoadHeadBean.fromJson(json.decode(value));
      if(bean.errno == 0){
        setState(() {
          this.isloading = false;
          setData("avater", bean.data.avater);
          Navigator.pop(context,bean.data);
        });
      }else{
        showToast(bean.msg);
      }
    }).catchError((err){
      setState(() {
        this.isloading = false;
      });
    });
  }
}