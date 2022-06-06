/// errno : 0
/// errmsg : ""
/// data : [{"id":83,"name":"基础知识","pid":80,"sort":0,"schoolid":"1","cover":null,"isfinal":null,"description":null,"date":null},{"id":84,"name":"石膏几何体","pid":80,"sort":0,"schoolid":"1","cover":null,"isfinal":null,"description":null,"date":null},{"id":86,"name":"静物单体","pid":80,"sort":0,"schoolid":"1","cover":null,"isfinal":null,"description":null,"date":null},{"id":182,"name":"静物组合","pid":80,"sort":0,"schoolid":"1","cover":null,"isfinal":null,"description":null,"date":null},{"id":215,"name":"石膏头像","pid":80,"sort":0,"schoolid":"1","cover":null,"isfinal":null,"description":null,"date":null},{"id":229,"name":"人物头像","pid":80,"sort":0,"schoolid":"1","cover":null,"isfinal":null,"description":null,"date":null}]

class VideoCategoryGroupBean {
  int _errno;
  String _errmsg;
  List<Data> _data;

  int get errno => _errno;
  String get errmsg => _errmsg;
  List<Data> get data => _data;

  VideoCategoryGroupBean({
      int errno, 
      String errmsg, 
      List<Data> data}){
    _errno = errno;
    _errmsg = errmsg;
    _data = data;
}

  VideoCategoryGroupBean.fromJson(dynamic json) {
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

/// id : 83
/// name : "基础知识"
/// pid : 80
/// sort : 0
/// schoolid : "1"
/// cover : null
/// isfinal : null
/// description : null
/// date : null

class Data {
  int _id;
  String _name;
  int _pid;
  int _sort;
  String _schoolid;
  dynamic _cover;
  dynamic _isfinal;
  dynamic _description;
  dynamic _date;

  int get id => _id;
  String get name => _name;
  int get pid => _pid;
  int get sort => _sort;
  String get schoolid => _schoolid;
  dynamic get cover => _cover;
  dynamic get isfinal => _isfinal;
  dynamic get description => _description;
  dynamic get date => _date;

  Data({
      int id, 
      String name, 
      int pid, 
      int sort, 
      String schoolid, 
      dynamic cover, 
      dynamic isfinal, 
      dynamic description, 
      dynamic date}){
    _id = id;
    _name = name;
    _pid = pid;
    _sort = sort;
    _schoolid = schoolid;
    _cover = cover;
    _isfinal = isfinal;
    _description = description;
    _date = date;
}

  Data.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _pid = json['pid'];
    _sort = json['sort'];
    _schoolid = json['schoolid'];
    _cover = json['cover'];
    _isfinal = json['isfinal'];
    _description = json['description'];
    _date = json['date'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['pid'] = _pid;
    map['sort'] = _sort;
    map['schoolid'] = _schoolid;
    map['cover'] = _cover;
    map['isfinal'] = _isfinal;
    map['description'] = _description;
    map['date'] = _date;
    return map;
  }

}