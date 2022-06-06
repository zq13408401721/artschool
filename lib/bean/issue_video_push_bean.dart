/// errno : 0
/// errmsg : ""
/// data : [2,3]

class IssueVideoPushBean {
  int _errno;
  String _errmsg;
  List<int> _data;

  int get errno => _errno;
  String get errmsg => _errmsg;
  List<int> get data => _data;

  IssueVideoPushBean({
      int errno, 
      String errmsg, 
      List<int> data}){
    _errno = errno;
    _errmsg = errmsg;
    _data = data;
}

  IssueVideoPushBean.fromJson(dynamic json) {
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