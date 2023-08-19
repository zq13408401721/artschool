import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:date_format/date_format.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:package_info/package_info.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:yhschool/FlutterPlugins.dart';
import 'package:yhschool/bean/eg_word_bean.dart';
import 'package:yhschool/bean/login_bean.dart';
import 'package:yhschool/main.dart';
import 'package:yhschool/utils/Constant.dart';
import 'package:yhschool/utils/DBUtils.dart';
import 'package:yhschool/utils/DataUtils.dart';
import 'package:yhschool/utils/HttpUtils.dart';
import 'package:yhschool/utils/SizeUtil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:math' as math;

import 'Home.dart';
import 'Login.dart';
import 'WebStage.dart';
import 'bean/BaseBean.dart';
import 'login/PhoneActiveCodePage.dart';

// 标题点击返回操作
typedef CallbackFun = void Function();
// 标题更多的点击方法
typedef CallmoreFun = void Function();

class CB_Class{
  CallbackFun callback;
  CallmoreFun moreFun;
  CB_Class(CallbackFun this.callback,CallmoreFun this.moreFun);
}

abstract class BaseState<T extends StatefulWidget> extends State<T>{

  bool isIpad = false;
  bool isAndroid = false;
  bool isData = true; // 是否有数据

  //当前是否正在发起http请求
  bool ishttp = false;

  String m_uid="",m_username="",m_nickname="",m_schoolid="";
  String welcome="",schoolname="";
  int m_role;
  bool isShowDialog = false;

  final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  Map<String,dynamic> deviceData = <String,dynamic>{};
  //当前用户所在的班级ID
  List<String> selfclassids = List.empty();
  bool permissionCheck = true;

  @override
  void initState() async{
    super.initState();
    if(Platform.isAndroid){
      if(permissionCheck){
        await permission_android();
      }
      this.isAndroid = true;
    }else{
      try{
        deviceData = _readIosDeviceInfo(await deviceInfoPlugin.iosInfo);
        String version = deviceData["systemVersion"];
        var v = version.split(".");
        if(v.length > 0 && int.parse(v[0]) < 13){
          Constant.isIosLowVersion = true;
        }
      }on PlatformException{
        deviceData = <String,dynamic>{
          "Error:":"not get platform"
        };
      }
    }
    getUserInfo().then((value){
      if(mounted){
        setState(() {
          if(value != null){
            m_uid = value["uid"];
            m_username = value["username"];
            m_nickname = value["nickname"];
            m_role = value["role"];
            m_schoolid = value["schoolid"];
            String classids = value["classids"];
            if(classids != null){
              selfclassids = classids.split("、");
            }
          }
        });
      }
    });
  }

  Map<String, dynamic> _readIosDeviceInfo(IosDeviceInfo data) {
    return <String, dynamic>{
      'name': data.name,
      'systemName': data.systemName,
      'systemVersion': data.systemVersion,
      'model': data.model,
      'localizedModel': data.localizedModel,
      'identifierForVendor': data.identifierForVendor,
      'isPhysicalDevice': data.isPhysicalDevice,
      'utsname.sysname:': data.utsname.sysname,
      'utsname.nodename:': data.utsname.nodename,
      'utsname.release:': data.utsname.release,
      'utsname.version:': data.utsname.version,
      'utsname.machine:': data.utsname.machine,
    };
  }

  /**
   * 检查用户登录是否失效
   */
  String checkLoginExpire(String result){
    if(result == null || result.isEmpty || !mounted) return "";
    BaseBean _baseBean = BaseBean.fromJson(json.decode(result));
    if(_baseBean.errno == 99999 || _baseBean.errno == ReqCode.Code_NoActive || _baseBean.errno == ReqCode.Code_PhoneNoActive){
      if(_baseBean.errno == 99999){
        Fluttertoast.showToast(msg: "账号在其他地方登录",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.deepOrangeAccent,
            textColor: Colors.white,
            fontSize: 16.0);
        clearCache();
      }else if(_baseBean.errno == ReqCode.Code_NoActive){
        Fluttertoast.showToast(msg: "账号已到期或未激活",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.deepOrangeAccent,
            textColor: Colors.white,
            fontSize: 24.0);
        clearCache();
        Timer(Duration(seconds: 2), (){
          exit(0);
        });
      }else if(_baseBean.errno == ReqCode.Code_PhoneNoActive){
        Fluttertoast.showToast(msg: "账号已到期或未激活",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.deepOrangeAccent,
            textColor: Colors.white,
            fontSize: 24.0);
      }
      return "";
    }else if(_baseBean.errno == 602){
      Fluttertoast.showToast(msg: "未登录",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.deepOrangeAccent,
          textColor: Colors.white,
          fontSize: 24.0);
      clearCache();
      Timer(Duration(seconds: 2), (){
        exit(0);
      });
      return "";
    }else{
      return result;
    }

  }

  void check() async{
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if(Platform.isIOS){
      var info = await deviceInfo.iosInfo;
      if(info.model == "iPad"){
        Constant.isPad = true;
      }
    }else{
      checkAndroidWH(context);
    }
  }

  /**
   * 检查屏幕的尺寸判断当前是pad还是手机
   */
  checkAndroidWH(BuildContext context){
    Size _size = MediaQuery.of(context).size;
    //屏幕密度
    double _ratio = MediaQuery.of(context).devicePixelRatio;
    //设备像素
    double width = _size.width*_ratio;
    double height = _size.height*_ratio;
    double ich = _ratio*160; //屏幕的像素密度
    double mc = math.sqrt(math.pow(width, 2)+math.pow(height, 2))/ich;
    //showToast("pixel:$mc");
    if(mc > Constant.padsize){
      Constant.isPad = true;
    }
    Constant.STAGE_W = _size.width;
    Constant.STAGE_H = _size.height;
  }

  Future<void> setStartFlag(bool value) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("startflag", value);
  }

  Future<bool> getStartFlag() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool("startflag");
  }

  /**
   * 拨打电话
   */
  Future<void> callPhone(String no) async{
    if(await canLaunch(no)){
      await launch(no);
    }else{
      showToast("检查电话号码：$no是否正确");
    }
  }

  //设置标记
  Future<void> setData(String key,dynamic value) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(value is String){
      prefs.setString(key, value);
    }else if(value is int){
      prefs.setInt(key, value);
    }else if(value is bool){
      prefs.setBool(key, value);
    }
  }

  /**
   * 清理缓存
   */
  void clearCache() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String username = await prefs.getString("username");
    String pw = await prefs.getString("password");
    int policy = await prefs.getInt("policy");
    prefs.clear();
    if(policy != null){
      prefs.setInt("policy", policy);
    }
    prefs.setString("username", username);
    prefs.setString("password", pw);
  }

  /**
   * 删除本地保存的数据
   */
  void removeData(String key) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
  }

  Future<String> getString(String key) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  Future<int> getInt(String key) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(key);
  }

  Future<bool> getBool(String key) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key);
  }

  //设置token
  void saveToken(String token) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("token", token);
  }

  //获取token
  Future<String> getToken() async{
    var token;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString("token");
    return token;
  }

  //获取是否常亮
  Future<bool> getLight() async{
    var light;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    light = prefs.getBool("light");
    return light;
  }

  /**
   * 设置软件常亮显示
   */
  Future<void> setLight(value) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("light",value);
  }

  //获取用户角色
  Future<int> getRole() async{
    var role;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    role = prefs.getInt("role");
    return role;
  }

  //获取用户的uid
  Future<String> getUid() async{
    var uid;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    uid = prefs.getString("uid");
    return uid;
  }

  //用户名
  Future<String> getUsername() async{
    var username;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    username = prefs.getString("username");
    return username;
  }

  Future<dynamic> getUserInfo() async{
    var username,nickname;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    username = prefs.getString("username");
    nickname = prefs.getString("nickname");
    welcome = prefs.getString("welcome");
    var option = {
      "username":username,
      "nickname":nickname,
      "role":prefs.getInt("role"),
      "avater":prefs.getString("avater"),
      "schoolid":prefs.getString("schoolid"),
      "uid":prefs.getString("uid"),
      "classes":prefs.getString("classes"),
      "schoolname":prefs.getString("schoolname"),
      "phoneno":prefs.getString("phoneno"),
      "classids":prefs.getString("classids")
    };
    return option;
  }

  //学校id
  Future<String> getSchoolid() async{
    var schoolid;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    schoolid = prefs.getString("schoolid");
    return schoolid;
  }

  /**
   * 保存用户信息
   */
  void saveUser(Userinfo info,String classes,String classids) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(info.avater != null){
      prefs.setString("avater", info.avater);
    }
    prefs.setInt("role", info.role);
    if(info.nickname != null){
      prefs.setString("nickname", info.nickname);
    }

    prefs.setString("username", info.username);
    prefs.setString("schoolid", info.schoolid);
    prefs.setString("uid", info.uid);
    prefs.setString("classes", classes);
    prefs.setString("classids", classids);
    prefs.setString("schoolname", info.schoolname);
    schoolname = info.schoolname;
    if(info.welcome != null) {
      welcome = info.welcome;
      prefs.setString("welcome", info.welcome);
    }
    if(info.appname != null){
      prefs.setString("appname", info.appname);
    }
    if(info.appicon != null){
      prefs.setString("appicon", info.appicon);
    }
    if(info.phone != null){
      prefs.setString("phoneno", info.phone);
    }
  }

  /**
   * 更新本地用户昵称
   */
  void saveNickname(String nickname) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(nickname != null){
      prefs.setString("nickname", nickname);
    }
  }

  /**
   * 保存日期格式数据
   */
  void saveIssueDate(date,dateId) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(date, dateId);
  }

  void savePhoneDialogState() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("phonedialog", true);
  }

  Future<bool> getPhoneDialogState() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool("phonedialog");
  }

  /**
   * 判断当前用户是否在此班级中
   */
  bool inClass(int cid){
    if(selfclassids != null){
      int index = selfclassids.indexOf(cid.toString());
      return index >= 0;
    }
    return false;
  }

  /**
   * 获取双师课堂视频当天的日期id
   */
  Future<int> getClassTodayDateByClass(int cid) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String date = formatDate(DateTime.now(),[yyyy,"-",mm,"-",dd]);
    String key = "class_${cid}_${date}";
    return prefs.getInt(key);
  }

  /**
   * 保存班级相关日期数据id
   */
  void saveClassTodayDate(int cid,int dateid) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String date = formatDate(DateTime.now(),[yyyy,"-",mm,"-",dd]);
    String key = "class_${cid}_${date}";
    prefs.setInt(key,dateid);
  }

  /**
   * 根据班级id获取对应的日期数据id
   * 固定返回数据格式为二维数组 0已经有日期的班级id 1班级对应的日期id 2还不存在日期id的班级id
   */
  Future<List<List<int>>> getDateIDByClass(List<int> classesid,String date) async{
    List<int> yclassids = []; //有日期id的班级id
    List<int> dateids = []; //存在的日期id
    List<int> nclassids = []; //不存在日期id的班级id
    if(date == null){
      date = formatDate(DateTime.now(),[yyyy,"-",mm,"-",dd]);
    }
    // key格式 班级+-+日期
    SharedPreferences prefs = await SharedPreferences.getInstance();
    for(int id in classesid){
      String key = id.toString()+"-"+date.toString();
      if(prefs.containsKey(key)){
        yclassids.add(id);
        dateids.add(prefs.getInt(key));
      }else{
        nclassids.add(id);
      }
    }
    List<List<int>> result = [];
    result.add(yclassids);
    result.add(dateids);
    result.add(nclassids);
    return result;
  }

  /**
   * 保存班级对应的日期id
   */
  void saveManyDateId(List<String> keys,List<int> ids) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    for(int i=0; i<keys.length; i++){
      prefs.setInt(keys[i], ids[i]);
    }
  }

  //保存日期id数据和对应的班级数据

  //刷新token
  Future<String> refreshToken() async{

  }

  //验证token是否过期
  Future<String> authToken() async{

  }

  /**
   * 保存视频播放器
   */
  void saveWebPlayerTemplete(String player) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("player", player);
  }

  /**
   * 读取视频播放器缓存模版
   */
  Future<String> getWebPlayerTemplete() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("player");
  }

  /**
   * 获取日期的id
   */
  Future<int> getDateId(String date) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(date);
  }

  /**
   * 是否阅读协议状态
   */
  Future<bool> savePolicy() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool _bool = await prefs.setInt("policy",1);
    return _bool;
  }

  Future<int> getPolicy() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int policy = await prefs.getInt("policy");
    print("policy :"+policy.toString());
    return policy;
  }

  Future<bool> savePanVisible(bool select) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool _bool = await prefs.setBool("panvisible",select);
    return _bool;
  }

  Future<bool> getPanVisible() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool _bool = await prefs.getBool("panvisible");
    return _bool;
  }

  /**
   * 获取欢迎语
   */
  Future<String> getWelcome() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String _welcome = await prefs.getString("welcome");
    return _welcome;
  }

  /**
   * 显示toast
   */
  showToast(String tips){
    Fluttertoast.showToast(msg: tips,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.CENTER,
    backgroundColor: Colors.deepOrangeAccent,
    textColor: Colors.white,
    fontSize: 16.0);
  }

  /**
   * android手机号权限
   */
  permission_phone_android() async{
    List<Permission> permissions = [];
    if(!await Permission.phone.isGranted){
      permissions.add(Permission.phone);
    }
    if(permissions.length > 0){
      Map<Permission,PermissionStatus> status = await permissions.request();
      if(!await Permission.phone.isGranted){
        exit(0);
      }
    }else{
      print("存储相机相册权限已经申请");
    }
  }

  /**
   * android
   */
  permission_android() async{
    //检查存储权限
    List<Permission> permissions = [];
   /* if(!await Permission.storage.isGranted){
      permissions.add(Permission.storage);
    }

    if(!await Permission.photos.isGranted){
      permissions.add(Permission.photos);
    }
    if(!await Permission.camera.isGranted){
      permissions.add(Permission.camera);
    }*/
    if(!await Permission.phone.isGranted){
      permissions.add(Permission.phone);
    }
    if(permissions.length > 0){
      if(!Constant.SDCARD_DALOG){
        Constant.SDCARD_DALOG = true;
        await showSdCardPermissionDialog(context,callback: () async{
          Map<Permission,PermissionStatus> status = await permissions.request();
        });
      }
    }else{
      print("存储相机相册权限已经申请");
    }
  }

  /**
   * 相机相册权限申请
   */
   Future<bool> permissionPhoto(Function callback) async{
    List<Permission> permissions = [];
    if(!await Permission.storage.isGranted){
      permissions.add(Permission.storage);
    }
    if(!await Permission.photos.isGranted){
      permissions.add(Permission.photos);
    }
    if(!await Permission.camera.isGranted){
      permissions.add(Permission.camera);
    }
    if(permissions.length > 0){
      if(!Constant.SDCARD_DALOG){
        Constant.SDCARD_DALOG = true;
        bool _bool = true;
        await showSdCardPermissionDialog(context,callback: () async{
          Map<Permission,PermissionStatus> status = await permissions.request();
          for(Permission key in status.keys){
            if(!await key.isGranted){
              _bool = false;
              break;
            }
          }
          callback(_bool);
        });
      }else{
        callback(false);
      }
    }else{
      print("存储相机相册权限已经申请");
      callback(true);
    }
  }

  /*********************UI相关*****************/
  
  void showLoadingUI(){
    showDialog(context: context,barrierDismissible: false, builder: (context){
      return StatefulBuilder(
        builder: (_context,_state){
          return Container(
            decoration: BoxDecoration(
              color: Colors.black38
            ),
            alignment: Alignment.center,
            child: Container(
              width: ScreenUtil().setWidth(600),
              height: ScreenUtil().setHeight(300),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.white
              ),
              alignment: Alignment.center,
              child: Text("正在准备资源文件",style: TextStyle(fontSize: ScreenUtil().setSp(32),color: Colors.black87),),
            )
          );
        },
      );
    });
  }

  /**
   * 普通标题
   */
  Widget TitleView(String title,CB_Class cb){
    return _getTitleView(title,true,cb);
  }

  /**
   * 显示带有更多的标题
   */
  Widget TitleMoreView(String title,CB_Class cb){
    return _getTitleView(title, false, cb);
  }

  /**
   * 创建页面顶部标题栏
   * ismore是否显示更多
   */
  Widget _getTitleView(String title,bool ismore,CB_Class cb){
    return Container(
      height:!ismore ? ScreenUtil().setHeight(Constant.SIZE_TOP_HEIGHT) : ScreenUtil().setHeight(Constant.SIZE_TITLE_NORMAL_HEIGHT),
      decoration: BoxDecoration(
        color: Colors.grey[100]
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            child: Container(
              width: 40,
              height:40,
              margin: EdgeInsets.only(left:ScreenUtil().setWidth(15),top: ScreenUtil().setHeight(15),bottom: ScreenUtil().setHeight(15)),
              child: Icon(
                Icons.arrow_back,
                size: 20,
              ),
            ),
            onTap: (){
              if(cb != null){
                cb.callback();
              }
            },
          ),
          Container(
            alignment: Alignment(0,0),
            child: Text(
              title,
              style: TextStyle(color:Colors.grey,fontSize: ScreenUtil().setSp(30),fontWeight: FontWeight.normal,decoration: TextDecoration.none),
            ),
          ),
          // 显示更多
          Offstage(
            offstage: ismore,
            child: Container(
              width: 30,
              height: 30,
              margin: EdgeInsets.only(top: ScreenUtil().setHeight(10),bottom: ScreenUtil().setHeight(10),right: ScreenUtil().setWidth(30)),
              child: InkWell(
                child: Image.asset("image/ic_more.png",),
                onTap: (){
                  cb.moreFun();
                },
              ),
            )

          )
        ],
      ),
    );
  }

  var _inputWord;
  void _txtInputChange(String word){
    this._inputWord = word;
  }

  /**
   * 显示弹框
   */
  showAlertDialog(BuildContext context,{String title,Function cb}){
    showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: Text(
              title,
              style: TextStyle(
                color: Colors.black,
                fontSize: ScreenUtil().setSp(70),
                fontWeight: FontWeight.bold
              ),
            ),
            content: Container(
              padding: EdgeInsets.only(top: ScreenUtil().setHeight(10),bottom: ScreenUtil().setHeight(10),),
              child: TextField(
                onChanged: _txtInputChange,
                maxLength: 20,
                keyboardType: TextInputType.text,
                maxLines: 1,
                decoration: InputDecoration(
                  hintText: "请输入内容"
                ),
              ),
            ),
            actions: [
              TextButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  child: Text("取消")
              ),
              TextButton(
                  onPressed: (){
                    if(this._inputWord == null || this._inputWord.length == 0){
                      showToast("请输入正确的名字");
                    }else{
                      cb(this._inputWord);
                    }
                    Navigator.pop(context);
                  },
                  child: Text("确定")
              )
            ],
          );
        }
    );
  }

  /**
   * 提示框
   */
  showAlertTips(BuildContext context,String tips,Function cb_ok){
    showDialog(context: context, builder: (BuildContext context){
      return AlertDialog(
        content: Text(tips),
        actions: [
          TextButton(onPressed: (){
            Navigator.pop(context);
          }, child: Text("取消")),
          TextButton(onPressed: (){
            cb_ok();
            Navigator.pop(context);
          },child: Text("确定"),)
        ],
      );
    });
  }

  /**
   * 追踪用户记录
   */
  void saveTrackVideo(int subjectid,int categoryid){
    var option = {
      "subjectid":subjectid,
      "categoryid":categoryid
    };
    httpUtil.post(DataUtils.api_trackvideo,data:option).then((value){

    }).catchError((e){
      showToast(e);
    });
  }

  /**
   * 英文单词查询
   */
  Future<String> queryEgWord() async{
    var word = "";
    await httpUtil.get(DataUtils.api_queryegword).then((value){
      var wordBean = EgWordBean.fromJson(json.decode(value));
      if(wordBean.errno == 0){
        word = wordBean.data[0].content;
      }else{
        showToast(wordBean.errmsg);
      }
    }).catchError((e){
      print("err:$e");
    });
    return word;
  }

  /**
   * 获取单词词组
   */
  Future<String> queryEgWordGroup() async{
    var word = "";
    await httpUtil.get(DataUtils.api_queryegwordgroup).then((value){
      var wordBean = EgWordBean.fromJson(json.decode(value));
      if(wordBean.errno == 0){
        word = wordBean.data[0].content;
      }else{
        showToast(wordBean.errmsg);
      }
    }).catchError((e){
      print("err:$e");
    });
    return word;
  }

  void showPolicyDialog(BuildContext context,{callback:Function}) async{
    isShowDialog = true;
    await showDialog(context: context,barrierDismissible: false, builder: (BuildContext _context){
      return StatefulBuilder(
        builder: (_context,_state){
         return AlertDialog(
           contentPadding: EdgeInsets.all(0),
           content: SingleChildScrollView(
             child: Container(
                 width: ScreenUtil().setWidth(300),
                 height:ScreenUtil().setHeight(600),
                 decoration: BoxDecoration(
                     borderRadius: BorderRadius.all(Radius.circular(ScreenUtil().setWidth(10)))
                 ),
                 child: Column(
                   crossAxisAlignment: CrossAxisAlignment.center,
                   children: [
                     Padding(
                       padding: EdgeInsets.only(
                           top: ScreenUtil().setHeight(40),
                           bottom:ScreenUtil().setHeight(40)
                       ),
                       child: Text("服务协议和隐私政策",style: TextStyle(fontSize: ScreenUtil().setSp(36),color: Colors.black54),),
                     ),
                     Container(
                       padding: EdgeInsets.only(
                           left: ScreenUtil().setWidth(40),
                           right:ScreenUtil().setWidth(40)
                       ),
                       child: RichText(
                           text: TextSpan(
                               children: [
                                 TextSpan(
                                     text:"请你务必审慎阅读、充分理解\"服务协议\"和\"隐私政策\"各条款，包括但不限于为了向你提供资料、内容发布等服务，我们需要收集你的设备信息、操作日志等个人信息，你可以在"+
                                         "\"我的\"中查看本隐私条款。你可以阅读",
                                     style:TextStyle(color: Colors.black54,fontSize: ScreenUtil().setSp(30),wordSpacing: 20,letterSpacing: 2)
                                 ),
                                 TextSpan(
                                     text: "《服务协议》",
                                     recognizer: TapGestureRecognizer()
                                       ..onTap = (){
                                         Navigator.push(context, MaterialPageRoute(builder: (context) =>
                                             WebStage(url: 'http://res.yimios.com:9050/html/privacy.html', title: "艺画美术app隐私协议")
                                         ));
                                       },
                                     style: TextStyle(color:Colors.blueAccent,fontSize: ScreenUtil().setSp(30))
                                 ),
                                 TextSpan(
                                     text:",",
                                     style: TextStyle(color:Colors.black54,fontSize: ScreenUtil().setSp(30))
                                 ),
                                 TextSpan(
                                     text: "《隐私协议》",
                                     recognizer: TapGestureRecognizer()
                                       ..onTap = (){
                                         Navigator.push(context, MaterialPageRoute(builder: (context) =>
                                             WebStage(url: 'http://res.yimios.com:9050/html/policy.html', title: "艺画美术app隐私协议")
                                         ));
                                       },
                                     style: TextStyle(color:Colors.blueAccent,fontSize: ScreenUtil().setSp(30))
                                 ),
                                 TextSpan(
                                     text: "了解详细信息，如你同意，请点击\"同意\"开始接受我们的服务。",
                                     style: TextStyle(color:Colors.black54,fontSize: ScreenUtil().setSp(30))
                                 )
                               ]
                           )),
                     ),

                   ],
                 )
             ),
           ),
           actions: [
             TextButton(onPressed: (){
               isShowDialog = false;
               exit(0);
             }, child: Text("暂不同意")),
             TextButton(onPressed: (){
               isShowDialog = false;
               savePolicy().then((value) {
                 print("savePolicy: $value");
                 if(callback != null){
                   callback();
                 }
                 Navigator.pop(context);
               });
             },child: Text("同意"),)
           ],
         );
        }
      );
    });
  }

  /**
   * 读取设备手机号
   */
  void showPhonePermissionDialog(BuildContext context,{callback:Function}) async{
    isShowDialog = true;
    await showDialog(context: context,barrierDismissible: false, builder: (BuildContext _context){
      return StatefulBuilder(
          builder: (_context,_state){
            return AlertDialog(
              contentPadding: EdgeInsets.all(0),
              content: SingleChildScrollView(
                child: Container(
                    width: ScreenUtil().setWidth(300),
                    height:ScreenUtil().setHeight(300),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(ScreenUtil().setWidth(10)))
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                              top: ScreenUtil().setHeight(40),
                              bottom:ScreenUtil().setHeight(40)
                          ),
                          child: Text("艺画美术将会用到您的电话权限",style: TextStyle(fontSize: ScreenUtil().setSp(36),color: Colors.black54),),
                        ),
                        Container(
                          padding: EdgeInsets.only(
                              left: ScreenUtil().setWidth(40),
                              right:ScreenUtil().setWidth(40)
                          ),
                          child: RichText(
                              text: TextSpan(
                                  children: [
                                    TextSpan(
                                        text:"用于读取设备硬件信息，判断账户与设备的关联关系，通过技术与风控规则提高登录与交易安全性。",
                                        style:TextStyle(color: Colors.black54,fontSize: ScreenUtil().setSp(30),wordSpacing: 20,letterSpacing: 2)
                                    ),
                                    /*TextSpan(
                                        text: "《服务协议》",
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = (){
                                            Navigator.push(context, MaterialPageRoute(builder: (context) =>
                                                WebStage(url: 'http://res.yimios.com:9050/html/privacy.html', title: "艺画美术app隐私协议")
                                            ));
                                          },
                                        style: TextStyle(color:Colors.blueAccent,fontSize: ScreenUtil().setSp(30))
                                    ),
                                    TextSpan(
                                        text:",",
                                        style: TextStyle(color:Colors.black54,fontSize: ScreenUtil().setSp(30))
                                    ),
                                    TextSpan(
                                        text: "《隐私协议》",
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = (){
                                            Navigator.push(context, MaterialPageRoute(builder: (context) =>
                                                WebStage(url: 'http://res.yimios.com:9050/html/policy.html', title: "艺画美术app隐私协议")
                                            ));
                                          },
                                        style: TextStyle(color:Colors.blueAccent,fontSize: ScreenUtil().setSp(30))
                                    ),
                                    TextSpan(
                                        text: "了解详细信息，如你同意，请点击\"同意\"开始接受我们的服务。",
                                        style: TextStyle(color:Colors.black54,fontSize: ScreenUtil().setSp(30))
                                    )*/
                                  ]
                              )),
                        ),

                      ],
                    )
                ),
              ),
              actions: [
                /*TextButton(onPressed: (){
                  isShowDialog = false;
                  exit(0);
                }, child: Text("暂不同意")),*/
                TextButton(onPressed: (){
                  isShowDialog = false;
                  savePolicy().then((value) {
                    print("savePolicy: $value");
                    if(callback != null){
                      callback();
                    }
                    Navigator.pop(context);
                  });
                },child: Text("我知道了"),)
              ],
            );
          }
      );
    });
  }

  /**
   * 存储权限说明
   */
  void showSdCardPermissionDialog(BuildContext context,{callback:Function}) async{
    isShowDialog = true;
    await showDialog(context: context,barrierDismissible: false, builder: (BuildContext _context){
      return StatefulBuilder(
          builder: (_context,_state){
            return AlertDialog(
              contentPadding: EdgeInsets.all(0),
              content: SingleChildScrollView(
                child: Container(
                    width: ScreenUtil().setWidth(300),
                    height:ScreenUtil().setHeight(300),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(ScreenUtil().setWidth(10)))
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                              top: ScreenUtil().setHeight(40),
                              bottom:ScreenUtil().setHeight(40)
                          ),
                          child: Text("设备权限使用说明",style: TextStyle(fontSize: ScreenUtil().setSp(36),color: Colors.black54),),
                        ),
                        Container(
                          padding: EdgeInsets.only(
                              left: ScreenUtil().setWidth(40),
                              right:ScreenUtil().setWidth(40)
                          ),
                          child: RichText(
                              text: TextSpan(
                                  children: [
                                    TextSpan(
                                        text:"需要访问设备的存储权限进行图片保存等读取行为，请点允许。",
                                        style:TextStyle(color: Colors.black54,fontSize: ScreenUtil().setSp(30),wordSpacing: 20,letterSpacing: 2)
                                    ),
                                    /*TextSpan(
                                        text: "《服务协议》",
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = (){
                                            Navigator.push(context, MaterialPageRoute(builder: (context) =>
                                                WebStage(url: 'http://res.yimios.com:9050/html/privacy.html', title: "艺画美术app隐私协议")
                                            ));
                                          },
                                        style: TextStyle(color:Colors.blueAccent,fontSize: ScreenUtil().setSp(30))
                                    ),
                                    TextSpan(
                                        text:",",
                                        style: TextStyle(color:Colors.black54,fontSize: ScreenUtil().setSp(30))
                                    ),
                                    TextSpan(
                                        text: "《隐私协议》",
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = (){
                                            Navigator.push(context, MaterialPageRoute(builder: (context) =>
                                                WebStage(url: 'http://res.yimios.com:9050/html/policy.html', title: "艺画美术app隐私协议")
                                            ));
                                          },
                                        style: TextStyle(color:Colors.blueAccent,fontSize: ScreenUtil().setSp(30))
                                    ),
                                    TextSpan(
                                        text: "了解详细信息，如你同意，请点击\"同意\"开始接受我们的服务。",
                                        style: TextStyle(color:Colors.black54,fontSize: ScreenUtil().setSp(30))
                                    )*/
                                  ]
                              )),
                        ),

                      ],
                    )
                ),
              ),
              actions: [
                /*TextButton(onPressed: (){
                  isShowDialog = false;
                  exit(0);
                }, child: Text("暂不同意")),*/
                TextButton(onPressed: (){
                  isShowDialog = false;
                  if(callback != null){
                    callback();
                  }
                  Navigator.pop(context);
                },child: Text("允许"),)
              ],
            );
          }
      );
    });
  }

  /**
   * 广告组件
   */
  Widget createAdvert(String url,String weburl,int height){
    return Container(
      height: ScreenUtil().setHeight(SizeUtil.getHeight(height.toDouble())),
      width: double.infinity,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(ScreenUtil().setWidth(10)),
          color: Colors.white
      ),
      margin: EdgeInsets.only(
          left: ScreenUtil().setWidth(SizeUtil.getWidth(20)),
          right: ScreenUtil().setWidth(SizeUtil.getWidth(20)),
          top: ScreenUtil().setHeight(SizeUtil.getHeight(10)),
          bottom: ScreenUtil().setHeight(SizeUtil.getHeight(20))
      ),
      child: InkWell(
        onTap: (){
          //
          Navigator.push(context, MaterialPageRoute(builder: (context) =>
              WebStage(url: weburl, title: "")
          ));
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: Image.network(url,fit:BoxFit.cover),
        ),
      ),
    );
  }

  String subWord(String word,int length){
    if(word == null || word.length == 0) return "";
    if(word.length < length) return word;
    return word.substring(0,length)+"...";
  }

  /**
   * 单张banner
   */
  Widget bannerSingleWidget(String path,{double horizontal=40,double vertical:20}){
    return Container(
      width: double.infinity,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: SizeUtil.getAppWidth(horizontal),
          vertical:SizeUtil.getAppHeight(vertical),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(SizeUtil.getAppWidth(10)),
          child: Image.asset(path,height: SizeUtil.getAppHeight(SizeUtil.getBannerHeight()),fit: BoxFit.cover,),
        ),
      ),
    );
  }

  Widget backArrowWidget(){
    return Container(
      padding: EdgeInsets.only(left: ScreenUtil().setWidth(20),top: ScreenUtil().setHeight(20),bottom: ScreenUtil().setHeight(20),right: ScreenUtil().setWidth(20)),
      child: Icon(
        Icons.arrow_back,
        size: 24,
      )
    );
  }

  @override
  Widget build(BuildContext context) {

  }

}