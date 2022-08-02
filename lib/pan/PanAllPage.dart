import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:yhschool/BaseRefreshState.dart';

import '../utils/Constant.dart';
import '../utils/SizeUtil.dart';

class PanAllPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    throw UnimplementedError();
  }

}

class PanAllPageState extends BaseRefreshState<PanAllPage>{

  ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    print("ColumnListPage initState");
    isShowAdvert = true;
    super.advertData = {
      "url":"http://res.yimios.com:9050/videos/advert/advert_column_list.jpg",
      "weburl":"https://support.qq.com/products/326279/faqs/121942",
      "height":Constant.ADVERT_COLUMN_HEIGHT
    };
    _scrollController = initScrollController();
  }

  @override
  Widget addChildren() {
    return StaggeredGridView.countBuilder(
      crossAxisCount: Constant.isPad ? 3 : 2,
      itemCount: 0,
      //primary: false,
      physics: BouncingScrollPhysics(),
      mainAxisSpacing: ScreenUtil().setWidth(SizeUtil.getWidth(Constant.DIS_LIST)),
      crossAxisSpacing: ScreenUtil().setHeight(SizeUtil.getHeight(Constant.DIS_LIST)),
      controller: _scrollController,
      //addAutomaticKeepAlives: false,
      padding: EdgeInsets.only(left: ScreenUtil().setWidth(SizeUtil.getWidth(Constant.DIS_LIST)),right: ScreenUtil().setWidth(SizeUtil.getWidth(Constant.DIS_LIST))),
      staggeredTileBuilder: (int index) => StaggeredTile.fit(1),
      //StaggeredTile.count(3,index==0?2:3),
      itemBuilder: (context,index){
        return GestureDetector(
        );
      },
    );
  }

  @override
  void loadmore() {

  }

  @override
  void refresh() {
    // TODO: implement refresh
  }

}