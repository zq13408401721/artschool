import 'dart:convert' show json;


class GalleryTab {
  int errno;
  List<GalleryTabData> data;
  String errmsg;

  GalleryTab({this.errno, this.data, this.errmsg});

  GalleryTab.fromJson(Map<String, dynamic> json) {
    errno = json['errno'];
    if (json['data'] != null) {
      data = new List<GalleryTabData>();(json['data'] as List).forEach((v) { data.add(new GalleryTabData.fromJson(v)); });
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
  static List<GalleryTab> formList(dynamic data, [String sub]) {
    List<GalleryTab> ll = [];

    try {
      var jsonArray;
      if (data is String) {
        jsonArray = sub == null ? json.decode(data) : json.decode(data)[sub];
      } else {
        jsonArray = sub == null ? data : data[sub];
      }

      if (jsonArray != null)
        for (var json in jsonArray) {
          ll.add(GalleryTab.fromJson(json));
        }
    } catch (e) {
      print('json解析错误，错误类型：${e.runtimeType}');
    }

    return ll;
  }


  /// 解析对象json
  /// sub 解析data其子项
  factory GalleryTab.facJson(data, [String sub]) {
    if (data == null) return null;

    try {
      var jsonObj;
      if (data is String) {
        jsonObj = sub == null ? json.decode(data) : json.decode(data)[sub];
      } else {
        jsonObj = sub == null ? data : data[sub];
      }
      if (jsonObj != null) return GalleryTab.fromJson(jsonObj);
    } catch (e) {
      print('json解析错误，错误类型：${e.runtimeType}');
    }

    return null;
  }
}

class GalleryTabData {
  String name;
  int id;
  int sort;

  GalleryTabData({this.name, this.id, this.sort});

  GalleryTabData.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    id = json['id'];
    sort = json['sort'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['id'] = this.id;
    data['sort'] = this.sort;
    return data;
  }

  /// 解析数组json
  /// sub 解析data其子项
  /// sub == null, data 必须是数组的json
  /// sub != null, data 必须是map的json
  static List<GalleryTabData> formList(dynamic data, [String sub]) {
    List<GalleryTabData> ll = [];

    try {
      var jsonArray;
      if (data is String) {
        jsonArray = sub == null ? json.decode(data) : json.decode(data)[sub];
      } else {
        jsonArray = sub == null ? data : data[sub];
      }

      if (jsonArray != null)
        for (var json in jsonArray) {
          ll.add(GalleryTabData.fromJson(json));
        }
    } catch (e) {
      print('json解析错误，错误类型：${e.runtimeType}');
    }

    return ll;
  }


  /// 解析对象json
  /// sub 解析data其子项
  factory GalleryTabData.facJson(data, [String sub]) {
    if (data == null) return null;

    try {
      var jsonObj;
      if (data is String) {
        jsonObj = sub == null ? json.decode(data) : json.decode(data)[sub];
      } else {
        jsonObj = sub == null ? data : data[sub];
      }
      if (jsonObj != null) return GalleryTabData.fromJson(jsonObj);
    } catch (e) {
      print('json解析错误，错误类型：${e.runtimeType}');
    }

    return null;
  }
}
