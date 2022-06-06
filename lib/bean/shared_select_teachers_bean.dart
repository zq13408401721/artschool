/// errno : 0
/// errmsg : ""
/// data : {"teachers":[{"id":1,"uid":"b4e4909f-6cf3-497e-981b-13449e438ea3","tid":"fba825c0-07cf-43ba-bca6-b66a482630b2","teachername":"duowei001","sort":1}]}

class SharedSelectTeachersBean {
  int _errno;
  String _errmsg;
  Data _data;

  int get errno => _errno;
  String get errmsg => _errmsg;
  Data get data => _data;

  SharedSelectTeachersBean({
      int errno, 
      String errmsg, 
      Data data}){
    _errno = errno;
    _errmsg = errmsg;
    _data = data;
}

  SharedSelectTeachersBean.fromJson(dynamic json) {
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

/// teachers : [{"id":1,"uid":"b4e4909f-6cf3-497e-981b-13449e438ea3","tid":"fba825c0-07cf-43ba-bca6-b66a482630b2","teachername":"duowei001","sort":1}]

class Data {
  List<Teachers> _teachers;

  List<Teachers> get teachers => _teachers;

  Data({
      List<Teachers> teachers}){
    _teachers = teachers;
}

  Data.fromJson(dynamic json) {
    if (json["teachers"] != null) {
      _teachers = [];
      json["teachers"].forEach((v) {
        _teachers.add(Teachers.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    if (_teachers != null) {
      map["teachers"] = _teachers.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// id : 1
/// uid : "b4e4909f-6cf3-497e-981b-13449e438ea3"
/// tid : "fba825c0-07cf-43ba-bca6-b66a482630b2"
/// teachername : "duowei001"
/// sort : 1

class Teachers {
  int _id;
  String _uid;
  String _tid;
  String _teachername;
  int _sort;

  int get id => _id;
  String get uid => _uid;
  String get tid => _tid;
  String get teachername => _teachername;
  int get sort => _sort;

  Teachers({
      int id, 
      String uid, 
      String tid, 
      String teachername, 
      int sort}){
    _id = id;
    _uid = uid;
    _tid = tid;
    _teachername = teachername;
    _sort = sort;
}

  Teachers.fromJson(dynamic json) {
    _id = json["id"];
    _uid = json["uid"];
    _tid = json["tid"];
    _teachername = json["teachername"];
    _sort = json["sort"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = _id;
    map["uid"] = _uid;
    map["tid"] = _tid;
    map["teachername"] = _teachername;
    map["sort"] = _sort;
    return map;
  }

}