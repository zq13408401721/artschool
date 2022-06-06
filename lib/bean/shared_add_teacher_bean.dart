/// errno : 0
/// errmsg : ""
/// data : {"id":1,"tid":"fba825c0-07cf-43ba-bca6-b66a482630b2"}

class SharedAddTeacherBean {
  int _errno;
  String _errmsg;
  Data _data;

  int get errno => _errno;
  String get errmsg => _errmsg;
  Data get data => _data;

  SharedAddTeacherBean({
      int errno, 
      String errmsg, 
      Data data}){
    _errno = errno;
    _errmsg = errmsg;
    _data = data;
}

  SharedAddTeacherBean.fromJson(dynamic json) {
    _errno = json["errno"];
    _errmsg = json["errmsg"];
    _data = json["data"] != null ? Data.fromJson(json["data"]) : null;
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["errno"] = _errno;
    map["errmsg"] = _errmsg;
    if (_data != null) {
      map["data"] = _data.toJson();
    }
    return map;
  }

}

/// id : 1
/// tid : "fba825c0-07cf-43ba-bca6-b66a482630b2"

class Data {
  int _id;
  String _tid;

  int get id => _id;
  String get tid => _tid;

  Data({
      int id, 
      String tid}){
    _id = id;
    _tid = tid;
}

  Data.fromJson(dynamic json) {
    _id = json["id"];
    _tid = json["tid"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = _id;
    map["tid"] = _tid;
    return map;
  }

}