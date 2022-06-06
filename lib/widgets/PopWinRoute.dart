import 'package:flutter/cupertino.dart';

/**
 * 自定义弹框
 */
class PopWinRoute extends PopupRoute{
  @override
  // TODO: implement barrierColor
  Color get barrierColor => null;

  @override
  // TODO: implement barrierDismissible
  bool get barrierDismissible => true;

  @override
  // TODO: implement barrierLabel
  String get barrierLabel => null;

  //弹框组件
  Widget childWin;

  PopWinRoute({@required this.childWin});

  @override
  Widget buildPage(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
    return childWin;
  }

  final Duration _duration = Duration(milliseconds: 300);

  @override
  // TODO: implement transitionDuration
  Duration get transitionDuration => _duration;

}