/// errno : 0
/// errmsg : ""
/// data : {"nickname":"张三"}

class EditUserInfoBean {
  int _errno;
  String _errmsg;
  Data _data;

  int get errno => _errno;
  String get errmsg => _errmsg;
  Data get data => _data;

  EditUserInfoBean({
      int errno, 
      String errmsg, 
      Data data}){
    _errno = errno;
    _errmsg = errmsg;
    _data = data;
}

  EditUserInfoBean.fromJson(dynamic json) {
    _errno = json["errno"];
    _errmsg = json["errmsg"];
    _data = json["data"] != null ? Data.fromJson(json["data"]) : null;
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["errno"] = _errno;
    map["errmsg"] = _errmsg;
    if (_data != null) {
      map["data"] = _data.toJson();
    }
    return map;
  }

}

/// nickname : "张三"

class Data {
  String _nickname;

  String get nickname => _nickname;

  Data({
      String nickname}){
    _nickname = nickname;
}

  Data.fromJson(dynamic json) {
    _nickname = json["nickname"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["nickname"] = _nickname;
    return map;
  }

}