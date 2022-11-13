class PanFileToppingBean {
  PanFileToppingBean({
      int errno, 
      String errmsg, 
      int data,}){
    _errno = errno;
    _errmsg = errmsg;
    _data = data;
}

  PanFileToppingBean.fromJson(dynamic json) {
    _errno = json['errno'];
    _errmsg = json['errmsg'];
    _data = json['data'];
  }
  int _errno;
  String _errmsg;
  int _data;

  int get errno => _errno;
  String get errmsg => _errmsg;
  int get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['errno'] = _errno;
    map['errmsg'] = _errmsg;
    map['data'] = _data;
    return map;
  }

}