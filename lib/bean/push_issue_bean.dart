/// errno : 0
/// errmsg : ""
/// data : [3879]

class PushIssueBean {
  int _errno;
  String _errmsg;
  List<int> _data;

  int get errno => _errno;
  String get errmsg => _errmsg;
  List<int> get data => _data;

  PushIssueBean({
      int errno, 
      String errmsg, 
      List<int> data}){
    _errno = errno;
    _errmsg = errmsg;
    _data = data;
}

  PushIssueBean.fromJson(dynamic json) {
    _errno = json['errno'];
    _errmsg = json['errmsg'];
    _data = json['data'] != null ? json['data'].cast<int>() : [];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['errno'] = _errno;
    map['errmsg'] = _errmsg;
    map['data'] = _data;
    return map;
  }

}