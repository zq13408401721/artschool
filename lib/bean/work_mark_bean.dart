/// errno : 0
/// errmsg : ""
/// data : {"workid":"1","grade":"1"}

class WorkMarkBean {
  int _errno;
  String _errmsg;
  Data _data;

  int get errno => _errno;
  String get errmsg => _errmsg;
  Data get data => _data;

  WorkMarkBean({
      int errno, 
      String errmsg, 
      Data data}){
    _errno = errno;
    _errmsg = errmsg;
    _data = data;
}

  WorkMarkBean.fromJson(dynamic json) {
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
/// grade : "1"

class Data {
  int _workid;
  int _grade;

  int get workid => _workid;
  int get grade => _grade;

  Data({
      int workid,
      int grade}){
    _workid = workid;
    _grade = grade;
}

  Data.fromJson(dynamic json) {
    _workid = json['workid'];
    _grade = json['grade'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['workid'] = _workid;
    map['grade'] = _grade;
    return map;
  }

}