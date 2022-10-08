import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yhschool/utils/Constant.dart';

class SizeUtil{

  /**
   * 根据设备计算当前设备的width
   */
  static double getWidth(double value){
    //if(Constant.isPad) return value;
    //return value*Constant.PHONE_SCREEN_WIDTH/Constant.PAD_SCREEN_WIDTH;

    return Constant.isPad ? value * 1 : value * Constant.WIDTH_SCALE;
  }

  /**
   * 根据设备计算当前设备的height
   */
  static double getHeight(double value){
    //if(Constant.isPad) return value;
    //return value*Constant.PHONE_SCREEN_HEIGHT/Constant.PAD_SCREEN_HEIGHT;
    return Constant.isPad ? value * 1 : value * Constant.HEIGHT_SCALE;
  }

  static double getFontSize(double value){
    return Constant.isPad ? value * 1 : value * Constant.FONT_SCALE;
  }

  static double getAppWidth(double value){
    return ScreenUtil().setWidth(getWidth(value));
  }

  static double getAppHeight(double value){
    return ScreenUtil().setHeight(getHeight(value));
  }

  static double getAppFontSize(double value){
    return ScreenUtil().setSp(getFontSize(value));
  }

}