
import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/shims/dart_ui_real.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yhschool/BaseState.dart';
import 'package:yhschool/bean/shared_teacher_pan_list_bean.dart';
import 'package:yhschool/utils/Constant.dart';
import 'package:yhschool/utils/DataUtils.dart';
import 'package:yhschool/utils/HttpUtils.dart';

import 'PanFolders.dart';

class SharedImage extends StatefulWidget{

  SharedImage({Key key}):super(key: key);

  SharedImageState _sharedImageState;

  @override
  State<StatefulWidget> createState() {
    _sharedImageState = new SharedImageState();
    return _sharedImageState;
  }

}

class SharedImageState extends BaseState<SharedImage>{

  List<Data> list = [];
  ScrollController _scrollController;
  bool isloading = false;
  bool hasMore = true; //记录是否还有更多数据
  int page = 1;
  int size = 50;
  bool isEditor = false;

  String selectTeacherUid;

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController()
      ..addListener(() {
        if(_scrollController.position.pixels > _scrollController.position.maxScrollExtent-100){
          //print("flag:$flag hasData: $_hasData");
          if(this.hasMore && !this.isloading){
            //加载列表数据
            showLoading(true);
            //延迟2秒才开始加载
            Timer(Duration(seconds: 2), (){
              if(selectTeacherUid != null){
                getPanFolders(selectTeacherUid);
              }else{
                showLoading(false);
              }
            });
          }
        }
      });
  }

  showTeacherPanByUid(String uid){
    setState(() {
      this.isData = true;
    });
    selectTeacherUid = uid;
    getPanFolders(uid);
  }

  /**
   * 获取盘文件夹
   */
  getPanFolders(String uid){
    this.isloading = true;
    var option = {
      "uid":uid,
      "page":this.page,
      "size":this.size,
      "type":1
    };
    httpUtil.post(DataUtils.api_panlistsharedteacher,data:option).then((value) => {
      this.isloading = false,
      getPanFoldersReturn(SharedTeacherPanListBean.fromJson(json.decode(value)))
    }).catchError((err)=>{
      this.isloading = false,
      print(err)
    });
  }

  /**
   * 获取盘文件夹目录返回
   */
  getPanFoldersReturn(SharedTeacherPanListBean bean){
    if(bean.errno == 0){
      if(bean.data.length < this.size){
        this.hasMore = false;
      }else{
        page++;
      }
      this.list.clear();
      setState(() {
        if(bean.data.length > 0){
          this.isData = true;
        }else{
          this.isData = false;
        }
        this.list.addAll(bean.data);
      });
    }else{
      showToast(bean.errmsg);
    }
  }

  /**
   * 是否显示loading
   */
  showLoading(bool visible){
    this.isloading = visible;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Offstage(
              offstage: !isData,
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
                          //点击事件
                          Navigator.push(context, MaterialPageRoute(builder: (context) =>
                              PanFolders(panid: list[index].id, type: 1, name: list[index].name,isShowMore: false,)
                          ));
                        },
                        child: Container(
                          child:Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(ScreenUtil().radius(20.0))),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(left: 0,right: 0),
                                    child: Image.asset("image/ic_folders.png",fit: BoxFit.cover,),
                                  ),
                                  Container(
                                      margin: EdgeInsets.only(top: ScreenUtil().setHeight(40)),
                                      child:Text(list[index].name,style: TextStyle(color: Colors.black,fontSize: Constant.isPad ? ScreenUtil().setSp(32) : ScreenUtil().setSp(42)),)
                                  )
                                ],
                              )
                          ),
                        ),
                      );
                    }),
              )
            ),
            Center(
              child: Offstage(
                offstage: isData,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset("image/ic_nodata.png"),
                    Text("无数据",style: TextStyle(fontSize: ScreenUtil().setSp(60)),)
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}