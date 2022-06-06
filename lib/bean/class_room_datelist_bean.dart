/// errno : 0
/// errmsg : ""
/// data : {"date":[{"dateid":1,"schoolid":"16261880866162721ff","classid":6,"date":"2021-09-15 00:00:00","videos":[{"id":1382,"dateid":1,"categoryid":115,"title":"色彩范画/色彩组合","tid":"23cd8a79-8b01-464f-aef9-8ea991fa3442","teachername":"teacherH","mark":1,"createtime":"2021-09-15 11:21:59"}]}]}

class Class_room_datelist_bean {
  int _errno;
  String _errmsg;
  Data _data;

  int get errno => _errno;
  String get errmsg => _errmsg;
  Data get data => _data;

  Class_room_datelist_bean({
      int errno, 
      String errmsg, 
      Data data}){
    _errno = errno;
    _errmsg = errmsg;
    _data = data;
}

  Class_room_datelist_bean.fromJson(dynamic json) {
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

/// date : [{"dateid":1,"schoolid":"16261880866162721ff","classid":6,"date":"2021-09-15 00:00:00","videos":[{"id":1382,"dateid":1,"categoryid":115,"title":"色彩范画/色彩组合","tid":"23cd8a79-8b01-464f-aef9-8ea991fa3442","teachername":"teacherH","mark":1,"createtime":"2021-09-15 11:21:59"}]}]

class Data {
  List<Date> _date;

  List<Date> get date => _date;

  Data({
      List<Date> date}){
    _date = date;
}

  Data.fromJson(dynamic json) {
    if (json['date'] != null) {
      _date = [];
      json['date'].forEach((v) {
        _date.add(Date.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    if (_date != null) {
      map['date'] = _date.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// dateid : 1
/// schoolid : "16261880866162721ff"
/// classid : 6
/// date : "2021-09-15 00:00:00"
/// videos : [{"id":1382,"dateid":1,"categoryid":115,"title":"色彩范画/色彩组合","tid":"23cd8a79-8b01-464f-aef9-8ea991fa3442","teachername":"teacherH","mark":1,"createtime":"2021-09-15 11:21:59"}]

class Date {
  int _dateid;
  String _schoolid;
  int _classid;
  String _date;
  List<Videos> _videos;

  int get dateid => _dateid;
  String get schoolid => _schoolid;
  int get classid => _classid;
  String get date => _date;
  List<Videos> get videos => _videos;
  set videos(value){
    _videos = value;
  }

  Date({
      int dateid, 
      String schoolid, 
      int classid, 
      String date, 
      List<Videos> videos}){
    _dateid = dateid;
    _schoolid = schoolid;
    _classid = classid;
    _date = date;
    _videos = videos;
}

  Date.fromJson(dynamic json) {
    _dateid = json['dateid'];
    _schoolid = json['schoolid'];
    _classid = json['classid'];
    _date = json['date'];
    if (json['videos'] != null) {
      _videos = [];
      json['videos'].forEach((v) {
        _videos.add(Videos.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['dateid'] = _dateid;
    map['schoolid'] = _schoolid;
    map['classid'] = _classid;
    map['date'] = _date;
    if (_videos != null) {
      map['videos'] = _videos.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// id : 1382
/// dateid : 1
/// categoryid : 115
/// title : "色彩范画/色彩组合"
/// tid : "23cd8a79-8b01-464f-aef9-8ea991fa3442"
/// teachername : "teacherH"
/// mark : 1
/// createtime : "2021-09-15 11:21:59"

class Videos {
  int _id;
  int _dateid;
  int _categoryid;
  String _title;
  String _name;
  String _cover;
  String _tid;
  String _teachername;
  int _mark;
  String _createtime;
  String _description;

  int get id => _id;
  int get dateid => _dateid;
  int get categoryid => _categoryid;
  String get title => _title;
  String get name => _name;
  String get cover => _cover;
  String get tid => _tid;
  String get teachername => _teachername;
  int get mark => _mark;
  String get createtime => _createtime;
  String get description => _description;

  Videos({
      int id, 
      int dateid, 
      int categoryid, 
      String title,
      String name,
      String cover,
      String tid, 
      String teachername, 
      int mark, 
      String createtime,
      String description}){
    _id = id;
    _dateid = dateid;
    _categoryid = categoryid;
    _title = title;
    _name = name;
    _cover = cover;
    _tid = tid;
    _teachername = teachername;
    _mark = mark;
    _createtime = createtime;
    _description = description;
}

  Videos.fromJson(dynamic json) {
    _id = json['id'];
    _dateid = json['dateid'];
    _categoryid = json['categoryid'];
    _title = json['title'];
    _name = json['name'];
    _cover = json['cover'];
    _tid = json['tid'];
    _teachername = json['teachername'];
    _mark = json['mark'];
    _createtime = json['createtime'];
    _description = json['description'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['id'] = _id;
    map['dateid'] = _dateid;
    map['categoryid'] = _categoryid;
    map['title'] = _title;
    map['name'] = _name;
    map['cover'] = _cover;
    map['tid'] = _tid;
    map['teachername'] = _teachername;
    map['mark'] = _mark;
    map['createtime'] = _createtime;
    map['description'] = _description;
    return map;
  }

}