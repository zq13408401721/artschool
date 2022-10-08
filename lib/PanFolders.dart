import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yhschool/BaseEditorState.dart';
import 'package:yhschool/BaseState.dart';
import 'package:yhschool/bean/pan_create_folder_bean.dart' as Folder;
import 'package:yhschool/bean/pan_delete_folder.dart' as DeleteFolder;
import 'package:yhschool/bean/pan_folder_bean.dart';
import 'package:yhschool/utils/Constant.dart';
import 'package:yhschool/utils/DataUtils.dart';
import 'package:yhschool/utils/HttpUtils.dart';

/**
 * 网盘二级文件夹目录
 */
class PanFolders extends StatefulWidget{

  int panid;
  int type; //文件夹分类1 图片 2步骤 3考题
  String name;
  bool isShowMore; //是否显示更多
  PanFolders({Key key,@required this.panid,@required this.type,@required this.name,@required this.isShowMore=true}):super(key: key);

  @override
  State<StatefulWidget> createState() {
    return PanFoldersState()
        ..panid = panid
        ..type = type
        ..name = name
        ..isShowMore = isShowMore;
  }

}

class PanFoldersState extends BaseEditorState<PanFolders>{

  int panid;
  int type;
  String name;
  int page = 1;
  int size = 50;
  bool isShowMore;

  List<Data> list = [];

  @override
  void initState() {
    super.initState();
    getPanFolderList();
  }

  refreshData(){

  }

  /**
   * 创建文件夹
   */
  void createFolder(){
    var option = {
      "page":page,
      "size":size,
      "panid":panid
    };
    httpUtil.post(DataUtils.api_panfoldercreate,data: option).then((value) => {

    }).catchError((err)=>{
      print("err:$err")
    });
  }

  /**
   * 获取网盘目录列表
   */
  getPanFolderListReturn(PanFolderBean result){
    setState(() {
      this.list.addAll(result.data);
    });
  }

  /**
   * 获取盘列表
   */
  void getPanFolderList(){
    var option = {
      "page":page,
      "size":size,
      "panid":panid
    };
    httpUtil.post(DataUtils.api_panfolderlist,data: option).then((value) => {
      getPanFolderListReturn(PanFolderBean.fromJson(json.decode(value)))
    }).catchError((err)=>{
      print("err:$err")
    });
  }

  /**
   * 创建文件夹返回
   */
  void createFolderReturn(Folder.PanCreateFolderBean result){
    if(result.errno == 0){
      setState(() {
        Data _data = new Data();
        _data.id = result.data.id;
        _data.panid = result.data.panid;
        _data.name = result.data.name;
        _data.state = result.data.state;
        _data.date = result.data.date;
        _data.deletedate = result.data.deletedate;
        list.insert(0, _data);
      });
    }else{
      showToast(result.errmsg);
    }
  }

  /**
   * 创建文件夹
   */
  void folderCB(String content){
    print("content:$content");
    var option = {
      "name":content,
      "panid":panid
    };
    httpUtil.post(DataUtils.api_panfoldercreate,data:option).then((value) => {
      createFolderReturn(Folder.PanCreateFolderBean.fromJson(json.decode(value)))
    }).catchError((err)=>{
      print("err:$err")
    });
  }

  /**
   * 列表数据选中状态
   */
  selectListData(bool _bool){
    setState(() {
      for(Data item in list){
        item.select = _bool;
      }
      if(_bool){
        this.selectNum = list.length;
      }else{
        this.selectNum = 0;
      }
    });
  }

  //编辑全选
  void selectFun(bool _bool){
    selectListData(_bool);
  }

  //删除选择
  void deleteSelect(BuildContext context){
    if(this.list.length > 0){
      showAlertTips(context, "是否确定删除$selectNum个文件", (){
        //删除数据
        String ids = '';
        this.list.forEach((element) {
          if(element.select){
            ids = ids.length == 0 ? '${element.id}' : '$ids'',''${element.id}';
          }
        });
        if(ids.length > 0){
          deleteFolder(ids);
        }else{
          showToast("选择要删除的目录");
        }
      });
    }else{
      showToast("请选择删除数据");
    }
  }

  // 取消编辑
  void cancelSelect(){
    hideEditor();
    selectListData(false);
  }

  //删除文件夹
  void deleteFolder(String ids){
    var option = {
      'panid':panid,
      'folderids':ids
    };
    httpUtil.post(DataUtils.api_pandeletefolder,data: option).then((value) {
      DeleteFolder.PanDeleteFolder folder = DeleteFolder.PanDeleteFolder.fromJson(json.decode(value));
      if(folder.errno == 0){
        setState(() {
          folder.data.folderids.forEach((element) {
            for(var i=0; i<list.length; i++){
              if(int.parse(element) == list[i].id){
                list.removeAt(i);
                break;
              }
            }
          });
          //删除以后刷新界面
          this.selectNum = 0;
          this.selectAll = "全选";
        });
      }else{
        showToast(folder.errmsg);
      }
    }).catchError((err){
      print("err:$err");
    });
  }

  /**
   * 是否全选已经选中的数据
   */
  bool isSelectAll(){
    bool _bool = true;
    int number = 0;
    list.forEach((element) {
      if(!element.select){
        if(_bool){
          _bool = false;
        }
      }else{
        number++;
      }
    });
    this.selectNum = number;
    return _bool;
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                this.isShowMore ?
                TitleMoreView(name, CB_Class(()=>{
                  Navigator.pop(context)
                },()=>{  //更多操作
                  setState(() {
                    this.ischoose = false;
                  })
                })) :
                TitleView(name, CB_Class(()=>{
                  Navigator.pop(context)
                }, ()=>{})),
                SingleChildScrollView(
                  child: GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: list.length,
                      padding: EdgeInsets.only(top: ScreenUtil().setHeight(20)),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisSpacing: Constant.GARRERY_GRID_CROSSAXISSPACING,
                          mainAxisSpacing: ScreenUtil().setWidth(Constant.PADDING_GALLERY_CROSS),
                          crossAxisCount: Constant.isPad ? 3 : 2,
                          childAspectRatio: Constant.isPad ? 1.22 : 1.4
                      ),
                      itemBuilder: (context,index){
                        return GestureDetector(
                          onTap: (){
                            //点击事件
                            // Navigator.push(context, MaterialPageRoute(builder: (context){
                            //   PanFile(folderid: list[index].id, foldername: list[index].name);
                            // }
                            if(!this.iseditor){
                              setState(() {
                                list[index].select = !list[index].select;
                                //判断当前是否是全选
                                bool _isAll = this.isSelectAll();
                                if(_isAll){
                                  this.selectAll = "全不选";
                                }else{
                                  this.selectAll = "全选";
                                }
                              });
                            }else{

                            }
                          },
                          child: Container(
                            child:Card(
                                margin: EdgeInsets.only(top: ScreenUtil().setHeight(30)),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(ScreenUtil().radius(20.0))),
                                ),
                                child: Stack(
                                  children: [
                                    Positioned(
                                      left:0,
                                      right: 0,
                                      top: 0,
                                      bottom: 0,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            margin:EdgeInsets.only(left:0,right:0),
                                            child: Image.asset("image/ic_imgs.png",fit: BoxFit.cover,),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(top: ScreenUtil().setHeight(20)),
                                            child: Text(
                                              list[index].name,
                                              softWrap: true,
                                              textAlign: TextAlign.center,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              style: TextStyle(fontSize: Constant.isPad ? ScreenUtil().setSp(32) : ScreenUtil().setSp(42)),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Positioned(
                                      right: ScreenUtil().setWidth(10),
                                      child: Offstage(
                                        offstage: this.iseditor,
                                        child: Checkbox(tristate: false,value: list[index].select, onChanged: (_bool){
                                          setState(() {
                                            list[index].select = _bool;
                                            //判断当前是否是全选
                                            bool _isAll = this.isSelectAll();
                                            if(_isAll){
                                              this.selectAll = "全不选";
                                            }else{
                                              this.selectAll = "全选";
                                            }
                                          });
                                        },
                                          shape: CircleBorder(),
                                          focusNode: FocusNode(canRequestFocus: false),
                                          activeColor: Colors.blue,
                                        ),
                                      ),
                                    )
                                  ],
                                )
                            ),
                          ),
                        );
                      }),
                )
              ],
            ),
            Positioned(
              bottom: ScreenUtil().setHeight(20),
              right: ScreenUtil().setWidth(20),
              child: Offstage(
                offstage: !this.iseditor || !this.isShowMore,
                child: InkWell(
                  child: Image.asset("image/ic_add.png",width: 40,height: 40,),
                  onTap: (){
                    showAlertDialog(context,title: "创建$name下的目录",cb: folderCB);
                  },
                ),
              )
            ),
            //编辑bar
            EditorBar(cancelSelect, selectFun),
            //编辑状态底部删除框
            Positioned(
                bottom: 0,
                right: 0,
                left: 0,
                child: BottomBar(context,deleteSelect)
            ),
            // 更多的操作框
            Positioned(
              top: ScreenUtil().setHeight(Constant.SIZE_TITLE_NORMAL_HEIGHT),
              right: 0,
              child: PopChoose(context, (){
                showEditor();
              }),
            )
          ],
        ),
      ),
    );
  }
}