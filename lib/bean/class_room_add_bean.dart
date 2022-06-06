/// errno : 0
/// errmsg : ""
/// data : {"id":4,"dateid":"2","categoryid":"99","title":"速写/基础知识","mark":2,"createtime":"2021-09-16 22:28:52","tid":"23cd8a79-8b01-464f-aef9-8ea991fa3442"}

class ClassRoomAddBean {
  int _errno;
  String _errmsg;
  Data _data;

  int get errno => _errno;
  String get errmsg => _errmsg;
  Data get data => _data;

  ClassRoomAddBean({
      int errno, 
      String errmsg, 
      Data data}){
    _errno = errno;
    _errmsg = errmsg;
    _data = data;
}

  ClassRoomAddBean.fromJson(dynamic json) {
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

/// id : 4
/// dateid : "2"
/// categoryid : "99"
/// title : "速写/基础知识"
/// mark : 2
/// createtime : "2021-09-16 22:28:52"
/// tid : "23cd8a79-8b01-464f-aef9-8ea991fa3442"

class Data {
  int _id;
  int _dateid;
  int _categoryid;
  String _title;
  int _mark;
  String _createtime;
  String _tid;

  int get id => _id;
  int get dateid => _dateid;
  int get categoryid => _categoryid;
  String get title => _title;
  int get mark => _mark;
  String get createtime => _createtime;
  String get tid => _tid;

  Data({
      int id, 
      int dateid,
      int categoryid,
      String title, 
      int mark, 
      String createtime, 
      String tid}){
    _id = id;
    _dateid = dateid;
    _categoryid = categoryid;
    _title = title;
    _mark = mark;
    _createtime = createtime;
    _tid = tid;
}

  Data.fromJson(dynamic json) {
    _id = json['id'];
    _dateid = json['dateid'];
    _categoryid = json['categoryid'];
    _title = json['title'];
    _mark = json['mark'];
    _createtime = json['createtime'];
    _tid = json['tid'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['id'] = _id;
    map['dateid'] = _dateid;
    map['categoryid'] = _categoryid;
    map['title'] = _title;
    map['mark'] = _mark;
    map['createtime'] = _createtime;
    map['tid'] = _tid;
    return map;
  }

}