import 'dart:convert' show json;


class TabBean {
  int errno;
  List<TabBeanData> data;
  String errmsg;

  TabBean({this.errno, this.data, this.errmsg});

  TabBean.fromJson(Map<String, dynamic> json) {
    errno = json['errno'];
    if (json['data'] != null) {
      data = new List<TabBeanData>();(json['data'] as List).forEach((v) { data.add(new TabBeanData.fromJson(v)); });
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
  static List<TabBean> formList(dynamic data, [String sub]) {
    List<TabBean> ll = [];

    try {
      var jsonArray;
      if (data is String) {
        jsonArray = sub == null ? json.decode(data) : json.decode(data)[sub];
      } else {
        jsonArray = sub == null ? data : data[sub];
      }

      if (jsonArray != null)
        for (var json in jsonArray) {
          ll.add(TabBean.fromJson(json));
        }
    } catch (e) {
      print('json解析错误，错误类型：${e.runtimeType}');
    }

    return ll;
  }


  /// 解析对象json
  /// sub 解析data其子项
  factory TabBean.facJson(data, [String sub]) {
    if (data == null) return null;

    try {
      var jsonObj;
      if (data is String) {
        jsonObj = sub == null ? json.decode(data) : json.decode(data)[sub];
      } else {
        jsonObj = sub == null ? data : data[sub];
      }
      if (jsonObj != null) return TabBean.fromJson(jsonObj);
    } catch (e) {
      print('json解析错误，错误类型：${e.runtimeType}');
    }

    return null;
  }
}

class TabBeanData {
  dynamic cover;
  dynamic date;
  dynamic isfinal;
  String schoolid;
  String name;
  dynamic description;
  int pid;
  int id;
  int sort;

  TabBeanData({this.cover, this.date, this.isfinal, this.schoolid, this.name, this.description, this.pid, this.id, this.sort});

  TabBeanData.fromJson(Map<String, dynamic> json) {
    cover = json['cover'];
    date = json['date'];
    isfinal = json['isfinal'];
    schoolid = json['schoolid'];
    name = json['name'];
    description = json['description'];
    pid = json['pid'];
    id = json['id'];
    sort = json['sort'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cover'] = this.cover;
    data['date'] = this.date;
    data['isfinal'] = this.isfinal;
    data['schoolid'] = this.schoolid;
    data['name'] = this.name;
    data['description'] = this.description;
    data['pid'] = this.pid;
    data['id'] = this.id;
    data['sort'] = this.sort;
    return data;
  }

  /// 解析数组json
  /// sub 解析data其子项
  /// sub == null, data 必须是数组的json
  /// sub != null, data 必须是map的json
  static List<TabBeanData> formList(dynamic data, [String sub]) {
    List<TabBeanData> ll = [];

    try {
      var jsonArray;
      if (data is String) {
        jsonArray = sub == null ? json.decode(data) : json.decode(data)[sub];
      } else {
        jsonArray = sub == null ? data : data[sub];
      }

      if (jsonArray != null)
        for (var json in jsonArray) {
          ll.add(TabBeanData.fromJson(json));
        }
    } catch (e) {
      print('json解析错误，错误类型：${e.runtimeType}');
    }

    return ll;
  }


  /// 解析对象json
  /// sub 解析data其子项
  factory TabBeanData.facJson(data, [String sub]) {
    if (data == null) return null;

    try {
      var jsonObj;
      if (data is String) {
        jsonObj = sub == null ? json.decode(data) : json.decode(data)[sub];
      } else {
        jsonObj = sub == null ? data : data[sub];
      }
      if (jsonObj != null) return TabBeanData.fromJson(jsonObj);
    } catch (e) {
      print('json解析错误，错误类型：${e.runtimeType}');
    }

    return null;
  }
}
