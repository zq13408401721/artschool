import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yhschool/BaseState.dart';
import 'package:yhschool/bean/entity_tab_bean.dart';
import 'package:yhschool/bean/teacher_classes_bean.dart';
import 'package:yhschool/bean/video_category_group_bean.dart' as G;
import 'package:yhschool/utils/Constant.dart';
import 'package:yhschool/utils/DataUtils.dart';
import 'package:yhschool/utils/HttpUtils.dart';
import 'package:yhschool/utils/SizeUtil.dart';
import 'package:yhschool/widgets/TextButton.dart' as T;
import 'package:shared_preferences/shared_preferences.dart';

class DialogPush extends StatefulWidget{

  List<Data> classesList;
  bool ispushvideo; //当时是否是推送视频
  String label;
  DialogPush({Key key,@required this.classesList,@required this.ispushvideo=false,@required this.label}):super(key: key);

  @override
  State<StatefulWidget> createState() {
    return DialogPushState()
    ..classesList = classesList;
  }

}

class DialogPushState extends BaseState<DialogPush>{

  // 距离屏幕顶部高度 为屏幕的2/3
  double top;
  List<Data> classesList = [];
  bool saveState=false; //当前的保存状态
  List<TabBeanData> videoTabs = [];
  int selectTabId; //当前选中的Tab
  List<G.Data> videoGroup = [];
  int selectCategoryId; //当前选中的小节分组id
  String tabname,categoryname;


  Future<bool> getSaveState() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool _bool = prefs.getBool("classsavestate");
    return _bool;
  }

  /**
   * 设置班级id保存状态
   */
  Future<bool> setSaveState(bool _bool) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool("classsavestate",_bool);
  }

  /**
   * 保存班级id
   */
  void saveClassId() async{
    List<String> ids = [];
    for(Data _data in classesList){
      if(_data.select){
        ids.add(_data.id.toString());
      }
    }
    if(ids.length > 0){
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setStringList("classids",ids);
    }

  }

  /**
   *获取收藏的班级id
   */
  Future<List<String>> getClassIds() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList("classids");
  }

  //获取老师所在的所有班级
  void getTeacherClass(){
    var option = {
      "role":1
    };

    httpUtil.post(DataUtils.api_classesbyteacher,data: option).then((value){
      TeacherClassesBean classesBean = new TeacherClassesBean.fromJson(json.decode(value));
      if(classesBean.errno == 0){
        if(this.saveState){
          classesBean.data.forEach((element) async {
            var _bool = await this.getBool("class"+element.id.toString());
            if(_bool){
              element.select = true;
            }
          });
        }else{
          setState(() {
            classesList.addAll(classesBean.data);
          });
        }
      }
    });
  }

  /**
   * 保存标记班级
   */
  void saveMarkClass(){
    classesList.forEach((element) {
      if(element.select){
        this.setData("class"+element.id.toString(), true);
      }
    });
  }

  /**
   * 删除班级标志
   */
  void removeMarkClass(){
    classesList.forEach((element) {
      removeData("class"+element.id.toString());
    });
  }

  //获取当前选择的班级id
  List<int> getSelectClassIds(){
    List<int> ids = [];
    for(Data _data in classesList){
      if(_data.select){
        ids.add(_data.id);
      }
    }
    return ids;
  }

  @override
  void initState() {
    super.initState();
    if(classesList.length == 0){
      httpUtil.post(DataUtils.api_classesbyteacher,data: {}).then((value){
        TeacherClassesBean classesBean = new TeacherClassesBean.fromJson(json.decode(value));
        if(classesBean.errno == 0){
          classesList.addAll(classesBean.data);
          getSaveState().then((value){
            setState(() {
              if(value == null){
                this.saveState = false;
              }else{
                this.saveState = value;
                if(value){
                  classesList.forEach((element) async {
                    var _bool = await this.getBool("class"+element.id.toString());
                    if(_bool != null && _bool){
                      element.select = true;
                    }
                  });
                }
              }
            });
          });
        }else{
          showToast(classesBean.errmsg);
        }
      });
    }else{
      getSaveState().then((value){
        setState(() {
          if(value == null){
            this.saveState = false;
          }else{
            this.saveState = value;
            if(value){
              classesList.forEach((element) async {
                var _bool = await this.getBool("class"+element.id.toString());
                if(_bool != null && _bool){
                  element.select = true;
                }
              });
            }
          }
        });
      });
      _queryVideoTab();
    }
  }

  /**
   * 查询视频分类
   */
  void _queryVideoTab(){
    var option = {
      "type":3
    };
    print(option);
    httpUtil.get(DataUtils.api_tab,data: option).then((value){
      TabBean tabBean = TabBean.fromJson(json.decode(value));
      if(tabBean.errno == 0){
        //tabname = tabBean.data[0].name;
        setState(() {
          //selectTabId = tabBean.data[0].id;
          videoTabs.addAll(tabBean.data);
        });
        getCategoryByTab(tabBean.data[0].id);
      }else{
        showToast(tabBean.errmsg);
      }
    }).catchError((err){

    });
  }

  /**
   * 获取一级目录tab对应的章节数据
   */
  void getCategoryByTab(int tabid){
    var data = {
      "tabid":tabid,
      "type":3
    };
    //获取对应的章节数据
    httpUtil.get(DataUtils.api_categorybytabid,data: data).then((result){
      print(result);
      var group = new G.VideoCategoryGroupBean.fromJson(json.decode(result));
      videoGroup.clear();
      setState(() {
        /*selectCategoryId = group.data[0].id;
        categoryname = group.data[0].name;*/
        videoGroup.addAll(group.data);
      });
    }).catchError((err) => {
      print(err)
    });
  }

  /**
   * 对应的分类
   */
  Widget createVideoTabs(TabBeanData element){
    if(selectTabId == element.id){
      tabname = element.name;
    }
    return InkWell(
      child:Container(
        padding: EdgeInsets.only(left: ScreenUtil().setWidth(Constant.PADDING_GALLERY_LEFT-40)),
        child: Padding(
          padding: EdgeInsets.only(left: ScreenUtil().setWidth(40),right: ScreenUtil().setWidth(40),top: ScreenUtil().setHeight(15),bottom: ScreenUtil().setHeight(15)),
          child: Text(element.name,style: TextStyle(fontSize: ScreenUtil().setSp(42),
              color: this.selectTabId == element.id ? Constant.TAB_SELECT_COLOR : Constant.TAB_UNSELECT_COLOR),),
        ),
      ),
      onTap: ()=>{
        //print("item click+"+element.name)
        if(selectTabId != element.id){
          tabname = element.name,
          setState(() {
            selectTabId = element.id;
          }),
          getCategoryByTab(element.id)
        }else{
          tabname="",
          categoryname = "",
          setState((){
            selectTabId = 0;
            selectCategoryId = 0;
          })

        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    top = _size.height/3*2;
    return Card(
      margin: EdgeInsets.only(top:top,left: ScreenUtil().setWidth(SizeUtil.getWidth(20)),right: ScreenUtil().setWidth(SizeUtil.getWidth(20)),bottom: ScreenUtil().setHeight(SizeUtil.getHeight(10))),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10)
        ),
        child: Column(
          children: [
            Padding(padding: EdgeInsets.only(left: ScreenUtil().setWidth(SizeUtil.getWidth(20)),right: ScreenUtil().setWidth(SizeUtil.getWidth(20)),top: ScreenUtil().setHeight(SizeUtil.getHeight(10))),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(padding: EdgeInsets.only(left:ScreenUtil().setWidth(SizeUtil.getWidth(28))),
                        child: Text("选择班级",style:Constant.titleTextStyle,),
                      ),
                      Padding(padding: EdgeInsets.only(right: ScreenUtil().setWidth(SizeUtil.getWidth(20))),
                        child: Row(
                          children: [
                            Checkbox(value: saveState, onChanged:(_bool){
                              setSaveState(_bool);
                              setState(() {
                                saveState = _bool;
                              });
                              //保存班级选择状态
                              if(_bool){
                                saveMarkClass();
                              }else{
                                removeMarkClass();
                              }
                            }),
                            Text("记住我的选择",style: TextStyle(fontSize: ScreenUtil().setSp(SizeUtil.getFontSize(30))),)
                          ],
                        ),
                      )
                    ],
                  ),
                  Container(
                    height: SizeUtil.getHeight(100),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: GridView.builder(shrinkWrap:true,itemCount:classesList.length,gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        mainAxisSpacing: ScreenUtil().setWidth(SizeUtil.getWidth(10)),
                        crossAxisSpacing: ScreenUtil().setHeight(SizeUtil.getHeight(10)),
                        crossAxisCount: 2,
                        childAspectRatio: Constant.isPad ? 10/1 : 8/1,

                      ), itemBuilder: (context,index){
                        return Row(
                          children: [
                            Checkbox(value: classesList[index].select, onChanged:(_bool){
                              setState(() {
                                classesList[index].select = _bool;
                              });
                              if(_bool){
                                this.setData("class"+classesList[index].id.toString(), true);
                              }else{
                                this.removeData("class"+classesList[index].id.toString());
                              }
                            }),
                            Text(classesList[index].name,style: TextStyle(color: classesList[index].select?Colors.red:Colors.black87),)
                          ],
                        );
                      }),
                    ),
                  ),
                  //推荐视频
                 /* Offstage(
                    offstage: widget.ispushvideo,
                    child: Row(
                      children: [
                        Text("推荐一组教学视频"),
                        //视频分类
                        Row(
                          children: [
                            for(var i=0; i<videoTabs.length; i++) createVideoTabs(videoTabs[i])
                          ],
                        ),
                      ],
                    ),
                  ),
                  //分类对应的章节
                  Offstage(
                    offstage: widget.ispushvideo,
                    child: Container(
                      height: ScreenUtil().setHeight(100),
                      child: ListView.builder(
                          itemCount: videoGroup.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context,index){
                            return InkWell(
                                onTap: (){
                                  if(selectCategoryId == videoGroup[index].id){
                                    categoryname = "";
                                    tabname = "";
                                    setState(() {
                                      selectCategoryId = 0;
                                      selectTabId = 0;
                                    });
                                  }else{
                                    categoryname = videoGroup[index].name;
                                    setState(() {
                                      selectTabId = videoGroup[index].pid;
                                      selectCategoryId = videoGroup[index].id;
                                    });
                                  }
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: ScreenUtil().setWidth(20),
                                  ),
                                  child: Text(videoGroup[index].name,style: TextStyle(fontSize: ScreenUtil().setSp(36),color: selectCategoryId == videoGroup[index].id ? Colors.red : Colors.black87),),
                                )
                            );
                          }),
                    ),
                  )*/
                ],
              ),
            ),
            Spacer(),
            //拍照上传按钮
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  flex: 1,
                  child: InkWell(
                    onTap: (){
                      //发布图片上传
                      List<int> ids = this.getSelectClassIds();
                      if(ids.length == 0){
                        showToast("请先选择要发布的班级");
                      }else{
                        Navigator.pop(context,[1,ids,tabname,categoryname,selectCategoryId]);
                      }
                    },
                    child: Container(
                      height: ScreenUtil().setHeight(SizeUtil.getHeight(120)),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(ScreenUtil().setWidth(SizeUtil.getWidth(10))),
                            bottomRight: Radius.circular(ScreenUtil().setWidth(SizeUtil.getWidth(10))),
                          )
                      ),
                      child: Text(widget.ispushvideo ? "立即推送" : "相册 / 拍照上传",style: TextStyle(color: Colors.white,fontSize: ScreenUtil().setSp(SizeUtil.getFontSize(30))),),
                    ),
                  ),
                ),
                /*Expanded(
                  flex: 1,
                  child: InkWell(
                    onTap: (){
                      List<int> ids = this.getSelectClassIds();
                      if(ids.length == 0){
                        showToast("请先选择要发布的班级");
                      }else{
                        Navigator.pop(context,[2,ids]);
                      }
                    },
                    child: Container(
                      height: ScreenUtil().setHeight(120),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(ScreenUtil().setWidth(10))
                          )
                      ),
                      child: Text("发短视频"),
                    ),
                  ),
                )*/
              ],
            ),

          ],
        ),
      ),
    );
  }

}