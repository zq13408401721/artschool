/// errno : 0
/// errmsg : ""
/// data : {"uid":"e82cf39e-dfa1-45db-90dc-f5a6035a3b15","columnid":"1"}

class ColumnSubscribleCommonBean {
  int _errno;
  String _errmsg;
  Data _data;

  int get errno => _errno;
  String get errmsg => _errmsg;
  Data get data => _data;

  ColumnSubscribleCommonBean({
      int errno, 
      String errmsg, 
      Data data}){
    _errno = errno;
    _errmsg = errmsg;
    _data = data;
}

  ColumnSubscribleCommonBean.fromJson(dynamic json) {
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

/// uid : "e82cf39e-dfa1-45db-90dc-f5a6035a3b15"
/// columnid : "1"

class Data {
  String _uid;
  int _columnid;

  String get uid => _uid;
  int get columnid => _columnid;

  Data({
      String uid, 
      int columnid}){
    _uid = uid;
    _columnid = columnid;
}

  Data.fromJson(dynamic json) {
    _uid = json['uid'];
    _columnid = json['columnid'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['uid'] = _uid;
    map['columnid'] = _columnid;
    return map;
  }

}