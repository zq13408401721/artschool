import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yhschool/utils/Constant.dart';
import 'package:yhschool/utils/ImageType.dart';
import 'package:yhschool/utils/SizeUtil.dart';

import 'utils/AsperctRaioImage.dart';

class TileCard extends StatelessWidget{

  String url;
  String smallUrl=""; //小图路径
  final String title;
  final double width,height;
  final ImageType imgtype;
  TileCard({Key key,this.url,this.title,this.width=0,this.height=0,this.imgtype=ImageType.fix}){
    print("Tile url:${this.url}title:${this.title}");
    url = this.url == null ? "" : this.url;
    if(url != null){
      if(imgtype == ImageType.scale){
        smallUrl = url+"!300x300";
        /*if(url.indexOf("res.yimios.com") > 0){
          smallUrl = url+"!300x300";
        }else{
          smallUrl = Constant.parseString(url+"!300x300", "server.yimios.com");
        }*/
      }else if(imgtype == ImageType.issue){
        smallUrl = Constant.parseNewIssueSmallString(url,width.toInt(),height.toInt());
      }else if(imgtype == ImageType.normal){
        if(url.indexOf("res.yimios.com") > 0){
          smallUrl = Constant.parseSmallString(url, "res.yimios.com:9050");
        }else{
          smallUrl = Constant.parseString(url+"!300x300","server.yimios.com");
        }
      }else if(imgtype == ImageType.smallOffical) {
        //只有平台才传过数据到server服务器
        // res平台只需要在路径中添加small
        if(url.lastIndexOf("_") > 0){
          String name = url.substring(url.lastIndexOf("/") + 1, url.lastIndexOf("_")).trim();
          String fileType = url.substring(url.lastIndexOf("."), url.length);
          smallUrl = "http://res.yimios.com:9050/small/1/1/" + name + fileType;
        }else{
          smallUrl = Constant.parseSmallString(url, "res.yimios.com:9050");
        }
        /*if(url.indexOf("server.yimios.com") > 0){
          String name = url.substring(url.lastIndexOf("/")+1,url.lastIndexOf("_")).trim();
          String fileType = url.substring(url.lastIndexOf("."),url.length);
          smallUrl = "http://res.yimios.com:9050/small/1/1/"+name+fileType+"!300x300";
        }else{

        }*/
      }else if(imgtype == ImageType.smallSchool){
        if(url.indexOf("res.yimios.com") > 0){
          if(url.indexOf("_") > 0){
            String _url = url.substring(0,url.lastIndexOf("_"))+url.substring(url.lastIndexOf("."),url.length);
            smallUrl = Constant.parseSmallString(_url, "res.yimios.com:9050");
          }else{
            smallUrl = Constant.parseSmallString(url, "res.yimios.com:9050");
          }
        }else if(url.indexOf("server.yimios.com") > 0){
          String _url = url.replaceFirst("server.yimios.com", "server.yimios.com:8085");

          //smallUrl = _url.substring(0,_url.lastIndexOf("/")+1)+name+fileType;
          smallUrl = _url+"!300x300";
        }

      }else{
        if(url.indexOf("_") > 0){
          String name = url.substring(url.lastIndexOf("/")+1,url.lastIndexOf("_")).trim();
          String fileType = url.substring(url.lastIndexOf("."),url.length);
          smallUrl = "http://res.yimios.com:9050/imgs/"+name+fileType+"!300x300";
        }else{
          smallUrl = Constant.parseSmallString(url, "res.yimios.com:9050");
        }
      }
    }

    //if((imgtype == ImageType.small || imgtype == ImageType.fill) && url != null){
      //目前分为两个服务器，通过域名来判断 res.yimios.com server.yimios.com

     // if(url.indexOf("res.yimios.com") > 0){
      //  smallUrl = url+"!300x300";
      //}else{
        // String name = url.substring(url.lastIndexOf("/")+1,url.lastIndexOf("_")).trim();
        // if(url.endsWith("png")){
        //   smallUrl = "http://server.yimios.com/static/small/$name.png!300x300";
        // }else{
        //   smallUrl = "http://server.yimios.com/static/small/$name.jpg!300x300";
        // }
        //smallUrl = Constant.parseString(url+"!300x300", "http://res.yimios.com");
      //}
    //}else if(url != null){
     // smallUrl = Constant.parseString(url+"!300x300", "http://res.yimios.com");
    //}
  }

  Widget getImg(BuildContext context){
    return this.imgtype == ImageType.fix ?
      CachedNetworkImage(
        imageUrl: '$url',
        fit: BoxFit.cover,
        height: this.height > 0 ? this.height : MediaQuery.of(context).size.height,
        width: this.width > 0 ? this.width : MediaQuery.of(context).size.width,
      ) :
    CachedNetworkImage(
      imageUrl: '$url',
      fit: BoxFit.fitHeight
    );
  }

  /**
   * 创建
   */
  Widget getWHImage(BuildContext context){
    double width = Constant.galleryItemWidth();

    return AsperctRaioImage.network(
      imgtype == ImageType.smallOffical || imgtype == ImageType.smallSchool || imgtype == ImageType.scale || imgtype == ImageType.normal ? '$smallUrl' : '$url',
        builder: (context, snapshot, url) {
          double boxHeight = Constant.galleryItemHeight(
              width, snapshot.data.width.toDouble(),
              snapshot.data.height.toDouble());
          print("url $url width:"+snapshot.data.width.toDouble().toString() + " height:"+snapshot.data.height.toDouble().toString());
          return imgtype == ImageType.smallOffical ?
            Container(
                width: snapshot.data.width.toDouble(),
                height: snapshot.data.height.toDouble(),
                color: Colors.black38,
                child: CachedNetworkImage(
                  imageUrl: imgtype == ImageType.smallOffical || imgtype == ImageType.smallSchool || imgtype == ImageType.scale ? smallUrl : url,
                  placeholder: (_context, _url) =>
                      Container(
                        width: 130,
                        height: 80,
                        child: Center(
                            child: Stack(
                              alignment: Alignment(0,0),
                              children: [
                                Image.network(_url,fit: BoxFit.cover,),
                                Container(
                                  width: ScreenUtil().setWidth(40),
                                  height: ScreenUtil().setWidth(40),
                                  child: CircularProgressIndicator(color: Colors.red,),
                                ),
                              ],
                            )
                        ),
                      ),
                  fit: BoxFit.cover,
                )) :
            Container(
                child: CachedNetworkImage(
                  imageUrl: imgtype == ImageType.smallOffical || imgtype == ImageType.smallSchool || imgtype == ImageType.scale || imgtype == ImageType.normal ? smallUrl : url,
                  placeholder: (_context, _url) =>
                      Container(
                        width: 130,
                        height: 80,
                        child: Center(
                            child: Stack(
                              alignment: Alignment(0,0),
                              children: [
                                Image.network(_url,fit: BoxFit.cover,),
                                Container(
                                  width: ScreenUtil().setWidth(40),
                                  height: ScreenUtil().setWidth(40),
                                  child: CircularProgressIndicator(color: Colors.red,),
                                ),
                              ],
                            )
                        ),
                      ),
                  fit: BoxFit.cover,
                ));
        });
  }
  
  @override
  Widget build(BuildContext context) {

    double _top = imgtype == ImageType.smallOffical || imgtype == ImageType.smallOffical  ? ScreenUtil().setHeight(20) : 0;
    double _bottom = imgtype == ImageType.smallOffical || imgtype == ImageType.smallOffical  ? ScreenUtil().setHeight(SizeUtil.getHeight(20)) : ScreenUtil().setHeight(SizeUtil.getHeight(10));

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Stack(
          children: [
            imgtype == ImageType.fill ?
            AsperctRaioImage.network(
                smallUrl,
                builder: (context, snapshot, url) {
                  return Container(
                      color: Colors.black38,
                      child: CachedNetworkImage(
                        imageUrl: smallUrl,
                        //height: ScreenUtil().setHeight(height),
                        placeholder: (_context, _url) =>
                            Container(
                              width: 130,
                              height: 80,
                              child: Center(
                                  child: Stack(
                                    alignment: Alignment(0,0),
                                    children: [
                                      Image.network(_url,fit: BoxFit.cover,),
                                      Container(
                                        width: ScreenUtil().setWidth(40),
                                        height: ScreenUtil().setWidth(40),
                                        child: CircularProgressIndicator(color: Colors.red,),
                                      ),
                                    ],
                                  )
                              ),
                            ),
                        fit: BoxFit.cover,
                      ));
                })
                : getWHImage(context),
            Positioned(
              left:0,right:0,top:0,bottom: 0,
              child: Image.asset(Constant.isPad ? "image/ic_play.png" : "image/ic_play_30.png"),
            )
          ],
        ),
        Container(
          padding: EdgeInsets.only(left: ScreenUtil().setWidth(SizeUtil.getWidth(20)),top: ScreenUtil().setHeight(0),bottom: SizeUtil.getHeight(_bottom)),
          color: Colors.white,
          child: Text(
            '$title',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Constant.titleTextStyleNormal,

          ),
        )
      ],
    );
  }



}