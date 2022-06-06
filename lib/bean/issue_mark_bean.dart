/// errno : 0
/// errmsg : ""
/// data : {"markid":2}

class IssueMarkBean {
  int _errno;
  String _errmsg;
  Data _data;

  int get errno => _errno;
  String get errmsg => _errmsg;
  Data get data => _data;

  IssueMarkBean({
      int errno, 
      String errmsg, 
      Data data}){
    _errno = errno;
    _errmsg = errmsg;
    _data = data;
}

  IssueMarkBean.fromJson(dynamic json) {
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

/// markid : 2

class Data {
  int _markid;

  int get markid => _markid;

  Data({
      int markid}){
    _markid = markid;
}

  Data.fromJson(dynamic json) {
    _markid = json['markid'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['markid'] = _markid;
    return map;
  }

}