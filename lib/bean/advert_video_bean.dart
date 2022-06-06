/// errno : 0
/// errmsg : ""
/// data : {"id":1,"name":"APP宣传视频","url":"http://res.yimios.com:9050/videos/advert/APP宣传视频.mp4"}

class AdvertVideoBean {
  int _errno;
  String _errmsg;
  Data _data;

  int get errno => _errno;
  String get errmsg => _errmsg;
  Data get data => _data;

  AdvertVideoBean({
      int errno, 
      String errmsg, 
      Data data}){
    _errno = errno;
    _errmsg = errmsg;
    _data = data;
}

  AdvertVideoBean.fromJson(dynamic json) {
    _errno = json['errno'];
    _errmsg = json['errmsg'];
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['errno'] = _errno;
    map['errmsg'] = _errmsg;
    if (_data != null) {
      map['data'] = _data.toJson();
    }
    return map;
  }

}

/// id : 1
/// name : "APP宣传视频"
/// url : "http://res.yimios.com:9050/videos/advert/APP宣传视频.mp4"

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