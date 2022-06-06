import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yhschool/BaseState.dart';
import 'package:yhschool/bean/edit_user_info_bean.dart';
import 'package:yhschool/bean/edit_user_p_w_bean.dart';
import 'package:yhschool/utils/DataUtils.dart';
import 'package:yhschool/utils/HttpUtils.dart';
import 'package:crypto/crypto.dart';
import 'package:convert/convert.dart';


class DialogEditorPassword extends StatefulWidget{

  String title;
  DialogEditorPassword({Key key,@required this.title}):super(key: key);

  @override
  State<StatefulWidget> createState() {
    return DialogEditorPasswordState()
      ..title = title;
  }
}

class DialogEditorPasswordState extends BaseState{

  String title;
  bool loading = true;
  String oldTxt,newTxt1,newTxt2;
  FocusNode _focusNode1,_focusNode2,_focusNode3;

  @override
  void initState() {
    super.initState();
    _focusNode1 = new FocusNode();
    _focusNode2 = new FocusNode();
    _focusNode3 = new FocusNode();
  }

  String dataTomd5(String data){
    var content = new Utf8Encoder().convert(data);
    var digest = md5.convert(content);
    return hex.encode(digest.bytes);
  }

  /**
   * 保存修改昵称
   */
  void submit(){
    var option = {
      "oldpassword":dataTomd5(oldTxt),
      "newpassword":dataTomd5(newTxt1),
      "passwordtxt":newTxt1
    };
    httpUtil.post(DataUtils.api_updateuserinfo,data:option).then((value) {
      setState(() {
        loading = true;
      });
      EditUserPWBean userinfo = EditUserPWBean.fromJson(json.decode(value));
      if(userinfo.errno == 0){
        showToast(userinfo.data.msg);
        Navigator.pop(context);
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
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: (){
        if(_focusNode1.hasFocus || _focusNode2.hasFocus || _focusNode3.hasFocus){
          _focusNode1.unfocus();
          _focusNode2.unfocus();
          _focusNode3.unfocus();
          FocusScope.of(context).requestFocus(new FocusNode());
        }else{
          Navigator.pop(context);
        }
      },
      child: Center(
        child: Stack(
          alignment: Alignment(0,0),
          children: [
            Card(
              child: Container(
                width: ScreenUtil().setWidth(800),
                height: ScreenUtil().setHeight(900),
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
                      margin:EdgeInsets.only(left: ScreenUtil().setWidth(40),top: ScreenUtil().setHeight(40),right: ScreenUtil().setWidth(40)),
                      child: TextField(
                        maxLines: 1,
                        maxLength: 18,
                        enabled: loading,
                        obscureText: true,
                        focusNode: _focusNode1,
                        inputFormatters: [
                          FilteringTextInputFormatter(RegExp("^[a-z0-9A-Z]+"),allow: true)
                        ],
                        decoration:InputDecoration(
                            hintText: "请输入原来密码",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide: BorderSide(color: Colors.grey)
                            )
                        ),
                        onChanged: (word){
                          oldTxt = word;
                        },
                      ),
                    ),
                    Container(
                      margin:EdgeInsets.only(left: ScreenUtil().setWidth(40),top: ScreenUtil().setHeight(40),right: ScreenUtil().setWidth(40)),
                      child: TextField(
                        maxLines: 1,
                        maxLength: 18,
                        enabled: loading,
                        obscureText: true,
                        focusNode: _focusNode2,
                        inputFormatters: [
                          FilteringTextInputFormatter(RegExp("^[a-z0-9A-Z]+"),allow: true)
                        ],
                        decoration:InputDecoration(
                          hintText: "请输入新密码",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: BorderSide(color: Colors.grey)
                          ),
                        ),
                        onChanged: (word){
                          newTxt1 = word;
                        },
                      ),
                    ),
                    Container(
                      margin:EdgeInsets.only(left: ScreenUtil().setWidth(40),top: ScreenUtil().setHeight(40),right: ScreenUtil().setWidth(40)),
                      child: TextField(
                        maxLines: 1,
                        maxLength: 18,
                        enabled: loading,
                        obscureText: true,
                        focusNode: _focusNode3,
                        inputFormatters: [
                          FilteringTextInputFormatter(RegExp("^[a-z0-9A-Z]+"),allow: true)
                        ],
                        decoration:InputDecoration(
                            hintText: "请再次输入新密码",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide: BorderSide(color: Colors.grey)
                            )
                        ),
                        onChanged: (word){
                          newTxt2 = word;
                        },
                      ),
                    ),
                    Text("*只能输入数字和英文字母",style: TextStyle(color: Colors.red),),
                    Spacer(),
                    InkWell(
                      onTap: (){
                        //保存数据
                        if(oldTxt == null || newTxt1 == null || newTxt2 == null || oldTxt.length == 0 || newTxt1.length == 0 || newTxt2.length == 0){
                          return showToast("请输入内容");
                        }
                        if(newTxt1 == newTxt2){
                          if(newTxt1 == oldTxt){
                            return showToast("不能和原来密码一样");
                          }else if(newTxt1.length < 6){
                            return showToast("密码长度不能小于6位");
                          }else{
                            submit();
                          }
                        }else{
                          return showToast("两次输入的密码不一致");
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
      ),
    );
  }
}