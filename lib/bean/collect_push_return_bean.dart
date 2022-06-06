/// errno : 0
/// errmsg : ""
/// data : {"dataid":1,"ids":[[3087,3088],[3089,3090]]}

class CollectPushReturnBean {
  int _errno;
  String _errmsg;
  Data _data;

  int get errno => _errno;
  String get errmsg => _errmsg;
  Data get data => _data;

  CollectPushReturnBean({
      int errno, 
      String errmsg, 
      Data data}){
    _errno = errno;
    _errmsg = errmsg;
    _data = data;
}

  CollectPushReturnBean.fromJson(dynamic json) {
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

/// dataid : 1
/// ids : [[3087,3088],[3089,3090]]

class Data {
  int _dataid;
  String _msg;

  int get dataid => _dataid;
  String get msg => _msg;

  Data({
      int dataid, 
      String msg}){
    _dataid = dataid;
    _msg = msg;
}

  Data.fromJson(dynamic json) {
    _dataid = json['dataid'];
    _msg = json['msg'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['dataid'] = _dataid;
    map['msg'] = _msg;
    return map;
  }

}