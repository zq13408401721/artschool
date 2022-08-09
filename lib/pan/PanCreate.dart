import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yhschool/BaseState.dart';
import 'package:yhschool/utils/Constant.dart';
import 'package:yhschool/widgets/PanTitle.dart';

import '../utils/SizeUtil.dart';

class PanCreate extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    return new PanCreateState();
  }

}

class PanCreateState extends BaseState{

  String panName;
  int visible = 1;
  List types;
  List classifys;
  List categorys;

  @override
  void initState() {
    super.initState();
    types = [];
    classifys = [];
    categorys = [];
  }

  void selectVisible(int value){
    this.visible = value;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            //标题
            PanTitle(cb: (){
              Navigator.pop(context);
            }),
            Row(
              children: [
                TextField(
                  decoration: InputDecoration(
                      hintText: "网盘名称",
                      contentPadding: EdgeInsets.all( ScreenUtil().setHeight(SizeUtil.getHeight(20))),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black12)
                      ),
                      enabledBorder:OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black12)
                      )
                  ),
                  onChanged: (value){
                    panName = value;
                  },
                ),
                Text("*",style: TextStyle(color: Colors.red),)
              ],
            ),
            Row(
              children: [
                Row(
                  children: [
                    Radio(value: 1, groupValue: visible, activeColor: Colors.red, onChanged: selectVisible),
                    Text("本校可见",style: TextStyle(fontSize: ScreenUtil().setSp(SizeUtil.getFontSize(20))),)
                  ],
                ),
                Row(
                  children: [
                    Radio(value: 2, groupValue: visible, activeColor: Colors.red, onChanged: selectVisible),
                    Text("自己可见",style: TextStyle(fontSize: ScreenUtil().setSp(SizeUtil.getFontSize(20))),)
                  ],
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Column(
                    children: [
                      Row(
                        children: [
                          Center(
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
                                //value: selectItem,
                                onChanged: (item){
                                  setState(() {
                                    //selectItem = item;
                                    print(item.name);
                                  });
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Text("*",style: TextStyle(color: Colors.red),)
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(ScreenUtil().setWidth(SizeUtil.getWidth(10))),
              child: Column(
                children: [
                  Text("类型标签",style: Constant.smallTitleTextStyle,),
                  Container(
                    height: SizeUtil.getHeight(100),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: GridView.builder(shrinkWrap:true,itemCount:classifys.length,gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        mainAxisSpacing: ScreenUtil().setWidth(SizeUtil.getWidth(10)),
                        crossAxisSpacing: ScreenUtil().setHeight(SizeUtil.getHeight(10)),
                        crossAxisCount: 3,
                        childAspectRatio: Constant.isPad ? 10/1 : 8/1,

                      ), itemBuilder: (context,index){
                        return Row(
                          children: [
                            Checkbox(value: classifys[index].select, onChanged:(_bool){
                              setState(() {
                                classifys[index].select = _bool;
                              });
                              if(_bool){
                                this.setData("class"+classifys[index].id.toString(), true);
                              }else{
                                this.removeData("class"+classifys[index].id.toString());
                              }
                            }),
                            Text(classifys[index].name,style: TextStyle(color: classifys[index].select?Colors.red:Colors.black87),)
                          ],
                        );
                      }),
                    ),
                  ),
                  Text("类别标签",style: Constant.smallTitleTextStyle,),
                  Container(
                    height: SizeUtil.getHeight(100),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: GridView.builder(shrinkWrap:true,itemCount:categorys.length,gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        mainAxisSpacing: ScreenUtil().setWidth(SizeUtil.getWidth(10)),
                        crossAxisSpacing: ScreenUtil().setHeight(SizeUtil.getHeight(10)),
                        crossAxisCount: 3,
                        childAspectRatio: Constant.isPad ? 10/1 : 8/1,

                      ), itemBuilder: (context,index){
                        return Row(
                          children: [
                            Checkbox(value: categorys[index].select, onChanged:(_bool){
                              setState(() {
                                categorys[index].select = _bool;
                              });
                              if(_bool){
                                this.setData("class"+categorys[index].id.toString(), true);
                              }else{
                                this.removeData("class"+categorys[index].id.toString());
                              }
                            }),
                            Text(categorys[index].name,style: TextStyle(color: categorys[index].select?Colors.red:Colors.black87),)
                          ],
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: (){

              },
              child: Container(
                width: double.infinity,
                alignment: Alignment(0,0),
                padding: EdgeInsets.symmetric(
                  vertical: ScreenUtil().setHeight(SizeUtil.getHeight(20))
                ),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.all(Radius.circular(ScreenUtil().setWidth(10)))
                ),
                child: Text("提交",style: TextStyle(fontSize: ScreenUtil().setSp(SizeUtil.getFontSize(30)),color: Colors.white),),
              ),
            )
          ],
        ),
      ),
    );
  }
}