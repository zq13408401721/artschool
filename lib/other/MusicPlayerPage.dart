import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yhschool/bean/m_bean.dart';
import 'package:yhschool/utils/DataUtils.dart';
import 'package:yhschool/utils/HttpUtils.dart';
import 'package:yhschool/utils/SizeUtil.dart';
import 'package:yhschool/widgets/BackButtonWidget.dart';
import 'package:yhschool/widgets/CircleProgressWidget.dart';
import 'package:yhschool/widgets/RoundedButton.dart';

import '../BaseState.dart';

class MusicPlayerPage extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MusicPlayerPageState();
  }

}

class MusicPlayerPageState extends BaseState{

  String name;

  AudioPlayer _audioPlayer;
  int total=0;
  double currentpos = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _audioPlayer = AudioPlayer();
    _audioPlayer.onAudioPositionChanged.listen((event) {
      print("mp3:${event.inMilliseconds}");
      setState(() {
        currentpos = event.inMilliseconds/total;
      });
    });
    _audioPlayer.onDurationChanged.listen((event) async {
      print("duration:${event}");
      total = await _audioPlayer.getDuration();
    });
    _audioPlayer.onPlayerStateChanged.listen((event) {
      if(event == PlayerState.COMPLETED){
        loadMusic();
      }
    });
    _audioPlayer.onPlayerError.listen((event) {
      print("play err:${event}");
    });
    loadMusic();
  }

  void loadMusic(){
    httpUtil.post(DataUtils.api_loadmusic,data:{}).then((value){
      MBean bean = MBean.fromJson(json.decode(value));
      if(bean.errno == 0){
        if(mounted){
          setState(() {
            name = bean.data[0].name;
            _play(bean.data[0].url);
          });
        }
      }else{
        showToast(bean.errmsg);
      }
    });
  }

  /**
   * 播放音乐
   */
  void _play(String url) async{
    print("play url:${url}");
    int result = await _audioPlayer.play(url);
    if(result == 1){
      currentpos = 0;
      print("播放$url成功");
    }else{
      print("播放$url失败");
    }
  }

  /**
   * 暂停播放
   */
  void _pause() async{
    int result = await _audioPlayer.pause();
    if(result == 1){
      print("暂停播放");
    }else{
      print("暂停播放失败");
    }
  }

  /**
   * 快进
   */
  void _seekTo(int seek) async{
    int result = await _audioPlayer.seek(Duration(milliseconds: seek));
    print("result:$result");
  }

  /**
   * 停止播放
   */
  void _stop() async{
    int result = await _audioPlayer.release();
  }

  @override
  void dispose(){
    if(_audioPlayer != null){
      _stop();
    }
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
              }, title: "$name"),
              Padding(
                padding: EdgeInsets.only(
                    top: ScreenUtil().setHeight(SizeUtil.getHeight(100))
                ),
                child: CircleProgressWidget(
                  progress: Progress(
                      backgroundColor: Colors.grey[300],
                      value: currentpos,
                      radius: SizeUtil.getWidth(180),
                      completeText: "播放完",
                      color: Colors.red,
                      strokeWidth: 4
                  ),
                ),
              ),
              RoundedButton(click: (){
                loadMusic();
              }, label: "换一个", vertical:SizeUtil.getHeight(40).toInt(),margin_top: SizeUtil.getHeight(200).toInt(), margin_bottom: SizeUtil.getHeight(100).toInt(), margin_left: SizeUtil.getWidth(100).toInt(), margin_right: SizeUtil.getWidth(100).toInt(),)
            ],
          ),
        ),
      ),
    );
  }
}