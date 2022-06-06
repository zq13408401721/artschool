import 'dart:convert' show json;


class HomeBean {
  int errno;
  List<HomeBeanData> data;
  String errmsg;

  HomeBean({this.errno, this.data, this.errmsg});

  HomeBean.fromJson(Map<String, dynamic> json) {
    errno = json['errno'];
    if (json['data'] != null) {
      data = new List<HomeBeanData>();(json['data'] as List).forEach((v) { data.add(new HomeBeanData.fromJson(v)); });
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
  static List<HomeBean> formList(dynamic data, [String sub]) {
    List<HomeBean> ll = [];

    try {
      var jsonArray;
      if (data is String) {
        jsonArray = sub == null ? json.decode(data) : json.decode(data)[sub];
      } else {
        jsonArray = sub == null ? data : data[sub];
      }

      if (jsonArray != null)
        for (var json in jsonArray) {
          ll.add(HomeBean.fromJson(json));
        }
    } catch (e) {
      print('json解析错误，错误类型：${e.runtimeType}');
    }

    return ll;
  }


  /// 解析对象json
  /// sub 解析data其子项
  factory HomeBean.facJson(data, [String sub]) {
    if (data == null) return null;

    try {
      var jsonObj;
      if (data is String) {
        jsonObj = sub == null ? json.decode(data) : json.decode(data)[sub];
      } else {
        jsonObj = sub == null ? data : data[sub];
      }
      if (jsonObj != null) return HomeBean.fromJson(jsonObj);
    } catch (e) {
      print('json解析错误，错误类型：${e.runtimeType}');
    }

    return null;
  }
}

class HomeBeanData {
  List<HomeBeanDataCategory> categorys;
  String categoryname;

  HomeBeanData({this.categorys, this.categoryname});

  HomeBeanData.fromJson(Map<String, dynamic> json) {
    if (json['categorys'] != null) {
      categorys = new List<HomeBeanDataCategory>();(json['categorys'] as List).forEach((v) { categorys.add(new HomeBeanDataCategory.fromJson(v)); });
    }
    categoryname = json['categoryname'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.categorys != null) {
      data['categorys'] =  this.categorys.map((v) => v.toJson()).toList();
    }
    data['categoryname'] = this.categoryname;
    return data;
  }

  /// 解析数组json
  /// sub 解析data其子项
  /// sub == null, data 必须是数组的json
  /// sub != null, data 必须是map的json
  static List<HomeBeanData> formList(dynamic data, [String sub]) {
    List<HomeBeanData> ll = [];

    try {
      var jsonArray;
      if (data is String) {
        jsonArray = sub == null ? json.decode(data) : json.decode(data)[sub];
      } else {
        jsonArray = sub == null ? data : data[sub];
      }

      if (jsonArray != null)
        for (var json in jsonArray) {
          ll.add(HomeBeanData.fromJson(json));
        }
    } catch (e) {
      print('json解析错误，错误类型：${e.runtimeType}');
    }

    return ll;
  }


  /// 解析对象json
  /// sub 解析data其子项
  factory HomeBeanData.facJson(data, [String sub]) {
    if (data == null) return null;

    try {
      var jsonObj;
      if (data is String) {
        jsonObj = sub == null ? json.decode(data) : json.decode(data)[sub];
      } else {
        jsonObj = sub == null ? data : data[sub];
      }
      if (jsonObj != null) return HomeBeanData.fromJson(jsonObj);
    } catch (e) {
      print('json解析错误，错误类型：${e.runtimeType}');
    }

    return null;
  }
}

class HomeBeanDataCategory {
  String cover;
  String name;
  List<HomeBeanDataCategorysVideo> videos;
  int id;

  HomeBeanDataCategory({this.cover, this.name, this.videos, this.id});

  HomeBeanDataCategory.fromJson(Map<String, dynamic> json) {
    cover = json['cover'];
    name = json['name'];
    if (json['videos'] != null) {
      videos = new List<HomeBeanDataCategorysVideo>();(json['videos'] as List).forEach((v) { videos.add(new HomeBeanDataCategorysVideo.fromJson(v)); });
    }
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cover'] = this.cover;
    data['name'] = this.name;
    if (this.videos != null) {
      data['videos'] =  this.videos.map((v) => v.toJson()).toList();
    }
    data['id'] = this.id;
    return data;
  }

  /// 解析数组json
  /// sub 解析data其子项
  /// sub == null, data 必须是数组的json
  /// sub != null, data 必须是map的json
  static List<HomeBeanDataCategory> formList(dynamic data, [String sub]) {
    List<HomeBeanDataCategory> ll = [];

    try {
      var jsonArray;
      if (data is String) {
        jsonArray = sub == null ? json.decode(data) : json.decode(data)[sub];
      } else {
        jsonArray = sub == null ? data : data[sub];
      }

      if (jsonArray != null)
        for (var json in jsonArray) {
          ll.add(HomeBeanDataCategory.fromJson(json));
        }
    } catch (e) {
      print('json解析错误，错误类型：${e.runtimeType}');
    }

    return ll;
  }


  /// 解析对象json
  /// sub 解析data其子项
  factory HomeBeanDataCategory.facJson(data, [String sub]) {
    if (data == null) return null;

    try {
      var jsonObj;
      if (data is String) {
        jsonObj = sub == null ? json.decode(data) : json.decode(data)[sub];
      } else {
        jsonObj = sub == null ? data : data[sub];
      }
      if (jsonObj != null) return HomeBeanDataCategory.fromJson(jsonObj);
    } catch (e) {
      print('json解析错误，错误类型：${e.runtimeType}');
    }

    return null;
  }
}

class HomeBeanDataCategorysVideo {
  dynamic ccid;
  String name;
  int id;
  dynamic time;
  dynamic sort;
  String url;

  HomeBeanDataCategorysVideo({this.ccid, this.name, this.id, this.time, this.sort, this.url});

  HomeBeanDataCategorysVideo.fromJson(Map<String, dynamic> json) {
    ccid = json['ccid'];
    name = json['name'];
    id = json['id'];
    time = json['time'];
    sort = json['sort'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ccid'] = this.ccid;
    data['name'] = this.name;
    data['id'] = this.id;
    data['time'] = this.time;
    data['sort'] = this.sort;
    data['url'] = this.url;
    return data;
  }

  /// 解析数组json
  /// sub 解析data其子项
  /// sub == null, data 必须是数组的json
  /// sub != null, data 必须是map的json
  static List<HomeBeanDataCategorysVideo> formList(dynamic data, [String sub]) {
    List<HomeBeanDataCategorysVideo> ll = [];

    try {
      var jsonArray;
      if (data is String) {
        jsonArray = sub == null ? json.decode(data) : json.decode(data)[sub];
      } else {
        jsonArray = sub == null ? data : data[sub];
      }

      if (jsonArray != null)
        for (var json in jsonArray) {
          ll.add(HomeBeanDataCategorysVideo.fromJson(json));
        }
    } catch (e) {
      print('json解析错误，错误类型：${e.runtimeType}');
    }

    return ll;
  }


  /// 解析对象json
  /// sub 解析data其子项
  factory HomeBeanDataCategorysVideo.facJson(data, [String sub]) {
    if (data == null) return null;

    try {
      var jsonObj;
      if (data is String) {
        jsonObj = sub == null ? json.decode(data) : json.decode(data)[sub];
      } else {
        jsonObj = sub == null ? data : data[sub];
      }
      if (jsonObj != null) return HomeBeanDataCategorysVideo.fromJson(jsonObj);
    } catch (e) {
      print('json解析错误，错误类型：${e.runtimeType}');
    }

    return null;
  }
}
