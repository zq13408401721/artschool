import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:yhschool/utils/Constant.dart';

import '../BaseState.dart';


/**
 * 实现下拉刷新和上拉加载
 */
class YStaggeredGridView<T> extends StatefulWidget {

  List<T> list;
  ItemTile<T> tile;
  //异步刷新的方法变量
  Future<void> Function() onRefresh;
  //加载更多数据 返回是否还有更多的数据
  Future<bool> Function() onLoadMore;
  Function click;

  YStaggeredGridView({
    Key key,
    @required this.list,
    @required this.tile,
    @required this.onRefresh,
    @required this.onLoadMore,
    @required this.click
  }):assert(list != null),
    assert(tile != null),
    assert(onRefresh != null),
    assert(onLoadMore != null),
    assert(click != null),
    super(key: key);


  @override
  State<StatefulWidget> createState() {
    return YStaggeredGridViewState();
  }

}


class YStaggeredGridViewState extends BaseState<YStaggeredGridView>{

  ScrollController _scrollController;

  /**
   * 是否正在加载
   */
  bool isloading = false;

  /**
   * 是否正在刷新
   */
  bool refreshing = false;

  /**
   * 是否还有数据
   */
  bool hasData = true;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      //在距离底部100的位置实现加载更多
      if(_scrollController.position.pixels >=_scrollController.position.maxScrollExtent-100){
        if(!this.isloading && hasData){
          setState(() {
            this.isloading = true;
            widget.onLoadMore().then((value){
              this.hasData = value;
              setState(() {
                this.isloading = false;
              });
            });
          });
        }else if(!hasData){
          showToast("没有更多数据");
        }
      }
    });
  }

  /**
   * 刷新加载数据
   */
  Future<void> _onRefresh() async{
    if(this.refreshing){
      showToast("数据正在加载中");
    }else{
      this.refreshing = true;
      await widget.onRefresh().then((value){
        //加载数据完成
        this.refreshing = false;
        return;
      });
    }

  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: RefreshIndicator(
              onRefresh: _onRefresh,
              displacement: 60,
              child: StaggeredGridView.countBuilder(
                crossAxisCount: Constant.isPad ? 3 : 2,
                itemCount: widget.list.length,
                primary: false,
                mainAxisSpacing: ScreenUtil().setWidth(Constant.DIS_LIST),
                crossAxisSpacing: ScreenUtil().setWidth(Constant.DIS_LIST),
                controller: _scrollController,
                addAutomaticKeepAlives: false,
                padding: EdgeInsets.only(left: ScreenUtil().setWidth(Constant.DIS_LIST),right: ScreenUtil().setWidth(Constant.DIS_LIST)),
                staggeredTileBuilder: (int index) => StaggeredTile.fit(1),
                //StaggeredTile.count(3,index==0?2:3),
                itemBuilder: (context,index){
                  return InkWell(
                    child: widget.tile.builder(widget.list[index],),
                    onTap: (){
                      widget.click(index);
                    },
                  );
                },
              ),
            ),
          ),
          Offstage(
            offstage: !this.isloading,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white
              ),
              padding: EdgeInsets.symmetric(
                vertical: ScreenUtil().setHeight(20)
              ),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: ScreenUtil().setWidth(40),
                      height: ScreenUtil().setWidth(40),
                      child: CircularProgressIndicator(color: Colors.red,),
                    ),
                    SizedBox(width: ScreenUtil().setWidth(20),),
                    Text("加载数据中...",style: TextStyle(color: Colors.grey),)
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

abstract class ItemTile<T>{

  Widget builder(T data);

}