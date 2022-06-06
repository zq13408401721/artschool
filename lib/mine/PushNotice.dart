import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:yhschool/bean/push_notice_bean.dart';
import 'package:yhschool/utils/DataUtils.dart';
import 'package:yhschool/utils/HttpUtils.dart';
import 'package:yhschool/utils/SizeUtil.dart';

/**
 * 发布公告
 */
class PushNotice extends StatelessWidget{


  String title,content;

  void _send(BuildContext context){
    if(title != null && content != null){
      httpUtil.post(DataUtils.api_pushnotice,data:{"title":title,"content":content}).then((value){
        print(value);
        PushNoticeBean bean = PushNoticeBean.fromJson(json.decode(value));
        if(bean.errno == 0){
          Navigator.pop(context,bean.data.id);
        }
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Center(
          child: Card(
            child: Container(
              width: ScreenUtil().setWidth(SizeUtil.getWidth(750)),
              height: ScreenUtil().setHeight(SizeUtil.getHeight(1000)),
              padding: EdgeInsets.only(
                top: ScreenUtil().setHeight(SizeUtil.getHeight(20))
              ),
              child: Column(
                children: [
                  Container(
                    alignment: Alignment(0.95,0),
                    child: InkWell(
                      onTap: (){
                        Navigator.pop(context);
                      },
                      child: Image.asset("image/ic_fork.png"),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: ScreenUtil().setWidth(SizeUtil.getWidth(40))
                    ),
                    margin: EdgeInsets.only(
                      top: ScreenUtil().setHeight(SizeUtil.getHeight(30))
                    ),
                    child: TextField(
                      maxLength: 10,
                      maxLines: 1,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          hintText: "输入标题（10个字以内）",
                          hintStyle: TextStyle(color: Colors.grey),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: BorderSide(color: Colors.grey[300])
                          ),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: BorderSide(color: Colors.grey[300])
                          ),
                      ),
                      onChanged: (word){
                        title = word;
                      },
                    ),
                  ),
                  Container(
                    alignment: Alignment(-1,0),
                    padding: EdgeInsets.symmetric(
                        horizontal: ScreenUtil().setWidth(SizeUtil.getWidth(40)),
                        vertical: ScreenUtil().setHeight(SizeUtil.getHeight(20))
                    ),
                    child: Text("填写公告内容",style: TextStyle(fontSize: ScreenUtil().setSp(SizeUtil.getFontSize(32))),),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: ScreenUtil().setWidth(SizeUtil.getWidth(40))
                    ),
                    child: TextField(
                      maxLines: 8,
                      maxLength: 150,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          hintText: " 输入内容（150个字以内）",
                          hintStyle: TextStyle(color: Colors.grey),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: ScreenUtil().setHeight(SizeUtil.getHeight(10)),
                              horizontal: ScreenUtil().setWidth(SizeUtil.getWidth(10))
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: BorderSide(color:Colors.grey[300])
                          ),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: BorderSide(color:Colors.grey[300])
                          )
                      ),
                      onChanged: (word){
                        this.content = word;
                      },
                    ),
                  ),
                  Spacer(),
                  InkWell(
                    onTap: (){
                      //发布通知
                      _send(context);
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          vertical: ScreenUtil().setHeight(SizeUtil.getHeight(30))
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(5),
                            bottomRight: Radius.circular(5)
                        )
                      ),
                      alignment: Alignment(0,0),
                      child: Text("发 布",style: TextStyle(color: Colors.white,fontSize: ScreenUtil().setSp(SizeUtil.getFontSize(36))),),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

}