/// errno : 0
/// errmsg : ""
/// data : {"id":1}

class ClassRoomDelBean {
  int _errno;
  String _errmsg;
  Data _data;

  int get errno => _errno;
  String get errmsg => _errmsg;
  Data get data => _data;

  ClassRoomDelBean({
      int errno, 
      String errmsg, 
      Data data}){
    _errno = errno;
    _errmsg = errmsg;
    _data = data;
}

  ClassRoomDelBean.fromJson(dynamic json) {
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

/// id : 1

class Data {
  int _id;
  int _categoryid;

  int get id => _id;
  int get categoryid => _categoryid;

  Data({
      int id,
      int categoryid
  }){
    _id = id;
    _categoryid = categoryid;
}

  Data.fromJson(dynamic json) {
    _id = json['id'];
    _categoryid = json['categoryid'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['id'] = _id;
    map['categoryid'] = _categoryid;
    return map;
  }

}