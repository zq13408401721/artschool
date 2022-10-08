import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yhschool/BaseState.dart';

import '../widgets/WrapWord.dart';

class SearchHistoryPage extends StatefulWidget{

  Function callback;
  SearchHistoryPage({@required this.callback,Key key}):super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SearchHistoryPageState();
  }

}

class SearchHistoryPageState extends BaseState<SearchHistoryPage> {

  List<String> historyList; //历史记录
  List<String> hotsList; //热门搜索

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    historyList = [];
    hotsList = [];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        WrapWord(words: this.historyList, callback: (String item) {
          if (widget.callback != null) {
            widget.callback(item);
          }
        }),
        Container(
          width: double.infinity,
          height: 1,
          color: Colors.grey[100],
        ),
        //热门搜索
        Text("热门搜索",style: TextStyle(fontSize: ScreenUtil().setSp(25),color: Colors.red),),
        WrapWord(words: this.hotsList, callback: (String item){
          if (widget.callback != null) {
            widget.callback(item);
          }
        })
      ],
    );
  }
}
