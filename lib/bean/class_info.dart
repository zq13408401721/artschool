/// errno : 0
/// errmsg : ""
/// data : {"classes":[{"id":3,"name":"A1班级","sid":"1372445644860735500","date":"2021-08-11 23:39:10"},{"id":4,"name":"火箭班","sid":"1372445644860735500","date":"2021-08-12 00:57:52"}]}

class ClassInfo {
  int _errno;
  String _errmsg;
  Data _data;

  int get errno => _errno;
  String get errmsg => _errmsg;
  Data get data => _data;

  ClassInfo({
      int errno, 
      String errmsg, 
      Data data}){
    _errno = errno;
    _errmsg = errmsg;
    _data = data;
}

  ClassInfo.fromJson(dynamic json) {
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

/// classes : [{"id":3,"name":"A1班级","sid":"1372445644860735500","date":"2021-08-11 23:39:10"},{"id":4,"name":"火箭班","sid":"1372445644860735500","date":"2021-08-12 00:57:52"}]

class Data {
  List<Classes> _classes;

  List<Classes> get classes => _classes;

  Data({
      List<Classes> classes}){
    _classes = classes;
}

  Data.fromJson(dynamic json) {
    if (json['classes'] != null) {
      _classes = [];
      json['classes'].forEach((v) {
        _classes.add(Classes.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    if (_classes != null) {
      map['classes'] = _classes.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// id : 3
/// name : "A1班级"
/// sid : "1372445644860735500"
/// date : "2021-08-11 23:39:10"

class Classes {
  int _id;
  String _name;
  String _sid;
  String _date;

  int get id => _id;
  String get name => _name;
  String get sid => _sid;
  String get date => _date;

  Classes({
      int id, 
      String name, 
      String sid, 
      String date}){
    _id = id;
    _name = name;
    _sid = sid;
    _date = date;
}

  Classes.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _sid = json['sid'];
    _date = json['date'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['sid'] = _sid;
    map['date'] = _date;
    return map;
  }

}