import 'dart:convert';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:yhschool/BaseState.dart';
import 'package:yhschool/bean/entity_gallery_list.dart';
import 'package:yhschool/bean/work_correct_bean.dart';
import 'package:yhschool/bean/work_list_bean.dart';
import 'package:yhschool/bean/work_upload_bean.dart';
import 'package:yhschool/utils/Constant.dart';
import 'package:yhschool/utils/DataUtils.dart';
import 'package:yhschool/utils/HttpUtils.dart';
import 'package:yhschool/video/VideoMorePage.dart';
import 'dart:ui' as M;
import 'package:yhschool/bean/today_teach_gallery_editor_bean.dart';

class TodayTeachGalleryEditorPage extends StatefulWidget{

  GalleryListData data;
  TodayTeachGalleryEditorPage({Key key,@required this.data});

  @override
  State<StatefulWidget> createState() {
    return TodayTeachGalleryEditorPageState(data: data);
  }

}

class TodayTeachGalleryEditorPageState extends BaseState{

  GlobalKey _globalKey = GlobalKey();
  GalleryListData data;

  List<Offset> _points = <Offset>[];
  double height=0;
  bool isloading = false;
  int maxwidth=1;
  int maxheight=1;
  String editorurl;

  TodayTeachGalleryEditorPageState({Key key,@required this.data});

  @override
  void initState() {
    super.initState();
    if(data.maxwidth == null || data.maxheight == null || data.maxwidth == 0 || data.maxheight == 0){
      Image image = Image.network(this.data.url);
      image.image.resolve(new ImageConfiguration())
      .addListener(ImageStreamListener((ImageInfo info,bool _){
        setState(() {
          maxwidth = info.image.width;
          maxheight = info.image.height;
        });
      }));
    }else{
      maxwidth = data.maxwidth;
      maxheight = data.maxheight;
    }
  }

  /**
   * 保存图片
   * 直接把图片提交到服务器上
   */
  void _saveImage() async{
    setState(() {
      this.isloading = true;
    });
    RenderRepaintBoundary boundary = _globalKey.currentContext.findRenderObject();
    M.Image img = await boundary.toImage();
    print("img width:${img.width} height:${img.height}");
    ByteData byteData = await img.toByteData(format: M.ImageByteFormat.png);
    Uint8List picBytes = byteData.buffer.asUint8List();
    //final result = await ImageGallerySaver.saveImage(picBytes,quality: 100,name:"temp");
    //print("result:${result}");
    MultipartFile multipartFile = new MultipartFile.fromBytes(
        picBytes,
        filename: data.name+"_correct.jpg",
        contentType: MediaType("image","jpg")
    );
    FormData formdata = new FormData.fromMap({
      "file":multipartFile,
      "schoolid":await getSchoolid(),
      "issueid":data.id,
      "uid":await getUid(),
      "role":await getRole()
    });
    //上传图片
    httpIssueUpload.post(DataUtils.api_issueeditorupload, data: formdata).then((value) {
      _hideLoading();
      print(value);
      TodayTeachGalleryEditorBean bean = TodayTeachGalleryEditorBean.fromJson(json.decode(value));
      if(bean.errno == 0){
        editorurl = bean.data.url;
        Navigator.pop(context,editorurl);
      }else{
        showToast(bean.errmsg);
      }
    }).catchError((err){
      showToast("文件上传err："+err.toString());
      _hideLoading();
    });
  }

  void _hideLoading(){
    if(mounted){
      setState(() {
        this.isloading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    height = maxheight*size.width/maxwidth;
    print("当前图片height:${height}");
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          color: Colors.grey[100],
          child: SingleChildScrollView(
            physics: NeverScrollableScrollPhysics(),
            child: Column(
              children: [
                MyAppBar(
                  preferredSize: Size.fromHeight(40),
                  childView: Container(
                    padding: EdgeInsets.symmetric(
                        vertical: ScreenUtil().setHeight(20)
                    ),
                    decoration: BoxDecoration(
                        color:Colors.white
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: (){
                            Navigator.pop(context,editorurl);
                          },
                          child: backArrowWidget(),
                          //child: Image.asset("image/ic_arrow_left.png",width: ScreenUtil().setWidth(60),height: ScreenUtil().setHeight(40),),
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: (){
                              _saveImage();
                            },
                            child: Container(
                              alignment: Alignment(0.9,0),
                              child: Text("保存修改",style: TextStyle(fontSize: ScreenUtil().setSp(40),color:Colors.red),),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                //带有把布局保存成图片功能的组件
                Offstage(
                  offstage: (maxwidth <= 1 || maxheight <= 1),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxHeight: height,maxWidth: double.infinity),
                    child: Container(
                      width: double.infinity,
                      height: this.height,
                      child: RepaintBoundary(
                        key: _globalKey,
                        child: Stack(
                          children: [
                            CachedNetworkImage(
                              imageUrl: data.url,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              placeholder: (_context,_url)=>
                                  Stack(
                                    alignment: Alignment(0,0),
                                    children: [
                                      Image.network(data.url,fit: BoxFit.cover,width: double.infinity,),
                                      Container(
                                        width: ScreenUtil().setWidth(40),
                                        height: ScreenUtil().setWidth(40),
                                        child: CircularProgressIndicator(color: Colors.red,),
                                      ),
                                    ],
                                  ),
                            ),
                            GestureDetector(
                              onPanUpdate: (DragUpdateDetails detail){
                                RenderBox referenceBox = context.findRenderObject();
                                Offset localPosition = referenceBox.globalToLocal(detail.globalPosition);
                                // 如果点的位置超出图片的高度，直接忽略
                                if(localPosition.dy > 60 && localPosition.dy < this.height+60){
                                  setState(() {
                                    //print("dy${localPosition.dy} ${localPosition.dy-80}");
                                    _points = List.from(_points)..add(Offset(localPosition.dx, localPosition.dy-60));
                                  });
                                }
                              },
                              onPanEnd: (DragEndDetails details) => _points.add(null),
                            ),
                            CustomPaint(painter: SignaturePainter(_points),),
                            Offstage(
                              offstage: !this.isloading,
                              child: Container(
                                width: double.infinity,
                                height: double.infinity,
                                decoration: BoxDecoration(
                                    color: Color(0x50000000)
                                ),
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: ScreenUtil().setWidth(40),
                                        height: ScreenUtil().setWidth(40),
                                        child: CircularProgressIndicator(color: Colors.red,),
                                      ),
                                      SizedBox(height: ScreenUtil().setHeight(20),),
                                      Text("保存数据中",style: TextStyle(fontSize: ScreenUtil().setSp(30),color: Colors.red),)
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SignaturePainter extends CustomPainter{
  final List<Offset> points;
  SignaturePainter(this.points);

  void paint(Canvas canvas,Size size){
    Paint paint = Paint()
      ..color = Colors.red
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 4.0;
    for(int i=0; i<points.length-1; i++){
      if(points[i] != null && points[i+1] != null){
        canvas.drawLine(points[i], points[i+1], paint);
      }
    }
  }

  bool shouldRepaint(SignaturePainter other) => other.points != points;
}
