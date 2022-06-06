/// errno : 0
/// errmsg : ""
/// data : [{"id":4,"date_id":1,"tid":"b4e4909f-6cf3-497e-981b-13449e438ea3","name":"student1","date":"2021-06-17 07:52:44","url":"http://res.yimios.com:9050/1372445644860735500/b4e4909f-6cf3-497e-981b-13449e438ea3/PictureUnlock_s_275204.pictureunlock_t4fbp04fmqc.jpg"},{"id":3,"date_id":1,"tid":"b4e4909f-6cf3-497e-981b-13449e438ea3","name":"student1","date":"2021-06-17 05:08:59","url":"http://res.yimios.com:9050/1372445644860735500/b4e4909f-6cf3-497e-981b-13449e438ea3/PictureUnlock_s_166650.pictureunlock_ov9fyrup68d.jpg"},{"id":2,"date_id":1,"tid":"b4e4909f-6cf3-497e-981b-13449e438ea3","name":"student1","date":"2021-06-17 05:08:57","url":"http://res.yimios.com:9050/1372445644860735500/b4e4909f-6cf3-497e-981b-13449e438ea3/PictureUnlock_s_215138.pictureunlock_vpyqwvptwxf.jpg"},{"id":1,"date_id":1,"tid":"b4e4909f-6cf3-497e-981b-13449e438ea3","name":"student1","date":"2021-06-17 05:08:46","url":"http://res.yimios.com:9050/1372445644860735500/b4e4909f-6cf3-497e-981b-13449e438ea3/PictureUnlock_s_316297.pictureunlock_a0stzz4bcvc.jpg"}]

class IssueList {
  int _errno;
  String _errmsg;
  List<Data> _data;

  int get errno => _errno;
  String get errmsg => _errmsg;
  List<Data> get data => _data;

  IssueList({
      int errno, 
      String errmsg, 
      List<Data> data}){
    _errno = errno;
    _errmsg = errmsg;
    _data = data;
    }

  IssueList.fromJson(dynamic json) {
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

/// id : 4
/// date_id : 1
/// tid : "b4e4909f-6cf3-497e-981b-13449e438ea3"
/// name : "student1"
/// date : "2021-06-17 07:52:44"
/// url : "http://res.yimios.com:9050/1372445644860735500/b4e4909f-6cf3-497e-981b-13449e438ea3/PictureUnlock_s_275204.pictureunlock_t4fbp04fmqc.jpg"

class Data {
  int _id;
  int _dateId;
  String _tid;
  String _name;
  String _date;
  String _url;

  int get id => _id;
  int get dateId => _dateId;
  String get tid => _tid;
  String get name => _name;
  String get date => _date;
  String get url => _url;

  Data({
      int id,
      int dateId,
      String tid,
      String name,
      String date,
      String url}){
    _id = id;
    _dateId = dateId;
    _tid = tid;
    _name = name;
    _date = date;
    _url = url;
}

  Data.fromJson(dynamic json) {
    _id = json["id"];
    _dateId = json["date_id"];
    _tid = json["tid"];
    _name = json["name"];
    _date = json["date"];
    _url = json["url"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = _id;
    map["date_id"] = _dateId;
    map["tid"] = _tid;
    map["name"] = _name;
    map["date"] = _date;
    map["url"] = _url;
    return map;
  }

}