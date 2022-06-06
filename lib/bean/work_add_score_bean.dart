/// errno : 0
/// errmsg : ""
/// data : {"id":3,"type":"exist"} type=add

class WorkAddScoreBean {
  int _errno;
  String _errmsg;
  Data _data;

  int get errno => _errno;
  String get errmsg => _errmsg;
  Data get data => _data;

  WorkAddScoreBean({
      int errno, 
      String errmsg, 
      Data data}){
    _errno = errno;
    _errmsg = errmsg;
    _data = data;
}

  WorkAddScoreBean.fromJson(dynamic json) {
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

/// id : 3
/// type : "exist"

class Data {
  int _id;
  String _type;

  int get id => _id;
  String get type => _type;

  Data({
      int id, 
      String type}){
    _id = id;
    _type = type;
}

  Data.fromJson(dynamic json) {
    _id = json['id'];
    _type = json['type'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['id'] = _id;
    map['type'] = _type;
    return map;
  }

}