/// errno : 0
/// errmsg : ""
/// data : [{"id":1,"name":"素描教程","date":"2021-07-17 23:12:03","uid":"b4e4909f-6cf3-497e-981b-13449e438ea3","type":1,"state":1,"deletedate":null}]

class PanListBean {
  int _errno;
  String _errmsg;
  List<Data> _data;

  int get errno => _errno;
  String get errmsg => _errmsg;
  List<Data> get data => _data;

  PanListBean({
      int errno, 
      String errmsg, 
      List<Data> data}){
    _errno = errno;
    _errmsg = errmsg;
    _data = data;
}

  PanListBean.fromJson(dynamic json) {
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
/// name : "素描教程"
/// date : "2021-07-17 23:12:03"
/// uid : "b4e4909f-6cf3-497e-981b-13449e438ea3"
/// type : 1
/// state : 1
/// deletedate : null

class Data {
  int _id;
  String _name;
  String _date;
  String _uid;
  int _type;
  int _state;
  dynamic _deletedate;
  bool _select=false;

  int get id => _id;
  set id(int value) => _id = value;
  String get name => _name;
  set name(String value) => _name = value;
  String get date => _date;
  set date(String value) => _date = value;
  String get uid => _uid;
  set uid(String value) => _uid = value;
  int get type => _type;
  set type(int value) => _type = value;
  int get state => _state;
  set state(int value) => _state = value;
  dynamic get deletedate => _deletedate;
  set deletedate(dynamic value) => _deletedate = value;

  bool get select => _select;
  set select(value) => _select = value;


  Data({
      int id, 
      String name, 
      String date, 
      String uid, 
      int type, 
      int state, 
      dynamic deletedate}){
    _id = id;
    _name = name;
    _date = date;
    _uid = uid;
    _type = type;
    _state = state;
    _deletedate = deletedate;
}

  Data.fromJson(dynamic json) {
    _id = json["id"];
    _name = json["name"];
    _date = json["date"];
    _uid = json["uid"];
    _type = json["type"];
    _state = json["state"];
    _deletedate = json["deletedate"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = _id;
    map["name"] = _name;
    map["date"] = _date;
    map["uid"] = _uid;
    map["type"] = _type;
    map["state"] = _state;
    map["deletedate"] = _deletedate;
    return map;
  }

}