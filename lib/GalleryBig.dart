import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:photo_view/photo_view.dart';
import 'package:yhschool/BaseState.dart';
import 'package:yhschool/utils/Constant.dart';
import 'package:yhschool/utils/ImageType.dart';
import 'package:yhschool/widgets/CustomLoad.dart';

class GalleryBig extends StatefulWidget{

  String imgUrl;
  BigImageType imageType;
  int width;
  int height;

  @override
  State<StatefulWidget> createState() {
    return GalleryBigState()
        .._imgUrl = Constant.parseBigImageString(imgUrl, width*3, height*3,90)
        ..imageType = imageType;
  }

  GalleryBig({Key key,@required this.imgUrl,@required this.imageType=BigImageType.gallery,@required this.width=0,@required this.height=0}):super(key: key);

}

class GalleryBigState extends BaseState<GalleryBig>{

  String _imgUrl;
  BigImageType imageType;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      child:new GestureDetector(
        onTap: (){
          Navigator.pop(context);
        },
        child: Stack(
          children: [
            /*PhotoView(
            imageProvider: CachedNetworkImageProvider(
              '$_imgUrl',
            ),
            loadingBuilder: (_context,evt){
              print("大图加载"+evt.cumulativeBytesLoaded.toString());
            },
            minScale: 0.2,
            maxScale: 2.0,
          ),*/
            PhotoView.customChild(
              child: CachedNetworkImage(
                imageUrl: _imgUrl,
                progressIndicatorBuilder: (_context,_url,_progress){
                  print("progress:${_progress.progress}");
                  if(_progress.totalSize == null){
                    return SizedBox();
                  }else{
                    return Center(
                      child: CustomLoad(_progress.progress*100)
                    );
                  }
                },
              ),
              minScale: 0.2,
              maxScale: 4.0,

            ),
            /*Positioned(
              right: 10,
              bottom: 10,
              child:Icon(Icons.share),
            )*/
          ],
        ),
      )
    );
  }

}