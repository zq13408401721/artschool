import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yhschool/BaseState.dart';
import 'package:yhschool/utils/Constant.dart';
import 'package:yhschool/utils/DataUtils.dart';
import 'package:yhschool/utils/HttpUtils.dart';

import 'package:yhschool/bean/pan_create_bean.dart' as CreateData;


import 'PanFolders.dart';
import 'PanPage.dart';
import 'bean/pan_list_bean.dart';

class PanExam extends StatefulWidget{

  // 接口回调相关类
  Base_Class base_class;

  PanExam({Key key,@required this.base_class}):super(key: key);

  @override
  State<StatefulWidget> createState() {
    return PanExamState()
      ..base_class = base_class;
  }

}

class PanExamState extends BaseState<PanExam>{

  Base_Class base_class;
  bool isEditor = false;

  List<Data> list = [];
  bool isloading = false;
  bool hasMore = true; //记录是否还有更多数据
  int page = 1;
  int size = 50;

  @override
  void initState() {
    super.initState();
    getPanFolders();
  }

  /**
   * 文件夹创建完刷新列表
   */
  void refreshData(CreateData.PanCreateBean data){
    Data _data = new Data();
    _data.id = data.data.id;
    _data.name = data.data.name;
    _data.type = data.data.type;
    _data.date = data.data.date;
    _data.uid = data.data.uid;
    _data.state = data.data.state;
    _data.deletedate = data.data.deletedate;

    setState(() {
      list.insert(0, _data);
    });
  }


  /**
   * 获取盘文件夹
   */
  getPanFolders(){
    this.isloading = true;
    var option = {
      "page":this.page,
      "size":this.size,
      "type":3
    };
    httpUtil.post(DataUtils.api_panlist,data:option).then((value) => {
      this.isloading = false,
      getPanFoldersReturn(PanListBean.fromJson(json.decode(value)))
    }).catchError((err)=>{
      this.isloading = false,
      print(err)
    });
  }

  /**
   * 获取盘文件夹目录返回
   */
  getPanFoldersReturn(PanListBean bean){
    if(bean.errno == 0){
      if(bean.data.length < this.size){
        this.hasMore = false;
      }else{
        page++;
      }
      setState(() {
        this.list.addAll(bean.data);
      });
    }
  }

  /**
   * 是否显示loading
   */
  showLoading(bool visible){
    this.isloading = visible;
  }

  /**
   * 设置编辑状态
   */
  SetEditorState(bool _bool){
    setState(() {
      this.isEditor = _bool;
    });
  }

  /**
   * 设置列表的选中状态
   */
  SetSelectState(bool _bool){
    setState(() {
      this.list.forEach((element) {
        element.select = _bool;
      });
    });
  }

  /**
   * 选中数量
   */
  int getSelectNum(){
    int num = 0;
    this.list.forEach((element) {
      if(element.select){
        num++;
      }
    });
    return num;
  }

  /**
   * 是否全选
   */
  bool isSelectAll(){
    bool _bool = true;
    for(var i=0; i<this.list.length; i++){
      if(!this.list[i].select){
        if(_bool){
          _bool = false;
          break;
        }
      }
    }
    return _bool;
  }

  /**
   * 获取选中文件的id
   */
  String getSelectIds(){
    String ids = '';
    this.list.forEach((element) {
      if(element.select){
        ids = ids.length == 0 ? '${element.id}' : '$ids'',''${element.id}';
      }
    });
    return ids;
  }

  /**
   * 更新盘数据_list盘的id数据
   */
  updatePan(List<String> _list){
    setState(() {
      _list.forEach((element) {
        for(var i=0; i<list.length; i++){
          if(int.parse(element) == list[i].id){
            list.removeAt(i);
            break;
          }
        }
      });
    });
  }

  /**
   * loading加载效果
   */
  Widget _loadingWidget() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            CircularProgressIndicator(strokeWidth: 1.0),
            Text('加载中...', style: TextStyle(fontSize: 16.0),)
          ],
        ),
      ),
    );
  }

  // 显示加载中的圈圈
  Widget _showMore() {
    if(isloading) {
      return this.hasMore ? this._loadingWidget() : Text('---暂无其他数据了---');
    } else {
      return SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
            child: SingleChildScrollView(
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
                        if(this.isEditor){
                          if(this.base_class != null){
                            setState(() {
                              list[index].select = !list[index].select;
                            });
                            this.base_class.itemClick(list[index].select);
                          }
                        }else{
                          //点击事件
                          Navigator.push(context, MaterialPageRoute(builder: (context) =>
                              PanFolders(panid: list[index].id, type: 3, name: list[index].name)
                          ));
                        }
                      },
                      child: Container(
                        child:Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(ScreenUtil().radius(20.0))),
                            ),
                            child: Stack(
                              children: [
                                Positioned(
                                  left: 0,
                                  right: 0,
                                  top: 0,
                                  bottom: 0,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        child: Image.asset("image/ic_folders.png",fit: BoxFit.cover,),
                                      ),
                                      Container(
                                          margin: EdgeInsets.only(top: ScreenUtil().setHeight(40)),
                                          child:Text(list[index].name,style:TextStyle(fontSize: Constant.isPad ? ScreenUtil().setSp(32) : ScreenUtil().setSp(42)),)
                                      )
                                    ],
                                  ),
                                ),
                                Positioned(
                                    right: ScreenUtil().setWidth(10),
                                    child: Offstage(
                                      offstage: !this.isEditor,
                                      child: Checkbox(tristate: false,value: list[index].select, onChanged: (_bool){
                                        setState(() {
                                          list[index].select = _bool;
                                          //判断当前是否是全选
                                          if(base_class != null){
                                            base_class.itemClick(_bool);
                                          }
                                        });
                                      },
                                        shape: CircleBorder(),
                                        focusNode: FocusNode(canRequestFocus: false),
                                        activeColor: Colors.blue,
                                      ),
                                    )
                                )
                              ],
                            )
                        ),
                      ),
                    );
                  }),
            )
        ),
      ),
    );
  }
}