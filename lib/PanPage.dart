import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yhschool/BaseEditorState.dart';
import 'package:yhschool/BaseState.dart';
import 'package:yhschool/PanExam.dart';
import 'package:yhschool/PanImages.dart';
import 'package:yhschool/PanSteps.dart';
import 'package:yhschool/bean/pan_create_bean.dart';
import 'package:yhschool/bean/pan_delete_list.dart';
import 'package:yhschool/bean/pan_tabs_bean.dart';
import 'package:yhschool/utils/Constant.dart';
import 'package:yhschool/utils/HttpUtils.dart';

import 'utils/DataUtils.dart';

typedef SetEditor = void Function(bool _bool);
typedef SetSelect = void Function(bool _bool);
typedef ItemClick = void Function(bool _bool);

class Base_Class{

  SetEditor setEditor;
  SetSelect setSelect;
  ItemClick itemClick;

  Base_Class(SetEditor this.setEditor,SetSelect this.setSelect,ItemClick this.itemClick);
}

class PanPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return PanPageState();
  }
}

class PanPageState extends BaseEditorState<PanPage> with TickerProviderStateMixin{

  final GlobalKey<PanImagesState> panImagesKey = GlobalKey<PanImagesState>();
  final GlobalKey<PanStepsState> panStepsKey = GlobalKey<PanStepsState>();
  final GlobalKey<PanExamState> panExamKey = GlobalKey<PanExamState>();

  List<Widget> panPageList;
  int index=0;

  List<Tab> tabsList=[];
  List<String> tabs = ["图片","步骤","考题"];

  TabController _tabController;

  @override
  void initState() {
    super.initState();
    panPageList = [
      PanImages(key: panImagesKey,base_class:Base_Class((_bool) {

      }, (_bool) {

      }, (_bool) {
        setState(() {
          this.selectNum = panImagesKey.currentState.getSelectNum();
          bool _bool = panImagesKey.currentState.isSelectAll();
          if(_bool){
            this.selectAll = "全不选";
          }else{
            this.selectAll = "全选";
          }
        });
      }),),
      PanSteps(key: panStepsKey,base_class: Base_Class((_bool) { }, (_bool) { }, (_bool) {
        setState(() {
          this.selectNum = panStepsKey.currentState.getSelectNum();
          bool _bool = panStepsKey.currentState.isSelectAll();
          if(_bool){
            this.selectAll = "全不选";
          }else{
            this.selectAll = "全选";
          }
        });
      }),),
      PanExam(key: panExamKey,base_class: Base_Class((_bool) { }, (_bool) { }, (_bool) {
        setState(() {
          this.selectNum = panExamKey.currentState.getSelectNum();
          bool _bool = panExamKey.currentState.isSelectAll();
          if(_bool){
            this.selectAll = "全不选";
          }else{
            this.selectAll = "全选";
          }
        });
      }),)
    ];
    for(int i=0;i<tabs.length; i++){
      tabsList.add(
        Tab(
          child: Text(
            tabs[i],
            style: TextStyle(fontSize: ScreenUtil().setSp(60),color: Colors.black),
          ),
        )
      );
    }
    _tabController = new TabController(length: panPageList.length, vsync: this)
      ..addListener(() {
        if(_tabController.index == _tabController.animation.value){
          setState(() {
            this.index = _tabController.index;
          });
        }
      });
  }

  /**
   * 获取网盘tab返回创建对应的tab项
   */
  getPanTabsReturn(PanTabsBean tabs){
    setState(() {
      for(int i=0; i<tabs.data.length; i++){
        tabsList[i] = Tab(
          child: Text(
          tabs.data[i].name,
          style: TextStyle(
              fontSize: ScreenUtil().setSp(60),fontWeight: FontWeight.bold,color:Constant.COLOR_TITLE
          ),
        ));
      }
    });
  }

  /**
   * 获取盘tabs
   */
  getPanTabs(){
    httpUtil.post(DataUtils.api_pantabs,data:{}).then((value){
      print("获取网盘tabs返回");
      getPanTabsReturn(new PanTabsBean.fromJson(json.decode(value)));
    }).catchError((err)=>{
      print(err)
    });
  }

  // 添加网盘
  addFolder(String content){
    print("新建文件夹："+content);
    var option = {
      "name":content,
      "type":0
    };
    if(index == 0){
      option["type"] = 1;
    }else if(index == 1){
      option["type"] = 2;
    }else if(index == 2){
      option["type"] = 3;
    }
    httpUtil.post(DataUtils.api_pancreate,data: option).then((value) {
      PanCreateBean result = PanCreateBean.fromJson(json.decode(value));
      if(result.errno == 0){
        if(result.data.type == 1){
          //刷新图片列表
          panImagesKey.currentState.refreshData(result);
        }else if(result.data.type == 2){
          //刷新步骤列表
          panStepsKey.currentState.refreshData(result);
        }else if(result.data.type == 3){
          //刷新考题列表
          panExamKey.currentState.refreshData(result);
        }
      }else{
        showToast(result.errmsg);
      }
    }).catchError((err)=>{
      print("创建文件夹异常"),
      showToast(err.toString())
    });

  }


  /**
   * 取消选择
   */
  void cancelSelect(){
    hideEditor();
    if(index == 0){
      panImagesKey.currentState.SetSelectState(false);
      panImagesKey.currentState.SetEditorState(false);
    }else if(index == 1){
      panStepsKey.currentState.SetSelectState(false);
      panStepsKey.currentState.SetEditorState(false);
    }else if(index == 2){
      panExamKey.currentState.SetSelectState(false);
      panExamKey.currentState.SetEditorState(false);
    }
    setState(() {
      this.selectNum = 0;
    });
  }

  /**
   * 选择文件的方法
   */
  void selectFun(bool _bool){
    if(index == 0){
      panImagesKey.currentState.SetSelectState(_bool);
      setState(() {
        this.selectNum = panImagesKey.currentState.getSelectNum();
      });
    }else if(index == 1){
      panStepsKey.currentState.SetSelectState(_bool);
      setState(() {
        this.selectNum = panStepsKey.currentState.getSelectNum();
      });
    }else if(index == 2){
      panExamKey.currentState.SetSelectState(_bool);
      setState(() {
        this.selectNum = panExamKey.currentState.getSelectNum();
      });
    }

  }

  /**
   * 删除操作
   */
  void deleteSelect(BuildContext context){
    String ids = '';
    if(index == 0){
      ids = panImagesKey.currentState.getSelectIds();
    }else if(index == 1){
      ids = panStepsKey.currentState.getSelectIds();
    }else if(index == 2){
      ids = panExamKey.currentState.getSelectIds();
    }
    if(ids.length > 0){
      showAlertTips(context, "是否确定删除$selectNum个目录", (){
        //删除数据
        if(ids.length > 0){
          deleteFiles(ids);
        }else{
          showToast("选择要删除的目录");
        }
      });
    }else{
      showToast("请选择删除目录");
    }
  }

  /**
   * 删除文件
   */
  void deleteFiles(String ids){
    var option = {
      'panids':ids
    };
    httpUtil.post(DataUtils.api_pandelete,data: option).then((value) {
      PanDeleteList deleteFile = PanDeleteList.fromJson(json.decode(value));
      if(deleteFile.errno == 0){
        hideEditor();
        setState(() {
          if(index == 0){
            panImagesKey.currentState.isEditor = false;
            panImagesKey.currentState.updatePan(deleteFile.data.panids);
          }else if(index == 1){
            panStepsKey.currentState.isEditor = false;
            panStepsKey.currentState.updatePan(deleteFile.data.panids);
          }else if(index == 2){
            panExamKey.currentState.isEditor = false;
            panExamKey.currentState.updatePan(deleteFile.data.panids);
          }
          //删除以后刷新界面
          this.selectNum = 0;
          this.selectAll = "全选";
        });
      }else{
        showToast(deleteFile.errmsg);
      }
    }).catchError((err){
      print(err);
    });
  }
  
  Widget createPage(BuildContext context){
    return SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Container(
                  height: ScreenUtil().setHeight(Constant.SIZE_TOP_HEIGHT),
                  padding: EdgeInsets.only(top: ScreenUtil().setHeight(15),bottom: ScreenUtil().setHeight(15)),
                  child: TabBar(
                      controller: _tabController,
                      tabs:this.tabsList.map((e){
                        return e;
                      }).toList()
                  ),
                ),
                Expanded(
                  child: IndexedStack(
                    index: this.index,
                    children: this.panPageList,
                  ),
                )
              ],
            ),
            EditorBar(cancelSelect, selectFun),
            Positioned(
                bottom: 0,
                right: 0,
                left: 0,
                child: BottomBar(context,deleteSelect)
            ),
            Positioned(
              child: Offstage(
                offstage: !this.iseditor,
                child: Column(
                  children: [
                    InkWell(
                      child: Container(
                        margin: EdgeInsets.only(bottom: 10),
                        child: Image.asset("image/ic_more_btn.png",width: 36,height: 36,),
                      ),
                      onTap: (){
                        //进入编辑状态
                        setState(() {
                          this.iseditor = false;
                        });
                        if(index == 0){
                          panImagesKey.currentState.SetEditorState(true);
                        }else if(index == 1){
                          panStepsKey.currentState.SetEditorState(true);
                        }else if(index == 2){
                          panExamKey.currentState.SetEditorState(true);
                        }
                      },
                    ),
                    InkWell(
                      child: Image.asset("image/ic_add.png",width: 40,height: 40,),
                      onTap: (){
                        showAlertDialog(context,title: "新建文件夹",cb: addFolder);
                      },
                    )
                  ],
                ),
              ),
              right: ScreenUtil().setHeight(20),
              bottom: ScreenUtil().setHeight(40),
            ),
          ],
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isAndroid ? WillPopScope(
        onWillPop: (){
          print("返回键");
          if(!this.iseditor){
            hideEditor();
            this.selectNum = 0;
            //把列表列表中当前选中的目录都修改成未选中
            if(index == 0){
              panImagesKey.currentState.SetEditorState(false);
              panImagesKey.currentState.SetSelectState(false);
            }else if(index == 1){
              panStepsKey.currentState.SetEditorState(false);
              panStepsKey.currentState.SetSelectState(false);
            }else if(index == 2){
              panExamKey.currentState.SetEditorState(false);
              panExamKey.currentState.SetSelectState(false);
            }
          }else{
            Navigator.pop(context);
          }
        },
        child: createPage(context)
      ) : createPage(context),
    );
  }
}
