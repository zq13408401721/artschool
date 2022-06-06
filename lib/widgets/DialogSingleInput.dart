import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yhschool/BaseState.dart';
import 'package:yhschool/bean/edit_user_info_bean.dart';
import 'package:yhschool/utils/DataUtils.dart';
import 'package:yhschool/utils/HttpUtils.dart';

class DialogSingleInput extends StatefulWidget{

  String title,label;
  DialogSingleInput({Key key,@required this.title,@required this.label}):super(key: key);

  @override
  State<StatefulWidget> createState() {
    return DialogSingleInputState()
    ..title = title
    ..label = label;
  }
}

class DialogSingleInputState extends BaseState{

  String title,label;
  bool loading = true;
  TextEditingController controller;
  String inputTxt;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
    controller.text = label != null ? label : "";
  }

  /**
   * 保存修改昵称
   */
  void submit(String word){
    var option = {
      "nickname":word
    };
    httpUtil.post(DataUtils.api_updateuserinfo,data:option).then((value) {
      setState(() {
        loading = true;
      });
      EditUserInfoBean userinfo = EditUserInfoBean.fromJson(json.decode(value));
      if(userinfo.errno == 0){
        saveNickname(userinfo.data.nickname);
        Navigator.pop(context,userinfo.data.nickname);
      }else{
        showToast(userinfo.errmsg);
      }
    }).catchError((err){
      print("err:$err");
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Center(
      child: Stack(
        alignment: Alignment(0,0),
        children: [
          Card(
            child: Container(
              width: ScreenUtil().setWidth(800),
              height: ScreenUtil().setHeight(500),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10)
              ),
              child: Column(
                children: [
                  Container(
                    margin:EdgeInsets.only(left: ScreenUtil().setWidth(20),top: ScreenUtil().setHeight(40)),
                    child: Text(title,style: TextStyle(fontSize: ScreenUtil().setSp(40),color: Colors.grey),),
                  ),
                  Container(
                    margin:EdgeInsets.only(left: ScreenUtil().setWidth(40),top: ScreenUtil().setHeight(60),right: ScreenUtil().setWidth(40)),
                    child: TextField(
                      maxLines: 1,
                      maxLength: 20,
                      controller: controller,
                      enabled: loading,
                      decoration:InputDecoration(
                        hintText: "请输入内容",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: BorderSide(color: Colors.grey)
                          )
                      ),
                      onChanged: (word){
                        print("输入内容：$word");
                        inputTxt = word;
                      },
                    ),
                  ),
                  Spacer(),
                  InkWell(
                    onTap: (){
                      //保存数据
                      if(inputTxt == null || inputTxt.length == 0){
                        return showToast("请输入内容");
                      }
                      //如果输入没有变化就不提交数据
                      if(label != null && inputTxt != null && label == inputTxt){
                        print("数据没有变化");
                        Navigator.pop(context);
                      }else{
                        setState(() {
                          loading = false;
                        });
                        submit(inputTxt);
                      }
                    },
                    child: Container(
                      width: double.infinity,
                      alignment: Alignment(0,0),
                      decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(ScreenUtil().setWidth(10)),
                              bottomRight: Radius.circular(ScreenUtil().setWidth(10))
                          )
                      ),
                      padding: EdgeInsets.symmetric(
                          vertical: ScreenUtil().setHeight(20)
                      ),
                      child: Text("确定修改",style: TextStyle(color: Colors.white,fontSize: ScreenUtil().setSp(40)),),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Offstage(
            offstage: loading,
            child: Container(
              width: ScreenUtil().setWidth(40),
              height: ScreenUtil().setWidth(40),
              child: CircularProgressIndicator(color: Colors.red,),
            ),
          ),
        ],
      ),
    );
  }
}