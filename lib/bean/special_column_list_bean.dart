/// errno : 0
/// errmsg : ""
/// data : [{"id":1,"name":null,"uid":"b4e4909f-6cf3-497e-981b-13449e438ea3","type":1,"visible":0,"schoolid":"1372445644860735500","createtime":"2021-10-16 16:51:54","username":"student1","nickname":"系统测试","url":null,"width":null,"height":null}]

class SpecialColumnListBean {
  int _errno;
  String _errmsg;
  List<Data> _data;

  int get errno => _errno;
  String get errmsg => _errmsg;
  List<Data> get data => _data;

  SpecialColumnListBean({
      int errno, 
      String errmsg, 
      List<Data> data}){
    _errno = errno;
    _errmsg = errmsg;
    _data = data;
}

  SpecialColumnListBean.fromJson(dynamic json) {
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
/// name : null
/// uid : "b4e4909f-6cf3-497e-981b-13449e438ea3"
/// type : 1
/// visible : 0
/// schoolid : "1372445644860735500"
/// createtime : "2021-10-16 16:51:54"
/// username : "student1"
/// nickname : "系统测试"
/// url : null
/// width : null
/// height : null

class Data {
  int _id;
  dynamic _name;
  String _uid;
  int _type;
  int _visible;
  String _schoolid;
  String _createtime;
  String _username;
  String _nickname;
  dynamic _url;
  dynamic _width;
  dynamic _height;

  int get id => _id;
  dynamic get name => _name;
  String get uid => _uid;
  int get type => _type;
  int get visible => _visible;
  String get schoolid => _schoolid;
  String get createtime => _createtime;
  String get username => _username;
  String get nickname => _nickname;
  dynamic get url => _url;
  dynamic get width => _width;
  dynamic get height => _height;

  Data({
      int id, 
      dynamic name, 
      String uid, 
      int type, 
      int visible, 
      String schoolid, 
      String createtime, 
      String username, 
      String nickname, 
      dynamic url, 
      dynamic width, 
      dynamic height}){
    _id = id;
    _name = name;
    _uid = uid;
    _type = type;
    _visible = visible;
    _schoolid = schoolid;
    _createtime = createtime;
    _username = username;
    _nickname = nickname;
    _url = url;
    _width = width;
    _height = height;
}

  Data.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _uid = json['uid'];
    _type = json['type'];
    _visible = json['visible'];
    _schoolid = json['schoolid'];
    _createtime = json['createtime'];
    _username = json['username'];
    _nickname = json['nickname'];
    _url = json['url'];
    _width = json['width'];
    _height = json['height'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['uid'] = _uid;
    map['type'] = _type;
    map['visible'] = _visible;
    map['schoolid'] = _schoolid;
    map['createtime'] = _createtime;
    map['username'] = _username;
    map['nickname'] = _nickname;
    map['url'] = _url;
    map['width'] = _width;
    map['height'] = _height;
    return map;
  }

}