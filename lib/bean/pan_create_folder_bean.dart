/// errno : 0
/// errmsg : ""
/// data : {"name":"素描1","date":"2021-07-21 09:36:32","panid":"1","state":1,"id":2,"deletedate":""}

class PanCreateFolderBean {
  int _errno;
  String _errmsg;
  Data _data;

  int get errno => _errno;
  String get errmsg => _errmsg;
  Data get data => _data;

  PanCreateFolderBean({
      int errno, 
      String errmsg, 
      Data data}){
    _errno = errno;
    _errmsg = errmsg;
    _data = data;
}

  PanCreateFolderBean.fromJson(dynamic json) {
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

/// name : "素描1"
/// date : "2021-07-21 09:36:32"
/// panid : "1"
/// state : 1
/// id : 2
/// deletedate : ""

class Data {
  String _name;
  String _date;
  int _panid;
  int _state;
  int _id;
  String _deletedate;

  String get name => _name;
  String get date => _date;
  int get panid => _panid;
  int get state => _state;
  int get id => _id;
  String get deletedate => _deletedate;

  Data({
      String name, 
      String date, 
      int panid,
      int state, 
      int id, 
      String deletedate}){
    _name = name;
    _date = date;
    _panid = panid;
    _state = state;
    _id = id;
    _deletedate = deletedate;
}

  Data.fromJson(dynamic json) {
    _name = json["name"];
    _date = json["date"];
    _panid = json["panid"];
    _state = json["state"];
    _id = json["id"];
    _deletedate = json["deletedate"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["name"] = _name;
    map["date"] = _date;
    map["panid"] = _panid;
    map["state"] = _state;
    map["id"] = _id;
    map["deletedate"] = _deletedate;
    return map;
  }

}