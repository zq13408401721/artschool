/// errno : 0
/// errmsg : ""
/// data : {"msg":"修改成功"}

class EditUserPWBean {
  int _errno;
  String _errmsg;
  Data _data;

  int get errno => _errno;
  String get errmsg => _errmsg;
  Data get data => _data;

  EditUserPWBean({
      int errno, 
      String errmsg, 
      Data data}){
    _errno = errno;
    _errmsg = errmsg;
    _data = data;
}

  EditUserPWBean.fromJson(dynamic json) {
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

/// msg : "修改成功"

class Data {
  String _msg;

  String get msg => _msg;

  Data({
      String msg}){
    _msg = msg;
}

  Data.fromJson(dynamic json) {
    _msg = json['msg'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['msg'] = _msg;
    return map;
  }

}