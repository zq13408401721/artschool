
import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:yhschool/BaseCacheListRefresh.dart';
import 'package:yhschool/BaseState.dart';
import 'package:yhschool/utils/Constant.dart';
import 'package:yhschool/utils/DataUtils.dart';
import 'package:yhschool/utils/HttpUtils.dart';
import 'package:yhschool/utils/ImageType.dart';
import 'package:yhschool/utils/SizeUtil.dart';

import 'GalleryClassifyList.dart';
import 'GalleryListPage.dart';
import 'TileCard.dart';
import 'bean/entity_gallery_classify.dart';
import 'bean/entity_gallery_list.dart';
import 'bean/entity_gallery_tab.dart';
import 'gallery/GalleryPageView.dart';
import 'gallery/GalleryTile.dart';

class SchoolGallery extends StatefulWidget{

  SchoolGallery({Key key}):super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new SchoolState();
  }

}

class CategoryCache{
  int _page=1;
  set page(int value){
    _page = value;
  }
  get page => _page;
  List<GalleryListData> _list;
  set list(List<GalleryListData> value){
    _list = value;
  }
  get list => _list;

  CategoryCache({int page,List<GalleryListData> list}){
    _page = page;
    _list = list;
  }

}

class SchoolState extends BaseCacheListRefresh<SchoolGallery>{


  int type = 2; //1 官方图库
  GalleryTab officialGalleryTab; //官方图库的tab标题
  String classify_name=""; //当前选中的分类名字
  int tabId=0; //tab对应的index编号
  int classify_type = 0; //当前的分类id
  GalleryClassify galleryClassify; //当前的图库分类数据
  List<GalleryClassifyData> list=[];
  List<GalleryClassifyDataCategory> allCategory = [];
  List<GalleryListData> categoryList = []; //列表数据
  int curCategoryId = 0; //当前分类id
  var galleryMap;
  var categoryMap; //分类列表数据缓存
  ScrollController _scrollController;

  int page=1,size=20;
  bool isloading=false,hasData=true;

  TextStyle categorySelect;
  TextStyle categoryNormal;

  TextStyle categorySelect2;
  TextStyle categoryNormal2;

  @override
  void initState() {
    super.initState();
    categorySelect = TextStyle(fontSize: ScreenUtil().setSp(30),color: Colors.white);
    categoryNormal = TextStyle(fontSize: ScreenUtil().setSp(30),color: Colors.black87);
    categorySelect2 = TextStyle(fontSize: ScreenUtil().setSp(25),color: Colors.red,fontWeight: FontWeight.bold);
    categoryNormal2 = TextStyle(fontSize: ScreenUtil().setSp(25),color: Colors.black87);

    galleryMap = Map();
    categoryMap = Map();
    _scrollController = initScrollController(isfresh:false);
    /*_scrollController = ScrollController();
    _scrollController.addListener(() {
      if(_scrollController.position.pixels > _scrollController.position.maxScrollExtent-100){
        if(this.hasData && !this.isloading){
          //加载列表数据
          showLoading(true);
          //延迟2秒才开始加载
          Timer(Duration(seconds: 2), (){
            loadCategoryMore();
          });
        }else if(!this.hasData){
          showToast("没有更多数据了");
        }
      }
    });*/
    //学校没有数据 暂时注释
    loadTabs(type);
  }

  @override
  void refresh(){

  }

  @override
  void loadmore() {
    Future.delayed(Duration(milliseconds: 500),(){
      loadCategoryMore();
    });
  }

  @override
  void dispose(){
    super.dispose();
  }


  showLoading(bool visible){
    setState(() {
      this.isloading = visible;
    });
  }

  updataState(){
    loadTabs(type);
  }

  @override
  bool get wantKeepAlive => true;

  /**
   * 从服务器上加载tab数据
   */
  loadTabs(int _type){
    var option = {"type":_type};
    httpUtil.post(DataUtils.api_gallery,data: option).then((value){
      String result = checkLoginExpire(value);
      if(result.isNotEmpty){
        createTab(new GalleryTab.fromJson(json.decode(value)));
      }
    }).catchError((err)=>{
      print(err)
    });
  }

  //创建tabitem
  createTab(GalleryTab data){
    if(!mounted) return;
    if(data.errno != 0){
      return showToast(data.errmsg);
    }
    setState(() {
      tabId = data.data[0].id;
      officialGalleryTab = data;
    });
    //初始化获取第一个分类的数据
    if(data.data.length > 0){
      classify_type = data.data[0].id;
      classify_name = data.data[0].name;
      getClassify(classify_type);
    }
  }

  //创建列表条目
  Widget createListItem(GalleryClassifyData data){

    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            child: Container(
                height: ScreenUtil().setHeight(80),
                margin: EdgeInsets.only(top: ScreenUtil().setHeight(30)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(this.classify_name+" | "+data.categoryname,style: TextStyle(fontSize: Constant.FONT_TITLE_SIZE,color: Constant.COLOR_TITLE),),
                    Text("更多 >",style: TextStyle(fontSize: Constant.FONT_GRID_DESC_SIZE,color: Constant.COLOR_GRID_DESC),)
                  ],
                )
            ),
            onTap: (){
              //进入更多分类
              Navigator.push(context, MaterialPageRoute(builder: (context) =>
                  GalleryClassifyList(pid: data.categoryid, section: this.classify_name, category: data.categoryname)
              ));
            },
          ),
          GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: data.categorys.length,
              padding: EdgeInsets.only(top: ScreenUtil().setHeight(20)),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisSpacing: Constant.GARRERY_GRID_CROSSAXISSPACING,
                  mainAxisSpacing: ScreenUtil().setWidth(Constant.PADDING_GALLERY_CROSS),
                  crossAxisCount: 3,
                  childAspectRatio: Constant.isPad ? 1.22 : 1.15
              ),
              itemBuilder: (context,index){
                return GestureDetector(
                  onTap: (){
                    //点击事件
                    Navigator.push(context, MaterialPageRoute(builder: (context) =>
                        GalleryListPage(categoryid: data.categorys[index].id,section: this.classify_name,categroyname: data.categoryname,imageType: ImageType.smallSchool,)
                    ));
                  },
                  child: Container(
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(ScreenUtil().radius(20.0))),
                      ),
                      child: TileCard(url: data.categorys[index].cover,title: data.categorys[index].name,width: double.infinity,height: Constant.GARRERY_ITEM_HEIGHT),
                    ),
                  ),
                );
              }),
          Padding(
            padding: EdgeInsets.only(top: ScreenUtil().setHeight(20)),
            child: Divider(
              color: Colors.grey[300],
              thickness: ScreenUtil().setHeight(4),
            ),
          )
        ],
      ),
    );
  }

  /**
   * 请求图库分类列表数据
   */
  getClassify(id){
    setState(() {
      list.clear();
      this.hasData = true;
      this.allCategory.clear();
      categoryList.clear();
      this.curCategoryId = 0;
    });
    var key = "schoolgrallery$id";
    if(galleryMap[key] != null){
      setState(() {
        list.addAll(galleryMap[key]);
        this.allCategory.add(GalleryClassifyDataCategory(id: 0,name:"全部"));
        //把所有的数据集中
        list.forEach((element) {
          this.allCategory.addAll(element.categorys);
        });
        //初始化全部分类数据
        getCategoryList(0);
      });
      return;
    }
    var option = {"categoryid":id};
    httpUtil.post(DataUtils.api_gallery_category,data: option).then((value) => {
      this.setState(() {
        galleryClassify = new GalleryClassify.fromJson(json.decode(value));
        if(galleryClassify.errno == 0){
          galleryMap[key] = galleryClassify.data;
          setState(() {
            list.addAll(galleryClassify.data);
            this.allCategory.add(GalleryClassifyDataCategory(id: 0,name:"全部"));
            //把所有的数据集中
            list.forEach((element) {
              this.allCategory.addAll(element.categorys);
            });
            //初始化全部分类数据
            getCategoryList(0);
          });
        }else{
          showToast(galleryClassify.errmsg);
        }
      })
    }).catchError((err){

    });
  }

  /**
   * 根据分类id获取分类数据
   */
  getCategoryList(int cid){
    this.categoryList.clear();
    var key = "schoolcategory$tabId$cid";
    print("list key:$key");
    var category = categoryMap[key];
    if(category != null){
      this.page = category.page;
      setState(() {
        this.categoryList.addAll(category.list);
      });
    }else{
      this.page = 1;
      var option = {
        "categoryid":cid,
        "page":page,
        "size":this.size,
        "ids":""
      };
      if(cid == 0){
        List<int> ids = [];
        this.allCategory.forEach((element) {
          ids.add(element.id);
        });
        option["ids"] = ids.join(",");
      }
      httpUtil.post(DataUtils.api_gallery_list,data: option).then((value){
        GalleryList gallery = new GalleryList.fromJson(json.decode(value));
        if(gallery.errno == 0){
          page++;
          categoryMap[key] = CategoryCache(page: page,list:gallery.data);
          setState(() {
            this.categoryList.addAll(gallery.data);
          });
        }else{
          //showToast(gallery.errmsg);
        }
      }).catchError((err){
        print(err);
      });
    }
  }

  /**
   * 分页加载图片列表
   */
  loadCategoryMore(){
    var key = "schoolcategory$tabId$curCategoryId";
    var option = {
      "categoryid":curCategoryId,
      "page":page,
      "size":this.size,
      "ids":[]
    };
    if(curCategoryId == 0){
      List<int> ids = [];
      this.allCategory.forEach((element) {
        ids.add(element.id);
      });
      option["ids"] = ids.join(",");
    }
    httpUtil.post(DataUtils.api_gallery_list,data: option).then((value){
      setState(() {
        this.isloading = false;
      });
      GalleryList gallery = new GalleryList.fromJson(json.decode(value));
      if(gallery.errno == 0){
        if(gallery.data != null && gallery.data.length > 0){
          page++;
          if(gallery.data.length < size){
            hasData = false;
          }else{
            hasData = true;
          }
        }else{
          hasData = false;
          showToast("没有更多数据了");
        }
        CategoryCache cache = categoryMap[key];
        if(cache == null){
          cache = CategoryCache(page: page,list:gallery.data);
        }else{
          cache.page = page;
          cache.list.addAll(gallery.data);
        }
        setState(() {
          this.categoryList.addAll(gallery.data);
        });
      }else{
        setState(() {
          this.isloading = false;
        });
        showToast(gallery.errmsg);
      }
    }).catchError((err){
      setState(() {
        this.isloading = false;
      });
      print(err);
    });
  }

  /**
   * 创建tab
   */
  Widget createTabItems(GalleryTabData _data){
    return InkWell(
      onTap: (){
        if(tabId != _data.id){
          setState(() {
            this.tabId = _data.id;
            this.classify_type = _data.id;
            this.classify_name = _data.name;
            //请求对应的分类列表数据
            getClassify(_data.id);
          });
        }

      },
      child: Container(
        decoration: BoxDecoration(
            color: tabId == _data.id ? Colors.red : Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(ScreenUtil().setWidth(20),),
              topRight: Radius.circular(ScreenUtil().setWidth(10),),
              bottomLeft: Radius.circular(ScreenUtil().setWidth(10),),
              bottomRight: Radius.circular(ScreenUtil().setWidth(20),),
            ),
            border: Border.all(width: 1.0,color: tabId == _data.id ? Colors.red : Colors.black12,)
        ),
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(
            horizontal: ScreenUtil().setWidth(40),
            vertical: ScreenUtil().setHeight(10)
        ),
        margin: EdgeInsets.symmetric(
            horizontal: ScreenUtil().setWidth(10)
        ),
        child: Text(_data.name,style: TextStyle(color: tabId == _data.id ? Colors.white : Colors.black87,fontSize: ScreenUtil().setSp(SizeUtil.getFontSize(30))),),
      ),
    );
  }

  /**
   * 分类导航item
   */
  Widget getCategoryItem(GalleryClassifyDataCategory _data){
    return InkWell(
      onTap: (){
        if(curCategoryId != _data.id){
          setState(() {
            this.curCategoryId = _data.id;
            this.hasData = true;
            getCategoryList(_data.id);
          });
        }
      },
      child: Container(
        /*decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(ScreenUtil().setWidth(10)),
            color: curCategoryId == _data.id ? Colors.red : Colors.white
        ),*/
        margin: EdgeInsets.symmetric(
            horizontal: ScreenUtil().setWidth(SizeUtil.getWidth(10))
        ),
        padding: EdgeInsets.symmetric(
            horizontal: ScreenUtil().setWidth(SizeUtil.getWidth(20)),
            vertical: ScreenUtil().setHeight(SizeUtil.getHeight(10))
        ),
        child: Text(
          _data.name,style: curCategoryId == _data.id ? categorySelect2 : categoryNormal2,
        ),
      ),
    );
  }

  Widget _loadingWidget() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              width: ScreenUtil().setWidth(40),
              height: ScreenUtil().setWidth(40),
              child: CircularProgressIndicator(color: Colors.red,),
            ),
            Text('加载中...', style: TextStyle(fontSize: 16.0),)
          ],
        ),
      ),
    );
  }

  // 显示加载中的圈圈
  Widget showMore() {
    if(isloading) {
      return this.hasData ? this._loadingWidget() : Text('---暂无其他数据了---');
    } else {
      return SizedBox();
    }
  }

  @override
  List<Widget> addChildren() {
    return [
      // 学校的图片分类
      Container(
        color:Colors.white,
        child: Row(
          children: [
            Expanded(
              child: Container(
                height:ScreenUtil().setHeight(SizeUtil.getHeight(105)),
                decoration: BoxDecoration(
                    color: Colors.white
                ),
                padding: EdgeInsets.only(
                  left: ScreenUtil().setWidth(SizeUtil.getWidth(20)),
                  right: ScreenUtil().setWidth(SizeUtil.getWidth(20)),
                  bottom: ScreenUtil().setHeight(SizeUtil.getHeight(20)),
                ),
                child: ListView.builder(itemCount:(officialGalleryTab == null || officialGalleryTab.data == null) ? 0 : officialGalleryTab.data.length,scrollDirection:Axis.horizontal,itemBuilder: (_context,_index){
                  return createTabItems(officialGalleryTab.data[_index]);
                }),
              ),
            ),
            /*InkWell(
              onTap: (){
                //标签编辑
              },
              child: Image.asset("image/ic_tab_more.png",width: ScreenUtil().setWidth(70),),
            )*/
          ],
        ),
      ),
      // 分类列表
      Container(
        width: double.infinity,
        decoration: BoxDecoration(
            color:Colors.white
        ),
        child: Container(
          height: ScreenUtil().setHeight(SizeUtil.getHeight(70)),
          margin: EdgeInsets.only(
              bottom: ScreenUtil().setHeight(SizeUtil.getHeight(20)),
              left: ScreenUtil().setWidth(SizeUtil.getWidth(20)),
              right: ScreenUtil().setWidth(SizeUtil.getWidth(20))
          ),
          child: ListView.builder(
            itemCount: this.allCategory.length,
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemBuilder: (context,index){
              return getCategoryItem(this.allCategory[index]);
            },
          ),
        ),
      ),
      SizedBox(height: ScreenUtil().setHeight(SizeUtil.getHeight(20)),),
      //瀑布流显示分组中的第一张图片
      Expanded(
        child: Padding(
          padding: EdgeInsets.only(
            left: ScreenUtil().setWidth(SizeUtil.getWidth(20)),
            right: ScreenUtil().setWidth(SizeUtil.getWidth(20)),
          ),
          child: StaggeredGridView.countBuilder(
            crossAxisCount: Constant.isPad ? 3 : 2,
            itemCount: categoryList.length,
            controller: _scrollController,
            primary: false,
            mainAxisSpacing: ScreenUtil().setWidth(Constant.DIS_LIST),
            crossAxisSpacing: ScreenUtil().setWidth(Constant.DIS_LIST),
            addAutomaticKeepAlives: false,
            padding: EdgeInsets.only(left: ScreenUtil().setWidth(Constant.DIS_LIST),right: ScreenUtil().setWidth(Constant.DIS_LIST)),
            staggeredTileBuilder: (int index) =>
                StaggeredTile.fit(1),
            //StaggeredTile.count(3,index==0?2:3),

            itemBuilder: (context,index){
              return GestureDetector(
                child: GalleryTile(data: categoryList[index]),
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>
                      GalleryPageView(list: categoryList,position: index,from: Constant.COLLECT_GALLERY,)
                  ));
                },
              );
            },
          ),
        ),
      ),
      this.isloading ? loadmoreWidget() : SizedBox()
    ];
  }

}