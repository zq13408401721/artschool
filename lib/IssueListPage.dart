import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:yhschool/BaseState.dart';
import 'package:yhschool/Tile.dart';
import 'package:yhschool/bean/issue_gallery_bean.dart';
import 'package:yhschool/utils/Constant.dart';
import 'package:yhschool/utils/DataUtils.dart';
import 'package:yhschool/utils/HttpUtils.dart';
import 'package:yhschool/utils/ImageType.dart';
import 'package:yhschool/widgets/XCState.dart';

import 'GalleryBig.dart';
import 'TileCard.dart';

class IssueListPage extends StatefulWidget{

  int date_id;
  String tid;
  String title;

  IssueListPage({Key key,@required this.date_id,@required this.tid,@required this.title});

  @override
  State<StatefulWidget> createState() {
    return new IssueListState()
    ..date_id=date_id
    ..tid=tid
    ..title = title == null ? "" : title;
  }

}

class IssueListState extends XCState<Gallery,IssueListPage>{

  int date_id,page=1,size = 20;
  String title="",tid;
  ScrollController _scrollController;
  List<Gallery> list = [];

  bool _hasData = true;//是否还有数据
  bool flag = true;  //是否可以加载
  bool isloading = false; //是否正在加载中

  @override
  void initState() {
    super.initState();

    _scrollController = new ScrollController();
    getIssueList();

    _scrollController.addListener(() {
      //print("scroll: "+_scrollController.position.pixels.toString() + " max "+_scrollController.position.maxScrollExtent.toString());
      if(_scrollController.position.pixels > _scrollController.position.maxScrollExtent-100){
        //print("flag:$flag hasData: $_hasData");
        if(this.flag && this._hasData && !this.isloading){
          //加载列表数据
          showLoading(true);
          //延迟2秒才开始加载
          Timer(Duration(seconds: 2), (){
            getIssueList();
          });
        }
      }
    });
  }

  @override
  void dispose() {
    this._scrollController.dispose();
    super.dispose();
  }

  @override
  bool useSubstance(){
    return true;
  }

  @override
  List<Gallery> substance() {
    return list;
  }

  void aFunc(){
    reload();
  }

  showLoading(bool visible){
    this.isloading = visible;
    aFunc();
  }

  getIssueListReturn(IssueGalleryBean data){
    showLoading(false);
    if(data.errno != 0){
      return showToast(data.errmsg);
    }
    if(data.data.gallery.length > 0){
      if(data.data.gallery.length < this.size){
        this._hasData = false;
      }else{
        this.page ++;
        this._hasData = true;
      }
      this.list.addAll(data.data.gallery);
      aFunc();
    }
    this.flag = true;
  }

  getIssueList(){
    setState(() {
      this.flag = false; //设置加载状态
    });
    var option = {
      "date_id":this.date_id,
      "teacherid":this.tid,
      "page":this.page,
      "size":this.size
    };
    print("分页加载数据：$option");
    httpUtil.post(DataUtils.api_issuegallery,data: option).then((value){
      String result = checkLoginExpire(value);
      if(result.isNotEmpty){
        getIssueListReturn(new IssueGalleryBean.fromJson(json.decode(value)));
      }
    }).catchError((err){
      print(err);
    });
  }

  Widget _loadingWidget() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            CircularProgressIndicator(strokeWidth: 1.0),
            Text('加载中...', style: TextStyle(fontSize: 16.0),)
          ],
        ),
      ),
    );
  }

  // 显示加载中的圈圈
  Widget _showMore() {
    if(isloading) {
      return this._hasData ? this._loadingWidget() : Text('---暂无其他数据了---');
    } else {
      return SizedBox();
    }
  }

  @override
  Widget shouldBuild(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Container(
                height: ScreenUtil().setHeight(80),
                padding: EdgeInsets.only(left: ScreenUtil().setWidth(20)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(this.title,style: TextStyle(fontSize: Constant.FONT_TITLE_SIZE,color: Constant.COLOR_TITLE),),
                  ],
                ),
              ),
              SizedBox(height: ScreenUtil().setHeight(30),),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    //#ececec
                    color: Color.fromRGBO(236, 236, 236, 1.0)
                  ),
                  child: StaggeredGridView.countBuilder(
                    crossAxisCount: Constant.isPad ? 3 : 2,
                    itemCount: list.length,
                    primary: false,
                    mainAxisSpacing: ScreenUtil().setWidth(Constant.DIS_LIST),
                    crossAxisSpacing: ScreenUtil().setWidth(Constant.DIS_LIST),
                    controller: _scrollController,
                    addAutomaticKeepAlives: false,
                    padding: EdgeInsets.only(left: ScreenUtil().setWidth(Constant.DIS_LIST),right: ScreenUtil().setWidth(Constant.DIS_LIST)),
                    staggeredTileBuilder: (int index) =>
                        StaggeredTile.fit(1),
                    //StaggeredTile.count(3,index==0?2:3),

                    itemBuilder: (context,index){
                      return GestureDetector(
                        //child: TileCard(key:GlobalObjectKey(list[index].id),url: list[index].url,title: list[index].name,imgtype: ImageType.issue,width: list[index].width,height: list[index].height,),
                        child: Tile(smallurl: Constant.parseNewIssueSmallString(list[index].url,list[index].width,list[index].height),
                            title: Constant.getFileNameByUrl(list[index].url,list[index].filename),
                            author: list[index].name, width: list[index].width.toDouble(), height: list[index].height.toDouble()),
                        onTap: (){
                          /* Navigator.push(context, MaterialPageRoute(builder: (context) =>
                          GalleryBig(imgUrl: list[index].url,)
                      ));*/

                          Navigator.pushAndRemoveUntil(context, new MaterialPageRoute(builder: (BuildContext context){
                            return GalleryBig(imgUrl: list[index].url,imageType: BigImageType.issue,width:list[index].width,height: list[index].height,);
                          }), (route) => true);

                          //Navigator.of(context).pushNamedAndRemoveUntil("/GalleryBig",(Route route)=>false,arguments: {"imgUrl":list[index].url});
                        },
                      );
                    },
                  ),
                ),
              ),
              _showMore()
            ],
          ),
        )
    );
  }

}