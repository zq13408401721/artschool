import 'dart:convert';

import 'package:chewie/chewie.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yhschool/BaseState.dart';
import 'package:yhschool/bean/advert_video_bean.dart';
import 'package:yhschool/utils/DataUtils.dart';
import 'package:yhschool/utils/HttpUtils.dart';
import 'package:yhschool/utils/SizeUtil.dart';
import 'package:yhschool/widgets/BackButtonWidget.dart';
import 'package:yhschool/widgets/RoundedButton.dart';
import 'package:video_player/video_player.dart';

class AdvertVideoPage extends StatefulWidget{

  AdvertVideoPage({Key key}):super(key: key);

  @override
  State<StatefulWidget> createState() {
    return AdvertVideoPageState();
  }
}

class AdvertVideoPageState extends BaseState<AdvertVideoPage>{

  VideoPlayerController _videoPlayerController;
  ChewieController _chewieController;
  bool isinit = false;

  @override
  void initState() {
    super.initState();

    httpUtil.get(DataUtils.api_advertvideo).then((value){
      AdvertVideoBean _advertVideoBean = AdvertVideoBean.fromJson(json.decode(value));
      if(_advertVideoBean.errno == 0){
        _videoPlayerController = VideoPlayerController.network(_advertVideoBean.data.url);
        _videoPlayerController.initialize().then((value){
          print("initVideo over");
          setState(() {
            _chewieController = ChewieController(videoPlayerController: _videoPlayerController,aspectRatio: _videoPlayerController.value.aspectRatio,autoPlay: true,looping: true);
            isinit = true;
            _chewieController.play();
          });
        });
        _videoPlayerController.play();
      }
    });


  }

  void _stop(){
    if(_videoPlayerController != null ){
      _videoPlayerController.pause();
      _videoPlayerController.dispose();
    }
    if(_chewieController != null && _chewieController.isPlaying){
      isinit = false;
      _chewieController.pause();
      _chewieController.dispose();
    }
  }

  @override
  void dispose() {
    _stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          color: Colors.grey[100],
          child: Column(
            children: [
              BackButtonWidget(cb: (){
                _stop();
                Navigator.pop(context);
              }, title: "返回"),
              Center(
                child:isinit ?
                AspectRatio(aspectRatio:_chewieController.aspectRatio,child: Chewie(controller:_chewieController),) : Container(
                  width: ScreenUtil().setWidth(SizeUtil.getWidth(40)),
                  height: ScreenUtil().setWidth(SizeUtil.getWidth(40)),
                  child: CircularProgressIndicator(color: Colors.red,),
                ),
              ),
              RoundedButton(click: (){
                Navigator.pop(context);
              }, label: "返回", vertical:SizeUtil.getHeight(40).toInt(),margin_top: SizeUtil.getHeight(200).toInt(), margin_bottom: SizeUtil.getHeight(100).toInt(), margin_left: SizeUtil.getWidth(100).toInt(), margin_right: SizeUtil.getWidth(100).toInt(),)
            ],
          ),
        ),
      ),
    );
  }
}