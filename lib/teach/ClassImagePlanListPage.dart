import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yhschool/BaseState.dart';
import 'package:yhschool/utils/Constant.dart';
import 'package:yhschool/utils/SizeUtil.dart';
import 'package:yhschool/widgets/BackButtonWidget.dart';

import 'TodayTeachGallery.dart';

class ClassImagePlanListPage extends StatefulWidget{

  String teacherName;
  String tid;
  int dateId;
  String date;
  int classid;

  ClassImagePlanListPage({Key key,@required this.teacherName,@required this.tid,@required this.dateId,@required this.date,@required this.classid}):super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ClassImagePlanListPageState();
  }
}

class ClassImagePlanListPageState extends BaseState<ClassImagePlanListPage>{

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          height: double.infinity,
          decoration: BoxDecoration(
            color:Colors.grey[100]
          ),
          child: Column(
            children: [
              Container(
                height: ScreenUtil().setHeight(SizeUtil.getHeight(Constant.SIZE_TOP_HEIGHT)),
                decoration: BoxDecoration(
                    color: Colors.white
                ),
                child:InkWell(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: BackButtonWidget(cb: (){
                    Navigator.pop(context);
                  },title: widget.teacherName,),
                ),
              ),
              Expanded(
                  child:TodayTeachGallery(tid: widget.tid,dateId: widget.dateId,isplan: true,)
              )
            ],
          ),
        ),
      ),
    );
  }

}