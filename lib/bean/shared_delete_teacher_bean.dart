/// errno : 0
/// errmsg : ""
/// data : {"tid":"fba825c0-07cf-43ba-bca6-b66a482630b2"}

class SharedDeleteTeacherBean {
  int _errno;
  String _errmsg;
  Data _data;

  int get errno => _errno;
  String get errmsg => _errmsg;
  Data get data => _data;

  SharedDeleteTeacherBean({
      int errno, 
      String errmsg, 
      Data data}){
    _errno = errno;
    _errmsg = errmsg;
    _data = data;
}

  SharedDeleteTeacherBean.fromJson(dynamic json) {
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

/// tid : "fba825c0-07cf-43ba-bca6-b66a482630b2"

class Data {
  String _tid;

  String get tid => _tid;

  Data({
      String tid}){
    _tid = tid;
}

  Data.fromJson(dynamic json) {
    _tid = json["tid"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["tid"] = _tid;
    return map;
  }

}