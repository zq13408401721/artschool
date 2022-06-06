/// errno : 0
/// errmsg : ""
/// data : [{"id":2,"name":"IMG_0005","url":"http://res.yimios.com:9050/column/1/IMG_0005.JPG","width":300,"height":200,"columnid":1,"sourcewidth":2400,"sourceheight":1602,"createtime":"2021-10-17 20:07:28","sort":2,"username":"student1","nickname":"系统测试","columnname":"写生照片"},{"id":1,"name":"IMG_0004","url":"http://res.yimios.com:9050/column/1/IMG_0004.JPG","width":333,"height":500,"columnid":1,"sourcewidth":1335,"sourceheight":2000,"createtime":"2021-10-17 20:07:28","sort":1,"username":"student1","nickname":"系统测试","columnname":"写生照片"}]

class ColumnGalleryListBean {
  int _errno;
  String _errmsg;
  List<Data> _data;

  int get errno => _errno;
  String get errmsg => _errmsg;
  List<Data> get data => _data;

  ColumnGalleryListBean({
      int errno, 
      String errmsg, 
      List<Data> data}){
    _errno = errno;
    _errmsg = errmsg;
    _data = data;
}

  ColumnGalleryListBean.fromJson(dynamic json) {
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

/// id : 2
/// name : "IMG_0005"
/// url : "http://res.yimios.com:9050/column/1/IMG_0005.JPG"
/// width : 300
/// height : 200
/// columnid : 1
/// sourcewidth : 2400
/// sourceheight : 1602
/// createtime : "2021-10-17 20:07:28"
/// sort : 2
/// username : "student1"
/// nickname : "系统测试"
/// columnname : "写生照片"

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
  String _username;
  String _nickname;
  String _columnname;
  String _avater;

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
  String get username => _username;
  String get nickname => _nickname;
  String get columnname => _columnname;
  String get avater => _avater;

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
      String username, 
      String nickname, 
      String columnname,
      String avater}){
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
    _username = username;
    _nickname = nickname;
    _columnname = columnname;
    _avater = avater;
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
    _username = json['username'];
    _nickname = json['nickname'];
    _columnname = json['columnname'];
    _avater = json['avater'];
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
    map['username'] = _username;
    map['nickname'] = _nickname;
    map['columnname'] = _columnname;
    map['avater'] = _avater;
    return map;
  }

}