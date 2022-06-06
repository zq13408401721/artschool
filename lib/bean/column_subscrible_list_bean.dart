/// errno : 0
/// errmsg : ""
/// data : [{"id":1,"columnid":1,"uid":"e82cf39e-dfa1-45db-90dc-f5a6035a3b15","createtime":"2021-10-19 19:46:32","columnname":"写生照片","username":"student1","nickname":"系统测试","url":"http://res.yimios.com:9050/column/1/IMG_0005.JPG","count":2},{"id":1,"columnid":1,"uid":"e82cf39e-dfa1-45db-90dc-f5a6035a3b15","createtime":"2021-10-19 19:46:32","columnname":"写生照片","username":"student1","nickname":"系统测试","url":"http://res.yimios.com:9050/column/1/IMG_0004.JPG","count":2}]

class ColumnSubscribleListBean {
  int _errno;
  String _errmsg;
  List<Data> _data;

  int get errno => _errno;
  String get errmsg => _errmsg;
  List<Data> get data => _data;

  ColumnSubscribleListBean({
      int errno, 
      String errmsg, 
      List<Data> data}){
    _errno = errno;
    _errmsg = errmsg;
    _data = data;
}

  ColumnSubscribleListBean.fromJson(dynamic json) {
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
/// columnid : 1
/// uid : "e82cf39e-dfa1-45db-90dc-f5a6035a3b15"
/// createtime : "2021-10-19 19:46:32"
/// columnname : "写生照片"
/// username : "student1"
/// nickname : "系统测试"
/// url : "http://res.yimios.com:9050/column/1/IMG_0005.JPG"
/// count : 2

class Data {
  int _id;
  int _columnid;
  String _uid;
  String _createtime;
  String _columnname;
  String _username;
  String _nickname;
  String _subscribleuid; //被订阅的uid
  String _url;
  int _count;
  int _width;
  int _height;
  String _avater;

  int get id => _id;
  int get columnid => _columnid;
  String get uid => _uid;
  String get createtime => _createtime;
  String get columnname => _columnname;
  String get username => _username;
  String get nickname => _nickname;
  String get subscribleuid => _subscribleuid;

  String get url => _url;
  int get count => _count;
  int get width => _width;
  int get height => _height;
  String get avater => _avater;

  Data({
      int id, 
      int columnid, 
      String uid, 
      String createtime, 
      String columnname, 
      String username, 
      String nickname, 
      String url, 
      int count,
      int width,
      int height,
      String avater,
      String subscribleuid}){
    _id = id;
    _columnid = columnid;
    _uid = uid;
    _createtime = createtime;
    _columnname = columnname;
    _username = username;
    _nickname = nickname;
    _subscribleuid = subscribleuid;
    _url = url;
    _count = count;
    _width = width;
    _height = height;
    _avater = avater;
}

  Data.fromJson(dynamic json) {
    _id = json['id'];
    _columnid = json['columnid'];
    _uid = json['uid'];
    _createtime = json['createtime'];
    _columnname = json['columnname'];
    _username = json['username'];
    _nickname = json['nickname'];
    _url = json['url'];
    _count = json['count'];
    _width = json['width'];
    _height = json['height'];
    _subscribleuid = json['subscribleuid'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['id'] = _id;
    map['columnid'] = _columnid;
    map['uid'] = _uid;
    map['createtime'] = _createtime;
    map['columnname'] = _columnname;
    map['username'] = _username;
    map['nickname'] = _nickname;
    map['url'] = _url;
    map['count'] = _count;
    map['width'] = _width;
    map['height'] = _height;
    map['avater'] = _avater;
    map['subscribleuid'] = _subscribleuid;
    return map;
  }

}