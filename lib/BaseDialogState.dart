
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yhschool/BasePhotoState.dart';
import 'package:yhschool/bean/issue_video_push_bean.dart';
import 'package:yhschool/bean/teacher_classes_bean.dart';
import 'package:yhschool/mine/PushNotice.dart';
import 'package:yhschool/pan/PanScreen.dart';
import 'package:yhschool/popwin/PopWinEditorColumn.dart';
import 'package:yhschool/utils/Constant.dart';
import 'package:yhschool/utils/DataUtils.dart';
import 'package:yhschool/utils/HttpUtils.dart';
import 'package:yhschool/utils/SizeUtil.dart';
import 'package:yhschool/widgets/DialogClassPush.dart';
import 'package:yhschool/widgets/DialogEditorPassword.dart';
import 'package:yhschool/widgets/DialogPush.dart';
import 'package:yhschool/widgets/DialogSingleInput.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yhschool/bean/push_issue_bean.dart';

/**
 * 具备弹框性质的State
 */
class BaseDialogState<T extends StatefulWidget> extends BasePhotoState<T>{


  /**
   * 创建发布功能弹框
   * showModal
   */
  Future<bool> showPushDialog(BuildContext context,List<Data> classes,{Function cb=null}) async{
    bool issend = false;
    await showDialog(context: context, builder: (context){
      return StatefulBuilder(
        builder: (_context,_state){
          return DialogPush(classesList: classes,ispushvideo:false);
        }
      );
    }).then((value){
      print(value);
      // 弹框关闭返回是拍照相册上传还是收藏上传
      if(value != null){
        if(value[0] == 1){ //相册拍照上传
          openIssueGallery(context, value[1],(result){
            issend = true;
            print("当天排课：$value,$result");
            //设置推送视频内容 对应当前的排课
            if(value.length > 2 && value[2] != null && value[2].length > 0 && value[3] != null && value[3].length > 0 && value[4] > 0){
              var title = value[2]+"/"+value[3];
              var categoryid = value[4];
              if(categoryid > 0){
                _sendPushVideo(Constant.listToString(value[1]),title,categoryid,null);
              }
            }
            if(cb != null){
              cb();
            }
          });
        }else if(value[0] == 2){ //发短视频
          openSmallVideo(context,(value){
            //value 短视频文件

          });
        }
      }
    });
    return issend;
  }

  /**
   * 图文排课功能弹框
   */
  Future<bool> showGalleryPlanDialog(BuildContext context,String date,List<Data> classes,Function cb) async{
    showDialog(context: context, builder: (context){
      return StatefulBuilder(
          builder: (_context,_state){
            return DialogPush(classesList: classes,);
          }
      );
    }).then((value){
      // 弹框关闭返回是拍照相册上传还是收藏上传
      if(value != null){
        if(value[0] == 1){ //相册拍照上传
          openPlanGallery(context, value[1],date,(result){
            print("图文排课图片上传返回$result");
            //设置推送视频内容  对应选择日期的排课
            if(value.length > 2 && value[2] != null && value[2].length > 0 && value[3] != null && value[3].length > 0 && value[4] > 0){
              var title = value[2]+"/"+value[3];
              var categoryid = value[4];
              if(categoryid > 0){
                _sendPushVideo(Constant.listToString(value[1]),title,categoryid,date);
              }
            }
            cb(true);
          });
        }else if(value[0] == 2){ //收藏上传

        }
      }
    });
  }

  /**
   * 视频播放页面即时推送
   */
  Future<void> showPushVideo(BuildContext context,String title,int categoryid) async{

    showDialog(context: context, builder: (context){
      return StatefulBuilder(
          builder: (_context,_state){
            return DialogPush(classesList: [],ispushvideo: true,);
          }
      );
    }).then((value){
      // 推送视频到对应班级
      if(value != null){
        if(value[0] == 1){
          _sendPushVideo(Constant.listToString(value[1]),title,categoryid,Constant.getDateFormatByString(DateTime.now().toString()));
        }else if(value[0] == 2){ //收藏上传

        }
      }
    });
  }

  /**
   * 发送推送视频
   */
  void _sendPushVideo(ids,title,categoryid,date){
    var option = {
      "classids":ids,
      "title":title,
      "categoryid":categoryid
    };
    if(date != null){
      option["date"] = date;
    }
    print("option:$option");
    httpUtil.post(DataUtils.api_issuevideopush,data: option).then((value){
      print("pushVideo:$value");
      IssueVideoPushBean bean = IssueVideoPushBean.fromJson(json.decode(value));
      if(bean.errno == 0){
        showToast("资料上传成功");
      }else{
        showToast(bean.errmsg);
      }
    });
  }

  /**
   * 收藏发布功能弹框
   */
  Future<List<int>> showCollectDialog(BuildContext context) async{
    List<int> classids;
    await showDialog(context: context, builder: (context){
      return StatefulBuilder(builder: (_context,_state){
        return DialogClassPush();
      });
    }).then((value){
      //推送到对应的班级
      classids = value;
    });
    if(classids != null){
      return classids;
    }else{
      showToast("请选择你需要推送的班级");
    }
  }

  /**
   * 显示编辑弹框
   */
  Future<String> showEditorDialog(BuildContext context,String title,String label) async{
    String nickname;
    await showDialog(context: context, builder: (context){
      return StatefulBuilder(builder: (_context,_state){
        return DialogSingleInput(title: title, label: label);
      });
    }).then((value){
      nickname = value;
    });
    return nickname;
  }

  /**
   * 修改密码
   */
  Future<String> showEditorPassword(BuildContext context,String title) async{
    String nickname;
    await showDialog(context: context, builder: (context){
      return StatefulBuilder(builder: (_context,_state){
        return DialogEditorPassword(title: title);
      });
    }).then((value){
      nickname = value;
    });
    return nickname;
  }


  /**
   * 发布公告
   */
  Future<int> showPushNotice(BuildContext context) async{
    int id=0;
    await showDialog(context: context, builder: (context){
      return StatefulBuilder(builder: (_context,_state){
        return PushNotice();
      });
    }).then((value){
      id = value;
    });
    return id;
  }

  /**
   * 头像上传功能
   */
  Future<String> showUploadHead(BuildContext context) async{

  }

  /**
   * 显示编辑专栏
   */
  Future<dynamic> showEditorColumn(BuildContext context,int columnid,String name,int visible) async{
    var result;
    await showDialog(context: context, builder: (context){
      return StatefulBuilder(builder: (_context,_state){
        return UnconstrainedBox(
          child: PopWinEditorColumn(name: name,visible: visible,columnid: columnid,),
        );
      });
    }).then((value){
      result = value;
    });
    return result;
  }

  /**
   * 推送图库到课堂
   */
  Future<bool> pushGallery(BuildContext context,dynamic param) async{
    showDialog(context: context, builder: (context){
      return StatefulBuilder(
          builder: (_context,_state){
            return DialogPush(classesList: [],ispushvideo: true,);
          }
      );
    }).then((value){
      // 推送视频到对应班级
      if(value != null){
        if(value[0] == 1){
          String classes = Constant.listToString(value[1]);
          _pushGalleryToIssue(classes, param);
         }else if(value[0] == 2){ //收藏上传

        }
      }
    });
  }

  /**
   * 推送图片到课堂
   * classes 多个班级id用逗号分割 如：1，2，3
   * name 推送用户的昵称
   */
  Future<bool> _pushGalleryToIssue(String classes,dynamic param)async{
    bool _bool = false;
    var option = {
      "name":param["name"],
      "classes":classes,
      "url":param["url"],
      "sort":DateTime.now().millisecondsSinceEpoch,
      "width":param["width"],
      "height":param["height"],
      "maxwidth":param["maxwidth"],
      "maxheight":param["maxheight"],
      "from":param["from"]
    };
    await httpUtil.post(DataUtils.api_pushgallerytoissue,data:option).then((value){
      PushIssueBean bean = PushIssueBean.fromJson(json.decode(value));
      if(bean.errno == 0){
        _bool = true;
        showToast("推送成功");
      }else{
        showToast(bean.errmsg);
      }
    });
    return _bool;
  }

  /**
   * 打分弹框
   */
  Future<String> showWorkScore(int workid) async{
    return await showDialog(context: context, builder: (context){
      TextEditingController editingController = new TextEditingController();
      int score = 0;
      return StatefulBuilder(
          builder: (_context,_state){
            return UnconstrainedBox(
              child: Card(
                color: Colors.white,
                child: Container(
                  width: ScreenUtil().setWidth(500),
                  height: ScreenUtil().setHeight(350),
                  child: Stack(
                    children: [
                      Positioned(
                        top: ScreenUtil().setWidth(20),
                        right: ScreenUtil().setWidth(20),
                        child: InkWell(
                          onTap: (){
                            Navigator.pop(context);
                          },
                          child: Image.asset("image/ic_fork.png"),
                        ),
                      ),
                      Positioned(
                        top: 0,
                        bottom: ScreenUtil().setHeight(40),
                        left: ScreenUtil().setWidth(80),
                        right: ScreenUtil().setHeight(80),
                        child: Container(
                          alignment: Alignment(0,0),
                          child: TextField(
                            maxLines: 1,
                            maxLength: 3,
                            //focusNode: _focusNode1,
                            controller: editingController,
                            inputFormatters: [
                              FilteringTextInputFormatter(RegExp("^[0-9]+"),allow: true)
                            ],
                            decoration:InputDecoration(
                                hintText: "请输入分数",
                                counterText: "",
                                contentPadding: EdgeInsets.only(
                                  top: ScreenUtil().setWidth(10),
                                  bottom: ScreenUtil().setWidth(10),
                                  left: ScreenUtil().setWidth(20)
                                ),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide: BorderSide(color: Colors.grey)
                                )
                            ),
                            onChanged: (word){
                              if(int.parse(word) > 100){
                                showToast("分数不能大于100");
                              }else{
                                score = int.parse(word);
                              }
                            },
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: InkWell(
                          onTap: (){
                            getUid().then((value){
                              var option = {
                                "uid":value,
                                "workid":workid,
                                "score":score
                              };
                              print("score put:"+score.toString());
                              //打分
                              httpUtil.post(DataUtils.api_workputscore,data:option).then((value){
                                //WorkAddScoreBean bean = WorkAddScoreBean.fromJson(json.decode(value));
                                print("score result:"+value);
                                Navigator.pop(context,value);
                              });
                            });
                          },
                          child: Container(
                            height: ScreenUtil().setHeight(SizeUtil.getHeight(100)),
                            alignment:Alignment(0,0),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(ScreenUtil().setWidth(8)),
                                bottomRight: Radius.circular(ScreenUtil().setWidth(8)),
                              )
                            ),
                            child: Text("确定",style: TextStyle(color: Colors.white),),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          }
      );
    }).then((value){
      print("value:${value}");
      return value;
    });
  }

  /**
   * 作业评价
   */
  Future<String> showAppraise(int workid) async{
    return showDialog(context: context, builder: (content){
      return StatefulBuilder(builder: (_context,_state){
        return UnconstrainedBox(
          child: Card(
            color: Colors.white,
            child: Container(
              width: ScreenUtil().setWidth(500),
              height: ScreenUtil().setHeight(800),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(ScreenUtil().setWidth(10))
              ),
              child: Stack(
                children: [
                  ListView.builder(
                    itemCount: Constant.appraise.length,
                    shrinkWrap: true,
                    itemBuilder: (context,index){
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(Constant.appraise[index]),
                          RadioListTile(value: index,title: Text("差"), groupValue: Constant.appraise[index], onChanged: (T){

                          }),
                          RadioListTile(value: index,title: Text("良"), groupValue: Constant.appraise[index], onChanged: (T){

                          }),
                          RadioListTile(value: index,title: Text("优"), groupValue: Constant.appraise[index], onChanged: (T){

                          })
                        ],
                      );
                    },)
                ],
              ),
            ),
          ),
        );
      });
    }).then((value){

    });
  }

  /**
   * 网盘筛选
   */
  Future<dynamic> showPanScreen(BuildContext context,int classifyid) async{
    var result = "";
    await showDialog(context: context, builder: (context){
      return StatefulBuilder(builder: (_context,_state){
        return PanScreen(classifyid: classifyid);
      });
    }).then((value){
      result = value;
    });
    return result;
  }

  /**
   * 网盘显示全部或老师相关
   */
  Future<dynamic> showPanVisible(bool isteacher) async{
    bool select;
    select = await getPanVisible();
    select = select == null ? false : true;
    await showDialog(context: context, builder: (context){
      return StatefulBuilder(builder: (context,state){
        return FractionallySizedBox(
          widthFactor: 2/3,
          heightFactor: 1/5,
            child: Card(
            child: Container(
              padding: EdgeInsets.symmetric(
                  horizontal: SizeUtil.getAppWidth(20),
                  vertical: SizeUtil.getAppHeight(20)
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(isteacher == true ? "只显示老师的网盘" : "显示所有网盘",style: TextStyle(fontSize: SizeUtil.getAppFontSize(30)),),
                  Row(
                    children: [
                      Checkbox(value: select, onChanged: (value){
                        select = !select;
                        setState(() {
                        });
                      }),
                      Text("记住我的选择",style: Constant.smallTitleTextStyle,)
                    ],
                  ),
                  SizedBox(height: SizeUtil.getHeight(20),),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap: (){
                            savePanVisible(select);
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: SizeUtil.getAppWidth(10)),
                            padding: EdgeInsets.symmetric(vertical: SizeUtil.getAppWidth(10),horizontal: SizeUtil.getAppWidth(20)),
                            decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.all(Radius.circular(SizeUtil.getWidth(5)))
                            ),
                            child: Text("确定",style: TextStyle(color: Colors.white,fontSize: SizeUtil.getAppFontSize(30)),),
                          ),
                        ),
                        InkWell(
                            onTap: (){
                              Navigator.pop(context);
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: SizeUtil.getAppWidth(10)),
                              padding: EdgeInsets.symmetric(vertical: SizeUtil.getAppWidth(10),horizontal: SizeUtil.getAppWidth(20)),
                              decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.all(Radius.circular(SizeUtil.getWidth(5)))
                              ),
                              child: Text("取消",style: TextStyle(color: Colors.white,fontSize: SizeUtil.getAppFontSize(30)),),
                            )
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      });
    });
    return select;
  }

}