import 'dart:ffi';
import 'dart:math';
import 'dart:ui';

import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yhschool/bean/class_room_datelist_bean.dart';
import 'package:yhschool/utils/EnumType.dart';
import 'dart:math';

import 'package:yhschool/utils/SizeUtil.dart';

class Constant{

  static final PlatformType platformType = PlatformType.iphone; //当前是手机

  static final String VERSION = "1.1.1";  // 当前app版本

  static final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

  //当前是否在登录页面
  static bool isLogin = false;

  static final double PAD_SCREEN_WIDTH = 1536; //pad屏幕宽度
  static final double PAD_SCREEN_HEIGHT = 2056; //pad屏幕高度

  static final double PHONE_SCREEN_WIDTH = 750; //手机屏幕宽度
  static final double PHONE_SCREEN_HEIGHT = 1334; //手机屏幕高度

  static final double WIDTH_SCALE = 0.9;
  static final double HEIGHT_SCALE = 0.7;
  static final double FONT_SCALE = 0.85;

  static final int TAB_VIDEO = 0;  //视频页面对应的tab
  static final int TAB_GALLEY = 1; //图库页面对应的tab
  static final int TAB_ISSUE = 2; //发布页面对应的tab
  static final int TAB_MINE = 3; //我的页面对应的tab


  static final Color COLOR_BG = Colors.black12;

  static final double FONT_TITLE_SIZE = 20.0;  //标题字体大小
  static final double FONT_TABS_SIZE = 16.0; //tab对应的字体大小
  static final double FONT_GRID_NAME_SIZE = 16.0; //gridview 条目名称字体大小
  static final double FONT_GRID_DESC_SIZE = 14.0; //gridview条目描述字体大小


  static final double SIZE_TOP_HEIGHT = 120; //顶部高度
  static final double SIZE_TITLE_NORMAL_HEIGHT = 80; // 顶部标题的高度
  static final double SIZE_TOP_BAR_HEIGHT = 140; //顶部Bar高度

  static final Color COLOR_TITLE = Colors.black;  //标题字体的颜色
  static final Color COLOR_GRID_DESC = Colors.black26; //条目描述字体颜色
  static final Color COLOR_NOUSER = Color(0xb3b3b3);  //昵称
  static final Color COLOR_USER = Color(0x000000);  //昵称
  static final Color COLOR_VIDEO_BG = Colors.black54; //视频播放的背景颜色
  static final Color COLOR_BTN_BORDER_NORMAL = Colors.black54; //按钮边框颜色
  static final Color COLOR_BTN_BG = Colors.black12; //按钮背景颜色
  static final Color COLOR_BTN_SELECT = Colors.lightBlueAccent; //按钮选中的颜色



  static final double PADDING_LEFT = 15; //页面的左边距
  static final double PADDING_RIGHT = 15; //页面的右边距

  static final double PADDING_GALLERY_LEFT = 80; //图库左边偏移
  static final double PADDING_GALLERY_RIGHT = 80; //图库右边便宜
  static final double PADDING_GALLERY_CROSS = 25; //中间间距

  static final double IMAGE_LIST_ITEM_HEIGHT = 70; //图库列表图片的高度
  static final double IMAGE_LIST_ITEM_IMAGE_HEIGHT = 50; //列表图片高度

  static final double MINE_ITEM_HEIGHT = 50; //我的页面条目的高度
  static final double FONT_USERNUMBER_SIZE = 12; //用户账号字体大小
  static final double FONT_NICKNAME_SIZE = 20; //昵称大小
  static final double SIZE_HEADER = 80; //头像大小
  static final double FONT_MINE_ITEM_SIZE = 14; //我的页面条目字体大小

  static final Color BUTTON_BG = Color(0xff29abe2);  //登录按钮的背景颜色
  static final double FONT_LOGIN_SIZE = 20; //登录字体大小

  static final Color TAB_SELECT_COLOR = Color(0xffE55778); //tab选中颜色
  static final Color TAB_UNSELECT_COLOR = Color(0xff000000); //tab默认的颜色


  static final double GARRERY_ITEM_HEIGHT = 288; //相册图片的高度值

  static final double GARRERY_GRID_CROSSAXISSPACING = 10; //相册图片的间隔


  static final double VIDEO_HEIGHT = 750; //视频的高度

  static final String siteid= "A478E06B5AA1107B"; //userid

  static final double MAX_IMAGE = 3.0*1024*1024; //支持的单张图片大小

  static final double MAX_IMAGE_AVATER = 0.5*1024*1024; //头像但张图大小控制在500k

  static final double DIS_LIST = 20; //瀑布流列表间距


  static bool isPad = false; //当前是否是pad

  static final double padsize = 7; //pad屏幕尺寸

  static final double SCREEN_W = window.physicalSize.width;
  static final double SCREEN_H = window.physicalSize.height; //屏幕的宽高

  static double STAGE_W = 0;
  static double STAGE_H = 0;

  static bool isShowVersion = false; //是否显示显示版本弹框

  static bool isIosLowVersion = false; //是否是低配的iOS版本


  static final int COLLECT_CLASS = 1; // 老师发布课堂作品
  static final int COLLECT_GALLERY = 2; //图库
  static final int COLLECT_COLUMN = 3; //专栏
  static final int COLLECT_SMALLVIDEO = 4; //小视频
  static final int COLLECT_VIDEO = 5; //视频收藏
  static final int COLLECT_WORK = 6; //学生作业

  static final int PUSH_FROM_GALLERY = 1; //图库
  static final int PUSH_FROM_COLUMN = 2; //专栏
  static final int PUSH_FROM_TEACH = 3; //课堂

  static final List<String> appraise = ["构图","造型","结构","体积","空间","塑造","色调","质感"];

  //广告组件
  static final int ADVERT_DEFAULT_HEIGHT = 300;
  static final int ADVERT_COLUMN_HEIGHT = 150;

  static final List _colors = [Colors.amberAccent[600],Colors.greenAccent[600],Colors.purpleAccent[600],Colors.lightBlue[600]];

  static final List _randomColors = [Color(0xFFFCF6F6),Color(0xFFFCF7F1),Color(0xFFFAF7EB),Color(0xFFFFF7EE)];

  //标题字体样式加粗
  static final TextStyle titleTextStyle = TextStyle(fontSize: ScreenUtil().setSp(SizeUtil.getFontSize(30)),fontWeight: FontWeight.bold);

  //标题字体样式正常
  static final TextStyle titleTextStyleNormal = TextStyle(fontSize: ScreenUtil().setSp(SizeUtil.getFontSize(30)));

  //小标题样式
  static final TextStyle smallTitleTextStyle = TextStyle(fontSize: ScreenUtil().setSp(SizeUtil.getFontSize(25)),color: Colors.grey);

  //低版本ipad资源地址
  static final String LOW_IOS_RESURL = "http://res.yimios.com:9070/";

  static String logn_bg(bool isandroid){
    if(isandroid){
      return Constant.isPad ? "videos/login_page.mp4" : "videos/x2/login_page_android_x2.mp4";
    }else{
      return Constant.isPad ? "videos/login_page.mp4" : "videos/x2/login_page_x2.mp4";
    }
  }

  /**
   * 像素单位换算
   */
  static double galleryItemWidth(){
    var width = window.physicalSize.width; //屏幕宽度
    var content_width = width-2*PADDING_LEFT - 2* GARRERY_GRID_CROSSAXISSPACING;
    var item_width = content_width/3;
    return item_width;
  }

  /**
   * 使用宽度动态计算图片的高度
   */
  static double galleryItemHeight(double width,double sourceWidth,double sourceHeight){
    var height = sourceHeight*(width/sourceWidth);
    return height;
  }

  static String parseString(String url,String host){
    return url.replaceFirst(host, host+":8085");
  }

  static String parseSmallString(String url,String host){
    return url.replaceFirst(host, host+"/small");
  }

  /**
   * 专栏小图，对应服务器保存的路径
   */
  static String parseColumnSmallString(String url){
    return url.replaceFirst("res.yimios.com:9050/column", "res.yimios.com:9050/column/small");
  }

  static String parseNewColumnSmallString(String url,int w,int h){
    if(isIosLowVersion && w > 0 && h > 0){
      return parseIosSmallString(url, w, h,50);
    }else{
      return parseColumnSmallString(url);
    }
  }

  /**
   * 专栏封面
   */
  static String parseColumnListIconString(String url){
    return url.replaceFirst("res.yimios.com:9050/column", "res.yimios.com:9050/column/icon");
  }

  static String parseNewColumnListIconString(String url,int w,int h){
    if(isIosLowVersion && w > 0 && h > 0){
      return parseIosSmallString(url, w, h,50);
    }else{
      return parseColumnListIconString(url);
    }
  }

  /**
   * 网盘小图
   */
  static String parsePanSmallString(String url){
    if(url == null) return "";
    return url.replaceFirst("res.yimios.com:9050/pan", "res.yimios.com:9050/pan/small");
  }

  /**
   * 今日课堂小图
   */
  static String parseIssueSmallString(String url){
    return url.replaceFirst("res.yimios.com:9050/issue", "res.yimios.com:9050/issue/small");
  }

  /**
   * 包含ipad低版本图片
   */
  static String parseNewIssueSmallString(String url,int w,int h,{int scale:100}){
    if(isIosLowVersion && w > 0 && h > 0){
      return parseIosSmallString(url, w, h,scale);
    }else{
      return parseIssueSmallString(url);
    }
  }

  static String parseIosSmallString(String url,int width,int height,int q){
    url = url.replaceFirst("res.yimios.com:9050", "res.yimios.com:9070");
    url = url +"?w=${width}&h=${height}&q=${q}";
    print("iosSmall:${url}");
    return url;
  }

  /**
   * 课堂封面
   */
  static String parseIssueListIconString(String url){
    return url.replaceFirst("res.yimios.com:9050/issue", "res.yimios.com:9050/issue/icon");
  }

  /**
   * 图库小图
   */
  static String parseGallerySmallString(String url){
    print("图库小图：${url}");
    return url.replaceFirst("res.yimios.com:9050/gallery", "res.yimios.com:9050/gallery/small");
  }

  static String parseNewGallerySmallString(String url,int w,int h){
    if(isIosLowVersion && w > 0 && h > 0){
      return parseIosSmallString(url, w, h,50);
    }else{
      return parseGallerySmallString(url);
    }
  }

  static String parseMiddleImageString(String url,int w,int h,int q){
    return parseIosSmallString(url, w*2, h*2,q);
  }

  static String parseBigImageString(String url,int w,int h,int q){
    if(isIosLowVersion && w > 0 && h > 0){
      return parseIosSmallString(url, w, h,q);
    }
    return url;
  }

  /**
   * 图库列表封面
   */
  static String parseGalleryListIconString(String url){
    return url.replaceFirst("res.yimios.com:9050/gallery", "res.yimios.com:9050/gallery/icon");
  }

  /**
   * 作业小图
   */
  static String parseWorkSmallString(String url){
    return url.replaceFirst("res.yimios.com:9050/work", "res.yimios.com:9050/work/small");
  }

  /**
   * 作业封面
   */
  static String parseWorkListIconString(String url){
    return url.replaceFirst("res.yimios.com:9050/work", "res.yimios.com:9050/work/icon");
  }

  static String parseNewWorkListIconString(String url,int w,int h){
    return parseIosSmallString(url, w, h,70);
    /*if(isIosLowVersion && w > 0 && h > 0){
      return parseIosSmallString(url, w, h,70);
    }else{
      return parseWorkListIconString(url);
    }*/
  }

  /**
   *解析收藏小图
   * from 1图库  2课堂  3专栏
   */
  static String parseCollectSmallString(int from,String url,int width,int height){
    url = url.replaceFirst("9050", "9070");
    if(from == 1){
      return parseGallerySmallString(url)+"?w=${width}&h=${height}&q=50";
    }else if(from == 2){
      return parseIssueSmallString(url)+"?w=${width}&h=${height}&q=50";
    }else if(from == 3){
      return parseColumnSmallString(url)+"?w=${width}&h=${height}&q=50";
    }
  }

  static String parsePanString(String url ,String port){
    return url.replaceFirst(port, "9070");
  }

  static String parseTime(DateTime _date){
    //return _date.year+"-"+_date.month+"-"+_date.day+" "+_date.hour+":"+_date.minute+":"+_date.second;
    return "${_date.year}-${_date.month}-${_date.day} ${_date.hour}:${_date.minute}:${_date.second}";
  }


  /**
   * 获取随机颜色
   */
  /*static Color getRandomColor(){
    var random = Random();
    return _colors[random.nextInt(_colors.length)];
  }*/

  /**
   * 计算图片显示和设备的等比例高
   */
  static double getScaleH(double iw,double ih){
    var itemW = (1536-Constant.DIS_LIST*4)/3;
    var itemH = (itemW/iw)*ih;
    return itemH;
  }

  /**
   * 通过url路径截取文件名
   */
  static String getFileNameByUrl(String url,String filename){
    if(filename != null){
      return filename;
    }else{
      var start = url.lastIndexOf("/")+1;
      var end = url.lastIndexOf(".");
      return url.substring(start,end);
    }
  }

  /**
   * 得到格式化的日期
   */
  static String getDateFormat(){
    String date = formatDate(DateTime.now(),[yyyy,"-",mm,"-",dd]);
    return date;
  }

  /**
   * 日期的事件格式
   */
  static String getDateTimeFormat(){
    String date = formatDate(DateTime.now(),[yyyy,"-",mm,"-",dd,HH,":",nn,":",ss]);
    return date;
  }

  /**
   * 格式化日期转换
   */
  static String getDateFormatByString(String _date){
    String date = formatDate(DateTime.parse(_date),[yyyy,"-",mm,"-",dd]);
    return date;
  }

  /**
   * 获取时间格式HH:nn
   */
  static String getHourFormatByString(String _date){
    String date = formatDate(DateTime.parse(_date),[HH,":",nn]);
    return date;
  }

  /**
   * 获取时间对应的星期
   */
  /*static String getWeekFormatByString(String _date){
    String week = DateFormat('EEEE','zh_CN').format(DateTime.parse(_date));
    return week;
  }*/

  /**
   * 获取图标随机颜色
   */
  static Color getColor(){
    return _randomColors[Random().nextInt(_randomColors.length)];
  }

  /**
   * 列表转逗号分割字符串
   */
  static String listToString(List<dynamic> list){
    if(list == null || list.length == 0) return "";
    String result;
    list.forEach((element) => {
      if(result == null) result = element.toString() else result = '$result,$element'
    });
    return result;
  }

  /**
   * 角色名
   */
  static String parseRole(int role){
    if(role == null || role == 0) return "";
    return role == 1 ? "老师" : "学生";
  }
}