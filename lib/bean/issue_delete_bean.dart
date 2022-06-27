/// errno : 0
/// errmsg : ""
/// data : {"workid":"1","grade":"1"}

class IssueDeleteBean {
  int _errno;
  String _errmsg;
  Data _data;

  int get errno => _errno;
  String get errmsg => _errmsg;
  Data get data => _data;

  IssueDeleteBean({
      int errno, 
      String errmsg, 
      Data data}){
    _errno = errno;
    _errmsg = errmsg;
    _data = data;
}

  IssueDeleteBean.fromJson(dynamic json) {
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

/// workid : "1"

class Data {
  int _id;

  int get id => _id;

  Data({int id}){
    _id = id;
}

  Data.fromJson(dynamic json) {
    _id = json['id'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['id'] = _id;
    return map;
  }

}