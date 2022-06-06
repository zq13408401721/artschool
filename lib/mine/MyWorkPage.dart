import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:yhschool/BaseState.dart';
import 'package:yhschool/bean/my_work_bean.dart';
import 'package:yhschool/teach/ClassWorkDetail.dart';
import 'package:yhschool/teach/WorkTile.dart';
import 'package:yhschool/utils/Constant.dart';
import 'package:yhschool/utils/DataUtils.dart';
import 'package:yhschool/utils/HttpUtils.dart';
import 'package:yhschool/video/VideoMorePage.dart';

import 'MyWorkTile.dart';

class MyWorkPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return MyWorkPageState();
  }
}

class MyWorkPageState extends BaseState{

  List<Data> workList = [];

  @override
  void initState() {
    super.initState();
    _queryWorkList();
  }

  void _queryWorkList(){
    httpUtil.post(DataUtils.api_querymywork,data: {}).then((value) {
      String result = checkLoginExpire(value);
      if(result.isNotEmpty){
        MyWorkBean bean = MyWorkBean.fromJson(json.decode(value));
        if(bean.errno == 0){
          setState(() {
            workList.addAll(bean.data);
          });
        }else{
          showToast(bean.errmsg);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            MyAppBar(
              preferredSize: Size.fromHeight(80),
              childView: Container(
                padding: EdgeInsets.only(
                    top: ScreenUtil().setHeight(60)
                ),
                decoration: BoxDecoration(
                    color:Colors.white
                ),
                child: Row(
                  children: [
                    InkWell(
                      onTap: (){
                        Navigator.pop(context);
                      },
                      child: Image.asset("image/ic_arrow_left.png",width: ScreenUtil().setWidth(60),height: ScreenUtil().setHeight(80),),
                    ),
                    Text("我的作业",style: TextStyle(fontSize: ScreenUtil().setSp(40),fontWeight: FontWeight.bold),),
                  ],
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: StaggeredGridView.countBuilder(
                  crossAxisCount: Constant.isPad ? 3 : 2,
                  itemCount: workList.length,
                  primary: false,
                  shrinkWrap: true,
                  mainAxisSpacing: ScreenUtil().setWidth(Constant.DIS_LIST),
                  crossAxisSpacing: ScreenUtil().setWidth(Constant.DIS_LIST),
                  addAutomaticKeepAlives: false,
                  //padding: EdgeInsets.only(left: ScreenUtil().setWidth(Constant.DIS_LIST),right: ScreenUtil().setWidth(Constant.DIS_LIST)),
                  staggeredTileBuilder: (int index) =>
                      StaggeredTile.fit(1),
                  //StaggeredTile.count(3,index==0?2:3),
                  itemBuilder: (context,index){
                    return GestureDetector(
                      child: MyWorkTile(data: workList[index],),
                      onTap: (){

                      },
                    );
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}