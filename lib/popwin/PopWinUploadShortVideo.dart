import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:yhschool/BaseState.dart';

class PopWinUploadShortVideo extends StatefulWidget{

  PickedFile xFile;
  PopWinUploadShortVideo({Key key,@required this.xFile}):super(key: key);

  @override
  State<StatefulWidget> createState() {
    return PopWinUploadShortVideoState();
  }
}

class PopWinUploadShortVideoState extends BaseState{

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Center(
      child: Container(
        height: 200,
        width: 300,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(ScreenUtil().setWidth(10)))
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: ScreenUtil().setHeight(20),),
            Text("视频上传中")
          ],
        ),
      ),
    );
  }

}