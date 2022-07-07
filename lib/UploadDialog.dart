
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
import 'package:yhschool/utils/EnumType.dart';
import 'package:yhschool/utils/HttpUtils.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:yhschool/utils/SizeUtil.dart';
import 'package:yhschool/widgets/CircleProgressWidget.dart';

import 'bean/class_date_bean.dart' as M;
import 'bean/entity_tab_bean.dart';

class UploadDialog extends StatefulWidget{
  List<LocalFile> list;
  List<int> classids; //选中需要发布的班级id
  UploadType uploadType; //上传图片功能列表
  String date; //排课日期
  
  UploadDialog({Key key,@required this.list,@required this.classids,@required this.date,@required this.uploadType=UploadType.ISSUE}):super(key: key);
  @override
  State<StatefulWidget> createState() {
    return UploadState()
    ..imgs = list
    ..classids = classids;
  }

}

class UploadState extends BaseState<UploadDialog>{

  List<LocalFile> imgs;
  List<int> classids; // 多个班级id表示一次要发布到多个班级
  int current=1;
  int total;
  double _w=0,_h=0;

  int comporessnum = 0; //已经压缩的数量

  @override
  void initState() {
    super.initState();
    total = imgs.length;
    print("开始压缩");
    //先进行图片压缩
    _compressFile().then((value){
      if(value){
        _galleryPlan();
      }
    });
    //dateInfo();
  }

  /**
   * 图片压缩中
   */
  Future<bool> _compressFile() async{
    if(total > 0){
      for(var i=0; i<total; i++){
        String _path = await getFilePath(imgs[i].data);
        File file = new File(_path);
        Uint8List _list = file.readAsBytesSync();
        //判断图片是否超出限制
        if(_list.lengthInBytes < Constant.MAX_IMAGE){
          comporessnum++;
          imgs[i].path = _path;
        }else{
          String _comporessPath = await _comporessImage(_path);
          imgs[i].path = _comporessPath;
          comporessnum++;
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

  //图文课堂排课 默认排课为当天的
  void _galleryPlan(){
    //获取对应班级对应的日期id
    getDateIDByClass(this.classids,widget.uploadType==UploadType.ISSUE ? null : widget.date).then((value){
      //数组最后还未获得日期id数据的班级id如果还存在这种情况需要去服务器重新获取对应的日期id
      if(value[2].length > 0){
        //班级id转成逗号分隔的字符串
        String ids = value[2].map((e) => e).join(",");
        var option = {
          "ids":ids,
        };
        String date;
        if(widget.date != null){
          option["date"] = widget.date;
          date = widget.date;
        }else{
          date = formatDate(DateTime.now(),[yyyy,"-",mm,"-",dd]);
        }
        httpUtil.post(DataUtils.api_manydatebyclass,data: option).then((result) {
          print(result);
          M.ClassDateBean classDate = new M.ClassDateBean.fromJson(json.decode(result));
          if(classDate.errno == 0){
            //合并已有的数据和请求回来的班级日期数据
            List<int> list = [];
            List<int> tempCid = [];
            tempCid.addAll(value[0]);
            if(value[1].length > 0){
              list.addAll(value[1]);
            }
            for(M.Dates data in classDate.data.dates) {
              tempCid.add(int.parse(data.classid));
              list.add(data.dateid);
            }
            List<String> keys = [];
            for(int _id in tempCid){
              keys.add(_id.toString()+"-"+date);
            }
            //保存日期数据到本地
            saveManyDateId(keys,list);
            _submitData(list);
          }else{
            //请求数据id的班级出错查看以有的班级日期id数据是否存在，存在直接发布已经存在的数据
            showToast(classDate.errmsg);
            if(value[1].length > 0){
              _submitData(value[1]);
            }
          }
        });
      }else{ //需要发布的班级id齐全直接发布
        _submitData(value[1]);
      }
    });
  }

  //提交数据 只需要提交日期id 班级id已经和日期id进行绑定
  void _submitData(List<int> dateids) async {
    List<MultipartFile> imageList = new List<MultipartFile>();
    String schoolid = await getSchoolid();
    String uid = await getUid();
    var info = await getUserInfo();
    String username = "";
    if(info["nickname"] == null){
      username = info["username"];
    }else{
      username = info["nickname"];
    }
    int loaded = 0;
    int index = 0;
    int time = DateTime.now().millisecondsSinceEpoch;
    String dateidsStr = dateids.map((e) => e).join(",");
    for (LocalFile localFile in imgs) {
      index ++;
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
        "schoolid": schoolid,
        "name":username,
        "uid": uid,
        "role":1,
        "dateid":dateidsStr,
        "sort":time+index
      });
      //上传图片
      httpIssueUpload.post(DataUtils.api_issueupload, data: formdata).then((value) {
        print("图片上传成功：${value}");
        loaded++;
        setState(() {
          updateImgsState(localFile.filename, "成功");
          if(current < total){
            current ++;
          }
          //上传完成
          if(loaded >= imgs.length){
            Navigator.pop(context);
          }
        });
      }).catchError((err){
        showToast("文件上传失败：${localFile.filename} "+err.toString());
        loaded++;
        setState(() {
          updateImgsState(localFile.filename, "失败");
          if(current < total){
            current ++;
          }
          //上传完成
          if(loaded >= imgs.length){
            Navigator.pop(context);
          }
        });
      });
    }
  }

  /**
   * 更新上传图片状态
   */
  void updateImgsState(String name,String state){
    for(LocalFile item in imgs){
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
    return UnconstrainedBox(
      child: Container(
        width: ScreenUtil().setWidth(SizeUtil.getWidth(Constant.isPad ? 800 : 600)),
        height: ScreenUtil().setHeight(SizeUtil.getHeight(Constant.isPad ? 760 : 840)),
        padding: EdgeInsets.only(
            top: ScreenUtil().setHeight(SizeUtil.getHeight(20)),
            bottom: ScreenUtil().setHeight(SizeUtil.getHeight(20)),
            left: ScreenUtil().setWidth(SizeUtil.getWidth(20)),
            right: ScreenUtil().setWidth(SizeUtil.getWidth(20))
        ),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(SizeUtil.getWidth(10)),
        ),
        child: comporessnum < total ? Center(
          child: Text("资源处理中：${comporessnum}/${total}",style: TextStyle(color:Colors.grey,fontSize: ScreenUtil().setSp(30),fontWeight: FontWeight.normal,decoration: TextDecoration.none),),
        ) :Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text("图片上传$current/$total",style: TextStyle(fontSize: ScreenUtil().setSp(SizeUtil.getFontSize(40))),),
            Container(
              width: double.infinity,
              height: ScreenUtil().setHeight(SizeUtil.getHeight(Constant.isPad ? 500 : 620)),
              padding: EdgeInsets.only(
                  left: ScreenUtil().setWidth(SizeUtil.getWidth(40)),
                  right: ScreenUtil().setWidth(SizeUtil.getWidth(40))
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 3,
                    child: Container(
                      child: ListView.builder(
                        itemCount: imgs.length,
                        itemBuilder: (_context,_index){
                          return Padding(
                            padding:EdgeInsets.symmetric(
                              vertical: ScreenUtil().setHeight(3)
                            ),
                            child: Row(
                                children: [
                                  Expanded(
                                    flex:2,
                                    child:Text(_getFilename(imgs[_index].filename),style: TextStyle(fontSize: ScreenUtil().setSp(SizeUtil.getFontSize(32)),color: Colors.black87),maxLines: 1,overflow: TextOverflow.ellipsis,),
                                  ),
                                  Expanded(
                                      flex:1,
                                      child: Text(imgs[_index].uploadState,style: TextStyle(fontSize: ScreenUtil().setSp(SizeUtil.getFontSize(32)),color:Colors.red))
                                  )
                                ]
                            ),
                          );
                        },
                      ),
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
    );
  }

}