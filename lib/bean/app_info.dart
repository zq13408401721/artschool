/// errno : 0
/// errmsg : ""
/// data : {"id":1,"name":"艺画美术","code":12,"package":"com.yhschool","version":"1.1.2","url":"https://www.pgyer.com/L8tx","description":"1.bug修改。\\n2.发布功能更新。","date":"2021-08-30 21:22:12","model":"android","force":0}

class AppInfo {
  int _errno;
  String _errmsg;
  Data _data;

  int get errno => _errno;
  String get errmsg => _errmsg;
  Data get data => _data;

  AppInfo({
      int errno, 
      String errmsg, 
      Data data}){
    _errno = errno;
    _errmsg = errmsg;
    _data = data;
}

  AppInfo.fromJson(dynamic json) {
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
/// name : "艺画美术"
/// code : 12
/// package : "com.yhschool"
/// version : "1.1.2"
/// url : "https://www.pgyer.com/L8tx"
/// description : "1.bug修改。\\n2.发布功能更新。"
/// date : "2021-08-30 21:22:12"
/// model : "android"
/// force : 0

class Data {
  int _id;
  String _name;
  int _code;
  String _package;
  String _version;
  String _url;
  String _description;
  String _date;
  String _model;
  int _force;

  int get id => _id;
  String get name => _name;
  int get code => _code;
  String get package => _package;
  String get version => _version;
  String get url => _url;
  String get description => _description;
  set description(String value) => _description = value;
  String get date => _date;
  String get model => _model;
  int get force => _force;

  Data({
      int id, 
      String name, 
      int code, 
      String package, 
      String version, 
      String url, 
      String description, 
      String date, 
      String model, 
      int force}){
    _id = id;
    _name = name;
    _code = code;
    _package = package;
    _version = version;
    _url = url;
    _description = description;
    _date = date;
    _model = model;
    _force = force;
}

  Data.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _code = json['code'];
    _package = json['package'];
    _version = json['version'];
    _url = json['url'];
    _description = json['description'];
    _date = json['date'];
    _model = json['model'];
    _force = json['force'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['code'] = _code;
    map['package'] = _package;
    map['version'] = _version;
    map['url'] = _url;
    map['description'] = _description;
    map['date'] = _date;
    map['model'] = _model;
    map['force'] = _force;
    return map;
  }

}