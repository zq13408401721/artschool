import 'package:flutter/cupertino.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:yhschool/BaseRefreshState.dart';
import 'package:yhschool/utils/DataUtils.dart';
import 'package:yhschool/utils/SizeUtil.dart';

import '../utils/Constant.dart';
import '../utils/HttpUtils.dart';

class UserPanFollowPage extends StatefulWidget{

  String uid;
  UserPanFollowPage({Key key,@required this.uid}):super(key: key);

  @override
  State<StatefulWidget> createState() {
    return UserPanFollowPageState();
  }

}

class UserPanFollowPageState extends BaseRefreshState<UserPanFollowPage>{

  ScrollController _scrollController;
  int page = 1;
  int size = 10;

  @override
  void initState() {
    super.initState();
    _scrollController = initScrollController(isfresh: false);
    getUserFollow();
  }

  void getUserFollow(){
    var param = {
      "uid":widget.uid,
      "page":page,
      "size":size
    };
    httpUtil.post(DataUtils.api_queryuserfollow,data: param).then((value){
      print("pan:$value");
      page ++;
      setState(() {

      });

    });
  }

  @override
  Widget addChildren() {
    return Container(
      child:StaggeredGridView.countBuilder(
        crossAxisCount: Constant.isPad ? 3 : 2,
        itemCount: 1,
        primary: false,
        crossAxisSpacing: SizeUtil.getAppWidth(Constant.DIS_LIST),
        controller: _scrollController,
        addAutomaticKeepAlives: false,
        padding: EdgeInsets.only(left: SizeUtil.getAppWidth(Constant.DIS_LIST),right: SizeUtil.getAppWidth(Constant.DIS_LIST)),
        staggeredTileBuilder: (int index) => StaggeredTile.fit(1),
        //StaggeredTile.count(3,index==0?2:3),

        itemBuilder: (context,index){
          return Text("关注");
        },
      ),
    );
  }

  @override
  void loadmore() {
    getUserFollow();
  }

  @override
  void refresh() {

  }

}