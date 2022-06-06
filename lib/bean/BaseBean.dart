
class BaseBean{
  int _errno;
  dynamic _data;
  String _errmsg;

  int get errno => _errno;
  set errno(value){
    _errno = value;
  }
  String get errmsg => _errmsg;
  set errmsg(value){
    _errmsg = value;
  }

  String get data => _data;
  set data(value){
    _data = value;
  }

  BaseBean.fromJson(Map<String,dynamic> json){
    _errno = json['errno'];
    _errmsg = json['errmsg'];
    if(json['data'] != null){
      _data = json['data'];
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['errno'] = _errno;
    map['errmsg'] = _errmsg;
    if (_data != null) {
      map['data'] = _data;
    }
    return map;
  }



}

