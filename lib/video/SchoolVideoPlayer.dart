import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_player/video_player.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:yhschool/BaseState.dart';
import 'package:yhschool/FlutterPlugins.dart';
import 'package:yhschool/widgets/BackButtonWidget.dart';

import '../utils/SizeUtil.dart';

class SchoolVideoPlayer extends StatefulWidget{

  String url;
  String icon;
  String name;
  int total;
  SchoolVideoPlayer({Key key,@required this.url,@required this.icon,@required this.name,@required this.total}):super(key:key);

  @override
  State<StatefulWidget> createState() {
    return SchoolVideoPlayerState();
  }
}

class VideoChewieController extends ChewieController {

  VideoPlayerController videoPlayerController;
  double aspectRatio;
  bool autoInitialize;
  bool autoPlay;
  bool looping;
  bool allowedScreenSleep;
  List<DeviceOrientation> deviceOrientationsAfterFullScreen;


  VideoChewieController({
    @required this.videoPlayerController,
    @required this.aspectRatio,
    @required this.autoInitialize,
    @required this.autoPlay,
    @required this.looping,
    @required this.allowedScreenSleep,
    @required this.deviceOrientationsAfterFullScreen
  }):super(
    videoPlayerController: videoPlayerController,
    aspectRatio: aspectRatio,
    autoInitialize: autoInitialize,
    autoPlay: autoPlay,
    looping: looping,
    allowedScreenSleep: allowedScreenSleep,
    deviceOrientationsAfterFullScreen: deviceOrientationsAfterFullScreen
  );

  @override
  void enterFullScreen() {
    super.enterFullScreen();
    print("enterFullScreen");
  }

  @override
  void exitFullScreen() {
    // TODO: implement exitFullScreen
    super.exitFullScreen();
    print("exitFullScreen");
    /*SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown
    ]);*/
  }


}

class SchoolVideoPlayerState extends BaseState<SchoolVideoPlayer>{

  ChewieController _chewieController;
  VideoPlayerController _videoPlayerController;
  bool isinit = false;

  @override
  void initState() {
    super.initState();
    print("video url: ${widget.url}");
    //FlutterPlugins.setOrientation(1);
    _videoPlayerController = VideoPlayerController.network(Uri.encodeFull(widget.url));
    _videoPlayerController.addListener(refreshPlayPosition);
    _videoPlayerController.initialize().then((value){
      print("init over");
      if(mounted){
        setState(() {
          _chewieController = VideoChewieController(
              videoPlayerController: _videoPlayerController,
              aspectRatio: _videoPlayerController.value.aspectRatio,
              autoInitialize: true,
              autoPlay: false,
              looping: false,
              allowedScreenSleep: false,
            deviceOrientationsAfterFullScreen: [
              DeviceOrientation.portraitUp,
              DeviceOrientation.portraitDown
            ]
          );
          isinit = true;
          _chewieController.play();
        });
      }
    });
    //changeScreen();
  }

  void changeScreen(){
    String curmodel = "horizontal";
    if(curmodel == "vertical"){  //竖屏
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown
      ]);
    }else if(curmodel == "horizontal"){  //横屏
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight
      ]);
    }
  }

  void refreshPlayPosition(){
    //print("${_videoPlayerController.value.isInitialized} ${_videoPlayerController.value.isPlaying} ${_videoPlayerController.value.position} ${_videoPlayerController.value.duration}");
    //print("rotation ${_videoPlayerController.value.rotationCorrection} ${_videoPlayerController.value}");
    if(_videoPlayerController.value.isInitialized && _videoPlayerController.value.isPlaying && _videoPlayerController.value.position.inSeconds == _videoPlayerController.value.duration.inSeconds){
      print("刷新 vieo");
      _videoPlayerController.removeListener(refreshPlayPosition);
    }
  }

  void _stopPlay(){
    if(_videoPlayerController != null){
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
    _stopPlay();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("build");
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              BackButtonWidget(cb: (){
                Navigator.pop(context);
              }, title: ""),
              isinit ? AspectRatio(aspectRatio:_chewieController.aspectRatio,child: Container(width: double.infinity,height: double.infinity,child: Chewie(controller: _chewieController,),),) :
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
              //视频合集信息
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: SizeUtil.getAppWidth(20),
                  vertical: SizeUtil.getAppHeight(20)
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: CachedNetworkImage(imageUrl: widget.icon,width: SizeUtil.getAppWidth(200),height: SizeUtil.getAppHeight(140),fit: BoxFit.cover,),
                    ),
                    SizedBox(width: SizeUtil.getAppWidth(20),),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width:SizeUtil.getAppWidth(500),
                          child: Text("${widget.name}",style: TextStyle(fontSize: SizeUtil.getAppFontSize(30)),maxLines: 1,overflow: TextOverflow.ellipsis,),
                        ),
                        SizedBox(height: SizeUtil.getAppHeight(10),),
                        Text("共计${widget.total}个视频课程",style: TextStyle(fontSize: SizeUtil.getAppFontSize(18),color: Colors.grey),)
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

}