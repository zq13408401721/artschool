
import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:yhschool/BaseCacheListRefresh.dart';
import 'package:yhschool/BaseCoustPageRefreshState.dart';
import 'package:yhschool/BaseCoustRefreshState.dart';
import 'package:yhschool/BaseState.dart';
import 'package:yhschool/bean/GalleryTabDB.dart';
import 'package:yhschool/bean/official_cover.dart';
import 'package:yhschool/gallery/GalleryCover.dart';
import 'package:yhschool/gallery/GalleryPageView.dart';
import 'package:yhschool/gallery/GalleryTabEditor.dart';
import 'package:yhschool/gallery/GalleryTile.dart';
import 'package:yhschool/utils/BaseParam.dart';
import 'package:yhschool/utils/Constant.dart';
import 'package:yhschool/utils/DBUtils.dart';
import 'package:yhschool/utils/DataUtils.dart';
import 'package:yhschool/utils/HttpUtils.dart';
import 'package:yhschool/utils/ImageType.dart';
import 'package:yhschool/utils/SizeUtil.dart';
import 'package:yhschool/widgets/XCState.dart';

import 'GalleryClassifyList.dart';
import 'GalleryListPage.dart';
import 'TileCard.dart';
import 'bean/entity_gallery_classify.dart';
import 'bean/entity_gallery_list.dart';
import 'bean/entity_gallery_tab.dart';

/***************请求参数*************/

//官方图库一级分类
class _TabGalleryOfficalParam extends BaseParam{
  _TabGalleryOfficalParam(int type){
    data = {
      "type":type
    };
    param = "type:${type}";
  }
}

//图库二级分类
class _GalleryCategoryParam extends BaseParam{
  _GalleryCategoryParam(int categoryid){
    data = {
      "categoryid":categoryid
    };
    param = "categoryid:${categoryid}";
  }
}

//图库列表
class _GalleryListParam  extends BaseParam{
  _GalleryListParam(cid,page,size,ids){
    data = {
      "categoryid":cid,
      "page":page,
      "size":size,
      "ids":ids
    };
    param = "categoryid:${cid}&page:${page}&size:${size}&ids:${ids}";
  }
}




/**
 * 官方图库
 */
class OfficialGallery extends StatefulWidget{

  OfficialGallery({Key key}):super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new OfficialState();
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

class OfficialState extends BaseCacheListRefresh<OfficialGallery>{

  int type = 1; //1 官方图库
  GalleryTab officialGalleryTab; //官方图库的tab标题
  String classify_name=""; //当前选中的分类名字
  int tabId=0; //tab对应的index编号
  int classify_type = 0; //当前的分类id
  GalleryClassify galleryClassify; //当前的图库分类数据
  List<GalleryTabData> myTabList=[];
  List<GalleryTabDB> localList = [];
  List<GalleryClassifyData> list=[];
  List<GalleryClassifyDataCategory> allCategory = [];
  List<GalleryListData> categoryList = []; //列表数据
  int curCategoryId = 0; //当前分类id
  var galleryMap;
  var categoryMap; //分类列表数据缓存
  ScrollController _scrollController;
  List<Data> officialCoverList = [];
  List<Data> coverGridList = [];


  int page=1,size=30;
  //封面分页页码
  int pageCover=1;

  TextStyle categorySelect;
  TextStyle categoryNormal;

  TextStyle categorySelect2;
  TextStyle categoryNormal2;

  @override
  void initState() {
    super.initState();
    print("OfficialGallery initState");
    categorySelect = TextStyle(fontSize: ScreenUtil().setSp(30),color: Colors.white);
    categoryNormal = TextStyle(fontSize: ScreenUtil().setSp(30),color: Colors.black87);
    categorySelect2 = TextStyle(fontSize: ScreenUtil().setSp(25),color: Colors.red,fontWeight: FontWeight.bold);
    categoryNormal2 = TextStyle(fontSize: ScreenUtil().setSp(25),color: Colors.black87);
    galleryMap = Map();
    categoryMap = Map();
    _scrollController = initScrollController(isfresh:false);
    loadTabs(type);
  }

  @override
  void refresh(){

  }

  @override
  void loadmore(){
    Future.delayed(Duration(milliseconds: 500),(){
      loadCategoryMore();
    });
  }

  updataState(){
    loadTabs(type);
    loadBookTabs(0);
  }

  /**
   * 获取书籍标签
   */
  loadBookTabs(int pid){
    httpUtil.post(DataUtils.api_booktab,data: {"pid":pid}).then((value){
      print("bookTabs $value");
    });
  }

  /**
   * 从服务器上加载tab数据
   */
  loadTabs(int _type){
    myTabList.clear();
    httpUtil.post(DataUtils.api_gallery,option:_TabGalleryOfficalParam(_type)).then((value){
      print("gallery:$value");
      String result = checkLoginExpire(value);
      if(result.isNotEmpty){
         (new GalleryTab.fromJson(json.decode(result)));
      }
    }).catchError((err)=>{
      print("gallery err:$err")
    });
  }

  //创建tabitem
  createTab(GalleryTab data){
    if(data.errno != 0){
      return showToast(data.errmsg);
    }
    if(data.data != null && data.data.length > 0){
      setState(() {
        tabId = data.data[0].id;
        officialGalleryTab = data;
        DBUtils.dbUtils.then((value){
          value.queryGalleryTabs(m_uid).then((value){
            localList = value;
            officialGalleryTab.data.forEach((element) {
              if(!this.isRemove(element.id)){
                myTabList.add(element);
              }
            });
            if(myTabList.length > 0){
              classify_type = myTabList[0].id;
              classify_name = myTabList[0].name;
              getClassify(classify_type);
              //getGalleryCover(classify_type);
            }else{
              //初始化获取第一个分类的数据
              if(data.data.length > 0){
                classify_type = data.data[0].id;
                classify_name = data.data[0].name;
                getClassify(classify_type);
                //getGalleryCover(classify_type);
              }
            }
          }).catchError((err){
            //初始化获取第一个分类的数据
            if(data.data.length > 0){
              classify_type = data.data[0].id;
              classify_name = data.data[0].name;
              getClassify(classify_type);

              //getGalleryCover(classify_type);
            }
          });
        }).catchError((err){
          //初始化获取第一个分类的数据
          if(data.data.length > 0){
            classify_type = data.data[0].id;
            classify_name = data.data[0].name;
            getClassify(classify_type);

            //getGalleryCover(classify_type);
          }
        });
      });
    }
  }

  /**
   * 检查是否在删除列表中
   */
  bool isRemove(int id){
    return localList.any((element) => element.tabid == id);
  }

  /**
   * 获取封面列表
   */
  getGalleryCoverList(int id){
    var option = {
      "pid":id,
      "page":this.page,
      "size":this.size
    };
    if(this.page == 1){
      this.coverGridList.clear();
    }
    httpUtil.post(DataUtils.api_gallery_more,data: option).then((value){
      print("gallerycover $value");
      if(value != null){
        OfficialCover officialCover = OfficialCover.fromJson(json.decode(value));
        if(officialCover.errno == 0) {
          this.coverGridList.addAll(officialCover.data);
        }
      }
      setState(() {
      });
    }).catchError((err)=>{
      print(err)
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

            //getGalleryCover(_data.id);

          });
        }

      },
      child: Container(
        decoration: BoxDecoration(
            color: tabId == _data.id ? Colors.red : Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(ScreenUtil().setWidth(SizeUtil.getWidth(20)),),
              topRight: Radius.circular(ScreenUtil().setWidth(SizeUtil.getWidth(10)),),
              bottomLeft: Radius.circular(ScreenUtil().setWidth(SizeUtil.getWidth(10)),),
              bottomRight: Radius.circular(ScreenUtil().setWidth(SizeUtil.getWidth(20)),),
            ),
            border: Border.all(width: 1.0,color: tabId == _data.id ? Colors.red : Colors.grey[200],)
        ),
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(
            horizontal: ScreenUtil().setWidth(40),
            vertical: ScreenUtil().setHeight(10)
        ),
        margin: EdgeInsets.symmetric(
            horizontal: ScreenUtil().setWidth(SizeUtil.getWidth(10))
        ),
        child: Text(_data.name,style: TextStyle(color: tabId == _data.id ? Colors.white : Colors.black87,fontSize: ScreenUtil().setSp(SizeUtil.getFontSize(30))),),
      ),
    );
  }

  //创建列表条目
  Widget createListItem(GalleryClassifyData data){

    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            child: Container(
                height: ScreenUtil().setHeight(SizeUtil.getHeight(80)),
                margin: EdgeInsets.only(top: ScreenUtil().setHeight(SizeUtil.getHeight(30))),
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
              padding: EdgeInsets.only(top: ScreenUtil().setHeight(SizeUtil.getHeight(20))),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisSpacing: Constant.GARRERY_GRID_CROSSAXISSPACING,
                  mainAxisSpacing: ScreenUtil().setWidth(Constant.PADDING_GALLERY_CROSS),
                  crossAxisCount: Constant.isPad ? 3 : 2,
                  childAspectRatio: Constant.isPad ? 1.22 : 1.15
              ),
              itemBuilder: (context,index){
                return GestureDetector(
                  onTap: (){
                    //点击事件
                    Navigator.push(context, MaterialPageRoute(builder: (context) =>
                        GalleryListPage(categoryid: data.categorys[index].id,section: this.classify_name,categroyname: data.categoryname,imageType: ImageType.smallOffical,)
                    ));
                  },
                  child: Container(
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(ScreenUtil().radius(SizeUtil.getWidth(20)))),
                      ),
                      child: TileCard(url: data.categorys[index].cover,title: data.categorys[index].name,width: double.infinity,height: Constant.GARRERY_ITEM_HEIGHT),
                    ),
                  ),
                );
              }),
          Padding(
            padding: EdgeInsets.only(top: ScreenUtil().setHeight(SizeUtil.getHeight(20))),
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
    var key = "grallery$id";
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
    httpUtil.post(DataUtils.api_gallery_category,option: _GalleryCategoryParam(id)).then((value){
      print("OfficalGallery value:$value");
      String result = checkLoginExpire(value);
      if(result.isNotEmpty){
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
            //初始化全部分类数据  现在修改成书籍的形式
            getCategoryList(0);
          });
        }else{
          showToast(galleryClassify.errmsg);
        }
      }
    }).catchError((err){

    });
  }

  /**
   * 根据分类id获取分类数据
   */
  getCategoryList(int cid){
    this.categoryList.clear();
    var key = "category$tabId$cid";
    var category = categoryMap[key];
    if(category != null && category.list != null && category.list.length > 0){
      this.page = category.page;
      setState(() {
        this.categoryList.addAll(category.list);
      });
    }else{
      this.page = 1;
      String _ids = "";

      if(cid == 0){
        List<int> ids = [];
        this.allCategory.forEach((element) {
          ids.add(element.id);
        });
        _ids = ids.join(",");
      }
      _GalleryListParam param = _GalleryListParam(cid, page, size, _ids);
      httpUtil.post(DataUtils.api_gallery_list,option: param,context: context).then((value){
        String result = checkLoginExpire(value);
        if(result.isNotEmpty){
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
        }
      }).catchError((err){
        print(err);
      });
    }
  }

  //图库封面
  getGalleryCover(int id){
    var param = {
      "page":pageCover,
      "size":size,
      "id":id
    };
    officialCoverList.clear();
    httpUtil.post(DataUtils.api_gallery_cover,data: param,context: context).then((value){
      print("cover:${value}");
      if(value != null){
        OfficialCover officialCover = OfficialCover.fromJson(json.decode(value));
        if(officialCover.errno == 0){
          this.officialCoverList.add(new Data(id: 0,name: "全部"));
          officialCoverList.addAll(officialCover.data);
          pageCover++;
        }
      }
      setState(() {
      });
    }).catchError((err){
      print(err);
    });
  }

  /**
   * 分页加载图片列表
   */
  loadCategoryMore(){
    var key = "category$tabId$curCategoryId";
    String _ids = "";
    if(curCategoryId == 0){
      List<int> ids = [];
      this.allCategory.forEach((element) {
        ids.add(element.id);
      });
      _ids = ids.join(",");
    }
    _GalleryListParam param = _GalleryListParam(curCategoryId, page, size, _ids);
    httpUtil.post(DataUtils.api_gallery_list,option: param).then((value){
      hideLoadMore();
      String result = checkLoginExpire(value);
      if(result.isNotEmpty){
        GalleryList gallery = new GalleryList.fromJson(json.decode(value));
        if(gallery.errno == 0){
          page++;
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
          //showToast(gallery.errmsg);
        }
      }
    }).catchError((err){
      hideLoadMore();
      print(err);
    });
  }

  /**
   * 刷新Tab
   */
  void updateTab(){
    myTabList = [];
    DBUtils.dbUtils.then((value){
      value.queryGalleryTabs(m_uid).then((value){
        localList = value;
        setState(() {
          officialGalleryTab.data.forEach((element) {
            if(!this.isRemove(element.id)){
              myTabList.add(element);
            }
          });
          categoryList.clear();
          tabId = myTabList[0].id;
          //初始化获取第一个分类的数据
          if(myTabList.length > 0){
            classify_type = myTabList[0].id;
            classify_name = myTabList[0].name;
            getClassify(classify_type);

            //getGalleryCover(classify_type);
          }
        });
      });
    });
  }

  /**
   * 是否有更新
   */
  bool isUpdate(List<GalleryTabData> _list){
    bool _bool;
    myTabList.forEach((element) {
      _bool = _list.any((e) => e.id == element.id);
      if(!_bool) return true;
    });
    return false;
  }

  /**
   * 分类导航item
   */
  Widget getCategoryItem(GalleryClassifyDataCategory _data){
    return InkWell(
      onTap: (){
        if(curCategoryId != _data.id){
          setState(() {
            page = 1;
            this.curCategoryId = _data.id;
            this.hasData = true;
            //获取列表的封面
            getCategoryList(_data.id);
            //getGalleryCoverList(this.curCategoryId);
          });
        }
      },
      child: Container(
        /*decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(ScreenUtil().setWidth(SizeUtil.getWidth(10))),
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

  @override
  List<Widget> addChildren() {
    return [
      Container(
        color:Colors.white,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                height: ScreenUtil().setHeight(SizeUtil.getHeight(105)),
                decoration: BoxDecoration(
                    color: Colors.white
                ),
                padding: EdgeInsets.only(
                  left: ScreenUtil().setWidth(SizeUtil.getWidth(20)),
                  right: ScreenUtil().setWidth(SizeUtil.getWidth(20)),
                  bottom: ScreenUtil().setHeight(SizeUtil.getHeight(20)),
                  //top: ScreenUtil().setHeight(SizeUtil.getHeight(25))
                ),
                child: ListView.builder(itemCount:myTabList.length,scrollDirection:Axis.horizontal,itemBuilder: (_context,_index){
                  return createTabItems(myTabList[_index]);
                }),
              ),
            ),
            InkWell(
              onTap: (){
                //标签编辑
                Navigator.push(context, MaterialPageRoute(builder: (context)=>GalleryTabEditor(tabList: officialGalleryTab.data))).then((value) {
                  //标签返回
                  if(value != null || myTabList.length != value.length || isUpdate(value)){
                    updateTab();
                  }
                });
              },
              child: Padding(
                padding: EdgeInsets.only(
                    top: ScreenUtil().setHeight(SizeUtil.getHeight(20))
                ),
                child: Container(
                  height: ScreenUtil().setHeight(SizeUtil.getHeight(50)),
                  alignment: Alignment(0,-1),
                  decoration: BoxDecoration(
                      color: Colors.white
                  ),
                  child: Image.asset("image/ic_tab_more.png",width: ScreenUtil().setWidth(SizeUtil.getWidth(60),),),
                ),
              ),
            )
          ],
        ),
      ),
      //分类列表
      Container(
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.white
        ),
        child: Container(
          height: ScreenUtil().setHeight(SizeUtil.getHeight(70)),
          margin: EdgeInsets.only(
              //top: ScreenUtil().setHeight(SizeUtil.getHeight(20)),
              bottom: ScreenUtil().setHeight(SizeUtil.getHeight(20)),
              left: ScreenUtil().setWidth(SizeUtil.getWidth(20)),
              right: ScreenUtil().setWidth(SizeUtil.getWidth(20))
          ),
          child: ListView.builder(
            itemCount: this.allCategory.length,//this.officialCoverList.length,
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
            child:  StaggeredGridView.countBuilder(
              crossAxisCount: Constant.isPad ? 3 : 2,
              itemCount: categoryList.length,
              controller: _scrollController,
              primary: false,
              mainAxisSpacing: ScreenUtil().setWidth(SizeUtil.getWidth(6)),
              crossAxisSpacing: ScreenUtil().setWidth(SizeUtil.getWidth(6)),
              addAutomaticKeepAlives: false,
              staggeredTileBuilder: (int index) =>
                  StaggeredTile.fit(1),
              itemBuilder: (context,index){
                return GestureDetector(
                  child:GalleryTile(data: categoryList[index]), //GalleryCover(category: coverGridList[index],),
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>
                        GalleryPageView(list: categoryList,position: index,from: Constant.COLLECT_GALLERY,)
                    ));
                  },
                );
              },
            ),
          )
      ),
      this.isloading ? loadmoreWidget() : SizedBox()
    ];
  }
}