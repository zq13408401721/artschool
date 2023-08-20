import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yhschool/BaseState.dart';

import '../widgets/BackButtonWidget.dart';

class AboutYH extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return AboutYHState();
  }

}

class AboutYHState extends BaseState<AboutYH>{


  List<String> imgs = List.of([
    "P1.jpg",
    "P2.jpg",
    "P3.jpg",
    "P4.jpg",
    "P5.jpg",
    "P6.jpg",
    "P7.jpg",
    "P8.jpg",
    "P9.jpg",
    "P10.jpg",
    "P11.jpg",
    "P12.jpg",
    "P13.jpg",
    "P14.jpg",
    "P15.jpg",
    "P16.jpg",
    "P17.jpg",
    "P18.jpg"
  ]);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            //标题
            BackButtonWidget(cb: (){
              Navigator.pop(context);
            }, title: "关于艺画",),
            Expanded(
              child: SizedBox(
                height: double.infinity,
                child: ListView.builder(itemBuilder: (context,index){
                  return Image.asset("image/${imgs[index]}",width: double.infinity,fit: BoxFit.cover,);
                },itemCount: imgs.length,scrollDirection: Axis.vertical,),
              )
            )
          ],
        ),
      ),
    );
  }
}