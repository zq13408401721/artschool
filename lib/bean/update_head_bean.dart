/// errno : 0
/// msg : ""
/// data : {"avater":"http://res.yimios.com:9050/user/e82cf39e-dfa1-45db-90dc-f5a6035a3b15/IMG_0111.png","uid":"e82cf39e-dfa1-45db-90dc-f5a6035a3b15"}

class UpdateHeadBean {
  int _errno;
  String _msg;
  Data _data;

  int get errno => _errno;
  String get msg => _msg;
  Data get data => _data;

  UpdateHeadBean({
      int errno, 
      String msg, 
      Data data}){
    _errno = errno;
    _msg = msg;
    _data = data;
}

  UpdateHeadBean.fromJson(dynamic json) {
    _errno = json['errno'];
    _msg = json['msg'];
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['errno'] = _errno;
    map['msg'] = _msg;
    if (_data != null) {
      map['data'] = _data.toJson();
    }
    return map;
  }

}

/// avater : "http://res.yimios.com:9050/user/e82cf39e-dfa1-45db-90dc-f5a6035a3b15/IMG_0111.png"
/// uid : "e82cf39e-dfa1-45db-90dc-f5a6035a3b15"

class Data {
  String _avater;
  String _uid;

  String get avater => _avater;
  String get uid => _uid;

  Data({
      String avater, 
      String uid}){
    _avater = avater;
    _uid = uid;
}

  Data.fromJson(dynamic json) {
    _avater = json['avater'];
    _uid = json['uid'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['avater'] = _avater;
    map['uid'] = _uid;
    return map;
  }

}