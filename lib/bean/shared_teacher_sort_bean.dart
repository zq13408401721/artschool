/// errno : 0
/// errmsg : ""
/// data : {"id":1,"sort":2}

class SharedTeacherSortBean {
  int _errno;
  String _errmsg;
  Data _data;

  int get errno => _errno;
  String get errmsg => _errmsg;
  Data get data => _data;

  SharedTeacherSortBean({
      int errno, 
      String errmsg, 
      Data data}){
    _errno = errno;
    _errmsg = errmsg;
    _data = data;
}

  SharedTeacherSortBean.fromJson(dynamic json) {
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
/// sort : 2

class Data {
  int _id;
  int _sort;

  int get id => _id;
  int get sort => _sort;

  Data({
      int id, 
      int sort}){
    _id = id;
    _sort = sort;
}

  Data.fromJson(dynamic json) {
    _id = json["id"];
    _sort = json["sort"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = _id;
    map["sort"] = _sort;
    return map;
  }

}