
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yhschool/utils/SizeUtil.dart';


class CustomLoad extends CustomPaint{

  double _present = 0;

  CustomLoad(double present){
    _present = present;
  }

  @override
  CustomPainter get painter => _CustomLoading(_present);

  @override
  Size get size => Size(ScreenUtil().setWidth(SizeUtil.getWidth(120)), ScreenUtil().setWidth(SizeUtil.getWidth(120)));

}


class _CustomLoading extends CustomPainter{

  Paint _paintBgCircle;
  final double _circleBgRadius = ScreenUtil().setWidth(SizeUtil.getWidth(60));
  Paint _paintSmallCircle;
  final double _circleSmallRadius = ScreenUtil().setWidth(SizeUtil.getWidth(60));
  final double pi = 3.1415;

  double _present;

  _CustomLoading(double present){
    _present = present;
    _paintBgCircle = Paint()..color = Color.fromARGB(230, 255, 255, 255);
    _paintSmallCircle = Paint()
    ..color = Colors.red;
  }

  @override
  void paint(Canvas canvas,Size size){
    //canvas.drawCircle(Offset(40, 20), _circleRadius, _paintCircle);
    canvas.drawCircle(Offset(_circleBgRadius,_circleBgRadius/2), _circleBgRadius, _paintBgCircle);
    Rect rect = Rect.fromCircle(center: Offset(_circleBgRadius,_circleBgRadius/2),radius: _circleSmallRadius);
    double _angle = 360/(_present/100*360);
    canvas.drawArc(rect, -2*pi/4,2*pi/_angle, true,_paintSmallCircle);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate){
    return true;
  }

}