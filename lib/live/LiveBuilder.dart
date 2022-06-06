import 'dart:convert';

import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yhschool/BasePage.dart';
import 'package:yhschool/BaseState.dart';
import 'package:yhschool/utils/Constant.dart';
import 'package:yhschool/utils/DataUtils.dart';
import 'package:yhschool/utils/HttpUtils.dart';
import 'package:yhschool/utils/SizeUtil.dart';
import 'package:yhschool/bean/live_editor_bean.dart';

class LiveBuilder extends StatefulWidget{
  String roomid;
  LiveBuilder({@required this.roomid});
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return LiveBuilderState();
  }
}

class LiveBuilderState extends BasePage<LiveBuilder>{


  String name;
  String password;
  String desc;
  //直播时间
  String date = Constant.parseTime(DateTime.now());

  //直播名称
  void _liveName(String name){
    this.name = name;
  }

  //直播间密码
  void _password(String pw){
    this.password = pw;
  }

  //直播介绍
  void _desc(String desc){
    this.desc = desc;
  }

  /**
   * 提交直播信息
   */
  void _submitLive(){
    if(!isloading){
      if(name == null) return showToast("请输入直播名称");
      if(date == null) return showToast("请选择直播时间");
      if(desc == null) return showToast("请填写直播介绍");
      var option = {
        "roomid":widget.roomid,
        "name":name,
        "date":date,
        "desc":desc
      };
      if(password != null){
        option["password"] = password;
      }
      setLoading(true);
      httpUtil.post(DataUtils.api_editorliveroom,data:option).then((value){
        setLoading(false);
        LiveEditorBean bean = LiveEditorBean.fromJson(json.decode(value));
        if(bean.errno == 0){
          Navigator.pop(context,option);
        }
      }).catchError((e){
        setLoading(false);
      });
    }
  }

  @override
  List<Widget> addChildren() {
    return [
      //直播名称
      TextField(
        keyboardType: TextInputType.text,
        maxLines: 1,
        maxLength: 14,
        maxLengthEnforcement: MaxLengthEnforcement.enforced,
        decoration: InputDecoration(
          hintText: "直播名称（例如xx老师色彩直播间）",
          hintStyle: TextStyle(fontSize: ScreenUtil().setSp(SizeUtil.getFontSize(36)),color: Colors.black26),
          counterText: "",
          fillColor:Colors.white,
          filled: true,
          isCollapsed: true,
          contentPadding: EdgeInsets.only(
            left: ScreenUtil().setWidth(SizeUtil.getWidth(30)),
            top: ScreenUtil().setHeight(SizeUtil.getHeight(30)),
            bottom: ScreenUtil().setHeight(SizeUtil.getHeight(30)),
          ),
          enabledBorder: OutlineInputBorder(
            //边角
            borderRadius: BorderRadius.all(
              Radius.circular(SizeUtil.getWidth(10)), //边角为30
            ),
            borderSide: BorderSide(
              color: Colors.white, //边线颜色为黄色
              width: 1, //边线宽度为2
            ),
          ),
          focusedBorder: OutlineInputBorder(
            //边角
            borderRadius: BorderRadius.all(
              Radius.circular(SizeUtil.getWidth(10)), //边角为30
            ),
            borderSide: BorderSide(
              color: Colors.white, //边线颜色为黄色
              width: 1, //边线宽度为2
            ),
          ),
        ),
        onChanged: _liveName,
      ),
      SizedBox(height: ScreenUtil().setHeight(20),),
      //直播时间
      InkWell(
        onTap: (){
          //日期选择器
          DatePicker.showDateTimePicker(context,
            showTitleActions: false, //显示顶部按钮
            onChanged: (date){
              print("${date}");
              setState(() {
                this.date = Constant.parseTime(date);
              });
            },
            //确定事件
            //onConfirm: (date){}
            //当前事件
            currentTime: DateTime.now(),
            //语言
            locale: LocaleType.zh
          );
        },
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(ScreenUtil().setWidth(SizeUtil.getWidth(20))))

          ),
          padding: EdgeInsets.only(
              top: ScreenUtil().setHeight(SizeUtil.getHeight(30)),
              bottom: ScreenUtil().setHeight(SizeUtil.getHeight(30)),
              left:ScreenUtil().setHeight(SizeUtil.getWidth(30)),
              right:ScreenUtil().setHeight(SizeUtil.getWidth(30))
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("直播时间",style: TextStyle(color: Colors.black26,fontSize: ScreenUtil().setSp(SizeUtil.getFontSize(36))),),
              Text("${date}",style: TextStyle(color: Colors.red,),)
            ],
          ),
        ),
      ),
      /*SizedBox(height: ScreenUtil().setHeight(20),),
      //直播密码
      TextField(
        keyboardType: TextInputType.text,
        maxLines: 1,
        maxLength: 10,
        maxLengthEnforced: true,
        decoration: InputDecoration(
          hintText: "直播密码（不填则为不设密码）",
          hintStyle: TextStyle(fontSize: ScreenUtil().setSp(SizeUtil.getFontSize(36)),color: Colors.black26),
          counterText: "",
          fillColor:Colors.white,
          filled: true,
          isCollapsed: true,
          contentPadding: EdgeInsets.only(
            left: ScreenUtil().setWidth(SizeUtil.getWidth(30)),
            top: ScreenUtil().setHeight(SizeUtil.getHeight(30)),
            bottom: ScreenUtil().setHeight(SizeUtil.getHeight(30)),
          ),
          enabledBorder: OutlineInputBorder(
            //边角
            borderRadius: BorderRadius.all(
              Radius.circular(SizeUtil.getWidth(10)), //边角为30
            ),
            borderSide: BorderSide(
              color: Colors.white, //边线颜色为黄色
              width: 1, //边线宽度为2
            ),
          ),
          focusedBorder: OutlineInputBorder(
            //边角
            borderRadius: BorderRadius.all(
              Radius.circular(SizeUtil.getWidth(10)), //边角为30
            ),
            borderSide: BorderSide(
              color: Colors.white, //边线颜色为黄色
              width: 1, //边线宽度为2
            ),
          ),
        ),
        onChanged: _password,
      ),*/
      SizedBox(height: ScreenUtil().setHeight(20),),
      //直播介绍
      TextField(
        keyboardType: TextInputType.text,
        maxLines: 4,
        maxLength: 100,
        maxLengthEnforcement: MaxLengthEnforcement.enforced,
        decoration: InputDecoration(
          hintText: "直播介绍",
          hintStyle: TextStyle(fontSize: ScreenUtil().setSp(SizeUtil.getFontSize(36)),color: Colors.black26),
          counterText: "",
          fillColor:Colors.white,
          filled: true,
          isCollapsed: true,
          contentPadding: EdgeInsets.only(
            left: ScreenUtil().setWidth(SizeUtil.getWidth(30)),
            top: ScreenUtil().setHeight(SizeUtil.getHeight(30)),
            bottom: ScreenUtil().setHeight(SizeUtil.getHeight(30)),
          ),
          enabledBorder: OutlineInputBorder(
            //边角
            borderRadius: BorderRadius.all(
              Radius.circular(SizeUtil.getWidth(10)), //边角为30
            ),
            borderSide: BorderSide(
              color: Colors.white, //边线颜色为黄色
              width: 1, //边线宽度为2
            ),
          ),
          focusedBorder: OutlineInputBorder(
            //边角
            borderRadius: BorderRadius.all(
              Radius.circular(SizeUtil.getWidth(10)), //边角为30
            ),
            borderSide: BorderSide(
              color: Colors.white, //边线颜色为黄色
              width: 1, //边线宽度为2
            ),
          ),
        ),
        onChanged: _desc,
      ),
      SizedBox(height: ScreenUtil().setHeight(100),),
      InkWell(
        onTap: (){
          _submitLive();
        },
        child: Container(
          width: double.infinity,
          margin: EdgeInsets.only(
            left: ScreenUtil().setWidth(SizeUtil.getWidth(40)),
            right: ScreenUtil().setWidth(SizeUtil.getWidth(40)),
          ),
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.all(Radius.circular(ScreenUtil().setWidth(SizeUtil.getWidth(10))))
          ),
          padding: EdgeInsets.symmetric(
            vertical: ScreenUtil().setHeight(SizeUtil.getHeight(40)),
          ),
          alignment: Alignment(0,0),
          child: Text("创建直播",style: TextStyle(color:Colors.white),),
        ),
      )
    ];
  }

  @override
  String backTitle() {
    return "创建直播";
  }

}