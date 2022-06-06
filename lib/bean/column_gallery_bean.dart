/// errno : 0
/// errmsg : ""
/// data : [{"id":3,"name":"IMG_0001","url":"http://res.yimios.com:9050/column/2/IMG_0001.JPG","width":214,"height":142,"columnid":2,"sourcewidth":3431,"sourceheight":2279,"createtime":"2021-10-18 10:00:23","sort":1,"columnname":"yhschool","columndate":"2021-10-18 10:01:50","username":"student1","nickname":"系统测试"},{"id":2,"name":"IMG_0005","url":"http://res.yimios.com:9050/column/1/IMG_0005.JPG","width":300,"height":200,"columnid":1,"sourcewidth":2400,"sourceheight":1602,"createtime":"2021-10-17 20:07:28","sort":2,"columnname":"写生照片","columndate":"2021-10-16 16:51:54","username":"student1","nickname":"系统测试"},{"id":1,"name":"IMG_0004","url":"http://res.yimios.com:9050/column/1/IMG_0004.JPG","width":333,"height":500,"columnid":1,"sourcewidth":1335,"sourceheight":2000,"createtime":"2021-10-17 20:07:28","sort":1,"columnname":"写生照片","columndate":"2021-10-16 16:51:54","username":"student1","nickname":"系统测试"}]

class ColumnGalleryBean {
  int _errno;
  String _errmsg;
  List<Data> _data;

  int get errno => _errno;
  String get errmsg => _errmsg;
  List<Data> get data => _data;

  ColumnGalleryBean({
      int errno, 
      String errmsg, 
      List<Data> data}){
    _errno = errno;
    _errmsg = errmsg;
    _data = data;
}

  ColumnGalleryBean.fromJson(dynamic json) {
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

/// id : 3
/// name : "IMG_0001"
/// url : "http://res.yimios.com:9050/column/2/IMG_0001.JPG"
/// width : 214
/// height : 142
/// columnid : 2
/// sourcewidth : 3431
/// sourceheight : 2279
/// createtime : "2021-10-18 10:00:23"
/// sort : 1
/// columnname : "yhschool"
/// columndate : "2021-10-18 10:01:50"
/// username : "student1"
/// nickname : "系统测试"

class Data {
  int _id;
  String _name;
  String _url;
  int _width;
  int _height;
  int _columnid;
  int _sourcewidth;
  int _sourceheight;
  String _createtime;
  int _sort;
  String _columnname;
  String _columndate;
  String _username;
  String _nickname;
  String _avater;
  String _uid;

  int get id => _id;
  String get name => _name;
  String get url => _url;
  int get width => _width;
  int get height => _height;
  int get columnid => _columnid;
  int get sourcewidth => _sourcewidth;
  int get sourceheight => _sourceheight;
  String get createtime => _createtime;
  int get sort => _sort;
  String get columnname => _columnname;
  String get columndate => _columndate;
  String get username => _username;
  String get nickname => _nickname;
  String get avater => _avater;
  String get uid => _uid;

  Data({
      int id, 
      String name, 
      String url, 
      int width, 
      int height, 
      int columnid, 
      int sourcewidth, 
      int sourceheight, 
      String createtime, 
      int sort, 
      String columnname, 
      String columndate, 
      String username, 
      String nickname,
      String avater,
      String uid}){
    _id = id;
    _name = name;
    _url = url;
    _width = width;
    _height = height;
    _columnid = columnid;
    _sourcewidth = sourcewidth;
    _sourceheight = sourceheight;
    _createtime = createtime;
    _sort = sort;
    _columnname = columnname;
    _columndate = columndate;
    _username = username;
    _nickname = nickname;
    _avater = avater;
    _uid = uid;
}

  Data.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _url = json['url'];
    _width = json['width'];
    _height = json['height'];
    _columnid = json['columnid'];
    _sourcewidth = json['sourcewidth'];
    _sourceheight = json['sourceheight'];
    _createtime = json['createtime'];
    _sort = json['sort'];
    _columnname = json['columnname'];
    _columndate = json['columndate'];
    _username = json['username'];
    _nickname = json['nickname'];
    _avater = json['avater'];
    _uid = json['uid'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['url'] = _url;
    map['width'] = _width;
    map['height'] = _height;
    map['columnid'] = _columnid;
    map['sourcewidth'] = _sourcewidth;
    map['sourceheight'] = _sourceheight;
    map['createtime'] = _createtime;
    map['sort'] = _sort;
    map['columnname'] = _columnname;
    map['columndate'] = _columndate;
    map['username'] = _username;
    map['nickname'] = _nickname;
    map['avater'] = _avater;
    map['uid'] = _uid;
    return map;
  }

}