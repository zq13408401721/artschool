import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yhschool/widgets/BackButtonWidget.dart';

class ImagePage extends StatelessWidget{

  String imgpath;
  String title;

  ImagePage({Key key,@required this.imgpath,@required this.title}):super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            //标题
            BackButtonWidget(cb: (){
              Navigator.pop(context);
            }, title: "$title",),
            //图片内容
            Expanded(
              child: Image.asset("$imgpath",fit: BoxFit.cover,),
            )
          ],
        ),
      ),
    );
  }

}