import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yhschool/BaseDialogState.dart';
import 'package:yhschool/BaseState.dart';
import 'package:yhschool/bean/add_special_column_bean.dart';
import 'package:yhschool/popwin/DialogManager.dart';
import 'package:yhschool/utils/Constant.dart';
import 'package:yhschool/utils/SizeUtil.dart';
import 'package:yhschool/bean/pan_list_bean.dart' as P;

import '../GalleryBig.dart';
import '../utils/DataUtils.dart';
import '../utils/HttpUtils.dart';
import '../utils/ImageType.dart';

class PanImageDetail extends StatefulWidget{

  P.Data panData;
  String imgUrl;
  dynamic imgData;
  int fileid; //对应的文件id
  bool isself;

  PanImageDetail({Key key,@required this.panData,@required this.imgUrl,@required this.imgData,@required this.fileid,
  @required this.isself = false}):super(key: key);

  @override
  State<StatefulWidget> createState() {
    return PanImageDetailState();
  }
}

class PanImageDetailState extends BaseDialogState<PanImageDetail>{

  double loadingProgress=-1;
  bool loadover = false;
  double _width=0;

  Timer timer;

  @override
  void initState() {
    super.initState();
  }

  void registerTimer(){
    timer = Timer.periodic(Duration(milliseconds: 50), (timer) {
      if(!mounted){
        timer.cancel();
        return;
      }
      if(!loadover){
        setState(() {
        });
      }else{
        setState(() {
        });
        timer.cancel();
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
      setState(() {
        widget.imgData.like = 1;
      });
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
      if(widget.isself){
        //取消喜欢退回到上一个页面
        Navigator.pop(context,fileid);
      }else{
        setState(() {
          widget.imgData.like = 0;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    _width = _size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: SizeUtil.getAppWidth(20),
                      vertical: SizeUtil.getAppHeight(40)
                    ),
                    child: Image.asset("image/ic_arrow_left.png",width: SizeUtil.getAppWidth(60),height: SizeUtil.getAppHeight(60),),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    //喜欢
                    Offstage(
                      offstage: widget.panData.uid == m_uid,
                      child: InkWell(
                        onTap: (){
                          //喜欢
                          if(widget.imgData.like == 0){
                            addPanFileLike(widget.imgData.id, widget.panData.panid);
                          }else{
                            deletePanFileLike(widget.imgData.id, widget.panData.panid);
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.all(Radius.circular(SizeUtil.getAppWidth(5)))
                          ),
                          margin: EdgeInsets.only(right: SizeUtil.getAppWidth(20)),
                          padding: EdgeInsets.symmetric(
                              horizontal: SizeUtil.getAppWidth(20),
                              vertical: SizeUtil.getAppHeight(10)
                          ),
                          child: Text(widget.imgData.like == 0 ? "喜欢" : "取消喜欢",style: TextStyle(fontSize: SizeUtil.getAppFontSize(25),color: Colors.white),),
                        ),
                      ),
                    ),
                    //自己网盘进来显示取消喜欢
                    /*Offstage(
                      offstage: !widget.isself,
                      child: InkWell(
                        onTap: (){
                          deletePanFileLike(widget.imgData.id, widget.panData.panid);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.all(Radius.circular(SizeUtil.getAppWidth(5)))
                          ),
                          margin: EdgeInsets.only(right: SizeUtil.getAppWidth(20)),
                          padding: EdgeInsets.symmetric(
                              horizontal: SizeUtil.getAppWidth(20),
                              vertical: SizeUtil.getAppHeight(10)
                          ),
                          child: Text("取消喜欢",style: TextStyle(fontSize: SizeUtil.getAppFontSize(25),color: Colors.white),),
                        ),
                      ),
                    ),*/
                    //老师身份推到课堂
                    Offstage(
                      offstage: m_role != 1,
                      child: InkWell(
                        onTap: (){
                          //推送到课堂
                          pushGallery(context, {
                            "name":m_username == null ? m_nickname : m_username,
                            "url":widget.imgUrl,
                            "width":widget.imgData.width,
                            "height":widget.imgData.height,
                            "maxwidth":widget.imgData.maxwidth,
                            "maxheight":widget.imgData.maxheight
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.purple,
                            borderRadius: BorderRadius.all(Radius.circular(SizeUtil.getAppWidth(5)))
                          ),
                          margin: EdgeInsets.only(right: SizeUtil.getAppWidth(20)),
                          padding: EdgeInsets.symmetric(
                              horizontal: SizeUtil.getAppWidth(20),
                              vertical: SizeUtil.getAppHeight(10)
                          ),
                          child: Text("推送到课堂",style: TextStyle(fontSize: SizeUtil.getAppFontSize(25),color: Colors.white),),
                        ),
                      ),
                    ),
                    //存网盘
                    Offstage(
                      offstage: widget.panData.imagenum == 0 || widget.panData.uid == m_uid,
                      child: InkWell(
                        onTap: (){
                          DialogManager().showCopyPanImageDialog(context,widget.panData.panid,widget.fileid).then((value){
                            if(value != null){

                            }
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(SizeUtil.getAppWidth(5)),
                              color: Colors.red
                          ),
                          margin: EdgeInsets.only(
                              right: SizeUtil.getAppWidth(20)
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: SizeUtil.getAppWidth(20),
                              vertical: SizeUtil.getAppHeight(10)
                          ),
                          child: Text("存网盘",style: TextStyle(fontSize: SizeUtil.getAppFontSize(25),color: Colors.white),),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: (){
                        Navigator.pushAndRemoveUntil(context, new MaterialPageRoute(builder: (BuildContext context){
                          return GalleryBig(imgUrl: widget.imgUrl,imageType: BigImageType.pan);
                        }), (route) => true);
                      },
                      child: CachedNetworkImage(
                        imageUrl: Constant.parsePanSmallString(widget.imgUrl),
                        width: double.infinity,
                        fit: BoxFit.cover,
                        progressIndicatorBuilder:(_context,_url,_progress){
                          if(_progress.totalSize == null){
                            loadover = true;
                            //print("loadingProgress:${loadingProgress} ${_progress.downloaded}/${_progress.totalSize}");
                          }else{
                            loadover = false;
                            if(!timer.isActive){
                              registerTimer();
                            }
                            loadingProgress = (_progress.downloaded/_progress.totalSize).toDouble()*_width;
                          }
                          return SizedBox();
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: SizeUtil.getAppHeight(20),
                        horizontal: SizeUtil.getAppWidth(20)
                      ),
                      child: Text("${widget.panData.date}",style: Constant.smallTitleTextStyle,),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: SizeUtil.getAppHeight(20),
                        horizontal: SizeUtil.getAppWidth(20)
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          ClipOval(
                            child: (widget.panData.avater == null || widget.panData.avater.length == 0)
                                ? Image.asset("image/ic_head.png",width: SizeUtil.getAppWidth(50),height: SizeUtil.getAppWidth(50),fit: BoxFit.cover,)
                                : CachedNetworkImage(imageUrl: widget.panData.avater,width: SizeUtil.getAppWidth(50),height: SizeUtil.getAppWidth(50),fit: BoxFit.cover),
                          ),
                          SizedBox(width: SizeUtil.getAppWidth(20),),
                          Text(widget.panData.nickname != null ? widget.panData.nickname : widget.panData.username,style: Constant.smallTitleTextStyle,),
                        ],
                      ),
                    ),
                    Offstage(
                      offstage: widget.panData.name == null,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: SizeUtil.getAppHeight(20),
                            horizontal: SizeUtil.getAppWidth(20)
                        ),
                        child: Text("${widget.panData.name}${widget.panData.imagenum}张",style: Constant.smallTitleTextStyle,),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}