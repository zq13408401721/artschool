class PanToppingBean {
  PanToppingBean({
      num errno, 
      String errmsg, 
      Data data,}){
    _errno = errno;
    _errmsg = errmsg;
    _data = data;
  }

  PanToppingBean.fromJson(dynamic json) {
    _errno = json['errno'];
    _errmsg = json['errmsg'];
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
  num _errno;
  String _errmsg;
  Data _data;

  num get errno => _errno;
  String get errmsg => _errmsg;
  Data get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['errno'] = _errno;
    map['errmsg'] = _errmsg;
    if (_data != null) {
      map['data'] = _data.toJson();
    }
    return map;
  }

}

class Data {
  Data({
      num top,}){
    _top = top;
}

  Data.fromJson(dynamic json) {
    _top = json['top'];
  }
  num _top;

  num get top => _top;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['top'] = _top;
    return map;
  }

}