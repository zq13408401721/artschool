/// errno : 0
/// errmsg : ""
/// data : {"id":208,"schoolid":"16261880866162721ff","date":"2021-10-25","groups":[{"id":3486,"date_id":208,"name":"H老师","tid":"23cd8a79-8b01-464f-aef9-8ea991fa3442","date":"2021-10-25 16:08:37","url":"http://res.yimios.com:9050/issue/16261880866162721ff/23cd8a79-8b01-464f-aef9-8ea991fa3442/50893536cf4140c9f6e1991f92dee572.JPG"}]}

class GalleryPlanListBean {
  int _errno;
  String _errmsg;
  Data _data;

  int get errno => _errno;
  String get errmsg => _errmsg;
  Data get data => _data;

  GalleryPlanListBean({
      int errno, 
      String errmsg, 
      Data data}){
    _errno = errno;
    _errmsg = errmsg;
    _data = data;
}

  GalleryPlanListBean.fromJson(dynamic json) {
    _errno = json['errno'];
    _errmsg = json['errmsg'];
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['errno'] = _errno;
    map['errmsg'] = _errmsg;
    if (_data != null) {
      map['data'] = _data.toJson();
    }
    return map;
  }

}

/// id : 208
/// schoolid : "16261880866162721ff"
/// date : "2021-10-25"
/// groups : [{"id":3486,"date_id":208,"name":"H老师","tid":"23cd8a79-8b01-464f-aef9-8ea991fa3442","date":"2021-10-25 16:08:37","url":"http://res.yimios.com:9050/issue/16261880866162721ff/23cd8a79-8b01-464f-aef9-8ea991fa3442/50893536cf4140c9f6e1991f92dee572.JPG"}]

class Data {
  int _id;
  String _schoolid;
  String _date;
  List<Groups> _groups;

  int get id => _id;
  String get schoolid => _schoolid;
  String get date => _date;
  List<Groups> get groups => _groups;

  Data({
      int id, 
      String schoolid, 
      String date, 
      List<Groups> groups}){
    _id = id;
    _schoolid = schoolid;
    _date = date;
    _groups = groups;
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
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['id'] = _id;
    map['schoolid'] = _schoolid;
    map['date'] = _date;
    if (_groups != null) {
      map['groups'] = _groups.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// id : 3486
/// date_id : 208
/// name : "H老师"
/// tid : "23cd8a79-8b01-464f-aef9-8ea991fa3442"
/// date : "2021-10-25 16:08:37"
/// url : "http://res.yimios.com:9050/issue/16261880866162721ff/23cd8a79-8b01-464f-aef9-8ea991fa3442/50893536cf4140c9f6e1991f92dee572.JPG"

class Groups {
  int _id;
  int _dateId;
  String _name;
  String _tid;
  String _date;
  String _url;
  int _width,_height;
  String _classname;

  int get id => _id;
  int get dateId => _dateId;
  String get name => _name;
  String get tid => _tid;
  String get date => _date;
  String get url => _url;
  int get width => _width;
  set width(value){
    _width = value;
  }
  int get height => _height;
  set height(value){
    _height = value;
  }
  String get classname => _classname;

  Groups({
      int id, 
      int dateId, 
      String name, 
      String tid, 
      String date, 
      String url,
      int width,
      int height,
      String classname}){
    _id = id;
    _dateId = dateId;
    _name = name;
    _tid = tid;
    _date = date;
    _url = url;
    _width = width;
    _height = height;
    _classname = classname;
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
    _classname = json['classname'];
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
    map['classname'] = _classname;
    return map;
  }

}