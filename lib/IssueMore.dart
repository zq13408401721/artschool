import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yhschool/BaseState.dart';
import 'package:yhschool/bean/issue_more_bean.dart';
import 'package:yhschool/utils/Constant.dart';
import 'package:yhschool/utils/DataUtils.dart';
import 'package:yhschool/utils/HttpUtils.dart';

import 'IssueListPage.dart';

/**
 * 当前日期下的更多老师作品
 */
class IssueMore extends StatefulWidget{

  int dateId; //日期id
  String curDate; //当前日期

  IssueMore({Key key,@required this.dateId,@required this.curDate}):super(key: key);

  @override
  State<StatefulWidget> createState() {
    return IssueMoreState()
        ..date_id = dateId
        ..date = curDate;
  }
}

class IssueMoreState extends BaseState<IssueMore>{

  int page = 1;
  int size = 30;
  int date_id;
  String date; //当前的日期

  List<Data> issueMoreList=[];

  @override
  void initState() {
    super.initState();
    getIssueMore();
  }

  getIssueMore(){
    var option = {
      "page":page,
      "size":size,
      "date_id":date_id
    };

    httpUtil.post(DataUtils.api_issuegallerymore,data: option).then((value){
      String result = checkLoginExpire(value);
      if(result.isNotEmpty){
        IssueMoreBean issueMore = new IssueMoreBean.fromJson(json.decode(value));
        if(issueMore.errno == 0){
          setState(() {
            issueMoreList.addAll(issueMore.data);
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(left: ScreenUtil().setWidth(20),top: ScreenUtil().setHeight(20),bottom: ScreenUtil().setHeight(20)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  GestureDetector(
                    child: Icon(
                      Icons.arrow_back,
                      size: 24,
                    ),
                    onTap: (){
                      Navigator.pop(context);
                    },
                  ),
                  Container(
                    padding: EdgeInsets.only(left: ScreenUtil().setWidth(20)),
                    child: Text(
                      "$date作品",
                      style: TextStyle(fontSize: 18),
                    ),
                  )
                ],
              ),
            ),
            GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: issueMoreList.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisSpacing: Constant.GARRERY_GRID_CROSSAXISSPACING,
                  mainAxisSpacing: ScreenUtil().setWidth(Constant.PADDING_GALLERY_CROSS),
                  crossAxisCount: 3,
                  childAspectRatio: Constant.isPad ? 1.26 : 1.2
              ),
              itemBuilder: (context,index){
                return GestureDetector(
                  onTap: (){
                    //点击事件
                    Navigator.push(context, MaterialPageRoute(builder: (context) =>
                        IssueListPage(date_id: issueMoreList[index].dateId,tid: issueMoreList[index].tid, title: issueMoreList[index].name,)
                    ));
                  },
                  child: Container(
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(ScreenUtil().radius(20.0))),
                      ),
                      child: Column(
                        children: [
                          Container(
                              padding: EdgeInsets.only(top: ScreenUtil().setHeight(20)),
                              height: Constant.isPad ? ScreenUtil().setHeight(300) : ScreenUtil().setHeight(180),
                              width: ScreenUtil().setWidth(400),
                              child: CachedNetworkImage(
                                imageUrl: issueMoreList[index].url,
                                //height: ScreenUtil().setHeight(height),
                                placeholder: (_context, _url) =>
                                    Container(
                                      width: ScreenUtil().setWidth(40),
                                      height: ScreenUtil().setWidth(40),
                                      child: CircularProgressIndicator(color: Colors.red,),
                                    ),
                                fit: BoxFit.cover,
                              )),
                          Container(
                            padding: EdgeInsets.only(left:ScreenUtil().setWidth(20),top: ScreenUtil().setHeight(20),bottom: ScreenUtil().setHeight(10)),
                            alignment: Alignment(-1,0),
                            color: Colors.white,
                            child: Text(
                              issueMoreList[index].name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: Constant.isPad ? ScreenUtil().setSp(32) : ScreenUtil().setSp(48)),

                            ),
                          )
                        ],
                      ),
                      //child: TileCard(url: list[index].url,title: list[index].name,width: double.infinity,height: Constant.GARRERY_ITEM_HEIGHT,imgtype: ImageType.fill,),
                    ),
                  ),
                );
              }),
          ],
        )
      ),
    );
  }

}
