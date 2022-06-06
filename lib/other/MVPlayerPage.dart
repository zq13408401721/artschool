import 'dart:convert';

import 'package:chewie/chewie.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yhschool/BaseState.dart';
import 'package:yhschool/utils/DataUtils.dart';
import 'package:yhschool/utils/HttpUtils.dart';
import 'package:yhschool/utils/SizeUtil.dart';
import 'package:yhschool/widgets/BackButtonWidget.dart';
import 'package:yhschool/widgets/RoundedButton.dart';
import 'package:video_player/video_player.dart';
import 'package:yhschool/bean/m_bean.dart';

class MVPlayerPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MVPlayerPageState();
  }
}

class MVPlayerPageState extends BaseState{

  VideoPlayerController _videoPlayerController;
  ChewieController _chewieController;
  String name;
  bool isinit = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadMV();
  }

  void _loadMV(){
    httpUtil.post(DataUtils.api_loadmv,data: {}).then((value){
      _stopPlay();
      MBean bean = MBean.fromJson(json.decode(value));
      if(bean.errno == 0){
        setState(() {
          name = bean.data[0].name;
          _playMV(bean.data[0].url);
        });
      }else{
        showToast(bean.errmsg);
      }
    });
  }

  void refreshPlayPosition(){
    //print("${_videoPlayerController.value.isInitialized} ${_videoPlayerController.value.isPlaying} ${_videoPlayerController.value.position} ${_videoPlayerController.value.duration}");
    if(_videoPlayerController.value.isInitialized && _videoPlayerController.value.isPlaying && _videoPlayerController.value.position.inSeconds == _videoPlayerController.value.duration.inSeconds){
      print("刷新 mv");
      _videoPlayerController.removeListener(refreshPlayPosition);
      _loadMV();
    }
  }

  void _playMV(String url){
    _videoPlayerController = VideoPlayerController.network(url);
    print("play $url");
    _videoPlayerController.addListener(refreshPlayPosition);
    _videoPlayerController.initialize().then((value){
      print("init over");
      if(mounted){
        setState(() {
          _chewieController = ChewieController(videoPlayerController: _videoPlayerController,aspectRatio: _videoPlayerController.value.aspectRatio,autoPlay: true,looping: true);
          isinit = true;
          _chewieController.play();
        });
      }
    });

  }

  void _stopPlay(){
    if(_videoPlayerController != null){
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
    // TODO: implement dispose
    _stopPlay();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          color: Colors.grey[100],
          child: Column(
            children: [
              BackButtonWidget(cb: (){
                _stopPlay();
                Navigator.pop(context);
              }, title: "$name"),
              isinit ?
              AspectRatio(aspectRatio:_chewieController.aspectRatio,child: Chewie(controller: _chewieController,),) :
              Container(
                  height: ScreenUtil().setHeight(SizeUtil.getHeight(400)),
                  width: double.infinity,
                  child: Center(
                      child:Container(
                        width: ScreenUtil().setWidth(SizeUtil.getWidth(50)),
                        height: ScreenUtil().setWidth(SizeUtil.getWidth(50)),
                        child:  CircularProgressIndicator(color: Colors.red,),
                      )
                  )
              ),
              RoundedButton(click: (){
                _loadMV();
              }, label: "换一个", vertical:SizeUtil.getHeight(40).toInt(),margin_top: SizeUtil.getHeight(200).toInt(), margin_bottom: SizeUtil.getHeight(100).toInt(), margin_left: SizeUtil.getWidth(100).toInt(), margin_right: SizeUtil.getWidth(100).toInt(),)
            ],
          ),
        ),
      ),
    );
  }
}