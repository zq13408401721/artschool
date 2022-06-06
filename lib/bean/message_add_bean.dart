/// errno : 0
/// errmsg : ""
/// data : [{"id":3,"fromuid":"b4e4909f-6cf3-497e-981b-13449e438ea3","touid":"e82cf39e-dfa1-45db-90dc-f5a6035a3b15","content":"检查作业","time":"2021-10-22 16:50:57","relationid":1,"fromusername":"student1","fromnickname":"系统测试","fromavater":null,"tousername":"test00014","tonickname":"test_student1","toavater":"http://res.yimios.com:9050/user/small/e82cf39e-dfa1-45db-90dc-f5a6035a3b15/IMG_0001.png"}]

class MessageAddBean {
  int _errno;
  String _errmsg;
  List<Data> _data;

  int get errno => _errno;
  String get errmsg => _errmsg;
  List<Data> get data => _data;

  MessageAddBean({
      int errno, 
      String errmsg, 
      List<Data> data}){
    _errno = errno;
    _errmsg = errmsg;
    _data = data;
}

  MessageAddBean.fromJson(dynamic json) {
    _errno = json['errno'];
    _errmsg = json['errmsg'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['errno'] = _errno;
    map['errmsg'] = _errmsg;
    if (_data != null) {
      map['data'] = _data.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// id : 3
/// fromuid : "b4e4909f-6cf3-497e-981b-13449e438ea3"
/// touid : "e82cf39e-dfa1-45db-90dc-f5a6035a3b15"
/// content : "检查作业"
/// time : "2021-10-22 16:50:57"
/// relationid : 1
/// fromusername : "student1"
/// fromnickname : "系统测试"
/// fromavater : null
/// tousername : "test00014"
/// tonickname : "test_student1"
/// toavater : "http://res.yimios.com:9050/user/small/e82cf39e-dfa1-45db-90dc-f5a6035a3b15/IMG_0001.png"

class Data {
  int _id;
  String _fromuid;
  String _touid;
  String _content;
  String _time;
  int _relationid;
  String _fromusername;
  String _fromnickname;
  dynamic _fromavater;
  String _tousername;
  String _tonickname;
  String _toavater;

  int get id => _id;
  String get fromuid => _fromuid;
  String get touid => _touid;
  String get content => _content;
  String get time => _time;
  int get relationid => _relationid;
  String get fromusername => _fromusername;
  String get fromnickname => _fromnickname;
  dynamic get fromavater => _fromavater;
  String get tousername => _tousername;
  String get tonickname => _tonickname;
  String get toavater => _toavater;

  Data({
      int id, 
      String fromuid, 
      String touid, 
      String content, 
      String time, 
      int relationid, 
      String fromusername, 
      String fromnickname, 
      dynamic fromavater, 
      String tousername, 
      String tonickname, 
      String toavater}){
    _id = id;
    _fromuid = fromuid;
    _touid = touid;
    _content = content;
    _time = time;
    _relationid = relationid;
    _fromusername = fromusername;
    _fromnickname = fromnickname;
    _fromavater = fromavater;
    _tousername = tousername;
    _tonickname = tonickname;
    _toavater = toavater;
}

  Data.fromJson(dynamic json) {
    _id = json['id'];
    _fromuid = json['fromuid'];
    _touid = json['touid'];
    _content = json['content'];
    _time = json['time'];
    _relationid = json['relationid'];
    _fromusername = json['fromusername'];
    _fromnickname = json['fromnickname'];
    _fromavater = json['fromavater'];
    _tousername = json['tousername'];
    _tonickname = json['tonickname'];
    _toavater = json['toavater'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['id'] = _id;
    map['fromuid'] = _fromuid;
    map['touid'] = _touid;
    map['content'] = _content;
    map['time'] = _time;
    map['relationid'] = _relationid;
    map['fromusername'] = _fromusername;
    map['fromnickname'] = _fromnickname;
    map['fromavater'] = _fromavater;
    map['tousername'] = _tousername;
    map['tonickname'] = _tonickname;
    map['toavater'] = _toavater;
    return map;
  }

}