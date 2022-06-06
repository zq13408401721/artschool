import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LineLoad extends CustomPaint{

  double width=0;
  double height = 0;
  LineLoad(_width,_height){
    width = _width;
    height = _height;
  }

  @override
  CustomPainter get painter => LineLoadPainter(width);

  @override
  // TODO: implement size
  Size get size => Size(width, height);


}

class LineLoadPainter extends CustomPainter{

  double width = 0;
  double height = 1;

  Paint _paint;

  LineLoadPainter(_w){
    width = _w;
    _paint = Paint()
        ..color = Colors.red;
  }


  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Rect.fromLTRB(0, 0, width, height), _paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

}