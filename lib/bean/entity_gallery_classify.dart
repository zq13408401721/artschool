import 'dart:convert' show json;


class GalleryClassify {
  int errno;
  List<GalleryClassifyData> data;
  String errmsg;

  GalleryClassify({this.errno, this.data, this.errmsg});

  GalleryClassify.fromJson(Map<String, dynamic> json) {
    errno = json['errno'];
    if (json['data'] != null) {
      data = new List<GalleryClassifyData>();(json['data'] as List).forEach((v) { data.add(new GalleryClassifyData.fromJson(v)); });
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
  static List<GalleryClassify> formList(dynamic data, [String sub]) {
    List<GalleryClassify> ll = [];

    try {
      var jsonArray;
      if (data is String) {
        jsonArray = sub == null ? json.decode(data) : json.decode(data)[sub];
      } else {
        jsonArray = sub == null ? data : data[sub];
      }

      if (jsonArray != null)
        for (var json in jsonArray) {
          ll.add(GalleryClassify.fromJson(json));
        }
    } catch (e) {
      print('json解析错误，错误类型：${e.runtimeType}');
    }

    return ll;
  }


  /// 解析对象json
  /// sub 解析data其子项
  factory GalleryClassify.facJson(data, [String sub]) {
    if (data == null) return null;

    try {
      var jsonObj;
      if (data is String) {
        jsonObj = sub == null ? json.decode(data) : json.decode(data)[sub];
      } else {
        jsonObj = sub == null ? data : data[sub];
      }
      if (jsonObj != null) return GalleryClassify.fromJson(jsonObj);
    } catch (e) {
      print('json解析错误，错误类型：${e.runtimeType}');
    }

    return null;
  }
}

class GalleryClassifyData {
  List<GalleryClassifyDataCategory> categorys;
  String categoryname;
  int categoryid;

  GalleryClassifyData({this.categorys, this.categoryname, this.categoryid});

  GalleryClassifyData.fromJson(Map<String, dynamic> json) {
    if (json['categorys'] != null) {
      categorys = new List<GalleryClassifyDataCategory>();(json['categorys'] as List).forEach((v) { categorys.add(new GalleryClassifyDataCategory.fromJson(v)); });
    }
    categoryname = json['categoryname'];
    categoryid = json['categoryid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.categorys != null) {
      data['categorys'] =  this.categorys.map((v) => v.toJson()).toList();
    }
    data['categoryname'] = this.categoryname;
    data['categoryid'] = this.categoryid;
    return data;
  }

  /// 解析数组json
  /// sub 解析data其子项
  /// sub == null, data 必须是数组的json
  /// sub != null, data 必须是map的json
  static List<GalleryClassifyData> formList(dynamic data, [String sub]) {
    List<GalleryClassifyData> ll = [];

    try {
      var jsonArray;
      if (data is String) {
        jsonArray = sub == null ? json.decode(data) : json.decode(data)[sub];
      } else {
        jsonArray = sub == null ? data : data[sub];
      }

      if (jsonArray != null)
        for (var json in jsonArray) {
          ll.add(GalleryClassifyData.fromJson(json));
        }
    } catch (e) {
      print('json解析错误，错误类型：${e.runtimeType}');
    }

    return ll;
  }


  /// 解析对象json
  /// sub 解析data其子项
  factory GalleryClassifyData.facJson(data, [String sub]) {
    if (data == null) return null;

    try {
      var jsonObj;
      if (data is String) {
        jsonObj = sub == null ? json.decode(data) : json.decode(data)[sub];
      } else {
        jsonObj = sub == null ? data : data[sub];
      }
      if (jsonObj != null) return GalleryClassifyData.fromJson(jsonObj);
    } catch (e) {
      print('json解析错误，错误类型：${e.runtimeType}');
    }

    return null;
  }
}

class GalleryClassifyDataCategory {
  String cover;
  dynamic date;
  String name;
  dynamic description;
  int id;
  int sort;

  GalleryClassifyDataCategory({this.cover, this.date, this.name, this.description, this.id, this.sort});

  GalleryClassifyDataCategory.fromJson(Map<String, dynamic> json) {
    cover = json['cover'];
    date = json['date'];
    name = json['name'];
    description = json['description'];
    id = json['id'];
    sort = json['sort'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cover'] = this.cover;
    data['date'] = this.date;
    data['name'] = this.name;
    data['description'] = this.description;
    data['id'] = this.id;
    data['sort'] = this.sort;
    return data;
  }

  /// 解析数组json
  /// sub 解析data其子项
  /// sub == null, data 必须是数组的json
  /// sub != null, data 必须是map的json
  static List<GalleryClassifyDataCategory> formList(dynamic data, [String sub]) {
    List<GalleryClassifyDataCategory> ll = [];

    try {
      var jsonArray;
      if (data is String) {
        jsonArray = sub == null ? json.decode(data) : json.decode(data)[sub];
      } else {
        jsonArray = sub == null ? data : data[sub];
      }

      if (jsonArray != null)
        for (var json in jsonArray) {
          ll.add(GalleryClassifyDataCategory.fromJson(json));
        }
    } catch (e) {
      print('json解析错误，错误类型：${e.runtimeType}');
    }

    return ll;
  }


  /// 解析对象json
  /// sub 解析data其子项
  factory GalleryClassifyDataCategory.facJson(data, [String sub]) {
    if (data == null) return null;

    try {
      var jsonObj;
      if (data is String) {
        jsonObj = sub == null ? json.decode(data) : json.decode(data)[sub];
      } else {
        jsonObj = sub == null ? data : data[sub];
      }
      if (jsonObj != null) return GalleryClassifyDataCategory.fromJson(jsonObj);
    } catch (e) {
      print('json解析错误，错误类型：${e.runtimeType}');
    }

    return null;
  }
}
