/// errno : 0
/// errmsg : ""
/// data : [{"id":1,"content":"美 [trænzˈleɪt]  v.翻译;译;被翻译;被译成;(使)转变，变为"}]

class EgWordBean {
  int _errno;
  String _errmsg;
  List<Data> _data;

  int get errno => _errno;
  String get errmsg => _errmsg;
  List<Data> get data => _data;

  EgWordBean({
      int errno, 
      String errmsg, 
      List<Data> data}){
    _errno = errno;
    _errmsg = errmsg;
    _data = data;
}

  EgWordBean.fromJson(dynamic json) {
    _errno = json['errno'];
    _errmsg = json['errmsg'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['errno'] = _errno;
    map['errmsg'] = _errmsg;
    if (_data != null) {
      map['data'] = _data.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// id : 1
/// content : "美 [trænzˈleɪt]  v.翻译;译;被翻译;被译成;(使)转变，变为"

class Data {
  String _content;

  String get content => _content;

  Data({
      int id, 
      String content}){
    _content = content;
}

  Data.fromJson(dynamic json) {
    _content = json['content'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['content'] = _content;
    return map;
  }

}