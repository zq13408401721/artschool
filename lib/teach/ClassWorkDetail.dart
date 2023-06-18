import 'dart:async';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
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
import 'package:yhschool/bean/work_correct_bean.dart';
import 'package:yhschool/bean/work_list_bean.dart';
import 'package:yhschool/bean/work_score_bean.dart';
import 'package:yhschool/teach/WorkCorrect.dart';
import 'package:yhschool/utils/Constant.dart';
import 'package:yhschool/utils/DBUtils.dart';
import 'package:yhschool/utils/DataUtils.dart';
import 'package:yhschool/utils/HttpUtils.dart';
import 'package:yhschool/utils/ImageType.dart';
import 'package:yhschool/utils/SizeUtil.dart';
import 'package:yhschool/widgets/BackButtonWidget.dart';
import 'package:yhschool/widgets/BaseViewPagerState.dart';
import 'package:yhschool/widgets/CollectButton.dart';
import 'package:yhschool/widgets/LineLoad.dart';

import '../GalleryBig.dart';

class ClassWorkDetail extends StatefulWidget{

  int classid;
  List<Works> data;
  int position;
  ClassWorkDetail({@required this.classid,@required this.data,@required this.position=0});

  @override
  State<StatefulWidget> createState() {
    return ClassWorkDetailState(data: data,position: position,)
    ..classid = classid;
  }
}

class ClassWorkDetailState extends BaseViewPagerState<Works,ClassWorkDetail>{

  int classid;
  List<Works> data;
  bool waiting = false;
  bool iscollect = false;
  int position;
  String uid;
  int role;

  double loadingProgress=-1;
  bool loadover = false;
  double _width=0;
  WorkScoreBean workScoreBean;

  Timer timer;

  ClassWorkDetailState({Key key,@required this.data,@required this.position}):super(key: key,data: data,start: position);

  @override
  void initState() {
    super.initState();
    registerTimer();
    getUid().then((value) => uid=value);
    getRole().then((value) => role=value);
    getWorkScore(data[position]);
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
   * 获取作业分数
   */
  void getWorkScore(Works work){
    if(work.workScoreBean != null){
      setState(() {
        workScoreBean = work.workScoreBean;
      });
      return;
    }
    var option = {
      "workid":work.id
    };
    httpUtil.post(DataUtils.api_getworkscorebyworkid,data:option).then((value){
       WorkScoreBean bean = WorkScoreBean.fromJson(json.decode(value));
       setState(() {
         if(bean.data != null){
           if(work.id == bean.data.workid){
             work.workScoreBean = bean;
           }else{
             for(Works item in data){
               if(item.id == bean.data.workid){
                 item.workScoreBean = bean;
                 break;
               }
             }
           }
         }
         workScoreBean = bean;
       });
    });
  }

  @override
  void dispose() {
    if(timer != null){
      timer.cancel();
    }
    super.dispose();
  }

  /**
   * 添加到收藏功能
   */
  void addCollect(){
    waiting = true;
    DBUtils.dbUtils.then((value){
      String date = formatDate(DateTime.now(),[yyyy,"-",mm,"-",dd]);
      value.queryCollectDate(m_uid, date).then((value){
        if(value > 0){
          saveCollect(value);
        }else{
          httpUtil.post(DataUtils.api_collectdate,data:{}).then((value){
            CollectDateBean dateBean = CollectDateBean.fromJson(json.decode(value));
            if(dateBean.errno == 0){
              //保存收藏时间数据到本地
              DBUtils.dbUtils.then((value){
                value.insertCollectDate(CollectDateDB(uid: m_uid,dateid: dateBean.data.dateid,date: date));
              });
              saveCollect(dateBean.data.dateid);
            }else{
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
      "name":curSelect.name,
      "title":"",
      "from":Constant.COLLECT_GALLERY,
      "fromid":curSelect.id,
      "url":curSelect.url,
      "width":curSelect.width,
      "height":curSelect.height
    };
    httpUtil.post(DataUtils.api_addcollect,data:option).then((value){
      waiting = false;
      CollectAddBean addBean = CollectAddBean.fromJson(json.decode(value));
      if(addBean.errno == 0){
        //把收藏信息写入本地
        CollectDB _collectDB = CollectDB(uid: m_uid,from: Constant.COLLECT_WORK,fromid: curSelect.id);
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
      "from":Constant.COLLECT_WORK,
      "fromid":curSelect.id,
      "type":1
    };
    httpUtil.post(DataUtils.api_delcollect,data:option).then((value){
      waiting = false;
      CollectDeleteBean delBean = CollectDeleteBean.fromJson(json.decode(value));
      if(delBean.errno == 0){
        //把收藏信息写入本地
        DBUtils.dbUtils.then((value) => value.delCollect(m_uid,Constant.COLLECT_CLASS,curSelect.id));
        setState(() {
          this.iscollect = false;
        });
      }else{
        showToast(delBean.errmsg);
        DBUtils.dbUtils.then((value) => value.delCollect(m_uid,Constant.COLLECT_CLASS,curSelect.id));
        setState(() {
          this.iscollect = false;
        });
      }
    }).catchError((err){
      waiting = false;
    });
  }

  /**
   * 页面切换
   */
  @override
  void pageChange() {
    if(curSelect != null){
      getWorkScore(curSelect);
      DBUtils.dbUtils.then((value){
        value.checkCollect(m_uid, Constant.COLLECT_CLASS, curSelect.id).then((value){
          setState(() {
            this.iscollect = value;
          });
        });
      });
    }
  }

  /**
   * 作业打分
   */
  Widget scoreItem(Works data){
    return InkWell(
      onTap: (){
        //打分
        if((workScoreBean == null || workScoreBean.data == null) && role == 1){
          showWorkScore(data.id).then((value){
            if(value != null){
              setState(() {
                workScoreBean = WorkScoreBean.fromJson(json.decode(value));
                data.workScoreBean = workScoreBean;
              });
            }
          });
        }else{
          showToast("已打分或没权限打分");
        }
      },
      child: (workScoreBean != null && workScoreBean.data != null && data.id == workScoreBean.data.workid) ?
      Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(ScreenUtil().setWidth(10)),
            color: Colors.white
        ),
        alignment: Alignment(0,0),
        padding: EdgeInsets.only(
          top: ScreenUtil().setHeight(SizeUtil.getHeight(20)),
          bottom: ScreenUtil().setHeight(SizeUtil.getHeight(20)),
          left: ScreenUtil().setWidth(SizeUtil.getWidth(40)),
          right:ScreenUtil().setWidth(SizeUtil.getWidth(40)),
        ),
        margin: EdgeInsets.only(left: ScreenUtil().setWidth(SizeUtil.getWidth(10))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("${workScoreBean.data.score}分",style: TextStyle(color: Colors.red),),
            Text(workScoreBean.data.nickname == null ? "${workScoreBean.data.username}" : "${workScoreBean.data.nickname}",style: TextStyle(color: Colors.grey),)
          ],
        ),
      ) : Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(ScreenUtil().setWidth(10)),
            color: Colors.white
        ),
        alignment: Alignment(0,0),
        padding: EdgeInsets.only(
          top: ScreenUtil().setHeight(SizeUtil.getHeight(20)),
          bottom: ScreenUtil().setHeight(SizeUtil.getHeight(20)),
          left: ScreenUtil().setWidth(SizeUtil.getWidth(40)),
          right:ScreenUtil().setWidth(SizeUtil.getWidth(40))
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("打分",style: TextStyle(color: Colors.black54),),
            Text("百分制",style: TextStyle(color: Colors.black12),),
          ],
        ),
      ),
    );
  }

  /**
   * 批改作业状态
   */
  Widget correctItem(Works data){
    return InkWell(
      onTap: (){
        //
        if((data.correct_uid != null && data.correct_uid == uid || data.correct_uid == null) && role == 1){
          //批改作业
          Navigator.push(context, MaterialPageRoute(builder: (context)=>WorkCorrect(classid: classid, data: data))).then((value){
            //批改作业返回
            if(value != null){
              setState(() {
                data.correct = value.correct;
                data.correct_uid = value.correctUid;
                data.correct_name = m_username;
                data.correct_time = value.correctTime;
              });
            }
          });
        }else{
          showToast("已批改或没权限批改");
        }
      },
      child: data.correct == null ?
      Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(ScreenUtil().setWidth(10)),
            color: Colors.white
        ),
        alignment: Alignment(0,0),
        padding: EdgeInsets.only(
          top: ScreenUtil().setHeight(SizeUtil.getHeight(20)),
          bottom: ScreenUtil().setHeight(SizeUtil.getHeight(20)),
          left: ScreenUtil().setWidth(SizeUtil.getWidth(40)),
          right:ScreenUtil().setWidth(SizeUtil.getWidth(40))
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("批改 / 点评",style: TextStyle(color: Colors.black54),),
            Text("老师点评批改",style: TextStyle(color: Colors.black12),)
          ],
        ),
      ) : Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(ScreenUtil().setWidth(10)),
            color: Colors.white
        ),
        alignment: Alignment(0,0),
        padding: EdgeInsets.only(
          top: ScreenUtil().setHeight(SizeUtil.getHeight(20)),
          bottom: ScreenUtil().setHeight(SizeUtil.getHeight(20)),
          left: ScreenUtil().setWidth(SizeUtil.getWidth(40)),
          right:ScreenUtil().setWidth(SizeUtil.getWidth(40)),
        ),
        margin: EdgeInsets.only(left: ScreenUtil().setWidth(SizeUtil.getWidth(10))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("已批改",style: TextStyle(color: Colors.red),),
            Text("${data.correct_name} ${data.createtime}",style: TextStyle(color: Colors.grey),)
          ],
        ),
      ),
    );
  }

  /**
   * 作业评价
   */
  Widget appraiseWork(int workid){
    return Container(
      width: double.infinity,
      child: Column(
        children: [
          InkWell(
            onTap: (){
              showAppraise(workid);
            },
            child: Row(
              children: [
                Text("作业评价"),
                Image.asset("image/ic_score.png",width: ScreenUtil().setWidth(40),height:ScreenUtil().setWidth(40)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget initChildren(BuildContext context, Works data) {
    Size _size = MediaQuery.of(context).size;
    _width = _size.width;
    return Container(
      child: Column(
        children: [
          Container(
            height: ScreenUtil().setHeight(SizeUtil.getHeight(Constant.SIZE_TOP_HEIGHT)),
            decoration: BoxDecoration(
              color: Colors.white
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BackButtonWidget(cb: (){
                  //点击返回
                  Navigator.pop(context);
                }, title: data.author,word: '${data.createtime}',grade: data.grade,),
                /*CollectButton(margin_right:40,from: Constant.COLLECT_WORK,fromid: data.id,url: data.url,
                  name: data.name,width: data.width,height: data.height,),*/
              ],
            ),
          ),
          //图库显示区域
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          left: ScreenUtil().setWidth(SizeUtil.getWidth(40)),
                          right: ScreenUtil().setWidth(SizeUtil.getWidth(40)),
                          top: ScreenUtil().setHeight(SizeUtil.getHeight(20)),
                        ),
                        child: Stack(
                          alignment: Alignment(1,-1),
                          children: [
                            InkWell(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>GalleryBig(imgUrl: data.url, imageType: BigImageType.work,width:data.width,height:data.height)));
                              },
                              child: CachedNetworkImage(
                                imageUrl: data.url,
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
                            /*Offstage(
                              offstage: m_role != 1,
                              child: InkWell(
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>WorkCorrect(classid: classid, data: data))).then((value){
                                    //批改作业返回
                                    if(value != null){
                                      setState(() {
                                        data.correct = value.correct;
                                        data.correct_uid = value.correctUid;
                                        data.correct_name = m_username;
                                        data.correct_time = value.correctTime;
                                      });
                                    }
                                  });
                                },
                                child: Container(
                                  padding: EdgeInsets.all(SizeUtil.getHeight(10)),
                                  decoration: BoxDecoration(
                                      color: Colors.red
                                  ),
                                  child: Text("编辑图片",style: TextStyle(fontSize: ScreenUtil().setSp(SizeUtil.getFontSize(30)),color: Colors.white),),
                                ),
                              ),
                            )*/
                          ],
                        ),
                      ),
                      //进度条
                      loadover == false ? LineLoad(loadingProgress, 5.0) : SizedBox(),
                    ],
                  ),
                  /*Padding(
                    padding: EdgeInsets.only(
                      bottom: ScreenUtil().setHeight(SizeUtil.getHeight(10)),
                      top: ScreenUtil().setHeight(SizeUtil.getHeight(10)),
                      right:ScreenUtil().setWidth(SizeUtil.getWidth(40))
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text("小提示：左右滑动可以切换图片",style: Constant.smallTitleTextStyle,)
                      ],
                    ),
                  ),*/
                  SizedBox(height: ScreenUtil().setHeight(SizeUtil.getHeight(40)),),
                  //score 打分与批改
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(SizeUtil.getWidth(30))),
                    child: scoreItem(data),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(SizeUtil.getWidth(30)),vertical: ScreenUtil().setHeight(SizeUtil.getHeight(20))),
                    child: correctItem(data),
                  ),
                  //作品评价
                  /*Padding(
                    padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(SizeUtil.getWidth(40))),
                    child: appraiseWork(data.id),
                  ),*/
                  // 作业批改内容
                  Offstage(
                    offstage: data.correct == null,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: ScreenUtil().setWidth(SizeUtil.getWidth(40)),
                          vertical: ScreenUtil().setHeight(SizeUtil.getHeight(10))
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('最新批改：${data.correct_name} ${data.correct_time}',style: Constant.titleTextStyleNormal,),
                          SizedBox(height: ScreenUtil().setHeight(SizeUtil.getHeight(20)),),
                          InkWell(
                            onTap:(){
                              //查看作业批改大图
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>GalleryBig(imgUrl: data.correct, imageType: BigImageType.correct,width: data.width,height: data.height,)));
                            },
                            child: Image.network(data.correct != null ? Constant.parseSmallString(data.correct, "res.yimios.com:9050/work/correct") : "",),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          SizedBox(height: ScreenUtil().setHeight(SizeUtil.getHeight(40)),)
        ],
      ),
    );
  }
}