class PanBean {
  PanBean({
      num errno, 
      String errmsg, 
      List<Data> data,}){
    _errno = errno;
    _errmsg = errmsg;
    _data = data;
  }

  PanBean.fromJson(dynamic json) {
    _errno = json['errno'];
    _errmsg = json['errmsg'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data.add(Data.fromJson(v));
      });
    }
  }
  num _errno;
  String _errmsg;
  List<Data> _data;

  num get errno => _errno;
  String get errmsg => _errmsg;
  List<Data> get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['errno'] = _errno;
    map['errmsg'] = _errmsg;
    if (_data != null) {
      map['data'] = _data.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class Data {
  Data({
      num id, 
      String panid, 
      String name,}){
    _id = id;
    _panid = panid;
    _name = name;
}

  Data.fromJson(dynamic json) {
    _id = json['id'];
    _panid = json['panid'];
    _name = json['name'];
  }
  num _id;
  String _panid;
  String _name;

  num get id => _id;
  String get panid => _panid;
  String get name => _name;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['panid'] = _panid;
    map['name'] = _name;
    return map;
  }

}