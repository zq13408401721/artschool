import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:yhschool/BaseCoustRefreshState.dart';
import 'package:yhschool/bean/pan_file_bean.dart' as F;
import 'package:yhschool/bean/pan_list_bean.dart';
import 'package:yhschool/bean/pan_classify_bean.dart' as A;
import 'package:yhschool/bean/user_search.dart' as S;
import 'package:yhschool/pan/PanImageDetail.dart';
import 'package:yhschool/popwin/DialogManager.dart';
import 'package:yhschool/utils/Constant.dart';
import 'package:yhschool/utils/EnumType.dart';
import 'package:yhschool/utils/SizeUtil.dart';

import '../UploadDialog.dart';
import '../bean/LocalFile.dart';
import '../bean/pan_topping_bean.dart' as T;
import '../utils/DataUtils.dart';
import '../utils/HttpUtils.dart';
import 'PanCreate.dart';
import 'PanUserDetail.dart';

class PanDetailPage extends StatefulWidget{

  Data panData;
  bool isself;
  List<A.Data> tabs;
  PanDetailPage({Key key,@required this.panData,@required this.isself,@required this.tabs}):super(key: key);

  @override
  State<StatefulWidget> createState() {
    return PanDetailPageState();
  }

}

class PanDetailPageState extends BaseCoustRefreshState<PanDetailPage>{

  ScrollController _scrollController;

  int pagenum=1,pagesize=10;

  List<F.Data> filesList=[];
  List<Asset> _imgs = [];
  List<LocalFile> _files = []; //当前选中文件的路径

  @override
  void initState() {
    super.initState();
    _scrollController = initScrollController(isfresh: false);

    queryPanImageList();
  }

  @override
  void loadmore() {
    queryPanImageList();
  }

  @override
  void refresh() {

  }

  /**
   * 网盘对应的文件
   */
  void queryPanImageList(){
    var param = {
      "panid":widget.panData.panid,
      "page":pagenum,
      "size":pagesize
    };
    httpUtil.post(DataUtils.api_queryuserpanimage,data:param).then((value){
      hideLoadMore();
      if(value != null){
        print("panimagelist ${value}");
        pagenum++;
        F.PanFileBean panFileBean = F.PanFileBean.fromJson(json.decode(value));
        filesList.addAll(panFileBean.data);
        setState(() {
        });
      }
    });
  }

  /**
   * 复制网盘
   */
  void copyPan(){
    var param = {
      "panid":widget.panData.panid
    };
    httpUtil.post(DataUtils.api_pancopy,data:param).then((value){
      print("copypan $value");

    });
  }

  /**
   * 删除网盘
   */
  void deletePan(){

    var param = {
      "panid":widget.panData.panid
    };
    httpUtil.post(DataUtils.api_deletepan,data:param).then((value){
      print("value:$value");
      if(value){
        Navigator.pop(context,widget.panData.panid);
      }
    });
  }

  /**
   * top 1置顶 0非置顶
   */
  void panTopping(int top,String panid){
    var param = {
      "top":top,
      "panid":panid
    };
    httpUtil.post(DataUtils.api_pantopping,data:param).then((value){
      if(value != null){
        T.PanToppingBean panToppingBean = T.PanToppingBean.fromJson(json.decode(value));
      }
    });
  }

  /**
   * 添加网盘文件like
   */
  void addPanFileLike(int fileid,String panid){
    var param = {
      "panid":panid,
      "fileid":fileid
    };
    httpUtil.post(DataUtils.api_addpanfilelike,data: param).then((value){
      print("addpanfilelike $value");
    });
  }

  /**
   * 删除网盘文件like
   */
  void deletePanFileLike(int fileid,String panid){

    var param = {
      "panid":panid,
      "fileid":fileid
    };
    httpUtil.post(DataUtils.api_deletepanfilelike,data: param).then((value){
      print("deletepanfile like $value");
    });
  }

  Future<bool> deletePanImage() async{
    return showDialog(context: context, builder: (content){
      return StatefulBuilder(builder: (_context,_state){
        return UnconstrainedBox(
          child: Card(
            color: Colors.white,
            child: Container(
              width: SizeUtil.getAppWidth(500),
              height: SizeUtil.getAppHeight(250),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(SizeUtil.getAppWidth(10))
              ),
              padding: EdgeInsets.only(
                left: SizeUtil.getAppWidth(20),
                right: SizeUtil.getAppWidth(20),
                top: SizeUtil.getAppHeight(20)
              ),
              child:Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("删除图片？",style: TextStyle(color: Colors.black54,fontSize: SizeUtil.getAppFontSize(30)),),
                  Expanded(
                    flex: 1,
                    child: SizedBox(),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: (){
                          Navigator.pop(context,true);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(SizeUtil.getAppWidth(5)),
                            color: Colors.red
                          ),
                          padding: EdgeInsets.symmetric(
                            vertical: SizeUtil.getAppHeight(10),
                            horizontal: SizeUtil.getAppWidth(40)
                          ),
                          child: Text("确定",style: TextStyle(color: Colors.white),),
                        ),
                      ),
                      SizedBox(width: SizeUtil.getAppWidth(20),),
                      InkWell(
                        onTap: (){
                          Navigator.pop(context);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(SizeUtil.getAppWidth(5)),
                              color: Colors.grey[400]
                          ),
                          padding: EdgeInsets.symmetric(
                              vertical: SizeUtil.getAppHeight(10),
                              horizontal: SizeUtil.getAppWidth(40)
                          ),
                          child: Text("取消",style: TextStyle(color: Colors.white),),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: SizeUtil.getAppHeight(20),)
                ],
              ),
            ),
          ),
        );
      });
    }).then((value){
      return value;
    });
  }

  /**
   * 删除网盘图片
   */
  void deletePanFile(int fileid,String panid){
    deletePanImage().then((value){
      if(value != null){
        var param = {
          "panid":panid,
          "fileid":fileid
        };
        httpUtil.post(DataUtils.api_deletepanfile,data: param).then((value){
          print("deletepan file $value");
          for(F.Data item in filesList){
            if(item.id == fileid){
              filesList.remove(item);
              widget.panData.imagenum--;
              break;
            }
          }
          setState(() {
          });
        });
      }
    });

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
          return UploadDialog(list: _files,uploadType: UploadType.PAN,panid: widget.panData.panid,);
        },
      );
    }).then((value){
      //上传结束直接刷新数据
      this._imgs = [];
      _files = [];
      pagenum = 1;
      filesList = [];
      queryPanImageList();
    });
  }

  Widget panItem(F.Data item){
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(SizeUtil.getAppWidth(10)),
              bottomRight: Radius.circular(SizeUtil.getAppWidth(10))
          )
      ),
      child: InkWell(
        onTap: (){
          //进入网盘详情页面
          Navigator.push(context, MaterialPageRoute(builder: (context){
            return PanImageDetail(panData: widget.panData,imgUrl:item.url);
          }));
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CachedNetworkImage(imageUrl: Constant.parsePanSmallString(item.url),memCacheWidth: item.width,memCacheHeight: item.height,fit: BoxFit.cover,),
            Padding(padding: EdgeInsets.only(
                left: SizeUtil.getAppWidth(20),
                right: SizeUtil.getAppWidth(20),
                top: SizeUtil.getAppWidth(10),
                bottom: SizeUtil.getAppWidth(5),
              ),
              child:!widget.isself ?
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("1",style: Constant.smallTitleTextStyle,),
                      InkWell(
                        onTap: (){
                          //点赞
                        },
                        child: Image.asset("image/ic_pan_unlike.png",width: SizeUtil.getAppWidth(40),height: SizeUtil.getAppWidth(40),),
                      )
                    ],
                  ) :
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: (){
                          //网盘置顶
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: SizeUtil.getAppWidth(10),
                            vertical: SizeUtil.getAppHeight(10),
                          ),
                          child: Image.asset("image/ic_pan_top.png",width: SizeUtil.getAppWidth(40),height: SizeUtil.getAppWidth(40),),
                        ),
                      ),
                      Offstage(
                        offstage: widget.panData.uid == m_uid,
                        child: InkWell(
                          onTap: (){
                            //点赞
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: SizeUtil.getAppWidth(10),
                              vertical: SizeUtil.getAppHeight(10),
                            ),
                            child: Image.asset("image/ic_pan_unlike.png",width: SizeUtil.getAppWidth(40),height: SizeUtil.getAppWidth(40),),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: (){
                          //删除网盘图片
                          deletePanFile(item.id, widget.panData.panid);
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: SizeUtil.getAppWidth(10),
                            vertical: SizeUtil.getAppHeight(10),
                          ),
                          child: Image.asset("image/ic_pan_delete.png",width: SizeUtil.getAppWidth(40),height: SizeUtil.getAppWidth(40),),
                        ),
                      )
                    ],
                  )
            )
          ],
        ),
      ),
    );
  }

  @override
  List<Widget> addChildren() {
    return [
      //标题
      Container(
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: (){
                Navigator.pop(context,widget.panData.imagenum);
              },
              child: Container(
                child: Image.asset("image/ic_arrow_left.png",width: SizeUtil.getAppWidth(60),height: SizeUtil.getAppHeight(60),),
              ),
            ),
            Expanded(child: SizedBox()),
            Offstage(
              offstage: !widget.isself,
              child: InkWell(
                onTap: (){
                  //编辑
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> PanCreate(isCreate: false,panData: widget.panData,tabs: widget.tabs,))).then((value){
                    if(value != null){

                    }
                  });
                },
                child: Container(
                  padding: EdgeInsets.all(SizeUtil.getAppWidth(20)),
                  child: Image.asset("image/ic_pan_editor.png",width: SizeUtil.getAppWidth(40),height: SizeUtil.getAppWidth(40),),
                ),
              ),
            ),
            Offstage(
              offstage: widget.isself || widget.panData.imagenum == 0,
              child: InkWell(
                onTap: (){
                  //复制网盘
                  //copyPan();
                  DialogManager().showCopyPanDialog(context,widget.panData.panid);
                },
                child: Container(
                  padding: EdgeInsets.all(SizeUtil.getAppWidth(10)),
                  child: Image.asset("image/ic_pan_copy.png",width: SizeUtil.getAppWidth(40),height: SizeUtil.getAppWidth(40)),
                ),
              ),
            ),
            Offstage(
              offstage: !widget.isself || widget.panData.imagenum == 0,
              child: InkWell(
                onTap: (){
                  //删除
                  DialogManager().showDeletePanDialog(context,type:PanDeleteType.PAN, title: "是否确定删除${widget.panData.name}网盘？", panid: widget.panData.panid).then((value){
                    if(value){
                      Navigator.pop(context,widget.panData.panid);
                    }
                  });
                  //deletePan();
                },
                child: Container(
                  padding: EdgeInsets.all(SizeUtil.getAppWidth(10)),
                  child: Image.asset("image/ic_pan_delete.png",width: SizeUtil.getAppWidth(40),height: SizeUtil.getAppWidth(40)),
                ),
              ),
            )
          ],
        ),
      ),
      Container(color:Colors.white,height: SizeUtil.getAppHeight(20),),
      Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: SizeUtil.getAppWidth(20),vertical: SizeUtil.getAppHeight(20)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(widget.panData.name)
          ],
        ),
      ),
      Divider(height: 1,indent: SizeUtil.getAppWidth(20),color: Colors.grey,),
      InkWell(
        onTap: (){
          var param = new S.Result(
            uid: widget.panData.uid,
            username:widget.panData.username,
            nickname:widget.panData.nickname,
            avater:widget.panData.avater,
            role:widget.panData.role
          );
          //进入用户详情页
          Navigator.push(context, MaterialPageRoute(builder: (context){
            return PanUserDetail(data: param,);
          }));
        },
        child: Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: SizeUtil.getAppHeight(20),vertical: SizeUtil.getAppHeight(20)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ClipOval(
                  child: (widget.panData.avater == null || widget.panData.avater.length == 0)
                      ? Image.asset("image/ic_head.png",width: SizeUtil.getAppWidth(50),height: SizeUtil.getAppWidth(50),fit: BoxFit.cover,)
                      : CachedNetworkImage(imageUrl: widget.panData.avater,width: SizeUtil.getAppWidth(50),height: SizeUtil.getAppWidth(50),fit: BoxFit.cover),
                ),
                SizedBox(width: SizeUtil.getAppWidth(20),),
                Text(widget.panData.nickname != null ? widget.panData.nickname : widget.panData.username,style: Constant.smallTitleTextStyle,),
                Expanded(child: SizedBox()),
                Text("${widget.panData.imagenum}张图",style: Constant.smallTitleTextStyle,),
              ],
            )
        ),
      ),
      //自己的网盘上传图片
      (widget.panData.isself == 0 && widget.isself) ?
      InkWell(
        onTap: (){
          //上传
          _openGallery(context);
        },
        child: Container(
          padding: EdgeInsets.symmetric(
              horizontal: SizeUtil.getAppWidth(40),
              vertical: SizeUtil.getAppWidth(20)
          ),
          margin: EdgeInsets.only(
              top: SizeUtil.getAppHeight(20),
              left: SizeUtil.getAppWidth(20),
              right: SizeUtil.getAppWidth(20)
          ),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(SizeUtil.getAppWidth(10)))
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("+ 上传图片",style: TextStyle(fontSize: SizeUtil.getAppFontSize(30),fontWeight: FontWeight.bold,color: Colors.red),),
              Text("严禁上传色情、政治等不合规图片",style: Constant.smallTitleTextStyle,)
            ],
          ),
        ),
      ) : Text("复制网盘无法上传图片",style: Constant.smallTitleTextStyle,),
      Expanded(
        child: Container(
          padding: EdgeInsets.only(top: SizeUtil.getHeight(20)),
          decoration: BoxDecoration(
            color: Colors.grey[100],
          ),
          child: StaggeredGridView.countBuilder(
            crossAxisCount: Constant.isPad ? 3 : 2,
            itemCount: filesList.length,
            //primary: false,
            physics: BouncingScrollPhysics(),
            mainAxisSpacing: SizeUtil.getAppWidth(Constant.DIS_LIST),
            crossAxisSpacing: SizeUtil.getAppHeight(Constant.DIS_LIST),
            controller: _scrollController,
            //addAutomaticKeepAlives: false,
            padding: EdgeInsets.only(left: SizeUtil.getAppWidth(Constant.DIS_LIST),right: SizeUtil.getAppWidth(Constant.DIS_LIST)),
            staggeredTileBuilder: (int index) => StaggeredTile.fit(1),
            //StaggeredTile.count(3,index==0?2:3),
            itemBuilder: (context,index){
              return panItem(filesList[index]);
            },
          ),
        ),
      ),
      loadmoreUI()
    ];
  }

}