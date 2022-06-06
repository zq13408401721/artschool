/// errno : 0
/// errmsg : ""
/// data : [{"id":2,"schoolid":"1372445644860735500","date":"6/17/2021","groups":[{"id":5,"date_id":2,"name":"student1","tid":"b4e4909f-6cf3-497e-981b-13449e438ea3","date":"2021-06-17 07:54:16","url":"http://res.yimios.com:9050/1372445644860735500/b4e4909f-6cf3-497e-981b-13449e438ea3/PictureUnlock_s_275204.pictureunlock_rdx8uxr0x5.jpg"}]},{"id":1,"schoolid":"1372445644860735500","date":"6","groups":[{"id":6,"date_id":1,"name":"teacher1","tid":"08b87d11-8230-4e44-aad2-8bbd075899c9","date":"2021-06-18 07:54:16","url":"13449e438ea3/PictureUnlock_s_275204.pictureunlock_rdx8uxr0x5.jpg"},{"id":1,"date_id":1,"name":"student1","tid":"b4e4909f-6cf3-497e-981b-13449e438ea3","date":"2021-06-17 05:08:46","url":"http://res.yimios.com:9050/1372445644860735500/b4e4909f-6cf3-497e-981b-13449e438ea3/PictureUnlock_s_316297.pictureunlock_a0stzz4bcvc.jpg"},{"id":7,"date_id":1,"name":"teacher2","tid":"e7d1d13c-ffbc-4f34-a7c0-c12e0cb3955d","date":"2021-06-16 07:54:16","url":"13449e438ea3/PictureUnlock_s_275204.pictureunlock_rdx8uxr0x5.jpg"}]}]

class IssueBean {
  int _errno;
  String _errmsg;
  List<Data> _data;

  int get errno => _errno;
  String get errmsg => _errmsg;
  List<Data> get data => _data;

  IssueBean({
      int errno, 
      String errmsg, 
      List<Data> data}){
    _errno = errno;
    _errmsg = errmsg;
    _data = data;
}

  IssueBean.fromJson(dynamic json) {
    _errno = json["errno"];
    _errmsg = json["errmsg"];
    if (json["data"] != null) {
      _data = [];
      json["data"].forEach((v) {
        _data.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["errno"] = _errno;
    map["errmsg"] = _errmsg;
    if (_data != null) {
      map["data"] = _data.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// id : 2
/// schoolid : "1372445644860735500"
/// date : "6/17/2021"
/// groups : [{"id":5,"date_id":2,"name":"student1","tid":"b4e4909f-6cf3-497e-981b-13449e438ea3","date":"2021-06-17 07:54:16","url":"http://res.yimios.com:9050/1372445644860735500/b4e4909f-6cf3-497e-981b-13449e438ea3/PictureUnlock_s_275204.pictureunlock_rdx8uxr0x5.jpg"}]

class Data {
  int _id;
  String _schoolid;
  String _date;
  List<Groups> _groups;

  int get id => _id;
  String get schoolid => _schoolid;
  String get date => _date;
  List<Groups> get groups => _groups;

  Data({
      int id, 
      String schoolid, 
      String date, 
      List<Groups> groups}){
    _id = id;
    _schoolid = schoolid;
    _date = date;
    _groups = groups;
}

  Data.fromJson(dynamic json) {
    _id = json["id"];
    _schoolid = json["schoolid"];
    _date = json["date"];
    if (json["groups"] != null) {
      _groups = [];
      json["groups"].forEach((v) {
        _groups.add(Groups.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = _id;
    map["schoolid"] = _schoolid;
    map["date"] = _date;
    if (_groups != null) {
      map["groups"] = _groups.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// id : 5
/// date_id : 2
/// name : "student1"
/// tid : "b4e4909f-6cf3-497e-981b-13449e438ea3"
/// date : "2021-06-17 07:54:16"
/// url : "http://res.yimios.com:9050/1372445644860735500/b4e4909f-6cf3-497e-981b-13449e438ea3/PictureUnlock_s_275204.pictureunlock_rdx8uxr0x5.jpg"

class Groups {
  int _id;
  int _dateId;
  String _name;
  String _tid;
  String _date;
  String _url;

  int get id => _id;
  int get dateId => _dateId;
  String get name => _name;
  String get tid => _tid;
  String get date => _date;
  String get url => _url;

  Groups({
      int id, 
      int dateId, 
      String name, 
      String tid, 
      String date, 
      String url}){
    _id = id;
    _dateId = dateId;
    _name = name;
    _tid = tid;
    _date = date;
    _url = url;
}

  Groups.fromJson(dynamic json) {
    _id = json["id"];
    _dateId = json["date_id"];
    _name = json["name"];
    _tid = json["tid"];
    _date = json["date"];
    _url = json["url"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = _id;
    map["date_id"] = _dateId;
    map["name"] = _name;
    map["tid"] = _tid;
    map["date"] = _date;
    map["url"] = _url;
    return map;
  }

}