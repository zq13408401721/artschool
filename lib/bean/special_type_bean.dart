/// errno : 0
/// errmsg : ""
/// data : [{"id":1,"name":"色彩","sort":9},{"id":2,"name":"素描","sort":8},{"id":3,"name":"场景","sort":7}]

class SpecialTypeBean {
  int _errno;
  String _errmsg;
  List<Data> _data;

  int get errno => _errno;
  String get errmsg => _errmsg;
  List<Data> get data => _data;

  SpecialTypeBean({
      int errno, 
      String errmsg, 
      List<Data> data}){
    _errno = errno;
    _errmsg = errmsg;
    _data = data;
}

  SpecialTypeBean.fromJson(dynamic json) {
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
/// name : "色彩"
/// sort : 9

class Data {
  int _id;
  String _name;
  int _sort;
  bool _select=false;

  int get id => _id;
  String get name => _name;
  int get sort => _sort;
  bool get select => _select;
  void set select(value){
    this._select = value;
  }

  Data({
      int id, 
      String name, 
      int sort}){
    _id = id;
    _name = name;
    _sort = sort;
}

  Data.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _sort = json['sort'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['sort'] = _sort;
    return map;
  }

}