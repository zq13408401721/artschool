import 'dart:convert';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yhschool/BaseCoustPageRefreshState.dart';
import 'package:yhschool/BaseCoustRefreshState.dart';
import 'package:yhschool/BaseDialogState.dart';
import 'package:yhschool/bean/live_list_bean.dart';
import 'package:yhschool/bean/live_room_bean.dart';
import 'package:yhschool/bean/live_room_info_bean.dart';
import 'package:yhschool/bean/record_bean.dart';
import 'package:yhschool/bean/school_live_room_info_bean.dart';
import 'package:yhschool/live/LiveBuilder.dart';
import 'package:yhschool/live/LivePlayer.dart';
import 'package:yhschool/utils/DataUtils.dart';
import 'package:yhschool/utils/HttpUtils.dart';
import 'package:yhschool/utils/SizeUtil.dart';
import 'package:yhschool/widgets/BackButtonWidget.dart';
import 'package:yhschool/widgets/RoundedButton.dart';
import 'package:yhschool/bean/live_editor_bean.dart';

/**
 * 直播页面
 */
class LivePage extends StatefulWidget{
  String roomid;
  String schoolname;


  LivePage({Key key,@required this.roomid,@required this.schoolname});

  @override
  State<StatefulWidget> createState() {
    return LivePageState();
  }
}

class LivePageState extends BaseCoustPageRefreshState<LivePage>{

  ScrollController _controller;

  var cc_userid = "A478E06B5AA1107B";

  int page=1;
  List<dynamic> _list=[];
  //直播房间信息
  Room room;
  LivePage getWidget(){
    return widget as LivePage;
  }

  @override
  void initState() {
    super.initState();
    _controller = initScrollController(isfresh: false);
    getRole().then((value) => m_role = value);
    _getRoomInfo(getWidget().roomid);
    _getRecordList();
  }

  /**
   * 获取房间直播
   */
  void  _getRoomInfo(String roomid){
    Map<String,String> option = {
      "roomid":roomid,
      "userid":cc_userid
    };
    var params = httpUtil.ccLiveSign(option);
    ccUtil.get("${DataUtils.api_ccliveroominfo}?${params}").then((value){
      print("roominfo:$value");
      //获取直播间状态
      Map<String,String> stateOption = {
        "roomids":roomid,"userid":cc_userid
      };
      var stateParam = httpUtil.ccLiveSign(stateOption);
      ccUtil.get("${DataUtils.api_ccliveroomstate}?${stateParam}").then((stateResult){
        print("stateResult:${stateResult}");
        var _stateRes = json.decode(stateResult);
        var _state = 0;
        if(_stateRes["result"] == "OK"){
          for(var i=0; i<_stateRes["rooms"].length; i++){
            if(_stateRes["rooms"][i]["roomId"] == roomid){
              _state = _stateRes["rooms"][i]["liveStatus"];
              break;
            }
          }
        }
        var _info = json.decode(value);
        //获取对应的学校直播房间和二维码信息
        httpUtil.post(DataUtils.api_liverooninfobysid,data:{"roomid":roomid}).then((liveroom){
          SchoolLiveRoomInfoBean _liveroom = SchoolLiveRoomInfoBean.fromJson(json.decode(liveroom));
          if(_liveroom.errno == 0){
            Room _room = Room(
              id: _info["room"]["id"],
              name: _info["room"]["name"],
              desc:_info["room"]["desc"],
              status: _info["room"]["status"],
              authtype: _info["room"]["authtype"],
              liveStartTime: _info["room"]["liveStartTime"],
              liveState:_state,
              playurl: _liveroom.data.playurl,
              pushurl: _liveroom.data.pushurl,
              qrurl: _liveroom.data.qrurl,
              schoolname: _liveroom.data.schoolname
            );
            room = _room;
            setState(() {
              _list.insert(0,_room);
            });
          }
        });

      });
      /*LiveRoomInfoBean bean = LiveRoomInfoBean.fromJson(json.decode(value));
      room = bean.data.room;
      if(bean.errno == 0){
        setState(() {
          _list.insert(0,bean.data.room);
        });
      }else{

      }*/
    });
  }

  /**
   * 获取回放记录
   */
  void _getRecordList(){
    var option = {
      "roomid":getWidget().roomid,
      "page":page,
      "pagenum":50
    };
    httpUtil.post(DataUtils.api_recordlist,data: option).then((value){
      hideLoadMore();
      print(value);
      RecordBean bean = RecordBean.fromJson(json.decode(value));
      if(bean.errno == 0){
        if(bean.data.records != null && bean.data.records.length < 50){
          hasData = false;
        }else{
          page++;
        }
        setState(() {
          _list.addAll(bean.data.records);
        });
      }else{
        showToast(bean.errmsg);
      }
    });
  }

  void _showDelAlert(String recordid){
    showDialog<Null>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new AlertDialog(
            //可滑动
            content: Text('删除后无法找回，确认删除？'),
            actions: <Widget>[
              new ElevatedButton(
                child: new Text('确定'),
                onPressed: () {
                  _delLiveRecord(recordid);
                },
              ),
              new ElevatedButton(
                child: new Text('取消'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  /**
   * 删除直播记录
   */
  void _delLiveRecord(String recordid){
    var option = {
      "recordids":recordid
    };
    httpUtil.post(DataUtils.api_delliverecord,data: option).then((value){
      LiveEditorBean bean = LiveEditorBean.fromJson(json.decode(value));
      if(bean.errno == 0){
        //删除回放列表中的数据
        for(var i=0; i<_list.length; i++){
          if(_list[i] is Records && _list[i].id == recordid){
            setState(() {
              _list.removeAt(i);
            });
            break;
          }
        }
      }
      Navigator.of(context).pop();
    });
  }


  //直播二维码弹框
  void _showQRDialog(){
    showDialog(context: context, barrierDismissible:true,builder: (context){
      return StatefulBuilder(builder: (_context,_state){
        return UnconstrainedBox(
          child: Container(
            width: ScreenUtil().setWidth(SizeUtil.getWidth(600)),
            height: ScreenUtil().setHeight(SizeUtil.getHeight(900)),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(ScreenUtil().setWidth(10)),
                color: Colors.white
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                //顶部
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      color: Color(0xFF5810FF),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(ScreenUtil().setWidth(10)),
                        topRight: Radius.circular(ScreenUtil().setWidth(10)),
                      )
                  ),
                  child: RichText(
                    text: TextSpan(
                        children: [
                          TextSpan(text:"重要提示：",style: TextStyle(fontSize: ScreenUtil().setSp(SizeUtil.getFontSize(30)),color: Colors.white,fontWeight: FontWeight.bold,)),
                          TextSpan(text:"直播讲师需下载直播推流软件，并且输入讲师密码，请咨询学校相关负责人，谢谢。",style: TextStyle(fontSize: ScreenUtil().setSp(SizeUtil.getFontSize(30)),color: Colors.white,)),
                        ]
                    ),
                  ),
                ),
                //二维码
                SizedBox(height: ScreenUtil().setHeight(SizeUtil.getHeight(80)),),
                CachedNetworkImage(imageUrl:room.qrurl,width:ScreenUtil().setWidth(SizeUtil.getWidth(300)),height:ScreenUtil().setWidth(SizeUtil.getWidth(300))),
                SizedBox(height: ScreenUtil().setHeight(SizeUtil.getHeight(10)),),
                Text("使用直播推流软件扫描开播",style: TextStyle(color: Colors.black87,fontSize: ScreenUtil().setSp(SizeUtil.getFontSize(25)),fontWeight: FontWeight.normal,decoration: TextDecoration.none)),
                SizedBox(height: ScreenUtil().setHeight(SizeUtil.getHeight(80)),),
                GestureDetector(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(ScreenUtil().setSp(10))
                    ),
                    padding: EdgeInsets.symmetric(
                        horizontal: ScreenUtil().setWidth(SizeUtil.getWidth(40)),
                        vertical: ScreenUtil().setHeight(SizeUtil.getHeight(20))
                    ),
                    child: Text("我知道了",style: TextStyle(color: Colors.white,fontSize:ScreenUtil().setSp(SizeUtil.getFontSize(40)),fontWeight: FontWeight.normal,decoration: TextDecoration.none),),
                  ),
                )
              ],
            ),
          ),
        );
      });
    });
  }

  Widget _liveState(String icon,String label,TextStyle style){
    return Row(
      children: [
        Image.asset(icon,width: ScreenUtil().setWidth(SizeUtil.getWidth(60)),height: ScreenUtil().setWidth(SizeUtil.getWidth(60)),),
        SizedBox(width: ScreenUtil().setWidth(10),),
        Text((label == null || label.length ==0) ? "美好即将开启，敬请期待。" : label,style: style,)
      ],
    );
  }

  /**
   * 进入直播状态
   */
  Widget _liveComeInState(String label){
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text("$label >",style: TextStyle(color: Colors.grey),),
        SizedBox(width: ScreenUtil().setWidth(SizeUtil.getWidth(20)),),
      ],
    );
  }

  /**
   * 直播操作
   */
  Widget _liveToolsState(bool islive,dynamic _data){
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        //编辑
        Offstage(
          offstage: !islive,
          child: InkWell(
            onTap: (){
              if(m_role == 1){
                Navigator.push(context, MaterialPageRoute(builder:(context)=>LiveBuilder(roomid: (widget as LivePage).roomid,))).then((value){
                  if(value != null){
                    if(_list.length > 0){
                      setState(() {
                        if(_list[0] is Room){
                          (_list[0] as Room).name = value['name'];
                          (_list[0] as Room).desc = value['desc'];
                          (_list[0] as Room).liveStartTime = value['date'];
                        }
                      });
                    }
                  }
                });
              }else{
                showToast("只有老师才能直播");
              }
            },
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical:ScreenUtil().setHeight(20),
                horizontal:ScreenUtil().setWidth(10),
              ),
              child: Image.asset("image/ic_live_editor.png",width:ScreenUtil().setWidth(SizeUtil.getWidth(110)),height: ScreenUtil().setHeight(SizeUtil.getHeight(60)),),
            ),
          ),
        ),
        //二维码
        Offstage(
          offstage: !islive,
          child: InkWell(
            onTap: (){
              //弹出二维码 如果当前是老师，直接弹出
              if(m_role == 1){
                _showQRDialog();
              }else{
                showToast("只有老师才能直播");
              }
            },
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical:ScreenUtil().setHeight(20),
                horizontal:ScreenUtil().setWidth(10),
              ),
              child: Image.asset("image/ic_live_qr.png",width:ScreenUtil().setWidth(SizeUtil.getWidth(110)),height: ScreenUtil().setHeight(SizeUtil.getHeight(60)),),
            ),
          ),
        ),
        //删除
        Offstage(
          offstage: (islive || m_role != 1),
          child: InkWell(
            onTap: (){
              _showDelAlert(_data.id);
            },
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical:ScreenUtil().setHeight(20),
                horizontal:ScreenUtil().setWidth(10),
              ),
              child: Image.asset("image/ic_live_delete.png",width:ScreenUtil().setWidth(SizeUtil.getWidth(110)),height: ScreenUtil().setHeight(SizeUtil.getHeight(60)),),
            ),
          ),
        )
      ],
    );
  }

  /**
   * 获取直播间状态图标
   */
  String _liveIcon(Room _room){
    return _room.liveState == 0 ? "image/ic_live_date.png" : "image/ic_living.png";
  }

  /**
   *  直播房间对应的文字显示状态
   */
  TextStyle _liveStyle(Room _room){
    return _room.liveState == 0 ? TextStyle(color: Colors.green) : TextStyle(color: Colors.red);
  }

  /**
   * 直播列表条目
   */
  Widget _liveItem(dynamic _data){
    //通过_data类型判断当前是直播还是回放
    bool _islive = _data is Room;
    //直播间信息
    Room _room;
    //回放信息
    Records _records;
    if(_islive){
      _room = _data as Room;
    }else{
      _records = _data as Records;
    }
    return InkWell(
      onTap: (){
        if(_islive){
          if(_room.liveState == 0){
            showToast("直播尚未开启，敬请等待");
          }else{
            //进入直播
            print("playurl:${_room.playurl}");
            skipPlayer(_room.playurl,true);
          }
        }else{
          //观看回放
          skipPlayer(_records.replayUrl,false);
        }
      },
      child: Container(
        padding: EdgeInsets.only(
          left: ScreenUtil().setWidth(SizeUtil.getWidth(40)),
          top: ScreenUtil().setWidth(SizeUtil.getWidth(20)),
          bottom: ScreenUtil().setWidth(SizeUtil.getWidth(20)),
          right:ScreenUtil().setWidth(SizeUtil.getWidth(10)),
        ),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(ScreenUtil().setWidth(10))
        ),
        margin: EdgeInsets.only(
            left: ScreenUtil().setWidth(SizeUtil.getWidth(40)),
            right: ScreenUtil().setWidth(SizeUtil.getWidth(40)),
            top: ScreenUtil().setHeight(SizeUtil.getHeight(40)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //状态
                _liveState(_islive ? _liveIcon(_room) : "image/ic_live_end.png", _islive ? (_room.liveState == 0 ? _room.liveStartTime : "直播中...") : "直播已结束",
                    _islive ? _liveStyle(_room) : TextStyle(color: Colors.grey)),
                _liveComeInState(_islive ? "进入直播" : "观看回放")
              ],
            ),
            SizedBox(height: ScreenUtil().setHeight(SizeUtil.getHeight(20)),),
            //直播名称
            Text(_islive ? _room.name : _records.title,style: TextStyle(fontSize: ScreenUtil().setSp(SizeUtil.getFontSize(30))),),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(room != null ? room.schoolname : "",style: TextStyle(fontSize: ScreenUtil().setSp(SizeUtil.getFontSize(25)),color: Colors.grey[300]),),
                _liveToolsState(_islive,_data)
              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  List<Widget> addChildren() {
    return [
      Container(
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            BackButtonWidget(cb: (){
              Navigator.pop(context);
            }, title: "轻直播",),
            /*Padding(padding: EdgeInsets.only(right: ScreenUtil().setWidth(SizeUtil.getWidth(40))),
              child: Text("编辑 / 创建直播",style: TextStyle(color: Colors.red),),
            )*/
          ],
        ),
      ),
      Expanded(
        child: ListView.builder(itemCount:_list.length,
            itemBuilder: (context,index) => _liveItem(_list[index])
        ),
      )
    ];
  }

  @override
  void loadmore() {
    if(!this.isloading){
      if(hasData){
        _getRecordList();
      }
    }
  }

  @override
  void refresh() {

  }

  void skipPlayer(String url,bool _islive){
    Navigator.push(context, MaterialPageRoute(builder: (context)=>LivePlayer(name:room.name,url: url, qr_url: room.qrurl,islive: _islive,)));
  }


}