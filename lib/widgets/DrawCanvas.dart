import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yhschool/BaseState.dart';
import 'package:yhschool/teach/WorkCorrect.dart';
import 'package:yhschool/utils/Constant.dart';
import 'package:yhschool/video/VideoMorePage.dart';

class DrawCanvas extends StatefulWidget{

  Function click;
  String url;
  int maxwidth,maxheight;

  DrawCanvas({Key key,@required this.url,@required this.maxwidth,@required this.maxheight}):super(key: key);

  @override
  State<StatefulWidget> createState() {
    return DrawCanvasState();
  }

}

class DrawCanvasState extends BaseState<DrawCanvas>{

  GlobalKey _globalKey = GlobalKey();
  List<Offset> _points = <Offset>[];
  double height;
  bool isloading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;

    height = widget.maxheight*size.width/widget.maxwidth;
    return Scaffold(
      body: SafeArea(
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
                          Navigator.pop(context);
                        },
                        child: Image.asset("image/ic_arrow_left.png",width: ScreenUtil().setWidth(60),height: ScreenUtil().setHeight(40),),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: (){

                          },
                          child: Container(
                            alignment: Alignment(0.9,0),
                            child: Text("保存批改",style: TextStyle(fontSize: ScreenUtil().setSp(40),color:Colors.red),),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              //带有把布局保存成图片功能的组件
              ConstrainedBox(
                constraints: BoxConstraints(maxHeight: height,maxWidth: double.infinity),
                child: Container(
                  width: double.infinity,
                  height: this.height,
                  child: RepaintBoundary(
                    key: _globalKey,
                    child: Stack(
                      children: [
                        CachedNetworkImage(
                          imageUrl: widget.url,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          placeholder: (_context,_url)=>
                              Stack(
                                alignment: Alignment(0,0),
                                children: [
                                  Image.network(Constant.parseSmallString(widget.url, "res.yimios.com:9050/issue"),fit: BoxFit.cover,width: double.infinity,),
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
                                Text("保存数据中",style: TextStyle(color: Colors.grey),)
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
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