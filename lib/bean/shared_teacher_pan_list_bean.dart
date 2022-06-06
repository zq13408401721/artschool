/// errno : 0
/// errmsg : ""
/// data : [{"id":36,"name":"图片1","date":"2021-07-29 01:46:30","uid":"b4e4909f-6cf3-497e-981b-13449e438ea3","type":1,"state":1,"deletedate":null}]

class SharedTeacherPanListBean {
  int _errno;
  String _errmsg;
  List<Data> _data;

  int get errno => _errno;
  String get errmsg => _errmsg;
  List<Data> get data => _data;

  SharedTeacherPanListBean({
      int errno, 
      String errmsg, 
      List<Data> data}){
    _errno = errno;
    _errmsg = errmsg;
    _data = data;
}

  SharedTeacherPanListBean.fromJson(dynamic json) {
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

/// id : 36
/// name : "图片1"
/// date : "2021-07-29 01:46:30"
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

  int get id => _id;
  String get name => _name;
  String get date => _date;
  String get uid => _uid;
  int get type => _type;
  int get state => _state;
  dynamic get deletedate => _deletedate;

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