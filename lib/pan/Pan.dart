import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yhschool/widgets/ImageButton.dart';
import 'package:yhschool/widgets/PanTopTabButton.dart';

import '../BaseState.dart';
import '../utils/Constant.dart';
import '../utils/SizeUtil.dart';
import '../widgets/HorizontalListTab.dart';

/**
 * 网盘
 */
class PanPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return PanState();
  }
}

class PanState extends BaseState{

  //toptab state
  final GlobalKey<PanTopTabButtonState> allTopTabState = GlobalKey<PanTopTabButtonState>();
  final GlobalKey<PanTopTabButtonState> schoolTopTabState = GlobalKey<PanTopTabButtonState>();
  final GlobalKey<PanTopTabButtonState> mineTopTabState = GlobalKey<PanTopTabButtonState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  //切换顶部导航
  void changeTab(int index){
    if(index == 0){
      allTopTabState.currentState.select(true);
      schoolTopTabState.currentState.select(false);
      mineTopTabState.currentState.select(false);
    }else if(index == 1){
      allTopTabState.currentState.select(false);
      schoolTopTabState.currentState.select(true);
      mineTopTabState.currentState.select(false);
    }else if(index == 2){
      allTopTabState.currentState.select(false);
      schoolTopTabState.currentState.select(false);
      mineTopTabState.currentState.select(true);
    }
  }

  //panitem
  Widget panItem(){
    return Container(
      child: Column(
        children: [
          CachedNetworkImage(imageUrl: ""),
          Text("title"),
          Text("author"),
          Text("P100"),
          Align(
            alignment:Alignment.centerRight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                //copy
                InkWell(
                  onTap: (){

                  },
                  child: Image.asset(""),
                ),
                //置顶
                InkWell(
                  onTap: (){

                  },
                  child: Image.asset(""),
                ),
                //关注
                InkWell(
                  onTap: (){

                  },
                  child: Image.asset(""),
                )

              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            //顶部菜单 左右两边
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //左边
                Expanded(
                  flex: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      PanTopTabButton(key:allTopTabState,name: "全部", tab: "P1000", index: 0, clickCB: changeTab),
                      PanTopTabButton(key:schoolTopTabState,name: "学校", tab: "P1000", index: 1, clickCB: changeTab),
                      PanTopTabButton(key:mineTopTabState,name: "我的", tab: "P1000", index: 2, clickCB: changeTab)
                    ],
                  ),
                ),
                //中间
                Expanded(
                  flex: 1,
                  child: SizedBox(),
                ),
                //右边
                Expanded(
                  flex: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      //关注
                      ImageButton(icon: "image/ic_add.png", label: "", cb: ()=>{

                      }),
                      //筛选
                      ImageButton(icon: "image/ic_add.png", label: "", cb: ()=>{

                      }),
                      //搜索
                      ImageButton(icon: "image/ic_add.png", label: "", cb: ()=>{

                      }),
                    ],
                  ),
                )
              ],
            ),
            //分类
            Container(
              decoration: BoxDecoration(
                  color: Colors.white
              ),
              padding: EdgeInsets.only(
                  left:ScreenUtil().setWidth(SizeUtil.getWidth(30)),
                  right: ScreenUtil().setWidth(SizeUtil.getWidth(30))
              ),
              margin: EdgeInsets.only(
                  bottom: ScreenUtil().setHeight(SizeUtil.getHeight(10))
              ),
              child: HorizontalListTab(datas: [], click: (dynamic _data){
                print("${_data.id}");
              }),
            ),
            //广告栏
            CachedNetworkImage(imageUrl: ""),
            //盘列表
            GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: 0,
                padding: EdgeInsets.only(
                    left: ScreenUtil().setWidth(SizeUtil.getWidth(20)),
                    right: ScreenUtil().setWidth(SizeUtil.getWidth(20))
                ),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisSpacing: ScreenUtil().setWidth(SizeUtil.getWidth(20)),
                    mainAxisSpacing: ScreenUtil().setWidth(SizeUtil.getWidth(20)),
                    crossAxisCount: 2,
                    childAspectRatio: Constant.isPad ? 0.79 : 0.66
                ),
                itemBuilder: (context,index){
                  //return getPanItem(columnList[index]);
                  return panItem();
                }
            )
          ],
        ),
      ),
    );
  }
}
