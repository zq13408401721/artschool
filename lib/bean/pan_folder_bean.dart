/// errno : 0
/// errmsg : ""
/// data : [{"id":1,"panid":1,"name":"素描","date":"2021-07-18 01:43:41","state":1,"deletedate":null}]

class PanFolderBean {
  int _errno;
  String _errmsg;
  List<Data> _data;

  int get errno => _errno;
  String get errmsg => _errmsg;
  List<Data> get data => _data;

  PanFolderBean({
      int errno, 
      String errmsg, 
      List<Data> data}){
    _errno = errno;
    _errmsg = errmsg;
    _data = data;
}

  PanFolderBean.fromJson(dynamic json) {
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

/// id : 1
/// panid : 1
/// name : "素描"
/// date : "2021-07-18 01:43:41"
/// state : 1
/// deletedate : null

class Data {
  int _id;
  int _panid;
  String _name;
  String _date;
  int _state;
  dynamic _deletedate;
  bool _select = false;

  int get id => _id;
  set id(value) => _id = value;
  int get panid => _panid;
  set panid(value) => _panid = value;
  String get name => _name;
  set name(value) => _name = value;
  String get date => _date;
  set date(value) => _date = value;
  int get state => _state;
  set state(value) => _state = value;
  dynamic get deletedate => _deletedate;
  set deletedate(value) => _deletedate = value;

  bool get select => _select;
  set select(value) => _select = value;

  Data({
      int id, 
      int panid, 
      String name, 
      String date, 
      int state, 
      dynamic deletedate}){
    _id = id;
    _panid = panid;
    _name = name;
    _date = date;
    _state = state;
    _deletedate = deletedate;
}

  Data.fromJson(dynamic json) {
    _id = json["id"];
    _panid = json["panid"];
    _name = json["name"];
    _date = json["date"];
    _state = json["state"];
    _deletedate = json["deletedate"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = _id;
    map["panid"] = _panid;
    map["name"] = _name;
    map["date"] = _date;
    map["state"] = _state;
    map["deletedate"] = _deletedate;
    return map;
  }

}