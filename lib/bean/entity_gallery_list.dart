import 'dart:convert' show json;


class GalleryList {
  int errno;
  List<GalleryListData> data;
  String errmsg;

  GalleryList({this.errno, this.data, this.errmsg});

  GalleryList.fromJson(Map<String, dynamic> json) {
    errno = json['errno'];
    if (json['data'] != null) {
      data = new List<GalleryListData>();(json['data'] as List).forEach((v) { data.add(new GalleryListData.fromJson(v)); });
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
  static List<GalleryList> formList(dynamic data, [String sub]) {
    List<GalleryList> ll = [];

    try {
      var jsonArray;
      if (data is String) {
        jsonArray = sub == null ? json.decode(data) : json.decode(data)[sub];
      } else {
        jsonArray = sub == null ? data : data[sub];
      }

      if (jsonArray != null)
        for (var json in jsonArray) {
          ll.add(GalleryList.fromJson(json));
        }
    } catch (e) {
      print('json解析错误，错误类型：${e.runtimeType}');
    }

    return ll;
  }


  /// 解析对象json
  /// sub 解析data其子项
  factory GalleryList.facJson(data, [String sub]) {
    if (data == null) return null;

    try {
      var jsonObj;
      if (data is String) {
        jsonObj = sub == null ? json.decode(data) : json.decode(data)[sub];
      } else {
        jsonObj = sub == null ? data : data[sub];
      }
      if (jsonObj != null) return GalleryList.fromJson(jsonObj);
    } catch (e) {
      print('json解析错误，错误类型：${e.runtimeType}');
    }

    return null;
  }
}

class GalleryListData {
  dynamic date;
  String name;
  int id;
  dynamic sort;
  String url;
  int categoryid;
  String word;
  int width,height,maxwidth,maxheight;
  String markname,comments;
  String editorurl;

  GalleryListData({this.date, this.name, this.id, this.sort, this.url, this.categoryid,this.width,this.height,this.maxwidth,this.maxheight,this.markname,this.comments,this.editorurl});

  GalleryListData.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    name = json['name'];
    id = json['id'];
    sort = json['sort'];
    url = json['url'];
    categoryid = json['categoryid'];
    word = json['word'];
    width = json['width'];
    height = json['height'];
    markname = json['markname'];
    comments = json['comments'];
    editorurl = json['editorurl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    data['name'] = this.name;
    data['id'] = this.id;
    data['sort'] = this.sort;
    data['url'] = this.url;
    data['categoryid'] = this.categoryid;
    data['word'] = this.word;
    data['width'] = this.width;
    data['height'] = this.height;
    data['markname'] = this.markname;
    data['comments'] = this.comments;
    data['editorurl'] = this.editorurl;
    return data;
  }

  /// 解析数组json
  /// sub 解析data其子项
  /// sub == null, data 必须是数组的json
  /// sub != null, data 必须是map的json
  static List<GalleryListData> formList(dynamic data, [String sub]) {
    List<GalleryListData> ll = [];

    try {
      var jsonArray;
      if (data is String) {
        jsonArray = sub == null ? json.decode(data) : json.decode(data)[sub];
      } else {
        jsonArray = sub == null ? data : data[sub];
      }

      if (jsonArray != null)
        for (var json in jsonArray) {
          ll.add(GalleryListData.fromJson(json));
        }
    } catch (e) {
      print('json解析错误，错误类型：${e.runtimeType}');
    }

    return ll;
  }


  /// 解析对象json
  /// sub 解析data其子项
  factory GalleryListData.facJson(data, [String sub]) {
    if (data == null) return null;

    try {
      var jsonObj;
      if (data is String) {
        jsonObj = sub == null ? json.decode(data) : json.decode(data)[sub];
      } else {
        jsonObj = sub == null ? data : data[sub];
      }
      if (jsonObj != null) return GalleryListData.fromJson(jsonObj);
    } catch (e) {
      print('json解析错误，错误类型：${e.runtimeType}');
    }

    return null;
  }
}
