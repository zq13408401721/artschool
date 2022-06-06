/// errno : 0
/// errmsg : ""
/// data : [{"id":1,"name":"写生照片","uid":"b4e4909f-6cf3-497e-981b-13449e438ea3","type":1,"visible":0,"schoolid":"1372445644860735500","createtime":"2021-10-16 16:51:54","nickname":"系统测试","username":"student1","number":0,"url":null,"width":null,"height":null}]

class ColumnMineBean {
  int _errno;
  String _errmsg;
  List<Data> _data;

  int get errno => _errno;
  String get errmsg => _errmsg;
  List<Data> get data => _data;

  ColumnMineBean({
      int errno, 
      String errmsg, 
      List<Data> data}){
    _errno = errno;
    _errmsg = errmsg;
    _data = data;
}

  ColumnMineBean.fromJson(dynamic json) {
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
/// name : "写生照片"
/// uid : "b4e4909f-6cf3-497e-981b-13449e438ea3"
/// type : 1
/// visible : 0
/// schoolid : "1372445644860735500"
/// createtime : "2021-10-16 16:51:54"
/// nickname : "系统测试"
/// username : "student1"
/// number : 0
/// url : null
/// width : null
/// height : null

class Data {
  int _id;
  String _name;
  String _uid;
  int _type;
  int _visible;
  String _schoolid;
  String _createtime;
  String _nickname;
  String _username;
  int _number;
  String _url;
  int _width;
  int _height;
  String _avater;

  int get id => _id;
  String get name => _name;
  String get uid => _uid;
  int get type => _type;
  int get visible => _visible;
  String get schoolid => _schoolid;
  String get createtime => _createtime;
  String get nickname => _nickname;
  String get username => _username;
  int get number => _number;
  String get url => _url;
  void set url(value){
    _url = value;
  }
  int get width => _width;
  void set width(value){
    _width = value;
  }
  int get height => _height;
  void set height(value){
    _height = value;
  }
  String get avater => _avater;

  Data({
      int id, 
      String name, 
      String uid, 
      int type, 
      int visible, 
      String schoolid, 
      String createtime, 
      String nickname, 
      String username, 
      int number, 
      String url,
      int width,
      int height,
      String avater}){
    _id = id;
    _name = name;
    _uid = uid;
    _type = type;
    _visible = visible;
    _schoolid = schoolid;
    _createtime = createtime;
    _nickname = nickname;
    _username = username;
    _number = number;
    _url = url;
    _width = width;
    _height = height;
    _avater = avater;
}

  Data.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _uid = json['uid'];
    _type = json['type'];
    _visible = json['visible'];
    _schoolid = json['schoolid'];
    _createtime = json['createtime'];
    _nickname = json['nickname'];
    _username = json['username'];
    _number = json['number'];
    _url = json['url'];
    _width = json['width'];
    _height = json['height'];
    _avater = json['avater'];
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
    map['nickname'] = _nickname;
    map['username'] = _username;
    map['number'] = _number;
    map['url'] = _url;
    map['width'] = _width;
    map['height'] = _height;
    map['avater'] = _avater;
    return map;
  }

}