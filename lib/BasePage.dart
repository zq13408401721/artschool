import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yhschool/BaseState.dart';
import 'package:yhschool/utils/SizeUtil.dart';
import 'package:yhschool/widgets/BackButtonWidget.dart';

abstract class BasePage<T extends StatefulWidget> extends BaseState<T>{

  String backTitle();
  bool isloading=false;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  /**
   * 设置loading状态
   */
  void setLoading(bool _bool){
    setState(() {
      isloading = _bool;
    });
  }

  /**
   * 标题
   */
  Widget titleWidget(){
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(
          top: ScreenUtil().setHeight(SizeUtil.getHeight(40)),
          bottom: ScreenUtil().setHeight(SizeUtil.getHeight(20)),
      ),
      child: Row(
        children: [
          BackButtonWidget(cb: (){Navigator.pop(context);}, title: backTitle(),),
        ],
      ),

    );
  }

  /**
   * 创建子元素
   */
  List<Widget> addChildren();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              color: Colors.grey[100],
              width: double.infinity,
              height: double.infinity,
              child: Column(
                children: [
                  titleWidget(),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: ScreenUtil().setHeight(SizeUtil.getHeight(40)),
                        left: ScreenUtil().setWidth(SizeUtil.getWidth(40)),
                        right: ScreenUtil().setWidth(SizeUtil.getWidth(40)),
                      ),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
                          children: addChildren(),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            //全屏loading
            isloading ?
            Container(
              color: Color.fromARGB(80, 255, 255, 255),
              child: Center(
                child: CircularProgressIndicator(
                  color: Colors.red,strokeWidth: 2,
                ),
              ),
            ) : SizedBox()
          ],
        )
      ),
    );
  }

}