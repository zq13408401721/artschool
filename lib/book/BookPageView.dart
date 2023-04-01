
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yhschool/bean/entity_gallery_list.dart';
import 'package:yhschool/widgets/BaseViewPagerState.dart';

import '../widgets/BackButtonWidget.dart';

class BookPageView extends StatefulWidget{



  BookPageView({Key key}):super(key:key);

  @override
  State<StatefulWidget> createState() {
    return BookPageViewState();
  }

}

class BookPageViewState extends BaseViewPagerState<GalleryListData,BookPageView> {

  double _width = 0;

  @override
  void initState() {
    super.initState();

  }

  @override
  void pageChange() {
    // TODO: implement pageChange
  }

  @override
  Widget initChildren(BuildContext context, data) {
  }


}