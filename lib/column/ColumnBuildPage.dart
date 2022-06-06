import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yhschool/BaseState.dart';
import 'package:yhschool/bean/add_special_column_bean.dart';
import 'package:yhschool/bean/special_type_bean.dart' as M;
import 'package:yhschool/utils/DataUtils.dart';
import 'package:yhschool/utils/HttpUtils.dart';
import 'package:yhschool/utils/SizeUtil.dart';
import 'package:yhschool/widgets/BackButtonWidget.dart';
import 'package:yhschool/widgets/BaseTitleBar.dart';
import 'package:yhschool/widgets/MyRadiuButton.dart';

class ColumnBuildPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return ColumnBuildPageState();
  }

}

class ColumnBuildPageState extends BaseState{

  bool isopen = false; //是否公开，false表示只能本校看
  String columnname=""; //专栏名称
  List<M.Data> types = [];
  M.Data selectItem;

  @override
  void initState() {
    super.initState();
    _queryColumntType();
  }

  void _queryColumntType(){
    httpUtil.post(DataUtils.api_querycolumntype,data:{}).then((value){
      M.SpecialTypeBean bean = M.SpecialTypeBean.fromJson(json.decode(value));
      if(bean.errno == 0){
        setState(() {
          types.addAll(bean.data);
        });
      }else{
        showToast(bean.errmsg);
      }
    });
  }

  /**
   * 提交创建分类的数据
   */
  void _submit(){

    if(selectItem == null){ return showToast("请选择分类");}
    if(columnname ==  null || columnname.length == 0) {return showToast("请输入专栏名称");}
    var option = {
      "type":selectItem.id,
      "name":columnname,
      "visible":isopen ? 1 : 0
    };

    httpUtil.post(DataUtils.api_addcolumn,data: option).then((value){
      AddSpecialColumnBean bean = AddSpecialColumnBean.fromJson(json.decode(value));
      if(bean.errno == 0){
        Navigator.pop(context,bean.data);
      }else{
        showToast(bean.errmsg);
      }
    });
  }

  /**
   * 关闭键盘
   */
  void unfocus(BuildContext context){
    FocusScope.of(context).unfocus();
  }

  /**
   * 类别条目
   */
  Widget typeItem(Data _data,int index){
    return DropdownMenuItem(
      child: Text(_data.name),
      value: index+1,
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (){
        unfocus(context);
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Container(
            color: Colors.grey[100],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BackButtonWidget(cb: (){
                  unfocus(context);
                  Navigator.pop(context);
                }, title: "新建专栏"),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: ScreenUtil().setWidth(SizeUtil.getWidth(40)),
                      vertical: ScreenUtil().setHeight(SizeUtil.getHeight(40))
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                              hintText: "专栏名称",
                              contentPadding: EdgeInsets.all( ScreenUtil().setHeight(SizeUtil.getHeight(20))),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black12)
                              ),
                              enabledBorder:OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black12)
                              )
                          ),
                          onChanged: (value){
                            columnname = value;
                          },
                        ),
                      ),
                      Checkbox(value: isopen, onChanged: (value){
                        setState(() {
                          this.isopen = value;
                        });
                      }),
                      Text("仅本校看")
                    ],
                  ),
                ),
                //分类
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: ScreenUtil().setWidth(SizeUtil.getWidth(40)),
                      vertical: ScreenUtil().setHeight(SizeUtil.getHeight(20))
                  ),
                  child: Container(
                    width: ScreenUtil().setWidth(SizeUtil.getWidth(400)),
                    padding: EdgeInsets.only(
                        left:ScreenUtil().setWidth(SizeUtil.getWidth(20)),
                        top:ScreenUtil().setWidth(SizeUtil.getWidth(10))
                    ),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black12,width: 1),
                        borderRadius: BorderRadius.vertical(
                            top: Radius.elliptical(4,4,),
                            bottom: Radius.elliptical(4, 4)
                        )
                    ),
                    child: DropdownButton(
                      isExpanded: true,
                      hint: Text("分类"),
                      underline: Container(),
                      icon: Icon(Icons.arrow_right),
                      items: types.map((e) => DropdownMenuItem(
                        child: Text(e.name),
                        value: e,
                      )).toList(),
                      value: selectItem,
                      onChanged: (item){
                        setState(() {
                          selectItem = item;
                          print(item.name);
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(height: ScreenUtil().setHeight(SizeUtil.getHeight(40)),),
                MyRadiuButton(label: "提 交", angle: ScreenUtil().setWidth(SizeUtil.getWidth(10)), width: double.infinity, height: ScreenUtil().setHeight(SizeUtil.getHeight(100)), margin: ScreenUtil().setWidth(SizeUtil.getWidth(40)), cb: (){
                  unfocus(context);
                  //提交
                  _submit();
                })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
