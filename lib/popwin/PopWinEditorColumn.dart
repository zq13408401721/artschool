import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yhschool/BaseState.dart';
import 'package:yhschool/utils/DataUtils.dart';
import 'package:yhschool/utils/HttpUtils.dart';
import 'package:yhschool/bean/column_update_info_bean.dart';

class PopWinEditorColumn extends StatefulWidget{

  String name;
  int visible;
  int columnid;

  PopWinEditorColumn({Key key,@required this.name,@required this.visible,@required this.columnid}):super(key: key);

  @override
  State<StatefulWidget> createState() {
    return PopWinEditorColumnState();
  }
}

class PopWinEditorColumnState extends BaseState<PopWinEditorColumn>{
  bool loading = true;
  TextEditingController controller;
  String inputTxt="";
  bool isprivate = false; //是否公开
  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
    controller.text = widget.name;
    isprivate = widget.visible == 0 ? false : true;
  }

  /**
   * 提交编辑信息
   */
  void _submitColumnEidtor(){
    var option = {};
    if(inputTxt.length > 0 && inputTxt != widget.name){
      option["name"] = inputTxt;
    }
    if(isprivate != (widget.visible == 1)){
      option["visible"] = isprivate ? 1 : 0;
    }
    option["columnid"] = widget.columnid;
    httpUtil.post(DataUtils.api_unpdatecolumninfo,data: option).then((value){
      print("value:$value");
      ColumnUpdateInfoBean bean = ColumnUpdateInfoBean.fromJson(json.decode(value));
      if(bean.errno == 0){
        Navigator.pop(context,option);
      }else{
        showToast(bean.errmsg);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        width: ScreenUtil().setWidth(600),
        height: ScreenUtil().setHeight(600),
        child: Stack(
          alignment: Alignment(0,0),
          children: [
            Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10)
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Container(
                          margin:EdgeInsets.only(left: ScreenUtil().setWidth(20),top: ScreenUtil().setHeight(60)),
                          child: Text("编辑专栏",style: TextStyle(fontSize: ScreenUtil().setSp(40)),textAlign: TextAlign.center,),
                        ),
                      ),
                    ],
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
                              borderSide: BorderSide(color: Colors.black12)
                          ),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide(color: Colors.black12)
                        )
                      ),
                      onChanged: (word){
                        print("输入内容：$word");
                        inputTxt = word;
                      },
                    ),
                  ),
                  //权限设置
                  Padding(padding: EdgeInsets.only(left:ScreenUtil().setWidth(10)),
                    child: Row(
                      children: [
                        Checkbox(value: isprivate, onChanged: (value){
                          setState(() {
                            isprivate = value;
                          });
                        }),
                        InkWell(
                          onTap: (){
                            setState(() {
                              isprivate = !this.isprivate;
                            });
                          },
                          child: Text("仅本校看"),
                        )
                      ],
                    ),
                  ),
                  Spacer(),
                  InkWell(
                    onTap: (){
                      //保存数据
                      if((inputTxt == null || inputTxt.length == 0) && (this.isprivate == (widget.visible == 1))){
                        showToast("未做任何修改");
                        return Navigator.pop(context);
                      }else{
                        setState(() {
                          loading = false;
                        });
                        _submitColumnEidtor();
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
            Offstage(
              offstage: loading,
              child: CircularProgressIndicator(
                color: Colors.black12,
                semanticsValue: "loading",
                strokeWidth: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}