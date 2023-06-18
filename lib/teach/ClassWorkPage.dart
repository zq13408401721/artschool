import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:yhschool/BaseCoustRefreshState.dart';
import 'package:yhschool/BasePhotoState.dart';
import 'package:yhschool/BaseState.dart';
import 'package:yhschool/bean/teacher_classes_bean.dart' as T;
import 'package:yhschool/bean/work_delete_bean.dart';
import 'package:yhschool/bean/work_list_bean.dart' as M;
import 'package:yhschool/bean/work_mark_bean.dart';
import 'package:yhschool/teach/ClassWorkDetail.dart';
import 'package:yhschool/teach/WorkTile.dart';
import 'package:yhschool/utils/Constant.dart';
import 'package:yhschool/utils/DataUtils.dart';
import 'package:yhschool/utils/HttpUtils.dart';
import 'package:yhschool/utils/SizeUtil.dart';
import 'package:yhschool/widgets/ClassTab.dart';
import 'package:yhschool/widgets/RefreshListView.dart';

class ClassWorkPage extends StatefulWidget{

  ClassWorkPage({Key key}):super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ClassWorkPageState();
  }
}

class ClassWorkPageState extends BaseCoustRefreshState<ClassWorkPage>{

  static final GlobalKey<ClassTabState> classTabKey = GlobalKey<ClassTabState>();

  List<M.Data> workList = [];
  int selectClassId;
  String classname;

  int page=1,size=10;

  ScrollController _controller;
  int oldid;

  @override
  void initState() {
    super.initState();
    _controller = initScrollController();
    isrefreshing = true;
  }

  @override
  void refresh(){
    if(!this.isrefreshing){
      if(selectClassId > 0){
        getClassWork();
      }else{
        hideRefreshing();
      }
    }
  }

  @override
  void loadmore(){
    if(!this.isloading){
      getClassWorkMore();
    }
  }


  /**
   * 初始化班级数据
   */
  void initClass(List<T.Data> _list){
    if(_list.length > 0){
      setState(() {
        classTabKey.currentState.updateClassList(_list);
        selectClassId = _list[0].id;
        classname = _list[0].name;
        getClassWork();
      });
    }
  }

  /**
   * 获取当前班级数据
   */
  int getCurrentSelectClass(){
    return selectClassId;
  }

  /**
   * 获取班级对应的作业
   */
  void getClassWork(){
    var option = {
      "classid":selectClassId,
      "page":page,
      "size":size
    };
    setState(() {
      workList.clear();
    });
    httpUtil.post(DataUtils.api_worklist,data: option).then((value){
      if(mounted){
        hideRefreshing();
        M.WorkListBean bean = M.WorkListBean.fromJson(json.decode(value));
        if(bean.errno == 0){
          if(bean.data.length > 0){
            oldid = bean.data[bean.data.length-1].id;
            setState(() {
              workList.addAll(bean.data);
            });
          }
        }else{
          //showToast(bean.errmsg);
        }
      }
    });
  }

  /**
   * 更多对应的班级作业
   */
  void getClassWorkMore() {
    var option = {
      "classid": selectClassId,
      "oldid": oldid,
      "size": size
    };
    httpUtil.post(DataUtils.api_worklist, data: option).then((value) {
      hideLoadMore();
      M.WorkListBean bean = M.WorkListBean.fromJson(json.decode(value));
      if (bean.errno == 0) {
        if(bean.data.length > 0){
          oldid = bean.data[bean.data.length - 1].id;
          setState(() {
            workList.addAll(bean.data);
          });
        }
      } else {
        showToast(bean.errmsg);
      }
    });
  }
  /**
   * 给学生作业打标记
   */
  void _markWork(M.Works _data,int cid){
    var option = {
      "workid":_data.id,
      "classid":cid,
      "grade":_data.grade == 0 ? 1 : 0
    };
    httpUtil.post(DataUtils.api_workmark,data:option).then((value){
      WorkMarkBean bean = WorkMarkBean.fromJson(json.decode(value));
      if(bean.errno == 0){
        setState(() {
          if(_data.id == bean.data.workid){
            _data.grade = bean.data.grade;
          }
        });
      }else{
        showToast(bean.errmsg);
      }
    });
  }

  /**
   * 删除作业
   */
  void deleteWork(int workid,String uid){
    var option = {
      "workid":workid.toString()
    };
    String action;
    if(uid != null){
      action = DataUtils.api_workdeletebyteacher;
      option["uid"] = uid;
    }else{
      action = DataUtils.api_workdelete;
    }
    httpUtil.post(action,data:option).then((value){
      WorkDeleteBean bean = WorkDeleteBean.fromJson(json.decode(value));
      bool delete=false;
      if(bean.errno == 0){
        for(M.Data item in workList){
          for(M.Works work in item.works){
            if(workid == work.id){
              item.works.remove(work);
              delete = true;
              break;
            }
          }
          if(delete){
            if(item.works.length == 0){
              workList.remove(item);
            }
            break;
          }
        }
        setState(() {
        });
      }else{
        showToast(bean.errmsg);
      }
    });
  }

  /**
   * 是否显示删除按钮 老师身份并且老师在此班级中满足该条件
   */
  bool isShowDeleteButton(int cid){
    if(m_role == 1){
      return inClass(cid);
    }
    return false;
  }

  /**
   * 作业条目
   */
  Widget workItem(M.Data _data){
    return Container(
      padding: EdgeInsets.only(
        top: ScreenUtil().setHeight(SizeUtil.getHeight(40))
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(padding: EdgeInsets.only(
            left: ScreenUtil().setWidth(SizeUtil.getWidth(5)),
            bottom: ScreenUtil().setWidth(SizeUtil.getWidth(5)),
          ),child: Text('${_data.date}',style: TextStyle(fontSize: SizeUtil.getAppFontSize(36),color: Colors.black87,fontWeight: FontWeight.bold)),),
          StaggeredGridView.countBuilder(
            crossAxisCount: Constant.isPad ? 3 : 2,
            itemCount: _data.works.length,
            primary: false,
            shrinkWrap: true,
            mainAxisSpacing: ScreenUtil().setHeight(SizeUtil.getHeight(10)),
            crossAxisSpacing: ScreenUtil().setWidth(SizeUtil.getWidth(10)),
            addAutomaticKeepAlives: false,
            //padding: EdgeInsets.only(left: ScreenUtil().setWidth(Constant.DIS_LIST),right: ScreenUtil().setWidth(Constant.DIS_LIST)),
            staggeredTileBuilder: (int index) =>
                StaggeredTile.fit(1),
            //StaggeredTile.count(3,index==0?2:3),
            itemBuilder: (context,index){
              return GestureDetector(
                child: WorkTile(data: _data.works[index],ismark: m_role == 1,isInClass:isShowDeleteButton(_data.classid),avater:_data.works[index].avater,clickMark: (){
                  //给作业打标记
                  _markWork(_data.works[index],_data.classid);
                },clickDelete: (){
                  //删除作业
                  showAlertTips(context, "确定删除作业？", (){
                    if(_data.works[index].uid == m_uid){
                      deleteWork(_data.works[index].id,null);
                    }else{
                      deleteWork(_data.works[index].id,_data.works[index].uid);
                    }
                  });
                },isself: m_uid == _data.works[index].uid,),
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>
                      ClassWorkDetail(data: _data.works,position: index,classid: selectClassId,)
                  ));
                },
              );
            },
          )
        ],
      ),
    );
  }

  Widget refreshWidget(){
    return Center(
      child: Container(
        padding: EdgeInsets.symmetric(
            vertical: ScreenUtil().setHeight(40)
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: ScreenUtil().setWidth(40),
              height: ScreenUtil().setWidth(40),
              child: CircularProgressIndicator(color: Colors.red,),
            ),
            SizedBox(width: 10,),
            Text("数据刷新中",style: TextStyle(color: Colors.grey),)
          ],
        ),
      ),
    );
  }

  Widget loadmoreWidget(){
    return Center(
      child: Container(
        padding: EdgeInsets.symmetric(
            vertical: ScreenUtil().setHeight(40)
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: ScreenUtil().setWidth(40),
              height: ScreenUtil().setWidth(40),
              child: CircularProgressIndicator(color: Colors.red,),
            ),
            SizedBox(width: 10,),
            Text("加载更多",style: TextStyle(color:Colors.grey),)
          ],
        ),
      ),
    );
  }

  @override
  List<Widget> addChildren(){
    return [
      Container(
          height: SizeUtil.getAppHeight(SizeUtil.getTabHeight()),
          padding: EdgeInsets.only(
            top: SizeUtil.getAppHeight(SizeUtil.getTabRadius()),
            bottom: SizeUtil.getAppHeight(SizeUtil.getTabRadius()),
            left: ScreenUtil().setWidth(SizeUtil.getWidth(20)),
            right: ScreenUtil().setWidth(SizeUtil.getWidth(20)),
          ),
          decoration: BoxDecoration(
              color: Colors.white
          ),
          child: ClassTab(key: classTabKey,clickTab: (dynamic value){
            setState(() {
              workList.clear();
              selectClassId = value["id"];
              classname = value["name"];
              getClassWork();
            });
          },)
      ),
      isrefreshing ? refreshWidget() : SizedBox(),
      //班级对应作业列表
      Expanded(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: ScreenUtil().setWidth(SizeUtil.getWidth(20))
          ),
          child: ListView.builder(
            controller: _controller,
            padding:EdgeInsets.only(
              bottom: ScreenUtil().setWidth(SizeUtil.getWidth(20)),
            ),
            addAutomaticKeepAlives: false,
            itemBuilder: (context,index){
              return workItem(workList[index]);
            },itemCount: workList.length,shrinkWrap: true,),
        ),
      ),
      this.isloading ? loadmoreWidget() : SizedBox()
    ];
  }
}