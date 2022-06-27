import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yhschool/BaseState.dart';
import 'package:yhschool/bean/issue_gallery_bean.dart';
import 'package:yhschool/popwin/PopWindowMark.dart';
import 'package:yhschool/utils/Constant.dart';
import 'package:yhschool/utils/SizeUtil.dart';

/**
 * 新版的瀑布流列表条目
 */
class TeachTile extends StatefulWidget {

  String smallurl = '';
  String title = '';
  String author = '';
  int role;
  Gallery gallery;
  Function cb;

  TeachTile({Key key, @required this.smallurl, @required this.title, @required this.author,
    @required this.role,@required this.gallery,@required this.cb}) :super(key: key);

  @override
  State<StatefulWidget> createState() {
    return TeachTileState()
    ..smallurl=smallurl
    ..title=title
    ..author=author
    ..role = role
    ..gallery = gallery;
  }
}

class TeachTileState extends BaseState<TeachTile>{

  String smallurl = '';
  String title = '';
  String author = '';
  int role;
  String uid;
  Gallery gallery;
  @override
  void initState() {
    super.initState();
    getUid().then((value){
      setState(() {
        this.uid = value;
      });
    });
  }

  //打开设置标记页面
  void showMarkDialog(){
    showDialog(context: context, builder: (context){
      return StatefulBuilder(builder: (_context,_state){
        return PopWindowMark(gallery: this.gallery,);
      });
    }).then((value){
      //设置标记成功返回 更新当前列表
      if(value != null){
        if(gallery.id == value["galleryid"]){
          setState(() {
            gallery.markid = value["markid"];
            gallery.mark = value["mark"];
            gallery.markname = value["markname"];
            gallery.galleryid = value["galleryid"];
            gallery.comments = value["comments"];
          });
        }
      }
    });
  }

  /**
   * 获取标签显示内容
   */
  String getMarkWord(){
    if(gallery.markname != null){
      return gallery.markname;
    }else{
      //如果没有标签作品发布者不是自己，就不显示
      if(uid == gallery.tid){
        return "标记";
      }else{
        return "";
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    double _height = ScreenUtil().setHeight(SizeUtil.getHeight(Constant.getScaleH(gallery.width.toDouble(), gallery.height.toDouble())));
    return Padding(padding: EdgeInsets.only(top: ScreenUtil().setHeight(SizeUtil.getHeight(20))),
      child: Card(
        color: Colors.white,
        elevation: 0.0,
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    height: _height,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Constant.getColor(),
                    ),
                    child: CachedNetworkImage(
                      imageUrl: smallurl,
                      memCacheWidth: gallery.width,
                      memCacheHeight: gallery.height,
                      //height: ScreenUtil().setHeight(height),
                      /*placeholder: (_context, _url) =>
                          Stack(
                            alignment: Alignment(0,0),
                            children: [
                              Image.network(_url,width:double.infinity,height:_height,fit: BoxFit.cover,),
                              Container(
                                width: ScreenUtil().setWidth(40),
                                height: ScreenUtil().setWidth(40),
                                child: CircularProgressIndicator(color: Colors.red,),
                              ),
                            ],
                          ),*/
                      fit: BoxFit.cover,
                    )
                ),
                Padding(
                  padding: EdgeInsets.only(top: ScreenUtil().setHeight(SizeUtil.getHeight(20)),bottom: ScreenUtil().setHeight(SizeUtil.getHeight(20)),left: ScreenUtil().setWidth(SizeUtil.getWidth(20)),right: ScreenUtil().setWidth(SizeUtil.getWidth(20))),
                  child: Text(
                    '$author',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Constant.titleTextStyleNormal,
                  ),
                ),
                Offstage(
                  offstage: uid != gallery.tid,
                  child: Padding(
                    padding: EdgeInsets.only(top: ScreenUtil().setHeight(SizeUtil.getHeight(20)),bottom: ScreenUtil().setHeight(SizeUtil.getHeight(20)),left: ScreenUtil().setWidth(SizeUtil.getWidth(20)),right: ScreenUtil().setWidth(SizeUtil.getWidth(20))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: (){
                            //进入编辑条件必须是老师，并且发布作品还是自己的
                            if(role == 1 && gallery.tid == this.uid){
                              showMarkDialog();
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: Color.fromARGB(1, 246, 186, 207)
                            ),
                            child: Text(getMarkWord(),style: gallery.markname != null ? TextStyle(
                                fontSize: ScreenUtil().setSp(SizeUtil.getFontSize(30)),fontWeight: FontWeight.bold,color: Colors.red
                            ) : TextStyle( fontSize: ScreenUtil().setSp(SizeUtil.getFontSize(30)),fontWeight: FontWeight.bold,color:Color(0xFF3d5afe)),),
                          ),
                        ),
                        InkWell(
                          onTap: (){
                            if(widget.cb != null){
                              widget.cb();
                            }
                          },
                          child: Image.asset("image/ic_fork.png",color: Colors.black12,),
                        )
                      ],
                    ),
                  )
                ),
                //有数据就显示，没有数据就隐藏
                Offstage(
                    offstage: this.gallery.comments == null || gallery.comments.length == 0,
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(2)
                      ),
                      margin: EdgeInsets.only(top: ScreenUtil().setHeight(SizeUtil.getHeight(10)),left: ScreenUtil().setWidth(SizeUtil.getWidth(20)),right: ScreenUtil().setWidth(SizeUtil.getWidth(20)),bottom: ScreenUtil().setHeight(SizeUtil.getHeight(20))),
                      padding: EdgeInsets.all(ScreenUtil().setHeight(SizeUtil.getHeight(10))),
                      child: Text(
                        this.gallery.comments != null ? gallery.comments : "",
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: Constant.smallTitleTextStyle,
                      ),
                    )
                ),
              ],
            ),
            (gallery.eidtorurl != null && gallery.eidtorurl.length > 0) ?
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.purple
                ),
                padding: EdgeInsets.symmetric(
                    horizontal: ScreenUtil().setWidth(SizeUtil.getWidth(40)),
                    vertical: ScreenUtil().setHeight(SizeUtil.getHeight(20))
                ),
                child: Text("已编辑",style: TextStyle(fontSize: ScreenUtil().setSp(SizeUtil.getFontSize(36)),color: Colors.white),),
              ),
            ) : SizedBox()
          ],
        ),
      ),
    );
  }

}