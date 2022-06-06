/// errno : 0
/// errmsg : ""
/// data : [{"id":151,"schoolid":"16261880866162721ff","date":"2021-09-13","groups":[{"id":2952,"date_id":151,"name":"teacherH","tid":"23cd8a79-8b01-464f-aef9-8ea991fa3442","date":"2021-09-13 20:09:41","url":"http://res.yimios.com:9050/issue/16261880866162721ff/23cd8a79-8b01-464f-aef9-8ea991fa3442/e038319d0ce19a2058e6862fae7cee75.JPG"}],"recommend":[{"id":1,"classify":"素描","section":"石膏几何体","category":"12圆柱光影","categoryid":128,"dateid":151},{"id":2,"classify":"素描","section":"石膏几何体","category":"15多面体结构","categoryid":131,"dateid":151},{"id":3,"classify":"色彩","section":"基础知识","category":"1基础知识1","categoryid":248,"dateid":151},{"id":4,"classify":"色彩","section":"基础知识","category":"3基础知识3","categoryid":250,"dateid":151},{"id":5,"classify":"速写","section":"速写场景","category":"2卖拖把","categoryid":419,"dateid":151},{"id":6,"classify":"速写","section":"速写场景","category":"5看手机","categoryid":422,"dateid":151}]}]

class IssueClassDateBean {
  int _errno;
  String _errmsg;
  List<Data> _data;

  int get errno => _errno;
  String get errmsg => _errmsg;
  List<Data> get data => _data;

  IssueClassDateBean({
      int errno, 
      String errmsg, 
      List<Data> data}){
    _errno = errno;
    _errmsg = errmsg;
    _data = data;
}

  IssueClassDateBean.fromJson(dynamic json) {
    _errno = json['errno'];
    _errmsg = json['errmsg'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['errno'] = _errno;
    map['errmsg'] = _errmsg;
    if (_data != null) {
      map['data'] = _data.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// id : 151
/// schoolid : "16261880866162721ff"
/// date : "2021-09-13"
/// groups : [{"id":2952,"date_id":151,"name":"teacherH","tid":"23cd8a79-8b01-464f-aef9-8ea991fa3442","date":"2021-09-13 20:09:41","url":"http://res.yimios.com:9050/issue/16261880866162721ff/23cd8a79-8b01-464f-aef9-8ea991fa3442/e038319d0ce19a2058e6862fae7cee75.JPG"}]
/// recommend : [{"id":1,"classify":"素描","section":"石膏几何体","category":"12圆柱光影","categoryid":128,"dateid":151},{"id":2,"classify":"素描","section":"石膏几何体","category":"15多面体结构","categoryid":131,"dateid":151},{"id":3,"classify":"色彩","section":"基础知识","category":"1基础知识1","categoryid":248,"dateid":151},{"id":4,"classify":"色彩","section":"基础知识","category":"3基础知识3","categoryid":250,"dateid":151},{"id":5,"classify":"速写","section":"速写场景","category":"2卖拖把","categoryid":419,"dateid":151},{"id":6,"classify":"速写","section":"速写场景","category":"5看手机","categoryid":422,"dateid":151}]

class Data {
  int _id;
  String _schoolid;
  String _date;
  List<Groups> _groups;
  List<Recommend> _recommend;

  int get id => _id;
  String get schoolid => _schoolid;
  String get date => _date;
  List<Groups> get groups => _groups;
  List<Recommend> get recommend => _recommend;

  Data({
      int id, 
      String schoolid, 
      String date, 
      List<Groups> groups, 
      List<Recommend> recommend}){
    _id = id;
    _schoolid = schoolid;
    _date = date;
    _groups = groups;
    _recommend = recommend;
}

  Data.fromJson(dynamic json) {
    _id = json['id'];
    _schoolid = json['schoolid'];
    _date = json['date'];
    if (json['groups'] != null) {
      _groups = [];
      json['groups'].forEach((v) {
        _groups.add(Groups.fromJson(v));
      });
    }
    if (json['recommend'] != null) {
      _recommend = [];
      json['recommend'].forEach((v) {
        _recommend.add(Recommend.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['id'] = _id;
    map['schoolid'] = _schoolid;
    map['date'] = _date;
    if (_groups != null) {
      map['groups'] = _groups.map((v) => v.toJson()).toList();
    }
    if (_recommend != null) {
      map['recommend'] = _recommend.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// id : 1
/// classify : "素描"
/// section : "石膏几何体"
/// category : "12圆柱光影"
/// categoryid : 128
/// dateid : 151

class Recommend {
  int _id;
  String _classify;
  String _section;
  String _category;
  int _categoryid;
  int _dateid;
  String _description;

  int get id => _id;
  String get classify => _classify;
  String get section => _section;
  String get category => _category;
  int get categoryid => _categoryid;
  int get dateid => _dateid;
  String get description => _description;

  Recommend({
      int id, 
      String classify, 
      String section, 
      String category, 
      int categoryid, 
      int dateid,
      String description}){
    _id = id;
    _classify = classify;
    _section = section;
    _category = category;
    _categoryid = categoryid;
    _dateid = dateid;
    _description = description;
}

  Recommend.fromJson(dynamic json) {
    _id = json['id'];
    _classify = json['classify'];
    _section = json['section'];
    _category = json['category'];
    _categoryid = json['categoryid'];
    _dateid = json['dateid'];
    _description = json['description'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['id'] = _id;
    map['classify'] = _classify;
    map['section'] = _section;
    map['category'] = _category;
    map['categoryid'] = _categoryid;
    map['dateid'] = _dateid;
    map['description'] = _description;
    return map;
  }

}

/// id : 2952
/// date_id : 151
/// name : "teacherH"
/// tid : "23cd8a79-8b01-464f-aef9-8ea991fa3442"
/// date : "2021-09-13 20:09:41"
/// url : "http://res.yimios.com:9050/issue/16261880866162721ff/23cd8a79-8b01-464f-aef9-8ea991fa3442/e038319d0ce19a2058e6862fae7cee75.JPG"

class Groups {
  int _id;
  int _dateId;
  String _name;
  String _tid;
  String _date;
  String _url;
  int _width;
  int _height;

  int get id => _id;
  int get dateId => _dateId;
  String get name => _name;
  String get tid => _tid;
  String get date => _date;
  String get url => _url;
  int get width => _width;
  int get height => _height;

  Groups({
      int id, 
      int dateId, 
      String name, 
      String tid, 
      String date, 
      String url,
      int width,
      int height}){
    _id = id;
    _dateId = dateId;
    _name = name;
    _tid = tid;
    _date = date;
    _url = url;
    _width = width;
    _height = height;
}

  Groups.fromJson(dynamic json) {
    _id = json['id'];
    _dateId = json['date_id'];
    _name = json['name'];
    _tid = json['tid'];
    _date = json['date'];
    _url = json['url'];
    _width = json['width'];
    _height = json['height'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['id'] = _id;
    map['date_id'] = _dateId;
    map['name'] = _name;
    map['tid'] = _tid;
    map['date'] = _date;
    map['url'] = _url;
    map['width'] = _width;
    map['height'] = _height;
    return map;
  }

}