import 'dart:convert' show json;


class VideoList {
  int errno;
  List<VideoListData> data;
  Info info;
  String errmsg;

  VideoList({this.errno, this.data, this.errmsg});

  VideoList.fromJson(Map<String, dynamic> json) {
    errno = json['errno'];
    if (json['data'] != null) {
      data = new List<VideoListData>();(json['data']['result'] as List).forEach((v) { data.add(new VideoListData.fromJson(v)); });
      info = Info.fromJson(json['data']['info']);
    }
    errmsg = json['errmsg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['errno'] = this.errno;
    if (this.data != null) {
      data['data'] =  this.data.map((v) => v.toJson()).toList();
    }
    data['errmsg'] = this.errmsg;
    return data;
  }

  /// 解析数组json
  /// sub 解析data其子项
  /// sub == null, data 必须是数组的json
  /// sub != null, data 必须是map的json
  static List<VideoList> formList(dynamic data, [String sub]) {
    List<VideoList> ll = [];

    try {
      var jsonArray;
      if (data is String) {
        jsonArray = sub == null ? json.decode(data) : json.decode(data)[sub];
      } else {
        jsonArray = sub == null ? data : data[sub];
      }

      if (jsonArray != null)
        for (var json in jsonArray) {
          ll.add(VideoList.fromJson(json));
        }
    } catch (e) {
      print('json解析错误，错误类型：${e.runtimeType}');
    }

    return ll;
  }


  /// 解析对象json
  /// sub 解析data其子项
  factory VideoList.facJson(data, [String sub]) {
    if (data == null) return null;

    try {
      var jsonObj;
      if (data is String) {
        jsonObj = sub == null ? json.decode(data) : json.decode(data)[sub];
      } else {
        jsonObj = sub == null ? data : data[sub];
      }
      if (jsonObj != null) return VideoList.fromJson(jsonObj);
    } catch (e) {
      print('json解析错误，错误类型：${e.runtimeType}');
    }

    return null;
  }
}

class Info{
  String classify;
  String section;
  String category;
  String desc;

  Info({this.classify,this.section,this.category,this.desc});

  Info.fromJson(Map<String,dynamic> json){
    classify = json['calssify'];
    section = json['section'];
    category = json['category'];
    desc = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['classify'] = this.classify;
    data['section'] = this.section;
    data['category'] = this.category;
    data['desc'] = this.desc;
    return data;
  }

}

class VideoListData {
  dynamic ccid;
  String name;
  int id;
  dynamic time;
  dynamic sort;
  String url;
  int categoryid;

  VideoListData({this.ccid, this.name, this.id, this.time, this.sort, this.url, this.categoryid});

  VideoListData.fromJson(Map<String, dynamic> json) {
    ccid = json['ccid'];
    name = json['name'];
    id = json['id'];
    time = json['time'];
    sort = json['sort'];
    url = json['url'];
    categoryid = json['categoryid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ccid'] = this.ccid;
    data['name'] = this.name;
    data['id'] = this.id;
    data['time'] = this.time;
    data['sort'] = this.sort;
    data['url'] = this.url;
    data['categoryid'] = this.categoryid;
    return data;
  }

  /// 解析数组json
  /// sub 解析data其子项
  /// sub == null, data 必须是数组的json
  /// sub != null, data 必须是map的json
  static List<VideoListData> formList(dynamic data, [String sub]) {
    List<VideoListData> ll = [];

    try {
      var jsonArray;
      if (data is String) {
        jsonArray = sub == null ? json.decode(data) : json.decode(data)[sub];
      } else {
        jsonArray = sub == null ? data : data[sub];
      }

      if (jsonArray != null)
        for (var json in jsonArray) {
          ll.add(VideoListData.fromJson(json));
        }
    } catch (e) {
      print('json解析错误，错误类型：${e.runtimeType}');
    }

    return ll;
  }


  /// 解析对象json
  /// sub 解析data其子项
  factory VideoListData.facJson(data, [String sub]) {
    if (data == null) return null;

    try {
      var jsonObj;
      if (data is String) {
        jsonObj = sub == null ? json.decode(data) : json.decode(data)[sub];
      } else {
        jsonObj = sub == null ? data : data[sub];
      }
      if (jsonObj != null) return VideoListData.fromJson(jsonObj);
    } catch (e) {
      print('json解析错误，错误类型：${e.runtimeType}');
    }

    return null;
  }
}
