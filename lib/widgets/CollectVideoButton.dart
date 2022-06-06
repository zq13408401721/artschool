import 'dart:convert';

import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yhschool/BaseState.dart';
import 'package:yhschool/bean/CollectDB.dart';
import 'package:yhschool/bean/CollectDateDB.dart';
import 'package:yhschool/bean/CollectVideoDB.dart';
import 'package:yhschool/bean/collect_add_bean.dart';
import 'package:yhschool/bean/collect_date_bean.dart';
import 'package:yhschool/bean/collect_delete_bean.dart';
import 'package:yhschool/utils/Constant.dart';
import 'package:yhschool/utils/DBUtils.dart';
import 'package:yhschool/utils/DataUtils.dart';
import 'package:yhschool/utils/HttpUtils.dart';
import 'package:yhschool/utils/SizeUtil.dart';

class CollectVideoButton extends StatefulWidget{

  int margin_left;
  int margin_right;
  int categoryid;
  String subject;
  String section;
  CollectVideoButton({Key key,
    @required this.margin_left=0,
    @required this.margin_right=0,
    @required this.categoryid,
    @required this.subject,
    @required this.section
  }):super(key: key);

  @override
  State<StatefulWidget> createState() {
    return CollectVideoButtonState();
  }
}

class CollectVideoButtonState extends BaseState<CollectVideoButton>{

  bool iscollect = false;
  bool waiting = false;
  String uid;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.getUserInfo().then((value){
      setState(() {
        uid = value["uid"];
      });
    });
    _checkCollect(widget.categoryid);
  }

  /**
   * 检查是否收藏
   */
  void _checkCollect(int fromid){
    DBUtils.dbUtils.then((value){
      value.checkVideoCollect(uid, widget.categoryid).then((value){
        setState(() {
          this.iscollect = value;
        });
      });
    });
  }

  /**
   * 保存收藏数据到服务器
   */
  void saveCollect(){
    var option = {
      "categoryid":widget.categoryid,
      "subject":widget.subject,
      "section":widget.section
    };
    httpUtil.post(DataUtils.api_addvideocollect,data:option).then((value){
      waiting = false;
      CollectAddBean addBean = CollectAddBean.fromJson(json.decode(value));
      if(addBean.errno == 0){
        //把收藏信息写入本地
        CollectVideoDB _collectDB = CollectVideoDB(uid: uid,categoryid: widget.categoryid);
        DBUtils.dbUtils.then((value) => value.insertCollectVideo(_collectDB));
        setState(() {
          this.iscollect = true;
        });
      }else if(addBean.errno == 801){
        CollectVideoDB _collectDB = CollectVideoDB(uid: uid,categoryid: widget.categoryid);
        DBUtils.dbUtils.then((value) => value.insertCollectVideo(_collectDB));
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
      "categoryid":widget.categoryid,
    };
    httpUtil.post(DataUtils.api_deletevideocollect,data:option).then((value){
      waiting = false;
      CollectDeleteBean delBean = CollectDeleteBean.fromJson(json.decode(value));
      if(delBean.errno == 0){
        //把收藏信息写入本地
        DBUtils.dbUtils.then((value) => value.delCollectVideo(uid,widget.categoryid));
        setState(() {
          this.iscollect = false;
        });
      }else{
        showToast(delBean.errmsg);
        DBUtils.dbUtils.then((value) => value.delCollectVideo(uid,widget.categoryid));
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
    print("size:${ScreenUtil().setSp(SizeUtil.getFontSize(30))}");
    return InkWell(
      onTap: (){
        if(!waiting){
          waiting = true;
          if(this.iscollect){
            delCollect();
          }else{
            saveCollect();
          }
        }
      },
      child: Container(
        margin: EdgeInsets.only(
            left: ScreenUtil().setWidth(SizeUtil.getWidth(widget.margin_left.toDouble())),
            right: ScreenUtil().setWidth(SizeUtil.getWidth(widget.margin_right.toDouble()))
        ),
        padding: EdgeInsets.only(
            top: ScreenUtil().setHeight(SizeUtil.getHeight(20)),
            bottom: ScreenUtil().setHeight(SizeUtil.getHeight(30))
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(this.iscollect ? "image/ic_collect_select.png" : "image/ic_collect_normal.png",width: ScreenUtil().setWidth(SizeUtil.getWidth(40)),height: ScreenUtil().setHeight(SizeUtil.getHeight(40)),),
            SizedBox(width: ScreenUtil().setWidth(8),),
            Text(this.iscollect ? "取消收藏" : "收藏",style: TextStyle(color: this.iscollect ? Colors.red : Colors.black,fontSize: ScreenUtil().setSp(SizeUtil.getFontSize(30))))
          ],
        ),
      ),
    );
  }
}