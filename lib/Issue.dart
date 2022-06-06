import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http_parser/http_parser.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:yhschool/BaseState.dart';
import 'package:yhschool/IssueListPage.dart';
import 'package:yhschool/IssueMore.dart';
import 'package:yhschool/UploadDialog.dart';
import 'package:yhschool/UploadPage.dart';
import 'package:yhschool/bean/LocalFile.dart';
import 'package:yhschool/bean/issue_bean.dart';
import 'package:yhschool/utils/Constant.dart';
import 'package:yhschool/utils/DataUtils.dart';
import 'package:yhschool/utils/HttpUtils.dart';
import 'package:yhschool/utils/ImageType.dart';

import 'TileCard.dart';


/**
 * 发布页面
 */
class Issue extends StatefulWidget{

  Issue({Key key}):super(key: key);

  @override
  BaseState<StatefulWidget> createState() {
    return new IssueState();
  }

}

class IssueState extends BaseState<Issue>{

  List<Asset> _imgs = [];
  List<LocalFile> _files = []; //当前选中文件的路径

  List<Data> issueList = [];

  int page = 1;
  int size = 50;
  int role=0;

  double s_w = ScreenUtil().setWidth(window.physicalSize.width); //屏幕宽度

  @override
  void initState() {
    super.initState();
    getIssueList();
  }

  updataState(){
    getIssueList();
  }

  /*相册*/
  _openGallery(BuildContext context) async {
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
    ).then((value) async {
      if(!mounted) return;
      //_imgs = [];
      for(var item in value){

        LocalFile localFile = new LocalFile(filename: item.name, data: item);
        _files.add(localFile);

        //图片内存大小判断
        /*ByteData _data = await item.getByteData();
        print("图片"+item.name+"size:"+_data.lengthInBytes.toString() + "图片上限："+Constant.MAX_IMAGE.toString());
        if(_data.lengthInBytes < Constant.MAX_IMAGE){
          String path = await getFilePath(item);
          LocalFile localfile = new LocalFile(filename: item.name, path: path);
          //_imgs.add(item);
          _files.add(localfile);
        }else{
          //showToast(item.name+"超出限制大小");
          //压缩图片
          String path = await compressImage(item);
          LocalFile localFile = new LocalFile(filename: item.name, path: path);
          _files.add(localFile);
        }*/
      }
      //上传图片文件
      if(_files.length > 0){
        showUploadList(context);
      }
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

  Future<void> showUploadList(BuildContext context) async {
    await showDialog(context: context,barrierDismissible: false, builder: (context){
      return StatefulBuilder(
        builder: (_context,_state){
          return UploadDialog(list: _files);
        },
      );
    }).then((value){
      //上传结束直接刷新数据
      page = 1;
      this._imgs = [];
      _files = [];
      this.issueList = [];
      getIssueList();
    });
  }


  /**
   * 获取发布列表
   */
  getIssueList(){
    var option = {
      "page":page,
      "size":size
    };

    httpUtil.post(DataUtils.api_issuelist,data: option).then((value){
      String result = checkLoginExpire(value);
      if(result.isNotEmpty){
        IssueBean issueBean = new IssueBean.fromJson(json.decode(value));
        if(issueBean.errno == 0){
          setState(() {
            issueList.addAll(issueBean.data);
          });
        }
      }
    });

    getRole().then((value){
      setState(() {
        role = value;
      });
    });
  }


  //创建列表条目
  Widget createListItem(int _dateid,String date,List<Groups> list){

    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            child: Container(
                padding: EdgeInsets.only(top: ScreenUtil().setHeight(30),bottom: ScreenUtil().setHeight(10)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(date,style: TextStyle(fontSize: Constant.FONT_TITLE_SIZE,color: Constant.COLOR_TITLE),),
                    Text("更多 >",style: TextStyle(fontSize: Constant.FONT_GRID_DESC_SIZE,color: Constant.COLOR_GRID_DESC),)
                  ],
                )
            ),
            onTap: (){
              //进入更多分类
              Navigator.push(context, MaterialPageRoute(builder: (context) =>
                  IssueMore(curDate: date,dateId: _dateid,)
              ));
            },
          ),
          GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: list.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisSpacing: Constant.GARRERY_GRID_CROSSAXISSPACING,
                  mainAxisSpacing: ScreenUtil().setWidth(Constant.PADDING_GALLERY_CROSS),
                  crossAxisCount: 3,
                  childAspectRatio: Constant.isPad ? 1.15 : 1.1
              ),
              itemBuilder: (context,index){
                return GestureDetector(
                  onTap: (){
                    //点击事件
                    Navigator.push(context, MaterialPageRoute(builder: (context) =>
                      IssueListPage(date_id: list[index].dateId,tid: list[index].tid, title: list[index].name,)
                    ));
                  },
                  child: Container(
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(ScreenUtil().radius(20.0))),
                      ),
                      child: Column(
                        children: [
                          Container(
                              padding: EdgeInsets.only(top: ScreenUtil().setHeight(20)),
                              height: Constant.isPad ? ScreenUtil().setHeight(300) : ScreenUtil().setHeight(180),
                              width: ScreenUtil().setWidth(400),
                              child: CachedNetworkImage(
                                imageUrl: list[index].url,
                                //height: ScreenUtil().setHeight(height),
                                placeholder: (_context, _url) =>
                                    Container(
                                      width: 130,
                                      height: 80,
                                      child: Center(
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                          )
                                      ),
                                    ),
                                fit: BoxFit.cover,
                              )),
                          Container(
                            padding: EdgeInsets.only(left: ScreenUtil().setWidth(10),top: ScreenUtil().setHeight(20),bottom: ScreenUtil().setHeight(10)),
                            alignment: Alignment(-1,0),
                            color: Colors.white,
                            child: Text(
                              list[index].name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: Constant.isPad ? ScreenUtil().setSp(32) : ScreenUtil().setSp(48)),

                            ),
                          )
                        ],
                      ),
                      //child: TileCard(url: list[index].url,title: list[index].name,width: double.infinity,height: Constant.GARRERY_ITEM_HEIGHT,imgtype: ImageType.fill,),
                    ),
                  ),
                );
              }),
          Padding(
            padding: EdgeInsets.only(top: ScreenUtil().setHeight(20)),
            child: Divider(
              color: Colors.grey[300],
              thickness: ScreenUtil().setHeight(4),
            ),
          )
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      //padding: EdgeInsets.only(left: ScreenUtil().setWidth(20),right: ScreenUtil().setWidth(20)),
      color: Colors.grey[100],
      child: Column(
        children: [
          Container(
            height: ScreenUtil().setHeight(Constant.SIZE_TOP_HEIGHT),
            padding: EdgeInsets.only(left: ScreenUtil().setWidth(20),right: ScreenUtil().setWidth(20)),
            decoration: BoxDecoration(
              color: Colors.white
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "发布",
                  style: TextStyle(color:Constant.COLOR_TITLE,fontSize: ScreenUtil().setSp(60),fontWeight: FontWeight.bold),
                ),
                if(role == 1)
                  InkWell(
                    child: Container(
                      padding: EdgeInsets.only(top: ScreenUtil().setHeight(10),bottom: ScreenUtil().setHeight(10),left: ScreenUtil().setWidth(40),right: ScreenUtil().setWidth(20)),
                      decoration: BoxDecoration(
                        color: Colors.white
                      ),
                      child: Icon(
                        Icons.add_a_photo,
                      ),
                    ),
                    onTap: (){
                      //进入图片上传页面
                      _openGallery(context);
                    },
                  )
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.fromLTRB(ScreenUtil().setWidth(Constant.PADDING_GALLERY_LEFT), ScreenUtil().setHeight(25), ScreenUtil().setWidth(Constant.PADDING_GALLERY_RIGHT), 0),
              itemCount: issueList.length,
              itemBuilder: (context,index){
                return createListItem(issueList[index].id,issueList[index].date,issueList[index].groups);
              },
            ),
          )
        ],
      ),
    );
  }
}