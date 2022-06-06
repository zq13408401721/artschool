
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yhschool/BasePhotoState.dart';
import 'package:yhschool/BaseState.dart';
import 'package:yhschool/utils/Constant.dart';

/**
 * 具备编辑功能的State
 */
abstract class BaseEditorState<T extends StatefulWidget> extends BasePhotoState<T>{
  bool iseditor = true;
  int selectNum = 0;
  String selectAll = "全选";
  // 是否隐藏选择框
  bool ischoose = true;

  //显示编辑状态
  void showEditor(){
    setState(() {
      this.iseditor = false;
    });
  }

  //隐藏编辑状态
  void hideEditor(){
    setState(() {
      this.iseditor = true;
    });

  }

  /**
   * 编辑导航
   * cancelCB取消的时候调用  selectCB全选的时候调用 deleteCB删除的时候调用
   */
  Widget EditorBar(cancelCB,selectCB){
    return Container(
      height:ScreenUtil().setHeight(Constant.SIZE_TOP_HEIGHT),
      padding: EdgeInsets.only(top: ScreenUtil().setHeight(15),bottom: ScreenUtil().setHeight(15)),
      decoration: BoxDecoration(
        color: Colors.white
      ),
      child: Offstage(
        offstage: this.iseditor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            InkWell(
              child: Text(
                "取消",
                style: TextStyle(fontSize: ScreenUtil().setSp(60)),
              ),
              onTap: (){
                cancelCB();
              },
            ),
            Text(
              "已选中$selectNum个文件",
              style: TextStyle(fontSize: ScreenUtil().setSp(60)),
            ),
            InkWell(
              child: Text("$selectAll",style: TextStyle(fontSize: ScreenUtil().setSp(60)),),
              onTap: (){
                setState(() {
                  if(this.selectAll == "全选"){
                    this.selectAll = "全不选";
                    selectCB(true);
                  }else{
                    this.selectAll = "全选";
                    this.selectNum = 0;
                    selectCB(false);
                  }
                });
              },
            )
          ],
        ),
      ),
    );
  }

  /**
   * 选择弹框
   */
  Widget PopChoose(BuildContext context,Function callback){
    return Offstage(
      offstage: ischoose,
      child: Container(
          height: 50,
          width: 110,
          child: Card(
            color: Colors.white,
            shadowColor: Colors.black,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  child: Text("选择文件"),
                  onTap: (){
                    setState(() {
                      this.ischoose = true;
                    });
                    callback();
                  },
                )
              ],
            ),
          )
      ),
    );
  }


  /**
   * 底部导航操作栏
   */
  Widget BottomBar(BuildContext context,deleteCB){
    return Offstage(
      offstage: this.iseditor,
      child: Container(
        height: ScreenUtil().setHeight(120),
        decoration: BoxDecoration(
          color: Colors.blue
        ),
        child: InkWell(
          child: Column(
            children: [
              Image.asset("image/ic_delete.png",width: ScreenUtil().setWidth(60),height: ScreenUtil().setHeight(70),fit: BoxFit.contain,),
              Expanded(
                child: Text(
                  "删除",
                  style: TextStyle(fontSize: ScreenUtil().setSp(36),color: Colors.white),
                ),
              ),
            ],
          ),
          onTap: (){
            deleteCB(context);
          },
        )
      ),
    );
  }

}