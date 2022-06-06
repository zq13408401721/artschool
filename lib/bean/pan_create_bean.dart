/// errno : 0
/// errmsg : ""
/// data : {"name":"色彩1","type":"1","date":"2021-07-20 17:18:11","uid":"b4e4909f-6cf3-497e-981b-13449e438ea3","state":1,"id":8,"deletedate":""}

class PanCreateBean {
  int _errno;
  String _errmsg;
  Data _data;

  int get errno => _errno;
  String get errmsg => _errmsg;
  Data get data => _data;

  PanCreateBean({
      int errno, 
      String errmsg, 
      Data data}){
    _errno = errno;
    _errmsg = errmsg;
    _data = data;
}

  PanCreateBean.fromJson(dynamic json) {
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

/// name : "色彩1"
/// type : "1"
/// date : "2021-07-20 17:18:11"
/// uid : "b4e4909f-6cf3-497e-981b-13449e438ea3"
/// state : 1
/// id : 8
/// deletedate : ""

class Data {
  String _name;
  int _type;
  String _date;
  String _uid;
  int _state;
  int _id;
  String _deletedate;

  String get name => _name;
  int get type => _type;
  String get date => _date;
  String get uid => _uid;
  int get state => _state;
  int get id => _id;
  String get deletedate => _deletedate;

  Data({
      String name, 
      int type,
      String date, 
      String uid, 
      int state, 
      int id, 
      String deletedate}){
    _name = name;
    _type = type;
    _date = date;
    _uid = uid;
    _state = state;
    _id = id;
    _deletedate = deletedate;
}

  Data.fromJson(dynamic json) {
    _name = json["name"];
    _type = json["type"];
    _date = json["date"];
    _uid = json["uid"];
    _state = json["state"];
    _id = json["id"];
    _deletedate = json["deletedate"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["name"] = _name;
    map["type"] = _type;
    map["date"] = _date;
    map["uid"] = _uid;
    map["state"] = _state;
    map["id"] = _id;
    map["deletedate"] = _deletedate;
    return map;
  }

}