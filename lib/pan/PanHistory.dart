import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yhschool/BaseState.dart';
import 'package:yhschool/bean/pan_search_type.dart';
import 'package:yhschool/pan/SearchPanPage.dart';
import 'package:yhschool/pan/SearchUserPage.dart';
import 'package:yhschool/utils/Constant.dart';
import 'package:yhschool/widgets/BaseTitle.dart';
import 'package:yhschool/widgets/WrapWord.dart';

import '../utils/SizeUtil.dart';
import 'SearchHistoryPage.dart';

class PanHistory extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return PanHistoryState();
  }

}

class PanHistoryState extends BaseState{

  String searchWord; //搜索内容

  List<PanSearchType> searchTypes; //搜索类型
  PanSearchType searchType;
  int page = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    searchTypes = [];
    searchTypes.add(PanSearchType(typeid:0,typename: "搜索项"));
    searchTypes.add(PanSearchType(typeid:1,typename: "搜索网盘"));
    searchTypes.add(PanSearchType(typeid:2,typename: "搜索用户"));
    searchType = searchTypes[0];
  }

  /**
   * 搜索方法
   */
  void searchInput(String word) {
    searchWord = word;
  }

  void search() {

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BaseTitle(title: "全部网盘"),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    keyboardType: TextInputType.text,
                    maxLines: 1,
                    maxLength: 30,
                    maxLengthEnforcement: MaxLengthEnforcement.enforced,
                    controller: TextEditingController(text: searchWord),
                    decoration: InputDecoration(
                      hintText: "输入搜索内容",
                      hintStyle: TextStyle(fontSize: ScreenUtil().setSp(SizeUtil.getFontSize(36)),color: Colors.black26),
                      counterText: "",
                      fillColor:Colors.white,
                      filled: true,
                      isCollapsed: true,
                      contentPadding: EdgeInsets.only(
                        left: ScreenUtil().setWidth(SizeUtil.getWidth(50)),
                        top: ScreenUtil().setHeight(SizeUtil.getHeight(30)),
                        bottom: ScreenUtil().setHeight(SizeUtil.getHeight(30)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        //边角
                        borderRadius: BorderRadius.all(
                          Radius.circular(SizeUtil.getWidth(50)), //边角为30
                        ),
                        borderSide: BorderSide(
                          color: Colors.white, //边线颜色为黄色
                          width: 1, //边线宽度为2
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        //边角
                        borderRadius: BorderRadius.all(
                          Radius.circular(SizeUtil.getWidth(50)), //边角为30
                        ),
                        borderSide: BorderSide(
                          color: Colors.white, //边线颜色为黄色
                          width: 1, //边线宽度为2
                        ),
                      ),
                    ),
                    onChanged: searchInput,
                  ),
                ),
                DropdownButton(
                  isExpanded: true,
                  hint: Text("分类"),
                  underline: Container(),
                  icon: Icon(Icons.arrow_right),
                  items: searchTypes.map((e) => DropdownMenuItem(
                    child: Text(e.typename,style: Constant.smallTitleTextStyle,),
                    value: e,
                  )).toList(),
                  value: searchType,
                  onChanged: (item){
                    this.page = item.typeid;
                    setState(() {
                      searchType = item;
                    });
                  },
                ),
                InkWell(
                  onTap: (){
                    search();
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: ScreenUtil().setWidth(SizeUtil.getWidth(10)),
                      vertical: ScreenUtil().setHeight(SizeUtil.getHeight(10))
                    ),
                    child: Image.asset("image/ic_search.png"),
                  ),
                ),

              ],
            ),
            Expanded(
              child: IndexedStack(
                index: page,
                children: [
                  //搜索历史记录
                  SearchHistoryPage(callback: (){

                  }),
                  //搜索网盘列表
                  SearchPanPage(callback: (){

                  }),
                  //搜索用户
                  SearchUserPage(callback: (){

                  })
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}