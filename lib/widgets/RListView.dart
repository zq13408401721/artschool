import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yhschool/BaseRefreshState.dart';
import 'package:yhschool/utils/DataUtils.dart';
import 'package:yhschool/utils/HttpUtils.dart';

class RListView extends StatefulWidget{

  int tabid;
  RListView({Key key,@required this.tabid}):super(key: key);

  @override
  State<StatefulWidget> createState() {
    print("Rlistview create");
    return RListViewState();
  }
}

class RListViewState extends BaseRefreshState<RListView>{
  ScrollController _scrollController;
  int page = 1;
  int size = 20;
  @override
  void initState() {
    super.initState();
    _scrollController = initScrollController(isfresh: false);
    print("RlistView");
    getVideoGroup(widget.tabid);
  }

  @override
  Widget addChildren() {
    return Container(
      height: 500,
      color: Colors.greenAccent,
      child: Text("add child"),
    );
  }

  @override
  void loadmore() {

  }

  @override
  void refresh() {
    // TODO: implement refresh
  }

  void getVideoGroup(tabid){
    print("getVideoGroup");
    var param = {
      "tabid":tabid,
      "page":page,
      "size":size
    };
    httpUtil.post(DataUtils.api_school_video_group,data:param,context: context).then((value){
      print("school video group $value");
    });
  }

}