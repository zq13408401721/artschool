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
import 'package:yhschool/bean/pan_delete_file.dart';
import 'package:yhschool/bean/pan_file_bean.dart' as F;
import 'package:yhschool/bean/pan_file_topping_bean.dart';
import 'package:yhschool/bean/pan_list_bean.dart';
import 'package:yhschool/bean/pan_classify_bean.dart' as A;
import 'package:yhschool/bean/user_search.dart' as S;
import 'package:yhschool/pan/PanImageDetail.dart';
import 'package:yhschool/pan/PanImageDetailViewPager.dart';
import 'package:yhschool/popwin/DialogManager.dart';
import 'package:yhschool/utils/Constant.dart';
import 'package:yhschool/utils/EnumType.dart';
import 'package:yhschool/utils/SizeUtil.dart';
import 'package:yhschool/widgets/CoustSizeImage.dart';

import '../UploadDialog.dart';
import '../bean/LocalFile.dart';
import '../bean/pan_addlike_bean.dart' as K;
import '../bean/pan_topping_bean.dart' as T;
import '../utils/DataUtils.dart';
import '../utils/HttpUtils.dart';
import '../widgets/BackButtonWidget.dart';
import 'PanCreate.dart';
import 'PanUserDetail.dart';

class PanDetailPage extends StatefulWidget{

  Data panData;
  bool isself;
  List<A.Data> tabs;
  String marknames;
  String classifyname;
  bool fromSreach; //是否来自搜索页面
  PanDetailPage({Key key,@required this.panData,@required this.isself,@required this.tabs,@required this.classifyname,@required this.marknames,
    @required this.fromSreach=false
  }):super(key: key);

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
  bool isUpdate = false; //记录是否更新盘文件 空盘文件上传和文件删除更新上一个页面的列表中网盘信息


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
        if(pagenum == 1){
          filesList.clear();
        }
        F.PanFileBean panFileBean = F.PanFileBean.fromJson(json.decode(value));
        if(panFileBean.errno == 0){
          pagenum++;
          filesList.addAll(panFileBean.data);
        }
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
   * 删除网盘 废弃的方法
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
   * id 网盘对应的id
   */
  void panTopping(int top,int id){
    var param = {
      "top":top,
      "id":id
    };
    httpUtil.post(DataUtils.api_pantopping,data:param).then((value){
      if(value != null){
        T.PanToppingBean panToppingBean = T.PanToppingBean.fromJson(json.decode(value));
        if(panToppingBean.errno == 0){
          showToast("网盘置顶");
          pagenum = 1;
          filesList = [];
          queryPanImageList();
        }
      }
    });
  }

  /**
   * 网盘图片置顶
   */
  void panFileTopping(int id){
    var param = {
      "id":id
    };
    httpUtil.post(DataUtils.api_panfiletopping,data:param).then((value){
      print('panfiletopping ${value}');
      if(value != null){
        PanFileToppingBean bean = PanFileToppingBean.fromJson(json.decode(value));
        if(bean.errno == 0){
          //置顶重新获取网盘文件数据
          showToast("文件置顶");
          pagenum = 1;
          filesList = [];
          queryPanImageList();
        }
      }
    });
  }

  /**
   * 删除盘文件置顶
   */
  void deletePanFileTopping(int id){
    var param = {
      "id":id,
    };
    httpUtil.post(DataUtils.api_deletepanfiletopping,data:param).then((value){
      print('deletepanfiletopping ${value}');
      if(value != null){
        PanFileToppingBean bean = PanFileToppingBean.fromJson(json.decode(value));
        if(bean.errno == 0){
          //置顶重新获取网盘文件数据
          showToast("取消置顶");
          pagenum = 1;
          filesList = [];
          queryPanImageList();
        }
      }
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
  void deletePanFile(int folderid,String panid){
    print("deletePanFile ${folderid} ${panid}");
    deletePanImage().then((value){
      print("deletePanImage ${value}");
      isUpdate = true;
      if(value != null){
        var param = {
          "panid":panid,
          "folderid":folderid
        };
        httpUtil.post(DataUtils.api_deletepanfile,data: param).then((value){
          print("deletepan file $value");
          if(value != null){
            PanDeleteFile bean = PanDeleteFile.fromJson(json.decode(value));
            if(bean.errno == 0){
              for(F.Data item in filesList){
                if(item.id == folderid){
                  filesList.remove(item);
                  widget.panData.imagenum--;
                  break;
                }
              }
              setState(() {
              });
            }
          }
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
      isUpdate = true;
      //上传结束直接刷新数据
      this._imgs = [];
      _files = [];
      pagenum = 1;
      filesList = [];
      queryPanImageList();
    });
  }

  /**
   * 添加喜欢的网盘图片
   */
  void addPanImageLike(int fileid){
    var param = {
      "panid":widget.panData.panid,
      "fileid":fileid
    };
    httpUtil.post(DataUtils.api_addpanfilelike,data: param).then((value){
      print("pan file like:$value");
      if(value != null){
        K.PanAddlikeBean addlikeBean = K.PanAddlikeBean.fromJson(json.decode(value));
        if(addlikeBean.errno == 0){
          if(addlikeBean.data.type == "add"){
            showToast("收藏成功");
          }else{
            showToast("已经收藏");
          }
        }
      }
    });
  }

  Widget panItem(int index,F.Data item){
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(SizeUtil.getAppWidth(10)),
              bottomRight: Radius.circular(SizeUtil.getAppWidth(10))
          )
      ),
      child: GestureDetector(
        onTap: (){
          //进入网盘详情页面
          Navigator.push(context, MaterialPageRoute(builder: (context){
            //return PanImageDetail(panData: widget.panData,imgUrl:item.url,imgData: item,fileid: item.fileid,);
            return PanImageDetailViewPager(panData: widget.panData,start: index,);
          })).then((value){
            if(value != null){
              if(value == 1){
                item.like = 1;
              }else{
                item.like = 0;
              }
            }
          });
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CoustSizeImage(Constant.parsePanSmallString(item.url), mWidth: item.width, mHeight: item.height),
            Padding(padding: EdgeInsets.only(
                left: SizeUtil.getAppWidth(20),
                right: SizeUtil.getAppWidth(20),
                top: SizeUtil.getAppWidth(20),
                bottom: SizeUtil.getAppWidth(5),
              ),
              child:(!widget.isself || widget.panData.isself == 1 || widget.fromSreach) ?
              Padding(
                padding: EdgeInsets.symmetric(
                    vertical: SizeUtil.getAppHeight(20)
                ),
                child: Text("${item.name}",style: Constant.smallTitleTextStyle,maxLines: 1,overflow: TextOverflow.ellipsis,),
              ) :
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: (){
                      print("top click ${widget.panData.panid}");
                      DialogManager().showPanDialogTitle(context,title: item.top == 0 ? "置顶网盘？" : "取消置顶？").then((value){
                        //确定
                        if(value == true){
                          //网盘图片置顶
                          if(item.top == 0){
                            panFileTopping(item.id);
                          }else{
                            deletePanFileTopping(item.id);
                          }
                        }
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.only(
                        left: SizeUtil.getAppWidth(10),
                        right: SizeUtil.getAppWidth(10),
                        top: SizeUtil.getAppHeight(10),
                        bottom: SizeUtil.getAppHeight(20)
                      ),
                      child: Text("${item.top == 0 ? '置顶图片' : '取消置顶'}",style: item.top == 0 ? TextStyle(fontSize: SizeUtil.getAppFontSize(30),color: Colors.black54) :
                        TextStyle(fontSize: SizeUtil.getAppFontSize(30),color: Colors.deepOrangeAccent),)
                      //Image.asset(item.top == 0 ? "image/ic_pan_top.png" : "image/ic_pan_toped.png",width: SizeUtil.getAppWidth(40),height: SizeUtil.getAppWidth(40),),
                    ),
                  ),
                  InkWell(
                    onTap: (){
                      //删除网盘图片
                      deletePanFile(item.id, widget.panData.panid);
                    },
                    child: Container(
                      padding: EdgeInsets.only(
                        left: SizeUtil.getAppWidth(10),
                        right: SizeUtil.getAppWidth(10),
                        top: SizeUtil.getAppHeight(10),
                        bottom: SizeUtil.getAppHeight(20)
                      ),
                      child: Text("删除图片",style: TextStyle(color:Colors.black54,fontSize: SizeUtil.getAppFontSize(30)),)
                      //Image.asset("image/ic_pan_delete.png",width: SizeUtil.getAppWidth(40),height: SizeUtil.getAppWidth(40),),
                    ),
                  )
                ],
              ),
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
            /*InkWell(
              onTap: (){
                Navigator.pop(context,{"editor":PanEditor.EDITOR,"value":widget.panData.imagenum});
              },
              child: Container(
                child: Image.asset("image/ic_arrow_left.png",width: SizeUtil.getAppWidth(60),height: SizeUtil.getAppHeight(60),),
              ),
            ),*/
            BackButtonWidget(cb: (){
              //判断当前网盘信息是否更新如果已经更新，需要替换本地网盘信息
              var param = {"editor":PanEditor.EDITOR,"value":filesList.length};
              if(isUpdate){
                param["url"] = filesList.length == 0 ? "" : filesList[0].url;
              }
              Navigator.pop(context,param);
            }, title:""),
            Expanded(child: SizedBox()),
            Offstage(
              offstage: !widget.isself || widget.panData.isself != 0,
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
              offstage: widget.isself || widget.panData.isself != 0 || widget.panData.imagenum == 0,
              child: InkWell(
                onTap: (){
                  //复制网盘
                  //copyPan();
                  DialogManager().showCopyPanDialog(context,widget.panData.panid);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    vertical: SizeUtil.getAppHeight(10),
                    horizontal: SizeUtil.getAppWidth(20)
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.all(Radius.circular(SizeUtil.getAppWidth(10)))
                  ),
                  //child: Image.asset("image/ic_pan_copy.png",width: SizeUtil.getAppWidth(40),height: SizeUtil.getAppWidth(40)),
                  child: Text("复制网盘",style: TextStyle(fontSize: SizeUtil.getAppFontSize(30),color: Colors.white),),
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
                      Navigator.pop(context,{"editor":PanEditor.DELETE,"value":widget.panData.panid});
                    }
                  });
                  //deletePan();
                },
                child: Container(
                  padding: EdgeInsets.all(SizeUtil.getAppWidth(10)),
                  child: Image.asset("image/ic_pan_delete.png",width: SizeUtil.getAppWidth(40),height: SizeUtil.getAppWidth(40)),
                ),
              ),
            ),
            SizedBox(width: SizeUtil.getAppWidth(20),)
          ],
        ),
      ),
      //网盘名
      Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: SizeUtil.getAppWidth(20),vertical: SizeUtil.getAppHeight(20)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(widget.panData.name,style: TextStyle(fontSize: SizeUtil.getAppFontSize(40),fontWeight: FontWeight.bold,color: Colors.black87),)
          ],
        ),
      ),
      //网盘分类
      Offstage(
        offstage: widget.classifyname == null,
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white
          ),
          padding: EdgeInsets.symmetric(horizontal: SizeUtil.getAppWidth(20),vertical: SizeUtil.getAppHeight(10)),
          child: Text("分类：${widget.classifyname}",style: TextStyle(fontSize: SizeUtil.getAppFontSize(25),color: Colors.grey),),
        ),
      ),
      //网盘标签
      Offstage(
        offstage: widget.marknames == null  || widget.marknames.length == 0,
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white
          ),
          padding: EdgeInsets.only(left: SizeUtil.getAppWidth(20),right:SizeUtil.getAppWidth(20),top: SizeUtil.getAppHeight(10),bottom: SizeUtil.getAppHeight(10)),
          child: Text("标签：${widget.marknames}",style: TextStyle(fontSize: SizeUtil.getAppFontSize(25),color: Colors.grey),),
        ),
      ),
      Divider(height: 1,indent: SizeUtil.getAppWidth(20),endIndent: SizeUtil.getAppWidth(20),color: Colors.grey[100],),
      InkWell(
        onTap: (){
          var param = new S.Result(
            uid: widget.panData.uid,
            username:widget.panData.username,
            nickname:widget.panData.nickname,
            avater:widget.panData.avater,
            role:widget.panData.role,
          );
          param.panid = widget.panData.panid;
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
                SizedBox(width: SizeUtil.getAppWidth(10),),
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
          child: widget.panData.isself == 0 ? Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("+ 上传图片",style: TextStyle(fontSize: SizeUtil.getAppFontSize(30),fontWeight: FontWeight.bold,color: Colors.red),),
              Text("严禁上传色情、政治等不合规图片",style: Constant.smallTitleTextStyle,)
            ],
          ) : Padding(padding: EdgeInsets.only(top: SizeUtil.getAppHeight(20)),child: Text("复制网盘无法上传图片",style: Constant.smallTitleTextStyle,),),
        ),
      ) : SizedBox(),
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
              return panItem(index,filesList[index]);
            },
          ),
        ),
      ),
      loadmoreUI()
    ];
  }

}