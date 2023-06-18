class SchoolVideoTabBean {
  SchoolVideoTabBean({
      int errno, 
      String errmsg, 
      List<Data> data,}){
    _errno = errno;
    _errmsg = errmsg;
    _data = data;
}

  SchoolVideoTabBean.fromJson(dynamic json) {
    _errno = json['errno'];
    _errmsg = json['errmsg'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data.add(Data.fromJson(v));
      });
    }
  }
  int _errno;
  String _errmsg;
  List<Data> _data;

  int get errno => _errno;
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
      int id, 
      String name, 
      dynamic sort, 
      String schoolid, 
      int pid,}){
    _id = id;
    _name = name;
    _sort = sort;
    _schoolid = schoolid;
    _pid = pid;
}

  Data.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _sort = json['sort'];
    _schoolid = json['schoolid'];
    _pid = json['pid'];
  }
  int _id;
  String _name;
  dynamic _sort;
  String _schoolid;
  int _pid;

  int get id => _id;
  String get name => _name;
  dynamic get sort => _sort;
  String get schoolid => _schoolid;
  int get pid => _pid;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['sort'] = _sort;
    map['schoolid'] = _schoolid;
    map['pid'] = _pid;
    return map;
  }

}