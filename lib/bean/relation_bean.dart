/// errno : 0
/// errmsg : ""
/// data : [{"id":1,"initiativeuid":"b4e4909f-6cf3-497e-981b-13449e438ea3","relevancyuid":"e82cf39e-dfa1-45db-90dc-f5a6035a3b15","createtime":"2021-10-22 00:00:00"}]

class RelationBean {
  int _errno;
  String _errmsg;
  List<Data> _data;

  int get errno => _errno;
  String get errmsg => _errmsg;
  List<Data> get data => _data;

  RelationBean({
      int errno, 
      String errmsg, 
      List<Data> data}){
    _errno = errno;
    _errmsg = errmsg;
    _data = data;
}

  RelationBean.fromJson(dynamic json) {
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

/// id : 1
/// initiativeuid : "b4e4909f-6cf3-497e-981b-13449e438ea3"
/// relevancyuid : "e82cf39e-dfa1-45db-90dc-f5a6035a3b15"
/// createtime : "2021-10-22 00:00:00"

class Data {
  int _id;
  String _initiativeuid;
  String _relevancyuid;
  String _createtime;

  int get id => _id;
  String get initiativeuid => _initiativeuid;
  String get relevancyuid => _relevancyuid;
  String get createtime => _createtime;

  Data({
      int id, 
      String initiativeuid, 
      String relevancyuid, 
      String createtime}){
    _id = id;
    _initiativeuid = initiativeuid;
    _relevancyuid = relevancyuid;
    _createtime = createtime;
}

  Data.fromJson(dynamic json) {
    _id = json['id'];
    _initiativeuid = json['initiativeuid'];
    _relevancyuid = json['relevancyuid'];
    _createtime = json['createtime'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['id'] = _id;
    map['initiativeuid'] = _initiativeuid;
    map['relevancyuid'] = _relevancyuid;
    map['createtime'] = _createtime;
    return map;
  }

}