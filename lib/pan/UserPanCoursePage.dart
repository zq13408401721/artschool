import 'package:flutter/cupertino.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:yhschool/BaseRefreshState.dart';
import 'package:yhschool/utils/DataUtils.dart';
import 'package:yhschool/utils/SizeUtil.dart';

import '../utils/Constant.dart';
import '../utils/HttpUtils.dart';

class UserPanCoursePage extends StatefulWidget{

  String uid;
  UserPanCoursePage({Key key,@required this.uid}):super(key: key);

  @override
  State<StatefulWidget> createState() {
    return UserPanCoursePageState();
  }

}

class UserPanCoursePageState extends BaseRefreshState<UserPanCoursePage>{

  ScrollController _scrollController;
  int page = 1;
  int size = 10;

  @override
  void initState() {
    super.initState();
    _scrollController = initScrollController(isfresh: false);
    getUserCourse();
  }

  void getUserCourse(){
    var param = {
      "uid":widget.uid,
      "page":page,
      "size":size
    };
    httpUtil.post(DataUtils.api_queryusercourse,data: param).then((value){
      print("pan:$value");
      page ++;
      hideLoadMore();
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
          return Text("课程");
        },
      ),
    );
  }

  @override
  void loadmore() {
    getUserCourse();
  }

  @override
  void refresh() {

  }

}