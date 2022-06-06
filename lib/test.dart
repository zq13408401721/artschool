import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yhschool/widgets/DiagonalButton.dart';
import 'package:yhschool/widgets/DiagonalButtonGroup.dart';

void main(){
  runApp(MyApp());
}

class MyApp extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return MyState();
  }
  
}

class MyState extends State{

  List<String> list = List<String>.of({"色彩","素描","速写"});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SafeArea(
        child: Column(
          children: [
            DiagonalButtonGroup(list: this.list,)
          ],
        ),
      ),
    );
  }
  
}