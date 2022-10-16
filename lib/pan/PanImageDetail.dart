import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yhschool/BaseState.dart';
import 'package:yhschool/bean/add_special_column_bean.dart';
import 'package:yhschool/utils/Constant.dart';
import 'package:yhschool/utils/SizeUtil.dart';
import 'package:yhschool/bean/pan_list_bean.dart' as P;

import '../GalleryBig.dart';
import '../utils/ImageType.dart';

class PanImageDetail extends StatefulWidget{

  P.Data panData;

  PanImageDetail({Key key,@required this.panData}):super(key: key);

  @override
  State<StatefulWidget> createState() {
    return PanImageDetailState();
  }
}

class PanImageDetailState extends BaseState<PanImageDetail>{

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
                    child: Image.asset("image/ic_arrow_left.png",width: SizeUtil.getAppWidth(40),height: SizeUtil.getAppHeight(40),),
                  ),
                ),
                InkWell(
                  onTap: (){
                    
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
                )
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
                          return GalleryBig(imgUrl: widget.panData.url,imageType: BigImageType.pan);
                        }), (route) => true);
                      },
                      child: CachedNetworkImage(
                        imageUrl: Constant.parsePanSmallString(widget.panData.url),
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
                    Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: SizeUtil.getAppHeight(20),
                        horizontal: SizeUtil.getAppWidth(20)
                      ),
                      child: Text("${widget.panData.name}${widget.panData.imagenum}张",style: Constant.smallTitleTextStyle,),
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