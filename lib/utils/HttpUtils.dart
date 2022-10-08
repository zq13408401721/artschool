import 'dart:collection';
import 'dart:io';
import 'dart:typed_data';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:yhschool/Home.dart';
import 'package:yhschool/Login.dart';
import 'package:yhschool/bean/BaseBean.dart';
import 'package:yhschool/bean/class_room_datelist_bean.dart';
import 'package:yhschool/utils/BaseParam.dart';
import 'package:yhschool/utils/Constant.dart';
import 'package:yhschool/utils/DBUtils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';


class _ResultErr{
  int _errno;
  String _errmsg;
  _ResultErr(int errno,String errmsg){
    _errno = errno;
    _errmsg = errmsg;
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['errno'] = _errno;
    map['errmsg'] = _errmsg;
    map['data'] = "";
    return map;
  }
}

/**
 * app服务器网络地址请求
 */
var netUtil = HttpUtil(
  baseUrl: "http://res.yimios.com:9060/api/",
);

/**
 * cc视频使用场景接口
 */
var ccUtil = HttpUtil(
  baseUrl:"https://api.csslcloud.net/api/",
);

/*var httpUtil = HttpUtil(
    //baseUrl:"http://server.yimios.com/api/",
    //baseUrl: "http://res.yimios.com:9060/api/", //test
    baseUrl: "http://192.168.3.12:12005/api/",
    header:headers
);*/

HttpUtil httpUtil;
HttpUtil httpIssueUpload;

var httpUtilJson = HttpUtil(
    baseUrl:"http://server.yimios.com/api/",
    header:headersJson
);

//图片上传
var httpUpload = HttpUtil(
  //baseUrl: "http://res.yimios.com:9060/api/",
  baseUrl: "http://192.168.0.194:10001/api/",
  header: headers
);

//测试网盘上传
var httpPanUpload = HttpUtil(
  baseUrl: "http://res.yimios.com:9070/api/",
  header:headers
);

// 发布功能图片上传接口地址
/*var httpIssueUpload = HttpUtil(
  //debug版 9090是目前外网版本
  baseUrl: "http://res.yimios.com:9090/api/",
  //baseUrl: "http://192.168.0.199:10001/api/",
  //正式版
  //baseUrl: "http://res.yimios.com:9070/api/",
  header: headers
);*/

//cc web视频播放器
var webPlayerUtil = HttpUtil(
  baseUrl: "http://spark.bokecc.com/api/"
);

//普通格式的header
Map<String, dynamic> headers = {
  "Accept":"application/json",
//  "Content-Type":"application/x-www-form-urlencoded",
};
//json格式的header
Map<String, dynamic> headersJson = {
  "Accept":"application/json",
  "Content-Type":"application/json; charset=UTF-8",
};

/**
 * 注册网络请求对象
 */
void registerNet(String api,String upload){
  httpUtil = HttpUtil(baseUrl: api,header: headers);
  httpIssueUpload = HttpUtil(baseUrl: upload,header: headers);
}

/**
 * 判断两个对象是否相等
 */
bool hasEquls(dynamic a,dynamic b){
  return a.toString()==b.toString();
}

/**
 * 保存图片到本地
 */
Future<String> saveImage(String url) async {

  if(url != null && url.length > 0){
    var appDocDir = await getTemporaryDirectory();
    String imgname = url.substring(url.indexOf("/"),url.length);
    String savePath = "${appDocDir.path}/${imgname}";
    File _file = File(savePath);
    bool _bool = await _file.exists();
    if(_bool) return savePath;
    var result = await Dio().download(url, savePath,onReceiveProgress: (received,total){
      if(total > 0){
        if(received == total){
          //下载完毕
          print("${url}下载完成");
        }
      }
    });
    print("图片下载返回：${result}");
    //await ImageGallerySaver.saveFile(savePath);
    //ImageGallerySaver.saveImage(imageBytes)
    return savePath;
  }
}

class HttpUtil {
  Dio dio;
  BaseOptions options;
  //网络请求控制
  Map<String,dynamic> requestSet = Map<String,dynamic>();

  HttpUtil({String baseUrl,Map<String, dynamic> header}) {
    print('dio赋值');
    // 或者通过传递一个 `options`来创建dio实例
    options = BaseOptions(
      // 请求基地址，一般为域名，可以包含路径
      baseUrl: baseUrl,
      //连接服务器超时时间，单位是毫秒.
      connectTimeout: 60000,
      //[如果返回数据是json(content-type)，dio默认会自动将数据转为json，无需再手动转](https://github.com/flutterchina/dio/issues/30)
      responseType:ResponseType.plain,
      ///  响应流上前后两次接受到数据的间隔，单位为毫秒。如果两次间隔超过[receiveTimeout]，
      ///  [Dio] 将会抛出一个[DioErrorType.RECEIVE_TIMEOUT]的异常.
      ///  注意: 这并不是接收数据的总时限.
      receiveTimeout: 30000,
      headers: header,
    );
    dio = new Dio(options);
    var cookieJar = CookieJar();
    //设计cookie
    dio.interceptors.add(CookieManager(cookieJar));
    //dio.interceptors.add()
    //dio.interceptors.add(CookieManager(CookieJar()));
  }

  Future<dynamic> get(url, {data, BaseParam option, cancelToken}) async {
    print('get请求启动! url：$url ,body: $data');
    String key;
    DBUtils db;
    if(option != null){
      var utf8Content = Utf8Encoder().convert("${url}${option.toString()}");
      var digest = md5.convert(utf8Content);
      key = hex.encode(digest.bytes);
      db = await DBUtils.dbUtils;
      if(option != null){
        try{
          String content = await db.queryAppContent(key);
          if(content != null && content.length > 0){
            return content;
          }
        }catch(e){
          print("本地数据库异常");
        }
      }
    }
    Response response;
    try {
      var prefs = await SharedPreferences.getInstance();
      var token = prefs.getString("token");
      dio.options.headers["art-token"] = token;
      response = await dio.get(
        url,
        queryParameters: option != null ? option.data : data,
        cancelToken: cancelToken,
      );
      requestSet.remove(response.requestOptions.path);
      print('get请求成功!response.data：${response.data}');
      if(option != null && response.data != null){
        await db.insertAppContent(key, response.data);
      }
      //检查返回数据，做双保险
      if(response.data == null){
        return _ResultErr(9999, "").toJson();
      }
      return response.data;
    } on DioError catch (e) {
      if(!requestSet.isEmpty){
        requestSet.clear();
      }
    }catch(e){
      if(response != null && response.data != null) return response.data;
      //检查返回数据，做双保险
      if(response.data == null){
        return _ResultErr(9999, "").toJson();
      }
    }
  }

  Future<dynamic> post(url, {data,BaseParam option, cancelToken,BuildContext context}) async {
    String key;
    DBUtils db;
    if(option != null){
      var utf8Content = Utf8Encoder().convert("${url}${option.toString()}");
      var digest = md5.convert(utf8Content);
      key = hex.encode(digest.bytes);
      db = await DBUtils.dbUtils;
      if(option != null){
        try{
          String content = await db.queryAppContent(key);
          if(content != null && content.length > 0){
            print('请求本地返回:${url}${content}');
            return content;
          }
        }catch(e){
          print("db 数据库异常");
        }
      }
    }
    Response response;
    try {
      print("url:$url");
      var prefs = await SharedPreferences.getInstance();
      var token = prefs.getString("token");
      dio.options.headers["art-token"] = token;
      response = await dio.post(
        url,
        data: option != null ? option.data : data,
      );
      requestSet.remove(response.requestOptions.path);
      if(option != null && response.data != null){
        await insertData(db, key, response.data);
      }
      //检查返回数据，做双保险
      if(response.data == null){
        return _ResultErr(9999, "").toJson();
      }
      //检查返回的类型 99999 账号在其他地方登录  99997 账号有效期到期
      //BaseBean _baseBean = BaseBean.fromJson(json.decode(response.data));
      print("$url result:${response.data.toString()}");
      return response.data.toString();
    } on DioError catch (e) {
      print("response DioError $url :${response}");
      if(!requestSet.isEmpty){
        requestSet.clear();
      }
    }catch(e){
      if(!requestSet.isEmpty){
        requestSet.clear();
      }
      print("catch $url:${response.data}");
      if(response != null && response.data != null) return response.data;
      //检查返回数据，做双保险
      if(response.data == null){
        return _ResultErr(9999, "").toJson();
      }
    }
  }

  void insertData(DBUtils db,String key,String content) async{
    await db.insertAppContent(key, content);
  }
  /**
   * 获取流数据
   */
  Future<Uint8List> getStreamData(String path, [Map<String, dynamic> params]) async {
    try {
      var response = await Dio(options).get(path,
        options: Options(responseType: ResponseType.stream),
      );
      final stream = await (response.data as ResponseBody).stream.toList();
      final result = BytesBuilder();
      for (Uint8List subList in stream) {
        result.add(subList);
      }
      return result.takeBytes();
    } on DioError catch (_) {
      rethrow;
    }
  }

  /**
   * cc请求参数签名
   */
  String ccLiveSign(Map<String,String> _map){
    var param = {};
    //对key进行排序
    _map.keys.forEach((element) {
      param[element] = _map[element];
    });
    //对请求参数进行url编码
    var queryString = "";
    param.keys.forEach((element) {
      queryString += "$element=${param[element]}&";
    });
    queryString = Uri.encodeFull(queryString);
    //跟上当前时间
    var time = (DateTime.now().microsecondsSinceEpoch/1000000).toInt();
    queryString = "${queryString}time=${time}";
    var sign = "${queryString}&salt=wQqfuG0iLgu4ofhaBMjhAKqyE0laZ3nu";
    var hash = md5.convert(Utf8Encoder().convert(sign)).bytes;
    return "${queryString}&hash=${hex.encode(hash)}";
  }

}
