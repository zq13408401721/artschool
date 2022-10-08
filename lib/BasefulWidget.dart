import 'package:flutter/cupertino.dart';

class BasefulWidget<T extends State> extends StatefulWidget{

  BasefulWidget({Key key}):super(key: key);

  @override
  State<StatefulWidget> createState() {

  }

  T getBaseState(){}

}