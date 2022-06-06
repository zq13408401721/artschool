
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yhschool/utils/Button.dart';

class DiagonalButtonGroup extends StatefulWidget{

  List<String> list;

  DiagonalButtonGroup({Key key,@required this.list});

  @override
  State<StatefulWidget> createState() {
    return DiagonalButtonGroupState()
    ..list = list;
  }

}

class DiagonalButtonGroupState extends State{

  int selectNo=0;
  double radius_angle = 10;

  List list;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      child: ListView.builder(scrollDirection:Axis.horizontal,itemCount:list.length,itemBuilder: (BuildContext _context,int index){
        return Container(
          height: 50,
          child: GestureDetector(
            child: Container(
              decoration: BoxDecoration(
                  color: selectNo != index?ButtonNormalColor:ButtonSelectColor,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(radius_angle),
                      topRight: Radius.zero,
                      bottomRight: Radius.circular(radius_angle),
                      bottomLeft: Radius.zero
                  )
              ),
              padding: EdgeInsets.only(
                  left: 10,
                  right: 10,
                  top: 5,
                  bottom: 5
              ),
              child: Text(
                list[index],style: TextStyle(fontSize:16,color: selectNo != index?LabelNormalColor:LabelSelectColor),
              ),
            ),
            onTap: (){
              setState(() {
                selectNo = index;
              });
              print("click$index");
            },
          ),
        );
      }),
    );
  }

}