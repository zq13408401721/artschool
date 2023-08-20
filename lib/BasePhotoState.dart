import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:yhschool/BaseRefreshState.dart';
import 'package:yhschool/BaseState.dart';
import 'package:yhschool/PanUploadDialog.dart';
import 'package:yhschool/bean/BookListBean.dart';
import 'package:yhschool/column/ColumnUploadDialog.dart';
import 'package:yhschool/popwin/PopWinUploadShortVideo.dart';
import 'package:yhschool/popwin/PopWinUploadWork.dart';
import 'package:yhschool/utils/Constant.dart';
import 'package:yhschool/utils/DataUtils.dart';
import 'package:yhschool/utils/EnumType.dart';
import 'package:yhschool/utils/HttpUtils.dart';
import 'package:yhschool/utils/PluginManager.dart';
import 'package:yhschool/widgets/CropImageRoute.dart';

import 'FlutterPlugins.dart';
import 'UploadDialog.dart';
import 'bean/LocalFile.dart';

/**
 * 具备相机相册功能的State
 */
abstract class BasePhotoState<T extends StatefulWidget> extends BaseState<T>{

  List<Asset> _imgs = [];
  List<LocalFile> _files = []; //当前选中文件的路径
  int folderid;
  UploadType _uploadType;
  List<int> classids=[]; //选择需要发布的班级id
  String _uid;
  int columnid; //专栏id
  String _date; //当前图片上传对应的排课日期

  // 打开网盘相册选择功能
  void openPanGallery(BuildContext context,int folderid,Function cb) async{
    this.folderid = folderid;
    _uploadType = UploadType.PAN;
    _openGallery(context, cb,9);
  }

  //发布功能打开相册选择功能
  void openIssueGallery(BuildContext context,List<int> classids,Function cb) async{
    this.classids = classids;
    _uploadType = UploadType.ISSUE;
    _openGallery(context, cb,9);
  }

  /**
   * 图文排课
   */
  void openPlanGallery(BuildContext context,List<int> classids,String date,Function cb) async{
    _date = date;
    this.classids = classids;
    _uploadType = UploadType.PLAN;
    _openGallery(context, cb, 9);
  }

  //打开相册上传作业
  void openWorkGallery(BuildContext context,List<int> classids,Function cb) async{
    this.classids = classids;
    _uploadType = UploadType.WORK;
    _openGallery(context, cb,9);
  }

  /**
   * 打开相册传头像
   */
  void openAvaterGallery(BuildContext context,String uid,Function cb) async{
    _uploadType = UploadType.AVATAR;
    _uid = uid;
    _openGallery(context, cb,1);
  }

  /**
   * 打开专栏上传页面
   */
  void openColumnGallery(BuildContext context,int columnid,Function cb) async{
    _uploadType = UploadType.COLUMN;
    this.columnid = columnid;
    _openGallery(context, cb, 9);
  }

  /**
   * 打开小视频上传 压缩视频
   */
  void openSmallVideo(BuildContext context,Function cb) async{
    _opeonVideo().then((value) async {
      var file = File(value.path);
      var bytes = await file.readAsBytes();
      print("视频文件大小：${bytes.length}");
    });
  }

  /**
   * 打开本地相机相册图片选取功能
   */
  void _openGallery(BuildContext context,Function cb,int max) async {
    //先进行相机相册权限判断
    //如果是android14以上单独处理
    if(this.isAndroid){
      //检查android13是否有相机相册权限
      var _res = await FlutterPlugins.hasAndroidPermission();
      //当前sdk小于android13
      if(_res == 1000){
        await permissionPhoto((result){
          if(!result){
            print("没有打开对应的权限");
            showToast("没有相机相册权限无法使用该功能");
            return;
          }
          print("打开相册");
          photos(cb,max);
        });
      }else if(_res == -1){ //android13 但是权限没有申请下来
        //先提示权限用途
        await showSdCardPermissionDialog(context,callback: () async{
          var result = await FlutterPlugins.requestAndroidPermission();
          if(result == 1) {
            photos(cb,max);
          }else{
            showToast("没有相机相册权限无法使用该功能");
          }
        });
      }else{
        photos(cb,max);
      }
    }else{
      photos(cb,max);
    }
  }

  void photos(Function cb,int max){
    MultiImagePicker.pickImages(
        maxImages: max,
        enableCamera: true,
        selectedAssets: _imgs,
        materialOptions: MaterialOptions(
            startInAllView: true,
            allViewTitle: '所有照片',
            actionBarColor: '#2196f3',
            textOnNothingSelected: '没有选择照片',
            selectionLimitReachedText: '最多选择${max}张照片'
        )
    ).then((value) async {
      print("value :$value");
      if(!mounted || value == null || value.length == 0) return;
      //_imgs = [];
      int sort = 0;
      int time = DateTime.now().millisecondsSinceEpoch;
      String date;
      if(_date == null){
        date = DateTime.fromMillisecondsSinceEpoch(time).toString();
        date = date.split(".")[0];
      }else{
        date = _date;
      }
      print("读取图片返回");
      for(var item in value){
        sort += 1;
        //图片内存大小判断
        //ByteData _data = await item.getByteData();
        //String path = await getFilePath(item);
        LocalFile localFile = new LocalFile(filename: item.name, data: item,sort: time+sort,date: date);
        _files.add(localFile);

        /*print("图片"+item.name+"size:"+_data.lengthInBytes.toString() + "图片上限："+Constant.MAX_IMAGE.toString());
              if(_data.lengthInBytes < Constant.MAX_IMAGE){
                String path = await getFilePath(item);
                LocalFile localfile = new LocalFile(filename: item.name, path: path,sort: time+sort,date: date);
                //_imgs.add(item);
                _files.add(localfile);
              }else{
                //showToast(item.name+"超出限制大小");
                //压缩图片
                String path = await compressImage(item);
                //ByteData byteData = await rootBundle.load(path);
                //print("压缩以后的图片大小："+byteData.lengthInBytes.toString());
                LocalFile localFile = new LocalFile(filename: item.name, path: path,sort: time+sort,date: date);
                _files.add(localFile);
              }*/
      }
      //上传图片文件
      if(_files.length > 0){
        print("本地选择图片数量：${_files.length} ${_files}");
        //如果是学生提交作业，直接上传
        showUploadList(context,cb);
      }
    });
  }

  /**
   * 打开视频选择
   */
  Future<XFile> _opeonVideo() async{
    PickedFile file = await ImagePicker().getVideo(source: ImageSource.gallery);
    await showDialog(context: context,barrierDismissible: false, builder: (context){
      return StatefulBuilder(
        builder: (_context,_state)=>PopWinUploadShortVideo(xFile: file,),
      );
    }).then((value){
      print("value:$value");
      //上传结束直接刷新数据
    });
  }

  /**
   * 获取本地文件的图片路径
   */
  Future<String> getFilePath(Asset asset) async {
    return await FlutterAbsolutePath.getAbsolutePath(asset.identifier);
  }

  /**
   * 图片压缩得到图片的本地路径
   */
  Future<String> compressImage(Asset asset) async {
    //获取图片路径
    String filepath = await FlutterAbsolutePath.getAbsolutePath(asset.identifier);
    //图片压缩
    File compressImg = (await FlutterNativeImage.compressImage(filepath,quality: 80,percentage: 80)) as File;
    return compressImg.path;
  }

  //云盘文件上传弹框
  Future<void> showUploadList(BuildContext context,Function cb) async {
    await showDialog(context: context,barrierDismissible: false, builder: (context){
      return StatefulBuilder(
        builder: (_context,_state){
          //return _uploadType == UploadType.PAN ? PanUploadDialog(list: _files,folderid: folderid,) : UploadDialog(list: _files,classids: this.classids,);
          if(_uploadType == UploadType.PAN) return PanUploadDialog(list: _files,folderid: folderid,);
          if(_uploadType == UploadType.ISSUE) return UploadDialog(list: _files,classids: this.classids,);
          if(_uploadType == UploadType.PLAN) return UploadDialog(list: _files, classids: classids,date: _date,uploadType: UploadType.PLAN,);
          if(_uploadType == UploadType.WORK) return PopWinUploadWork(imgs:_files,classid: classids[0],);
          if(_uploadType == UploadType.AVATAR) return CropImageRoute(_files[0],_uid);
          if(_uploadType == UploadType.COLUMN) return ColumnUploadDialog(list: _files, columnid: columnid);
        },
      );
    }).then((value){
      print("选择上传图片:$value");
      //上传结束直接刷新数据
      _imgs.clear();
      _files.clear();
      cb(value);
    });
  }

}
