import 'dart:convert';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:yhschool/widgets/BaseRefreshViewPagerState.dart';
import 'package:yhschool/bean/pan_file_bean.dart' as F;

import '../GalleryBig.dart';
import '../bean/LocalFile.dart';
import '../bean/pan_file_bean.dart';
import '../utils/Constant.dart';
import '../utils/DataUtils.dart';
import '../utils/HttpUtils.dart';
import '../utils/ImageType.dart';

class PanImageDetailViewPager extends StatefulWidget{

  dynamic panData;
  List<Data> panFiles = [];
  int start;
  PanImageDetailViewPager({Key key,@required this.panData,@required this.start}):super(key: key);

  @override
  State<StatefulWidget> createState() {
    return PanImageDetailViewPagerState(key: key,filesList: panFiles,start:start);
  }
}

class PanImageDetailViewPagerState extends BaseRefreshViewPagerState<Data,PanImageDetailViewPager>{


  int pagenum=1,pagesize=10;
  List<F.Data> filesList=[];
  dynamic imgData;
  int fileid; //对应的文件id
  bool isself;
  int start;


  PanImageDetailViewPagerState({Key key,@required this.filesList,@required this.start}):super(key: key,data: filesList,start: start);

  @override
  void initState() {
    super.initState();
    print("PanImageDetailViewPager initState");
    pagenum = (start/10).ceil();
    int size = pagenum*10;
    queryPanImageList(1,size);
  }


  void queryPanImageList(int page,int size){
    var param = {
      "panid":widget.panData.panid,
      "page":pagenum,
      "size":size
    };
    httpUtil.post(DataUtils.api_queryuserpanimage,data:param).then((value){
      hideLoadMore();
      if(value != null){
        print("panimagelist ${value}");
        if(pagenum == 1){
          super.data.clear();
        }
        PanFileBean panFileBean = PanFileBean.fromJson(json.decode(value));
        if(panFileBean.errno == 0){
          pagenum++;
          super.data.addAll(panFileBean.data);
        }
        setState(() {
        });
      }
    });
  }

  @override
  Widget initChildren(BuildContext context, data) {
    return Container(
      child: InkWell(
        onTap: (){
          Navigator.pushAndRemoveUntil(context, new MaterialPageRoute(builder: (BuildContext context){
            return GalleryBig(imgUrl: data.url,imageType: BigImageType.pan);
          }), (route) => true);
        },
        child: CachedNetworkImage(
          imageUrl: Constant.parsePanSmallString(data.url),
          width: double.infinity,
          fit: BoxFit.cover,
          progressIndicatorBuilder:(_context,_url,_progress){
            /*if(_progress.totalSize == null){
              loadover = true;
              //print("loadingProgress:${loadingProgress} ${_progress.downloaded}/${_progress.totalSize}");
            }else{
              loadover = false;
              if(!timer.isActive){
              }
              loadingProgress = (_progress.downloaded/_progress.totalSize).toDouble()*_width;
            }*/
            return SizedBox();
          },
        ),
      )
    );
  }

  /**
   * 左右滑动加载更多
   */
  @override
  void loadData() {
    //queryPanImageList(pagesize);
  }

  @override
  void pageChange() {

  }

  @override
  List<Widget> addChildren() {

  }

  /**
   * 上下滑动加载更多
   */
  @override
  void loadmore() {

  }

  @override
  void refresh() {

  }
  
}
