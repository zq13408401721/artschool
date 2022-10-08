import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yhschool/utils/SizeUtil.dart';

import 'BaseRefreshState.dart';

abstract class BaseHeaderRefresh<T extends StatefulWidget> extends BaseRefreshState<T>{


  Widget addHeaderWidget();

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Container(
        color: Colors.grey[100],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            addHeaderWidget(),
            //刷新动画
            isrefreshing ?
            Center(
              child: Container(
                padding: EdgeInsets.symmetric(
                    vertical: SizeUtil.getAppHeight(40)
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: SizeUtil.getAppWidth(40),
                      height: SizeUtil.getAppWidth(40),
                      child: CircularProgressIndicator(color: Colors.red,),
                    ),
                    SizedBox(width: 10,),
                    Text("数据刷新中",style: TextStyle(color: Colors.grey),)
                  ],
                ),
              ),
            ) : SizedBox(),
            SizedBox(height: SizeUtil.getAppHeight(20)),
            Expanded(child: addChildren()),
            isloading ?
            Center(
              child: Container(
                padding: EdgeInsets.symmetric(
                    vertical: SizeUtil.getAppHeight(40)
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: SizeUtil.getAppWidth(40),
                      height: SizeUtil.getAppWidth(40),
                      child: CircularProgressIndicator(color: Colors.red,),
                    ),
                    SizedBox(width: 10,),
                    Text("加载更多",style: TextStyle(color:Colors.grey,fontSize: SizeUtil.getAppFontSize(30),fontWeight: FontWeight.normal,decoration: TextDecoration.none),)
                  ],
                ),
              ),
            ) : SizedBox()
          ],
        ),
      ),
    );
  }

}