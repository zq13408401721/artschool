/// errno : 0
/// errmsg : ""
/// data : {"userinfo":{"uid":"b4e4909f-6cf3-497e-981b-13449e438ea3","username":"student1","nickname":"系统测试","avater":null,"role":1,"schoolid":"1372445644860735500","token":"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiYjRlNDkwOWYtNmNmMy00OTdlLTk4MWItMTM0NDllNDM4ZWEzIiwic2Nob29saWQiOiIxMzcyNDQ1NjQ0ODYwNzM1NTAwIiwicm9sZSI6MSwiaWF0IjoxNjM0ODc2OTgzfQ.vjucyJFfId_seOulGGOsuqc8wDNE0vky7Dmmu9q8RpE","schoolname":"多维学校","phone":null},"classes":[{"id":3,"name":"A1班级","date":"2021-08-11 23:39:10","maxnum":500}],"relation":[{"id":1,"initiativeuid":"b4e4909f-6cf3-497e-981b-13449e438ea3","relevancyuid":"e82cf39e-dfa1-45db-90dc-f5a6035a3b15","createtime":"2021-10-22"}]}

class LoginBean {
  int _errno;
  String _errmsg;
  Data _data;

  int get errno => _errno;
  String get errmsg => _errmsg;
  Data get data => _data;

  LoginBean({
      int errno, 
      String errmsg, 
      Data data}){
    _errno = errno;
    _errmsg = errmsg;
    _data = data;
}

  LoginBean.fromJson(dynamic json) {
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

/// userinfo : {"uid":"b4e4909f-6cf3-497e-981b-13449e438ea3","username":"student1","nickname":"系统测试","avater":null,"role":1,"schoolid":"1372445644860735500","token":"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiYjRlNDkwOWYtNmNmMy00OTdlLTk4MWItMTM0NDllNDM4ZWEzIiwic2Nob29saWQiOiIxMzcyNDQ1NjQ0ODYwNzM1NTAwIiwicm9sZSI6MSwiaWF0IjoxNjM0ODc2OTgzfQ.vjucyJFfId_seOulGGOsuqc8wDNE0vky7Dmmu9q8RpE","schoolname":"多维学校","phone":null}
/// classes : [{"id":3,"name":"A1班级","date":"2021-08-11 23:39:10","maxnum":500}]
/// relation : [{"id":1,"initiativeuid":"b4e4909f-6cf3-497e-981b-13449e438ea3","relevancyuid":"e82cf39e-dfa1-45db-90dc-f5a6035a3b15","createtime":"2021-10-22"}]

class Data {
  Userinfo _userinfo;
  List<Classes> _classes;
  List<Relation> _relation;

  Userinfo get userinfo => _userinfo;
  List<Classes> get classes => _classes;
  List<Relation> get relation => _relation;

  Data({
      Userinfo userinfo, 
      List<Classes> classes, 
      List<Relation> relation}){
    _userinfo = userinfo;
    _classes = classes;
    _relation = relation;
}

  Data.fromJson(dynamic json) {
    _userinfo = json['userinfo'] != null ? Userinfo.fromJson(json['userinfo']) : null;
    if (json['classes'] != null) {
      _classes = [];
      json['classes'].forEach((v) {
        _classes.add(Classes.fromJson(v));
      });
    }
    if (json['relation'] != null) {
      _relation = [];
      json['relation'].forEach((v) {
        _relation.add(Relation.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    if (_userinfo != null) {
      map['userinfo'] = _userinfo.toJson();
    }
    if (_classes != null) {
      map['classes'] = _classes.map((v) => v.toJson()).toList();
    }
    if (_relation != null) {
      map['relation'] = _relation.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// id : 1
/// initiativeuid : "b4e4909f-6cf3-497e-981b-13449e438ea3"
/// relevancyuid : "e82cf39e-dfa1-45db-90dc-f5a6035a3b15"
/// createtime : "2021-10-22"

class Relation {
  int _id;
  String _initiativeuid;
  String _relevancyuid;
  String _createtime;

  int get id => _id;
  String get initiativeuid => _initiativeuid;
  String get relevancyuid => _relevancyuid;
  String get createtime => _createtime;

  Relation({
      int id, 
      String initiativeuid, 
      String relevancyuid, 
      String createtime}){
    _id = id;
    _initiativeuid = initiativeuid;
    _relevancyuid = relevancyuid;
    _createtime = createtime;
}

  Relation.fromJson(dynamic json) {
    _id = json['id'];
    _initiativeuid = json['initiativeuid'];
    _relevancyuid = json['relevancyuid'];
    _createtime = json['createtime'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['id'] = _id;
    map['initiativeuid'] = _initiativeuid;
    map['relevancyuid'] = _relevancyuid;
    map['createtime'] = _createtime;
    return map;
  }

}

/// id : 3
/// name : "A1班级"
/// date : "2021-08-11 23:39:10"
/// maxnum : 500

class Classes {
  int _id;
  String _name;
  String _date;
  int _maxnum;

  int get id => _id;
  String get name => _name;
  String get date => _date;
  int get maxnum => _maxnum;

  Classes({
      int id, 
      String name, 
      String date, 
      int maxnum}){
    _id = id;
    _name = name;
    _date = date;
    _maxnum = maxnum;
}

  Classes.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _date = json['date'];
    _maxnum = json['maxnum'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['date'] = _date;
    map['maxnum'] = _maxnum;
    return map;
  }

}

/// uid : "b4e4909f-6cf3-497e-981b-13449e438ea3"
/// username : "student1"
/// nickname : "系统测试"
/// avater : null
/// role : 1
/// schoolid : "1372445644860735500"
/// token : "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiYjRlNDkwOWYtNmNmMy00OTdlLTk4MWItMTM0NDllNDM4ZWEzIiwic2Nob29saWQiOiIxMzcyNDQ1NjQ0ODYwNzM1NTAwIiwicm9sZSI6MSwiaWF0IjoxNjM0ODc2OTgzfQ.vjucyJFfId_seOulGGOsuqc8wDNE0vky7Dmmu9q8RpE"
/// schoolname : "多维学校"
/// phone : null

class Userinfo {
  String _uid;
  String _username;
  String _nickname;
  dynamic _avater;
  int _role;
  String _schoolid;
  String _token;
  String _schoolname;
  dynamic _phone;
  String _appname;
  String _appicon;

  String get uid => _uid;
  String get username => _username;
  String get nickname => _nickname;
  dynamic get avater => _avater;
  int get role => _role;
  String get schoolid => _schoolid;
  String get token => _token;
  String get schoolname => _schoolname;
  dynamic get phone => _phone;
  String get appname => _appname;
  String get appicon => _appicon;

  Userinfo({
      String uid, 
      String username, 
      String nickname, 
      dynamic avater, 
      int role, 
      String schoolid, 
      String token, 
      String schoolname, 
      dynamic phone,
      String appname,
      String appicon}){
    _uid = uid;
    _username = username;
    _nickname = nickname;
    _avater = avater;
    _role = role;
    _schoolid = schoolid;
    _token = token;
    _schoolname = schoolname;
    _phone = phone;
    _appname = appname;
    _appicon = appicon;
}

  Userinfo.fromJson(dynamic json) {
    _uid = json['uid'];
    _username = json['username'];
    _nickname = json['nickname'];
    _avater = json['avater'];
    _role = json['role'];
    _schoolid = json['schoolid'];
    _token = json['token'];
    _schoolname = json['schoolname'];
    _phone = json['phone'];
    _appname = json['appname'];
    _appicon = json['appicon'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['uid'] = _uid;
    map['username'] = _username;
    map['nickname'] = _nickname;
    map['avater'] = _avater;
    map['role'] = _role;
    map['schoolid'] = _schoolid;
    map['token'] = _token;
    map['schoolname'] = _schoolname;
    map['phone'] = _phone;
    map['appname'] = _appname;
    map['appicon'] = _appicon;
    return map;
  }

}