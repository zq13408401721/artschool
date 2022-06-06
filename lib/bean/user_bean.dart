/// errno : 0
/// errmsg : ""
/// data : [{"id":222,"name":"刘*沛"},{"id":2440,"name":"建*"},{"id":526,"name":"郭*天"},{"id":1437,"name":"吴*杰"},{"id":2667,"name":"吴*雯"},{"id":1741,"name":"张*佩"},{"id":2523,"name":"林*玮"},{"id":201,"name":"周*婷"},{"id":31,"name":"张*萍"},{"id":1346,"name":"林*玲"},{"id":1343,"name":"冯*泰"},{"id":926,"name":"陈*廷"},{"id":138,"name":"叶*婷"},{"id":2838,"name":"张*良"},{"id":3024,"name":"黄*韦"},{"id":8,"name":"张*玫"},{"id":2786,"name":"王*婷"},{"id":2437,"name":"季*达"},{"id":1898,"name":"罗*君"},{"id":941,"name":"陈*木"}]

class UserBean {
  int _errno;
  String _errmsg;
  List<Data> _data;

  int get errno => _errno;
  String get errmsg => _errmsg;
  List<Data> get data => _data;

  UserBean({
      int errno, 
      String errmsg, 
      List<Data> data}){
    _errno = errno;
    _errmsg = errmsg;
    _data = data;
}

  UserBean.fromJson(dynamic json) {
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

/// id : 222
/// name : "刘*沛"

class Data {
  int _id;
  String _name;

  int get id => _id;
  String get name => _name;

  Data({
      int id, 
      String name}){
    _id = id;
    _name = name;
}

  Data.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    return map;
  }

}