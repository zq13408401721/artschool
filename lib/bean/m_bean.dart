/// errno : 0
/// errmsg : ""
/// data : [{"id":1,"name":"super psycho love（银魂MMD.3D）","url":"http://res.yimios.com:9050/videos/mv/super%20psycho%20love%EF%BC%88%E9%93%B6%E9%AD%82MMD.3D%EF%BC%89.mp4"}]

class MBean {
  int _errno;
  String _errmsg;
  List<Data> _data;

  int get errno => _errno;
  String get errmsg => _errmsg;
  List<Data> get data => _data;

  MBean({
      int errno, 
      String errmsg, 
      List<Data> data}){
    _errno = errno;
    _errmsg = errmsg;
    _data = data;
}

  MBean.fromJson(dynamic json) {
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
/// name : "super psycho love（银魂MMD.3D）"
/// url : "http://res.yimios.com:9050/videos/mv/super%20psycho%20love%EF%BC%88%E9%93%B6%E9%AD%82MMD.3D%EF%BC%89.mp4"

class Data {
  int _id;
  String _name;
  String _url;

  int get id => _id;
  String get name => _name;
  String get url => _url;

  Data({
      int id, 
      String name, 
      String url}){
    _id = id;
    _name = name;
    _url = url;
}

  Data.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _url = json['url'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['url'] = _url;
    return map;
  }

}