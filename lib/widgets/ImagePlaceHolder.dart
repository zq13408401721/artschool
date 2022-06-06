import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yhschool/BaseState.dart';
import 'package:yhschool/utils/Constant.dart';

/**
 * 带有自定义颜色背景和loading效果的图片item
 */
class ImagePlaceHolder extends StatefulWidget{

  String url;
  double width,height;
  ImagePlaceHolder({@required this.url,@required this.width,@required this.height});


  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ImagePlaceHolderState();
  }

}

class ImagePlaceHolderState extends BaseState<ImagePlaceHolder>{
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
        height: widget.height,
        width: widget.width,
        decoration: BoxDecoration(
          color: Constant.getColor(),
        ),
        child: CachedNetworkImage(
          imageUrl: widget.url,
          /*placeholder: (_context, _url) =>
              Stack(
                alignment: Alignment(0,0),
                children: [
                  Image.network(_url,width:widget.width,height:widget.height,fit: BoxFit.cover,),
                  Container(
                    width: ScreenUtil().setWidth(40),
                    height: ScreenUtil().setWidth(40),
                    child: CircularProgressIndicator(color: Colors.red,),
                  ),
                ],
              ),*/
          fit: BoxFit.cover,
        )
    );
  }
}