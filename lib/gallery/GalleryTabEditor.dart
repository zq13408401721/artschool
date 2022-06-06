import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yhschool/BaseState.dart';
import 'package:yhschool/bean/GalleryTabDB.dart';
import 'package:yhschool/bean/entity_gallery_tab.dart';
import 'package:yhschool/utils/Constant.dart';
import 'package:yhschool/utils/DBUtils.dart';
import 'package:yhschool/utils/SizeUtil.dart';
import 'package:yhschool/video/VideoMorePage.dart';
import 'package:yhschool/widgets/BackButtonWidget.dart';

class GalleryTabEditor extends StatefulWidget{

  List<GalleryTabData> tabList;

  GalleryTabEditor({Key key,@required this.tabList});

  @override
  State<StatefulWidget> createState() {
    return GalleryTabEditorState()
    ..tabList = tabList;
  }

}

class GalleryTabEditorState extends BaseState{

  List<GalleryTabData> tabList; //所有的Tab数据
  List<GalleryTabData> myTabList=[];
  List<GalleryTabDB> localList=[];
  String uid;
  bool isEditor = false;

  @override
  void initState() {
    super.initState();
    getUid().then((value){
      uid = value;
      DBUtils.dbUtils.then((value){
        value.queryGalleryTabs(uid).then((value){
          localList = value;
          setState(() {
            tabList.forEach((element) {
              if(!this.isRemove(element.id)){
                myTabList.add(element);
              }
            });
          });
        });
      });
    });
  }

  /**
   * 检查是否在删除列表中
   */
  bool isRemove(int id){
    return localList.any((element) => element.tabid == id);
  }

  /**
   * 删除tab数据
   */
  void removeTab(GalleryTabData _data){
    setState(() {
      myTabList.remove(_data);
      //添加到本地删除列表中
      GalleryTabDB tabDB = GalleryTabDB(uid:m_uid,tabid: _data.id,name: _data.name,sort: _data.sort);
      localList.add(tabDB);
      localList.sort((a,b) => a.sort > b.sort ? 0 : 1);
      DBUtils.dbUtils.then((value){
        value.insertGalleryTab(tabDB);
      });
    });
  }

  /**
   * 添加tab数据
   */
  void addTab(GalleryTabDB _data){
    setState(() {
      localList.remove(_data);
      myTabList.add(GalleryTabData(id: _data.tabid,name: _data.name,sort: _data.sort));
      myTabList.sort((a,b)=> a.sort > b.sort ? 0 : 1);
      DBUtils.dbUtils.then((value){
        value.delGallery(uid,_data.tabid);
      });
    });
  }

  /**
   * 获取本地分类项
   */
  Widget getLocalItem(GalleryTabData _data){
    return InkWell(
      onTap: (){
        //点击对应的item
        print("click${_data.name}");
        if(this.isEditor){
          if(myTabList.length <= 1){
            showToast("至少需要保留一个分类");
          }else{
            removeTab(_data);
          }
        }
      },
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(ScreenUtil().setWidth(SizeUtil.getWidth(20)),),
                  topRight: Radius.circular(ScreenUtil().setWidth(SizeUtil.getWidth(10)),),
                  bottomLeft: Radius.circular(ScreenUtil().setWidth(SizeUtil.getWidth(10)),),
                  bottomRight: Radius.circular(ScreenUtil().setWidth(SizeUtil.getWidth(20)),),
                ),
                border: Border.all(width: 1.0,color:Colors.black12,)
            ),
            padding: EdgeInsets.symmetric(
                horizontal: ScreenUtil().setWidth(SizeUtil.getWidth(40)),
                vertical: ScreenUtil().setHeight(SizeUtil.getHeight(30))
            ),
            child: Text("${_data.name}",style: TextStyle(color: Colors.black87,fontSize: ScreenUtil().setSp(SizeUtil.getFontSize(30))),),
          ),
          Offstage(
            offstage: !this.isEditor,
            child: Padding(
              padding: EdgeInsets.only(
                  right: ScreenUtil().setWidth(SizeUtil.getWidth(20)), top: ScreenUtil().setHeight(SizeUtil.getHeight(10))
              ),
              child: Text("X",style: TextStyle(fontSize: ScreenUtil().setSp(SizeUtil.getFontSize(30)),color: Colors.red,),),
            ),
          )
        ],
      ),
    );
  }

  /**
   * 创建所有类别的item项
   */
  Widget getAllItem(GalleryTabDB _data){
    return InkWell(
      onTap: (){
        //点击对应的item
        print("click${_data.name}");
        if(this.isEditor){
          addTab(_data);
        }
      },
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(ScreenUtil().setWidth(SizeUtil.getWidth(20)),),
                  topRight: Radius.circular(ScreenUtil().setWidth(SizeUtil.getWidth(10)),),
                  bottomLeft: Radius.circular(ScreenUtil().setWidth(SizeUtil.getWidth(10)),),
                  bottomRight: Radius.circular(ScreenUtil().setWidth(SizeUtil.getWidth(20)),),
                ),
                border: Border.all(width: 1.0,color:Colors.black12,)
            ),
            padding: EdgeInsets.symmetric(
                horizontal: ScreenUtil().setWidth(SizeUtil.getWidth(40)),
                vertical: ScreenUtil().setHeight(SizeUtil.getHeight(30))
            ),
            child: Text(_data.name,style: TextStyle(color: Colors.black87,fontSize: ScreenUtil().setSp(SizeUtil.getFontSize(30))),),
          ),
          Offstage(
            offstage: !this.isEditor,
            child: Padding(
              padding: EdgeInsets.only(
                top: ScreenUtil().setHeight(SizeUtil.getHeight(10)), right: ScreenUtil().setWidth(SizeUtil.getWidth(20))
              ),
              child: Text("+",style: TextStyle(fontSize: ScreenUtil().setSp(SizeUtil.getFontSize(30)),color: Colors.red),),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            color:Colors.grey[100]
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                    color:Colors.white
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    BackButtonWidget(cb: (){
                      Navigator.pop(context,myTabList);
                    }, title: "我的分类"),
                    InkWell(
                      onTap: (){
                        setState(() {
                          this.isEditor = !this.isEditor;
                          myTabList = myTabList;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.only(
                            right: ScreenUtil().setWidth(SizeUtil.getWidth(20))
                        ),
                        child: Text(this.isEditor ? "完成" : "编辑",style: TextStyle(fontSize: ScreenUtil().setSp(SizeUtil.getFontSize(30)),color:Colors.red),),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          left:ScreenUtil().setWidth(SizeUtil.getWidth(40)),
                          right:ScreenUtil().setWidth(SizeUtil.getWidth(40)),
                          top: ScreenUtil().setWidth(SizeUtil.getHeight(40)),
                        ),
                        child: Wrap(
                          runSpacing: ScreenUtil().setHeight(SizeUtil.getHeight(40)),
                          spacing: ScreenUtil().setHeight(SizeUtil.getHeight(40)),
                          //children: myTabList.map((e) => getLocalItem(e)).toList(),
                          children: <Widget>[
                            for(GalleryTabData item in myTabList) getLocalItem(item)
                          ],
                        ),
                      ),
                      Divider(height: ScreenUtil().setHeight(2),color: Colors.white,),
                      Container(
                        margin: EdgeInsets.only(
                            left: ScreenUtil().setWidth(SizeUtil.getWidth(40)),
                            top:ScreenUtil().setHeight(SizeUtil.getHeight(80))
                        ),
                        child: Text("全部分类",style: Constant.titleTextStyle,),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: ScreenUtil().setWidth(SizeUtil.getWidth(40)),
                            vertical: ScreenUtil().setHeight(SizeUtil.getHeight(40))
                        ),
                        child: Wrap(
                          runSpacing: ScreenUtil().setHeight(SizeUtil.getHeight(40)),
                          spacing: ScreenUtil().setHeight(SizeUtil.getHeight(40)),
                          children: localList.map((e) => getAllItem(e)).toList(),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}