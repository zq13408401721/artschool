/// errno : 0
/// errmsg : ""
/// data : [{"id":3,"folderid":1,"name":"WechatIMG3.jpeg","url":"http://res.yimios.com:9050/pan//WechatIMG3.jpeg","type":"jpeg","date":"2021-07-21 14:35:50","state":1,"deletedate":null,"size":1311837},{"id":2,"folderid":1,"name":"WechatIMG2.jpeg","url":"http://res.yimios.com:9050/pan//WechatIMG2.jpeg","type":"jpeg","date":"2021-07-19 22:43:48","state":1,"deletedate":null,"size":1225649},{"id":1,"folderid":1,"name":"WechatIMG2.jpeg","url":null,"type":"jpeg","date":"2021-07-19 21:54:13","state":1,"deletedate":null,"size":0}]

class PanFileBean {
  int _errno;
  String _errmsg;
  List<Data> _data;

  int get errno => _errno;
  String get errmsg => _errmsg;
  List<Data> get data => _data;

  PanFileBean({
      int errno, 
      String errmsg, 
      List<Data> data}){
    _errno = errno;
    _errmsg = errmsg;
    _data = data;
}

  PanFileBean.fromJson(dynamic json) {
    _errno = json["errno"];
    _errmsg = json["errmsg"];
    if (json["data"] != null) {
      _data = [];
      json["data"].forEach((v) {
        _data.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["errno"] = _errno;
    map["errmsg"] = _errmsg;
    if (_data != null) {
      map["data"] = _data.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// id : 3
/// folderid : 1
/// name : "WechatIMG3.jpeg"
/// url : "http://res.yimios.com:9050/pan//WechatIMG3.jpeg"
/// type : "jpeg"
/// date : "2021-07-21 14:35:50"
/// state : 1
/// deletedate : null
/// size : 1311837

class Data {
  int _id;
  int _folderid;
  String _name;
  String _url;
  String _type;
  String _date;
  int _state;
  dynamic _deletedate;
  int _size;
  bool _select = false;


  set select(value) => _select = value;

  int get id => _id;
  int get folderid => _folderid;
  String get name => _name;
  String get url => _url;
  String get type => _type;
  String get date => _date;
  int get state => _state;
  dynamic get deletedate => _deletedate;
  int get size => _size;
  bool get select => _select;

  Data({
      int id, 
      int folderid, 
      String name, 
      String url, 
      String type, 
      String date, 
      int state, 
      dynamic deletedate, 
      int size}){
    _id = id;
    _folderid = folderid;
    _name = name;
    _url = url;
    _type = type;
    _date = date;
    _state = state;
    _deletedate = deletedate;
    _size = size;
}

  Data.fromJson(dynamic json) {
    _id = json["id"];
    _folderid = json["folderid"];
    _name = json["name"];
    _url = json["url"];
    _type = json["type"];
    _date = json["date"];
    _state = json["state"];
    _deletedate = json["deletedate"];
    _size = json["size"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = _id;
    map["folderid"] = _folderid;
    map["name"] = _name;
    map["url"] = _url;
    map["type"] = _type;
    map["date"] = _date;
    map["state"] = _state;
    map["deletedate"] = _deletedate;
    map["size"] = _size;
    return map;
  }

}