import 'dart:collection';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yhschool/BaseEditorState.dart';
import 'package:yhschool/BasePhotoState.dart';
import 'package:yhschool/BaseState.dart';
import 'package:yhschool/GalleryBig.dart';
import 'package:yhschool/bean/pan_delete_file.dart' as DeleteFile;
import 'package:yhschool/bean/pan_file_bean.dart';
import 'package:yhschool/utils/Constant.dart';
import 'package:yhschool/utils/DataUtils.dart';
import 'package:yhschool/utils/HttpUtils.dart';
import 'package:yhschool/utils/ImageType.dart';

/**
 * 网盘文件页面
 */
class PanFile extends StatefulWidget{

  int folderid;
  String foldername;

  bool isShowMore;

  PanFile({Key key,@required this.folderid,@required this.foldername,@required this.isShowMore=true}):super(key: key);

  @override
  State<StatefulWidget> createState() {
    return PanFileState()
      ..folderid = folderid
      ..foldername = foldername
      ..isShowMore = isShowMore;
  }

}

class PanFileState extends BaseEditorState<PanFile>{

  int folderid;
  String foldername;
  bool isShowMore;

  int page=1;
  int size=50;

  List<Data> list=[];
  @override
  void initState() {
    super.initState();
    panFileList();
  }

  /**
   * 添加文件
   */
  void addFile(BuildContext context){
    //打开相机相册上传图片
    openPanGallery(context, folderid, (value)=>{
      this.list.clear(),
      panFileList()
    });
  }

  /**
   * 盘文件列表返回
   */
  void panFileListReturn(PanFileBean result){
    if(result.errno == 0){
      if(result.data != null && result.data.length > 0){
        setState(() {
          this.list.addAll(result.data);
        });
      }
    }else{
      showToast(result.errmsg);
    }
  }

  /**
   * 获取盘文件列表
   */
  void panFileList(){
    var option = {
      "folderid":folderid,
      "page":page,
      "size":size
    };
    httpUtil.post(DataUtils.api_panfilelist,data: option).then((value) => {
      print("result:$value"),
      panFileListReturn(PanFileBean.fromJson(json.decode(value)))

    }).catchError((err)=>{
      print("err$err")
    });
  }

  /**
   * 取消选择
   */
  void cancelSelect(){
    hideEditor();
    selectListData(false);
  }

  /**
   * 选择文件的方法
   */
  void selectFun(bool _bool){
    selectListData(_bool);
  }

  /**
   * 删除操作
   */
  void deleteSelect(BuildContext context){
    if(this.list.length > 0){
      showAlertTips(context, "是否确定删除$selectNum个文件", (){
        //删除数据
        String ids = '';
        this.list.forEach((element) {
          if(element.select){
            ids = ids.length == 0 ? '${element.id}' : '$ids'',''${element.id}';
          }
        });
        if(ids.length > 0){
          deleteFiles(ids);
        }else{
          showToast("选择要删除的文件");
        }
      });
    }else{
      showToast("请选择删除数据");
    }
  }

  /**
   * 删除文件
   */
  void deleteFiles(String ids){
    var option = {
      'fids':ids,
      'folderid':this.folderid
    };
    httpUtil.post(DataUtils.api_pandeletefile,data: option).then((value) {
      DeleteFile.PanDeleteFile deleteFile = DeleteFile.PanDeleteFile.fromJson(json.decode(value));
      if(deleteFile.errno == 0){
        setState(() {
          deleteFile.data.fids.forEach((element) {
            for(var i=0; i<this.list.length; i++){
              if(int.parse(element) == this.list[i].id){
                this.list.removeAt(i);
                break;
              }
            }
          });
          //删除以后刷新界面
          this.selectNum = 0;
          this.selectAll = "全选";
        });
      }else{
        showToast(deleteFile.errmsg);
      }
    }).catchError((err){
      print(err);
    });
  }

  /**
   * 列表数据选中状态
   */
  selectListData(bool _bool){
    setState(() {
      for(Data item in list){
        item.select = _bool;
      }
      if(_bool){
        this.selectNum = list.length;
      }else{
        this.selectNum = 0;
      }
    });
  }

  /**
   * 是否全选已经选中的数据
   */
  bool isSelectAll(){
    bool _bool = true;
    int number = 0;
    list.forEach((element) {
      if(!element.select){
        if(_bool){
          _bool = false;
        }
      }else{
        number++;
      }
    });
    this.selectNum = number;
    return _bool;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        child: SafeArea(
          child: Stack(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                color: Colors.transparent,
              ),
              Column(
                children: [
                  this.isShowMore ?
                  TitleMoreView(foldername,CB_Class(()=>{
                    Navigator.pop(context)
                  }, (){
                    setState(() {
                      this.ischoose = false;
                    });
                  })) :
                  TitleView(foldername, CB_Class(()=>{
                    Navigator.pop(context)
                  }, ()=>{})),
                  SingleChildScrollView(
                    child: GridView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: list.length,
                        padding: EdgeInsets.only(top: ScreenUtil().setHeight(20)),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisSpacing: Constant.GARRERY_GRID_CROSSAXISSPACING,
                            mainAxisSpacing: ScreenUtil().setWidth(Constant.PADDING_GALLERY_CROSS),
                            crossAxisCount: Constant.isPad ? 5 : 4,
                            childAspectRatio: Constant.isPad ? 1.22 : 0.85
                        ),
                        itemBuilder: (context,index){
                          return GestureDetector(
                            onTap: (){
                              //点击事件
                              // Navigator.push(context, MaterialPageRoute(builder: (context){
                              //   PanFile(folderid: list[index].id, foldername: list[index].name);
                              // }
                              if(!this.iseditor){
                                setState(() {
                                  list[index].select = !list[index].select;
                                  //判断当前是否是全选
                                  bool _isAll = this.isSelectAll();
                                  if(_isAll){
                                    this.selectAll = "全不选";
                                  }else{
                                    this.selectAll = "全选";
                                  }
                                });
                              }else{
                                Navigator.pushAndRemoveUntil(context, new MaterialPageRoute(builder: (BuildContext context){
                                  return GalleryBig(imgUrl: list[index].url,imageType: BigImageType.pan,);
                                }), (route) => true);
                              }
                            },
                            child: Container(
                              child:Card(
                                  margin: EdgeInsets.only(top: ScreenUtil().setHeight(0)),
                                  /*shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(ScreenUtil().radius(20.0))),
                                  ),*/
                                  child: Stack(
                                    children: [
                                      Column(
                                        children: [
                                          Expanded(
                                            child: AspectRatio(
                                                aspectRatio: 1.32,
                                                child:CachedNetworkImage(
                                                  imageUrl: Constant.parsePanSmallString(list[index].url,"res.yimios.com:9050/pan"),
                                                  fit: BoxFit.contain,
                                                )
                                            ),
                                          ),
                                          Container(
                                            padding: EdgeInsets.only(left: 4,right: 4,),
                                            child:Text(
                                              list[index].name,
                                              softWrap: true,
                                              textAlign: TextAlign.left,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              style:TextStyle(fontSize: Constant.isPad ? ScreenUtil().setSp(32) : ScreenUtil().setSp(42)),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Positioned(
                                        right: ScreenUtil().setWidth(0),
                                        child: Offstage(
                                          offstage: this.iseditor,
                                          child: Container(
                                            height: 20,
                                            width: 20,
                                            child: Checkbox(tristate: false,value: list[index].select, onChanged: (_bool){
                                                setState(() {
                                                  list[index].select = _bool;
                                                  //判断当前是否是全选
                                                  bool _isAll = this.isSelectAll();
                                                  if(_isAll){
                                                    this.selectAll = "全不选";
                                                  }else{
                                                    this.selectAll = "全选";
                                                  }
                                                });
                                              },
                                              shape: CircleBorder(side: BorderSide(color: Colors.grey[100],width: 2,style: BorderStyle.solid)),
                                            ),
                                          )
                                        ),
                                      )
                                    ],
                                  )
                              ),
                            ),
                          );
                        }),
                  )
                ],
              ),
              Positioned(
                bottom: ScreenUtil().setHeight(20),
                right: ScreenUtil().setWidth(20),
                child: Offstage(
                  offstage: !this.iseditor || !this.isShowMore,
                  child: InkWell(
                    child: Image.asset("image/ic_add.png",width: 40,height: 40,),
                    onTap: (){
                      addFile(context);
                    },
                  ),
                ),
              ),
              EditorBar(cancelSelect, selectFun),
              Positioned(
                  bottom: 0,
                  right: 0,
                  left: 0,
                  child: BottomBar(context,deleteSelect)
              ),
              // 更多操作框
              Positioned(
                top: ScreenUtil().setHeight(Constant.SIZE_TITLE_NORMAL_HEIGHT),
                right: 0,
                child: PopChoose(context, (){
                  showEditor();
                }),
              )

            ],
          ),
        ),
        onTap: (){
          setState(() {
            this.ischoose = true;
          });
        },
      )
    );
  }
}