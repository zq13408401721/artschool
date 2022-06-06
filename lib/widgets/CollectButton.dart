import 'dart:convert';

import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yhschool/BaseState.dart';
import 'package:yhschool/bean/CollectDB.dart';
import 'package:yhschool/bean/CollectDateDB.dart';
import 'package:yhschool/bean/collect_add_bean.dart';
import 'package:yhschool/bean/collect_date_bean.dart';
import 'package:yhschool/bean/collect_delete_bean.dart';
import 'package:yhschool/utils/Constant.dart';
import 'package:yhschool/utils/DBUtils.dart';
import 'package:yhschool/utils/DataUtils.dart';
import 'package:yhschool/utils/HttpUtils.dart';
import 'package:yhschool/utils/SizeUtil.dart';

class CollectButton extends StatefulWidget{

  int margin_left;
  int margin_right;
  int from;
  int fromid;
  String url;
  String name;
  int width,height;
  CollectButton({Key key,
    @required this.margin_left=0,
    @required this.margin_right=0,
    @required this.from,
    @required this.fromid,
    @required this.url,
    @required this.name,
    @required this.width,
    @required this.height
  }):super(key: key);

  @override
  State<StatefulWidget> createState() {
    return CollectButtonState();
  }
}

class CollectButtonState extends BaseState<CollectButton>{

  bool iscollect = false;
  bool waiting = false;
  String uid,username,nickname;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.getUserInfo().then((value){
      setState(() {
        uid = value["uid"];
        username = value["username"];
        nickname = value["nickname"];
      });
    });
    _checkCollect(widget.fromid);
  }

  /**
   * 检查是否收藏
   */
  void _checkCollect(int fromid){
    DBUtils.dbUtils.then((value){
      value.checkCollect(uid, widget.from,fromid).then((value){
        setState(() {
          this.iscollect = value;
        });
      });
    });
  }

  /**
   * 添加到收藏功能
   */
  void addCollect() {
    waiting = true;
    DBUtils.dbUtils.then((value) {
      String date = formatDate(DateTime.now(), [yyyy, "-", mm, "-", dd]);
      value.queryCollectDate(uid, date).then((value) {
        if (value > 0) {
          saveCollect(value);
        } else {
          httpUtil.post(DataUtils.api_collectdate, data: {}).then((value) {
            CollectDateBean dateBean = CollectDateBean.fromJson(json.decode(value));
            if (dateBean.errno == 0) {
              //保存收藏时间数据到本地
              DBUtils.dbUtils.then((value) {
                value.insertCollectDate(CollectDateDB(uid: uid, dateid: dateBean.data.dateid, date: date));
              });
              saveCollect(dateBean.data.dateid);
            } else {
              showToast(dateBean.errmsg);
            }
          });
        }
      });
    });
  }

  /**
   * 保存收藏数据到服务器
   */
  void saveCollect(int dateid){
    var option = {
      "dateid":dateid,
      "name":widget.name,
      "title":nickname == null ? username : nickname,
      "from":widget.from,
      "fromid":widget.fromid,
      "url":widget.url,
      "width":widget.width,
      "height":widget.height
    };
    httpUtil.post(DataUtils.api_addcollect,data:option).then((value){
      waiting = false;
      CollectAddBean addBean = CollectAddBean.fromJson(json.decode(value));
      if(addBean.errno == 0){
        //把收藏信息写入本地
        CollectDB _collectDB = CollectDB(uid: uid,from: widget.from,fromid: widget.fromid);
        DBUtils.dbUtils.then((value) => value.insertCollect(_collectDB));
        setState(() {
          this.iscollect = true;
        });
      }else if(addBean.errno == 801){
        CollectDB _collectDB = CollectDB(uid: uid,from: widget.from,fromid: widget.fromid);
        DBUtils.dbUtils.then((value) => value.insertCollect(_collectDB));
        setState(() {
          this.iscollect = true;
        });
      }else{
        showToast(addBean.errmsg);
      }
    }).catchError((err){
      waiting = false;
    });
  }

  /**
   * 删除收藏
   */
  void delCollect(){
    waiting = true;
    var option = {
      "from":widget.from,
      "fromid":widget.fromid,
    };
    httpUtil.post(DataUtils.api_delcollect,data:option).then((value){
      waiting = false;
      CollectDeleteBean delBean = CollectDeleteBean.fromJson(json.decode(value));
      if(delBean.errno == 0){
        //把收藏信息写入本地
        DBUtils.dbUtils.then((value) => value.delCollect(uid,widget.from,widget.fromid));
        setState(() {
          this.iscollect = false;
        });
      }else{
        showToast(delBean.errmsg);
        DBUtils.dbUtils.then((value) => value.delCollect(uid,widget.from,widget.fromid));
        setState(() {
          this.iscollect = false;
        });
      }
    }).catchError((err){
      waiting = false;
    });
  }


  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        if(!waiting){
          waiting = true;
          if(this.iscollect){
            delCollect();
          }else{
            addCollect();
          }
        }
      },
      child: Container(
        margin: EdgeInsets.only(
          left: ScreenUtil().setWidth(widget.margin_left),
          right: ScreenUtil().setWidth(widget.margin_right)
        ),
        padding: EdgeInsets.only(
            top: ScreenUtil().setHeight(SizeUtil.getHeight(20)),
            bottom: ScreenUtil().setHeight(SizeUtil.getHeight(30))
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(this.iscollect ? "image/ic_collect_select.png" : "image/ic_collect_normal.png",width: ScreenUtil().setWidth(SizeUtil.getWidth(40)),height: ScreenUtil().setHeight(SizeUtil.getWidth(40)),),
            SizedBox(width: ScreenUtil().setWidth(SizeUtil.getWidth(8)),),
            Text(this.iscollect ? "取消收藏" : "收藏",style: TextStyle(color: this.iscollect ? Colors.red : Colors.black,fontSize: ScreenUtil().setSp(SizeUtil.getFontSize(30))))
          ],
        ),
      ),
    );
  }
}