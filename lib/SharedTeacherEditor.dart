
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:yhschool/BaseState.dart';
import 'package:yhschool/bean/shared_add_teacher_bean.dart';
import 'package:yhschool/bean/shared_delete_teacher_bean.dart';
import 'package:yhschool/bean/shared_select_teachers_bean.dart' as SelectTeacher;
import 'package:yhschool/bean/teachers_bean.dart';
import 'package:yhschool/utils/Constant.dart';
import 'package:yhschool/utils/DataUtils.dart';
import 'package:yhschool/utils/HttpUtils.dart';


class SharedTeacherEditor extends StatefulWidget{

  List<SelectTeacher.Teachers> selectTeachers;

  SharedTeacherEditor({Key key,@required this.selectTeachers}):super(key: key);

  @override
  State<StatefulWidget> createState() {
    return SharedTeacherEditorState()
      ..selectTeachers = selectTeachers;
  }
}

class SharedTeacherEditorState extends BaseState<SharedTeacherEditor>{

  // 所有的老师
  List<Teachers> allTeachers = [];
  // 选择的老师列表
  List<SelectTeacher.Teachers> selectTeachers = [];
  // 剩下没有设置的老师
  List<Teachers> otherTeachers = [];
  // 当前是否是编辑状态
  bool isEditorState = false;

  String EditStr = "编辑";
  String selfUid;

  @override
  void initState() {
    super.initState();
    getUid().then((value) => {
      this.selfUid = value
    });
    getSchoolTeacher();
  }

  getSchoolTeacher(){
    httpUtil.post(DataUtils.api_getschoolteacher,data: {}).then((value){
      TeachersBean teachersBean = TeachersBean.fromJson(json.decode(value));
      if(teachersBean.errno == 0){
        otherTeachers.clear();
        setState(() {
          for(var i=0; i<teachersBean.data.teachers.length; i++){
            bool _bool = isSelect(teachersBean.data.teachers[i].uid);
            if(!_bool){
              otherTeachers.add(teachersBean.data.teachers[i]);
            }else{
              print("老师${teachersBean.data.teachers[i].username}已经添加");
            }
          }
        });
      }else{
        showToast(teachersBean.errmsg);
      }
    }).catchError((err)=>{
      print("err:$err")
    });
  }

  /**
   * 添加老师到选择区域
   */
  addTeacher(String uid,String username){
    //显示loading
    if(!EasyLoading.isShow){
      EasyLoading.showInfo("请求添加老师");
      var option = {
        "teacherid":uid,
        "teachername":username,
        "sort":selectTeachers.length
      };
      httpUtil.post(DataUtils.api_addsharedteacher,data:option).then((value){
        SharedAddTeacherBean addbean = SharedAddTeacherBean.fromJson(json.decode(value));
        if(addbean.errno == 0){
          EasyLoading.showInfo("添加$username成功");
          setState(() {
            SelectTeacher.Teachers teacher = SelectTeacher.Teachers(
                id: addbean.data.id,
                uid: selfUid,
                tid: uid,
                teachername: username,
                sort: selectTeachers.length
            );
            selectTeachers.add(teacher);
            for(int i=0; i<otherTeachers.length; i++){
              if(otherTeachers[i].uid == uid){
                otherTeachers.removeAt(i);
                break;
              }
            }
          });
        }else{
          EasyLoading.dismiss();
          showToast(addbean.errmsg);
        }
      }).catchError((err)=>{
        EasyLoading.dismiss(),
        print("err$err")
      });
    }
  }

  /**
   * 删除选择的老师
   */
  deleteTeacher(String uid){
    if(!EasyLoading.isShow){
      EasyLoading.showInfo("请求删除老师");
      var option={
        "teacherid":uid
      };
      httpUtil.post(DataUtils.api_deletesharedteacher,data: option).then((value) {
        SharedDeleteTeacherBean deleteBean = SharedDeleteTeacherBean.fromJson(json.decode(value));
        if(deleteBean.errno == 0){
          setState(() {
            Teachers teacher;
            for(var i=0; i<selectTeachers.length; i++){
              if(selectTeachers[i].tid == deleteBean.data.tid){
                teacher = Teachers(username: selectTeachers[i].teachername,uid: deleteBean.data.tid);
                selectTeachers.removeAt(i);
                break;
              }
            }
            if(teacher != null){
              otherTeachers.add(teacher);
            }
          });
        }else{
          EasyLoading.dismiss();
          showToast(deleteBean.errmsg);
        }
      }).catchError((err){
        EasyLoading.dismiss();
        print("err$err");
      });
    }
  }


  /**
   * 判断老师是否在已经选择的老师列表
   */
  bool isSelect(String tid){
    for(var i=0; i<selectTeachers.length; i++){
      if(selectTeachers[i].tid == tid){
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return FlutterEasyLoading(
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                TitleView("筛选编辑",CB_Class((){
                  Navigator.pop(context,selectTeachers);
                }, ()=>{})),
                Container(
                  margin: EdgeInsets.only(top: ScreenUtil().setHeight(20),bottom: ScreenUtil().setHeight(20)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        margin:EdgeInsets.only(left: 10),
                        child: Text("我选择的老师",style: TextStyle(fontSize: ScreenUtil().setSp(48),fontWeight: FontWeight.bold),),
                      ),
                      InkWell(
                        onTap: (){
                          //编辑
                          setState(() {
                            this.isEditorState = !this.isEditorState;
                            if(this.isEditorState){
                              EditStr = "完成";
                            }else{
                              EditStr = "编辑";
                            }
                          });
                        },
                        child: Container(
                          margin: EdgeInsets.only(right: 10),
                          child: Text(EditStr,style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold,fontSize: ScreenUtil().setSp(48)),),
                        ),
                      )
                    ],
                  ),
                ),
                GridView.builder(gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    childAspectRatio: 2
                ),
                    physics: NeverScrollableScrollPhysics(),
                    controller: ScrollController(keepScrollOffset: false),
                    itemCount: selectTeachers.length,
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context,int index){
                      return InkWell(
                        onTap: (){
                          if(this.isEditorState){
                            deleteTeacher(selectTeachers[index].tid);
                          }
                        },
                        child: Card(
                          shadowColor: Colors.grey,
                          child: Stack(
                            children: [
                              Align(
                                alignment: Alignment(0,0),
                                child: Text(selectTeachers[index].teachername,style: TextStyle(
                                    fontSize: ScreenUtil().setSp(48)
                                ),),
                              ),
                              Positioned(
                                right: 2,
                                top: 2,
                                child: Offstage(
                                  offstage: !this.isEditorState,
                                  child: Image.asset("image/ic_fork.png",width: 6,height: 6,),
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    }),
                Container(
                  alignment: Alignment(-1,0),
                  margin: EdgeInsets.only(left: 10,top: ScreenUtil().setHeight(20),bottom: ScreenUtil().setHeight(20)),
                  child: Text("为你推荐",style: TextStyle(fontSize: ScreenUtil().setSp(48),fontWeight: FontWeight.bold),),
                ),
                GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        childAspectRatio: 2
                    ),
                    itemCount: otherTeachers.length,
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context,int index){
                      return InkWell(
                        onTap: (){
                          if(this.isEditorState){
                            var um;
                            if(otherTeachers[index].nickname == null){
                              um = otherTeachers[index].username;
                            }else{
                              um = otherTeachers[index].nickname;
                            }
                            addTeacher(otherTeachers[index].uid, um);
                          }
                        },
                        child: Card(
                          shadowColor: Colors.grey,
                          child: Stack(
                            children: [
                              Align(
                                alignment: Alignment(0,0),
                                child: Text(
                                    otherTeachers[index].nickname == null ? otherTeachers[index].username : otherTeachers[index].nickname
                                ),
                              ),
                              Positioned(
                                top: 2,
                                right: 2,
                                child: Offstage(
                                  offstage: !this.isEditorState,
                                  child: Image.asset("image/ic_plus.png",width: 10,height: 10,),
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }

}