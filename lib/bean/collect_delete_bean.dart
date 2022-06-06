/// errno : 0
/// errmsg : ""
/// data : {"uid":"23cd8a79-8b01-464f-aef9-8ea991fa3442","from":"1","fromid":"2954","type":"1"}

class CollectDeleteBean {
  int _errno;
  String _errmsg;
  Data _data;

  int get errno => _errno;
  String get errmsg => _errmsg;
  Data get data => _data;

  CollectDeleteBean({
      int errno, 
      String errmsg, 
      Data data}){
    _errno = errno;
    _errmsg = errmsg;
    _data = data;
}

  CollectDeleteBean.fromJson(dynamic json) {
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

/// uid : "23cd8a79-8b01-464f-aef9-8ea991fa3442"
/// from : "1"
/// fromid : "2954"
/// type : "1"

class Data {
  String _uid;
  int _from;
  int _fromid;
  int _type;

  String get uid => _uid;
  int get from => _from;
  int get fromid => _fromid;
  int get type => _type;

  Data({
      String uid, 
      int from,
      int fromid,
      int type}){
    _uid = uid;
    _from = from;
    _fromid = fromid;
    _type = type;
}

  Data.fromJson(dynamic json) {
    _uid = json['uid'];
    _from = json['from'];
    _fromid = json['fromid'];
    _type = json['type'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['uid'] = _uid;
    map['from'] = _from;
    map['fromid'] = _fromid;
    map['type'] = _type;
    return map;
  }

}