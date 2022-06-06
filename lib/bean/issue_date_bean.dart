/// errno : 0
/// errmsg : ""
/// data : {"schoolid":41}

class IssueDateBean {
  int _errno;
  String _errmsg;
  Data _data;

  int get errno => _errno;
  String get errmsg => _errmsg;
  Data get data => _data;

  IssueDateBean({
      int errno, 
      String errmsg, 
      Data data}){
    _errno = errno;
    _errmsg = errmsg;
    _data = data;
}

  IssueDateBean.fromJson(dynamic json) {
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

/// schoolid : 41

class Data {
  int _dateid;

  int get dateid => _dateid;

  Data({
      int dateid}){
    _dateid = dateid;
}

  Data.fromJson(dynamic json) {
    _dateid = json["dateid"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["dateid"] = _dateid;
    return map;
  }

}