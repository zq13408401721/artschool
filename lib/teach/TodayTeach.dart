import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yhschool/BaseRefreshState.dart';
import 'package:yhschool/BaseState.dart';
import 'package:yhschool/bean/teacher_classes_bean.dart';
import 'package:yhschool/teach/TodayTeachList.dart';
import 'package:yhschool/bean/issue_class_date_bean.dart' as M;
import 'package:yhschool/utils/BaseParam.dart';
import 'package:yhschool/utils/Constant.dart';
import 'package:yhschool/utils/DataUtils.dart';
import 'package:yhschool/utils/EnumType.dart';
import 'package:yhschool/utils/HttpUtils.dart';
import 'package:yhschool/utils/SizeUtil.dart';
import 'package:yhschool/widgets/ClassTab.dart';
import 'package:yhschool/widgets/ClickCallback.dart';
import 'package:yhschool/bean/user_search.dart' as S;

import '../BaseCoustRefreshState.dart';
import '../VideoWeb.dart';
import '../pan/PanUserDetail.dart';

/****************参数****************/
class _MoreParam extends BaseParam{
  _MoreParam(classid,date,size){
    data = {
      "classid":classid,
      "date":date,
      "size":size
    };
    param = "classid:${classid}&date:${date}&size:${size}";
  }
}



/**
 * 今日课堂
 */
class TodayTeach extends StatefulWidget{

  CallBack callBack;

  TodayTeach({Key key,@required this.callBack}):super(key: key);

  @override
  State<StatefulWidget> createState() {
    return TodayTeachState();
  }

}

class TodayTeachState extends BaseCoustRefreshState<TodayTeach>{

  static final GlobalKey<ClassTabState> classTabKey = GlobalKey<ClassTabState>();

  List<M.Data> dateList=[]; //发布作品班级相关日期数据
  int selectClassId=0;
  String selectClassName=""; //班级名称
  int page=1,size=10;

  TextStyle classSelect;
  TextStyle classNormal;
  ScrollController _scrollController;
  String olddate;

  @override
  void initState() {
    super.initState();
    classSelect = TextStyle(fontSize: ScreenUtil().setSp(30),color: Colors.white);
    classNormal = TextStyle(fontSize: ScreenUtil().setSp(30),color: Colors.black87);
    _scrollController = initScrollController();
    isrefreshing = true;
  }

  @override
  void refresh() {
    if(!this.isrefreshing){
      if(selectClassId > 0){
        getClassDate(selectClassId);
      }else{
        hideRefreshing();
      }
    }
  }

  @override
  void loadmore(){
    if(!isloading){
      setState(() {
        isloading = true;
      });
      getClassDateMore(olddate, selectClassId);
    }
  }

  /**
   * 初始化班级数据
   */
  void initClass(List<Data> _list){
    if(_list.length > 0){
      setState(() {
        classTabKey.currentState.updateClassList(_list);
        selectClassId = _list[0].id;
        selectClassName = _list[0].name;
        getClassDate(selectClassId);
      });
    }
  }

  /**
   * 强制刷新视频数据
   */
  void updateClassDate(){
    print("强制刷新班级对应的图库课程：$selectClassId");
    //selectClassId = cid;
    //selectClassName = classTabKey.currentState.updateSelectClass(cid);
    getClassDate(selectClassId);
    /*if(dateList.length > 0){
      for(var i=0; i<dateList[0].groups.length; i++){
        if(dateList[0].groups[i].tid == m_uid){
          TodayTeachList(teacherName: dateList[0].groups[i].name,tid: dateList[0].groups[i].tid,dateId: dateList[0].groups[i].dateId,date: Constant.getDateFormatByString( dateList[0].groups[i].date),classid: selectClassId,);
        }
      }
    }*/
  }

  /**
   * 获取今日课堂对应班级日期列表数据
   */
  void getClassDate(int classid){
    var option = {
      "classid":classid,
      "page":1,
      "size":size
    };
    setState(() {
      this.dateList.clear();
    });
    httpUtil.post(DataUtils.api_issueclassdate,data: option).then((value){
      if(mounted){
        print("classData:${value}");
        hideRefreshing();
        if(value != null){
          M.IssueClassDateBean classDate = M.IssueClassDateBean.fromJson(json.decode(value));
          if(classDate.errno == 0){
            if(classDate.data.length > 0){
              olddate = classDate.data[classDate.data.length-1].date;
              setState(() {
                this.dateList.addAll(classDate.data);
              });
            }
          }else{
            //showToast(classDate.errmsg);
          }
        }
      }
    });
  }

  /**
   * 获取更多班级日期数据
   */
  void getClassDateMore(String date,int classid){
    var option = {
      "classid":classid,
      "date":date,
      "size":10
    };
    httpUtil.post(DataUtils.api_issueclassdate,data:option).then((value){
      hideLoadMore();
      M.IssueClassDateBean classDate = M.IssueClassDateBean.fromJson(json.decode(value));
      if(classDate.errno == 0 && classDate.data.length > 0){
        olddate = classDate.data[classDate.data.length-1].date;
        setState(() {
          this.dateList.addAll(classDate.data);
        });
      }else{
        //showToast(classDate.errmsg);
      }
    });
  }

  /**
   * 创建日期显示数据条目
   */
  Widget createDateItem(String _date,List<M.Groups> _data,List<M.Recommend> _recommend){
    String today = Constant.getDateFormat();
    return Container(
      margin: EdgeInsets.only(
        top: ScreenUtil().setHeight(SizeUtil.getHeight(40))
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(_date,style:TextStyle(fontSize: SizeUtil.getAppFontSize(36),fontWeight: FontWeight.bold),),
              SizedBox(width: 5,),
              today == _date ? Text("Today",style:TextStyle(color:Colors.red),) : SizedBox(),
            ],
          ),
          SizedBox(height: SizeUtil.getHeight(10),),
          GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: _data.length,
              addAutomaticKeepAlives: false,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisSpacing: ScreenUtil().setHeight(SizeUtil.getHeight(20)),
                  mainAxisSpacing: ScreenUtil().setWidth(SizeUtil.getWidth(20)),
                  crossAxisCount: Constant.isPad ? 3 : 2,
                  childAspectRatio: Constant.isPad ? 0.93 : 0.9
              ),
              itemBuilder: (context,index){
                return GestureDetector(
                  onTap: (){
                    //点击事件
                    Navigator.push(context, MaterialPageRoute(builder: (context) =>
                        TodayTeachList(teacherName: _data[index].nickname != null && _data[index].nickname.length > 0 ? _data[index].nickname : _data[index].username,tid: _data[index].tid,dateId: _data[index].dateId,date: Constant.getDateFormatByString( _data[index].date),classid: selectClassId,)
                    ));
                  },
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(ScreenUtil().setWidth(SizeUtil.getWidth(10)))
                        ),
                        child: Column(
                          children: [
                            AspectRatio(aspectRatio:1.3/1,
                              child: Container(
                                  child: CachedNetworkImage(
                                    imageUrl: Constant.parseNewIssueSmallString(_data[index].url,_data[index].width,_data[index].height),
                                    width: double.infinity,
                                    memCacheWidth: _data[index].width,
                                    memCacheHeight: _data[index].height,
                                    placeholder: (_context, _url) =>
                                        Container(
                                          /*width: 130,
                                          height: 80,*/
                                          color: Constant.getColor(),
                                          child: Center(
                                              child: Stack(
                                                alignment: Alignment(0,0),
                                                children: [
                                                  Image.network(_url,fit: BoxFit.cover,),
                                                  /*Container(
                                                    width: ScreenUtil().setWidth(40),
                                                    height: ScreenUtil().setWidth(40),
                                                    child: CircularProgressIndicator(color: Colors.red,),
                                                  ),*/
                                                ],
                                              )
                                          ),
                                        ),
                                    fit: BoxFit.cover,
                                  )),
                            ),
                            Padding(padding: EdgeInsets.only(top: ScreenUtil().setHeight(SizeUtil.getHeight(20)),left: ScreenUtil().setWidth(SizeUtil.getWidth(30)),right:ScreenUtil().setWidth(SizeUtil.getWidth(40))),
                              child: InkWell(
                                onTap: (){
                                  var param = new S.Result(
                                    uid: _data[index].tid,
                                    username:_data[index].username,
                                    nickname:_data[index].nickname,
                                    avater:_data[index].avater,
                                    role:_data[index].role,
                                  );
                                  param.panid = "";
                                  //进入用户详情页
                                  Navigator.push(context, MaterialPageRoute(builder: (context){
                                    return PanUserDetail(data: param,);
                                  }));
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    ClipOval(
                                      child: (_data[index].avater == null || _data[index].avater.length == 0)
                                          ? Image.asset("image/ic_head.png",width: SizeUtil.getAppWidth(50),height: SizeUtil.getAppWidth(50),fit: BoxFit.cover,)
                                          : CachedNetworkImage(imageUrl: _data[index].avater,width: SizeUtil.getAppWidth(50),height: SizeUtil.getAppWidth(50),fit: BoxFit.cover),
                                    ),
                                    SizedBox(width: SizeUtil.getAppWidth(10),),
                                    Container(
                                      alignment: Alignment(-1,0),
                                      color: Colors.white,
                                      child: Text(
                                        //_data[index].name,
                                        _data[index].nickname != null && _data[index].nickname.length > 0 ? _data[index].nickname : _data[index].username,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(fontSize: ScreenUtil().setSp(SizeUtil.getFontSize(30))),

                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Padding(padding: EdgeInsets.only(top: ScreenUtil().setHeight(SizeUtil.getHeight(20)),left: ScreenUtil().setWidth(SizeUtil.getWidth(30)),right:ScreenUtil().setWidth(SizeUtil.getWidth(40))),
                              child: Container(
                                alignment: Alignment(-1,0),
                                child: Text(
                                  selectClassName,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: Constant.smallTitleTextStyle,
                                ),
                              ),
                            ),
                          ],
                        ),
                        //child: TileCard(url: list[index].url,title: list[index].name,width: double.infinity,height: Constant.GARRERY_ITEM_HEIGHT,imgtype: ImageType.fill,),
                      ),
                      m_uid == _data[index].tid ?
                      Positioned(
                        right:  0,
                        top:  0,
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.red
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: ScreenUtil().setWidth(SizeUtil.getWidth(15)),
                              vertical: ScreenUtil().setHeight(SizeUtil.getHeight(15))
                          ),
                          child: Text("自己",style: TextStyle(fontSize: ScreenUtil().setSp(SizeUtil.getFontSize(30)),color: Colors.white),),
                        ),
                      ) : SizedBox()
                    ],
                  ),
                );
              }),
          SizedBox(height: SizeUtil.getHeight(20),),
          /*Offstage(
            offstage: _recommend.length == 0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(ScreenUtil().setWidth(SizeUtil.getWidth(10)))
              ),
              child: Padding(
                padding: EdgeInsets.only(
                    left: ScreenUtil().setWidth(SizeUtil.getWidth(40)),
                    right:ScreenUtil().setWidth(SizeUtil.getWidth(40)),
                    bottom: ScreenUtil().setHeight(SizeUtil.getHeight(20))
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.only(
                          top: ScreenUtil().setHeight(SizeUtil.getHeight(30)),
                          bottom: ScreenUtil().setHeight(SizeUtil.getHeight(10))
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("每天看组教学课程",style: Constant.titleTextStyle,),
                          InkWell(
                              onTap: (){
                                widget.callBack(CMD_MINE.CMD_PAGE_VIDEO,false,null);
                              },
                              child:Text("更多视频",style: Constant.smallTitleTextStyle,)
                          )
                        ],
                      ),
                    ),
                    Divider(color: Colors.grey[300],),
                    GridView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: _recommend.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisSpacing: Constant.GARRERY_GRID_CROSSAXISSPACING,
                            crossAxisCount: 2,
                            childAspectRatio: Constant.isPad ? 10 : 8
                        ),
                        itemBuilder: (context,index){
                          return GestureDetector(
                            onTap: (){
                              //点击事件
                              Navigator.push(context, MaterialPageRoute(builder: (context) =>
                                  VideoWeb(classify: _recommend[index].classify, section: _recommend[index].section, category: _recommend[index].category,
                                    categoryid: _recommend[index].categoryid,description: _recommend[index].description,step: [],)
                              ));
                            },
                            child:Container(
                              alignment: Alignment(-1,0),
                              child: Text("${_recommend[index].section} ${_recommend[index].category}",style: TextStyle(fontSize: ScreenUtil().setSp(SizeUtil.getFontSize(25)))),
                            ),
                          );
                        })
                  ],
                ),
              ),
            ),
          )*/
        ],
      ),
    );
  }

  @override
  List<Widget> addChildren() {
    return [
      //班级
      Container(
        height:SizeUtil.getAppHeight(SizeUtil.getTabHeight()),
        alignment:Alignment(-1,0),
        padding: EdgeInsets.only(
            left: ScreenUtil().setWidth(SizeUtil.getWidth(20)),
            right: ScreenUtil().setWidth(SizeUtil.getWidth(20)),
            top: SizeUtil.getAppHeight(SizeUtil.getTabRadius()),
            bottom: SizeUtil.getAppHeight(SizeUtil.getTabRadius())
        ),
        decoration: BoxDecoration(
            color: Colors.white
        ),
        child: ClassTab(key:classTabKey,clickTab: (dynamic value){
          setState(() {
            selectClassId = value["id"];
            selectClassName = value["name"];
            this.dateList.clear();
            getClassDate(selectClassId);
          });
        }),
      ),
      isrefreshing ? refreshWidget() : SizedBox(),
      Expanded(
        child: ListView.builder(
          //shrinkWrap: true,
          itemCount: dateList.length,
          controller: _scrollController,
          physics:BouncingScrollPhysics(),
          //addAutomaticKeepAlives: true,
          padding: EdgeInsets.only(
              left:ScreenUtil().setWidth(SizeUtil.getWidth(20)),
              right:ScreenUtil().setWidth(SizeUtil.getWidth(20))
          ),
          itemBuilder: (context,index){
            return createDateItem(dateList[index].date,dateList[index].groups,dateList[index].recommend);
          },
        ),
      ),
      isloading ? loadmoreWidget() : SizedBox()
    ];
  }

}