import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/shims/dart_ui_real.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yhschool/BaseState.dart';
import 'package:yhschool/bean/start_advert_bean.dart';
import 'package:yhschool/utils/DataUtils.dart';
import 'package:yhschool/utils/HttpUtils.dart';
import 'package:video_player/video_player.dart';

/**
 * 第一次进入软件的弹框
 */
class PopWinStartAdvert extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return PopWinStartAdvertState();
  }

}

class PopWinStartAdvertState extends BaseState{

  Data _data;

  VideoPlayerController _controller;
  bool _isPlayer = false;

  TextStyle _textStyle;

  @override
  void initState() {
    super.initState();
    /*_textStyle = TextStyle(decoration: TextDecoration.underline,decorationColor: Colors.red,decorationStyle:TextDecorationStyle.solid,
        decorationThickness: ScreenUtil().setHeight(6),fontSize: ScreenUtil().setSp(36),fontWeight: FontWeight.bold,color: Colors.black54);*/
    getStartAdvert();
    //initVideoControll("http://res.yimios.com:9050/videos/fb9ccb7e9964d0acd5fcf23d0d32908d.mp4");
  }

  void initVideoControll(String url){
    _controller = VideoPlayerController.network(url);
    _controller.addListener(() {
      final bool _playing = _controller.value.isPlaying;
      print("播放状态$_playing");
      if(_isPlayer != _playing){
        setState(() {
          _isPlayer = _playing;
        });
      }
    });
    _controller.initialize().then((value){
      setState(() {
      });
    });
  }

  @override
  void dispose(){
    _controller.pause();
    super.dispose();
  }

  getStartAdvert(){
    httpUtil.get(DataUtils.api_startadvert,data:null).then((value){
      print("advert:$value");
      var data = StartAdvertBean.fromJson(json.decode(value));
      if(data.errno == 0){
        setState(() {
          _data = data.data;
          initVideoControll(data.data.videourl);
        });
      }else{
        showToast(data.errmsg);
      }
    }).catchError((err){

    });
  }

  String getWord(int type){
    if(_data == null) return "";
    switch(type){
      case 1:
        return _data.title;
      case 2:
        return _data.word1;
      case 3:
        return _data.word2;
      case 4:
        return _data.tabTitle1;
      case 5:
        return _data.tabTitle2;
      case 6:
        return _data.tabTitle3;
      case 7:
        return _data.tabTitle4;
      case 8:
        return _data.tabTitle5;
    }
    
  }
  
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Center(
      child: Card(
        margin: EdgeInsets.symmetric(
            horizontal: ScreenUtil().setWidth(100),
            vertical: ScreenUtil().setHeight(200)
        ),
        child: Column(
          children: [
            Padding(padding: EdgeInsets.only(
                left: ScreenUtil().setWidth(40),
                right: ScreenUtil().setWidth(40),
                top: ScreenUtil().setHeight(40)
            ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    child: Container(
                      height: ScreenUtil().setHeight(520),
                      child: Stack(
                        children: [
                          new Container(
                            height: ScreenUtil().setHeight(520),
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: Colors.black87,
                                borderRadius: BorderRadius.circular(ScreenUtil().setSp(10))
                            ),
                            child: _controller == null ?  Container() : VideoPlayer(_controller),
                          ),
                          Offstage(
                            offstage: (_controller != null && _isPlayer) ? true : false,
                            child: InkWell(
                              onTap: (){
                                if(_controller != null){
                                  _controller.play();
                                }
                              },
                              child: FractionallySizedBox(
                                heightFactor: 1.0,
                                widthFactor: 1.0,
                                child: Image.asset("image/ic_play.png"),
                              ),
                            ),
                          )

                        ],
                      ),
                    )
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: ScreenUtil().setHeight(20)
                    ),
                    child: Text(getWord(1),style: TextStyle(fontSize: ScreenUtil().setSp(40),fontWeight: FontWeight.bold),),
                  ),
                  Text.rich(TextSpan(
                      children: [
                        TextSpan(text: getWord(2),style: TextStyle(fontSize: ScreenUtil().setSp(36),color: Colors.black54)),
                        TextSpan(text: getWord(3),style: TextStyle(fontSize: ScreenUtil().setSp(36),fontWeight: FontWeight.bold))
                      ]
                  )),
                  Container(
                    margin: EdgeInsets.only(
                      top: ScreenUtil().setHeight(20)
                    ),
                    height: ScreenUtil().setHeight(240),
                    child: Row(
                      children: [
                        Image.asset('image/ic_advert2.png',width: ScreenUtil().setWidth(258),height: ScreenUtil().setHeight(240),),
                        FractionallySizedBox(
                          heightFactor: 0.6,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(getWord(4),style: _textStyle,),
                              Text(getWord(5),style: _textStyle,)
                            ],
                          ),
                        ),

                      ],
                    ),
                  ),
                  Container(
                    height: ScreenUtil().setHeight(240),
                    child: Row(
                      children: [
                        Image.asset('image/ic_advert1.png',width: ScreenUtil().setWidth(258),height: ScreenUtil().setHeight(240)),
                        FractionallySizedBox(
                          heightFactor: .6,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment:CrossAxisAlignment.start,
                            children: [
                              Text(getWord(6),style: _textStyle),
                              Text(getWord(7),style: _textStyle)
                            ],
                          ),
                        )

                      ],
                    ),
                  ),
                  Container(
                    child: Row(
                      children: [
                        Image.asset('image/ic_advert3.png',width: ScreenUtil().setWidth(258),height: ScreenUtil().setHeight(144)),
                        Text(getWord(8),style: _textStyle,),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Spacer(),
            InkWell(
              onTap: (){
                if(_controller != null){
                  _controller.pause();
                  Navigator.pop(context);
                }
              },
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(ScreenUtil().setWidth(10)),
                      bottomRight: Radius.circular(ScreenUtil().setWidth(10)),
                    )
                ),
                padding: EdgeInsets.symmetric(
                    vertical: ScreenUtil().setHeight(40)
                ),
                alignment: Alignment(0,0),
                child: Text("开始学习！三个月提高30分",style: TextStyle(fontSize: ScreenUtil().setSp(40),color: Colors.white),),
              ),
            )

          ],
        ),
      ),
    );
  }
}