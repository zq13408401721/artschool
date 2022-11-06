class PanLikeBean {
  PanLikeBean({
      int errno, 
      String errmsg, 
      List<Data> data,}){
    _errno = errno;
    _errmsg = errmsg;
    _data = data;
}

  PanLikeBean.fromJson(dynamic json) {
    _errno = json['errno'];
    _errmsg = json['errmsg'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data.add(Data.fromJson(v));
      });
    }
  }
  int _errno;
  String _errmsg;
  List<Data> _data;

  int get errno => _errno;
  String get errmsg => _errmsg;
  List<Data> get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['errno'] = _errno;
    map['errmsg'] = _errmsg;
    if (_data != null) {
      map['data'] = _data.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class Data {
  Data({
      int id, 
      String uid, 
      String date, 
      String name, 
      String url, 
      num width,
      num height,
      String username, 
      dynamic nickname, 
      dynamic avater,
      num maxwidth,
      num maxheight,
      String panname,
      int imgnum,}){
    _id = id;
    _uid = uid;
    _date = date;
    _name = name;
    _url = url;
    _width = width;
    _height = height;
    _username = username;
    _nickname = nickname;
    _avater = avater;
    _maxwidth = maxwidth;
    _maxheight = maxheight;
    _panname = panname;
    _imgnum = imgnum;

}

  Data.fromJson(dynamic json) {
    _id = json['id'];
    _uid = json['uid'];
    _date = json['date'];
    _name = json['name'];
    _url = json['url'];
    _width = json['width'];
    _height = json['height'];
    _username = json['username'];
    _nickname = json['nickname'];
    _avater = json['avater'];
    _maxwidth = json['maxwidth'];
    _maxheight = json['maxheight'];
    _panname = json['panname'];
    _imgnum = json['imgnum'];
  }
  int _id;
  String _uid;
  String _date;
  String _name;
  String _url;
  num _width;
  num _height;
  String _username;
  dynamic _nickname;
  dynamic _avater;
  num _maxwidth;
  num _maxheight;
  String _panname;
  num _imgnum;


  int get id => _id;
  String get uid => _uid;
  String get date => _date;
  String get name => _name;
  String get url => _url;
  num get width => _width;
  num get height => _height;
  String get username => _username;
  dynamic get nickname => _nickname;
  dynamic get avater => _avater;
  num get maxwidth => _maxwidth;
  num get maxheight => _maxheight;
  String get panname => _panname;
  num get imgnum => _imgnum;


  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['uid'] = _uid;
    map['date'] = _date;
    map['name'] = _name;
    map['url'] = _url;
    map['width'] = _width;
    map['height'] = _height;
    map['username'] = _username;
    map['nickname'] = _nickname;
    map['avater'] = _avater;
    map['maxwidth'] = _maxwidth;
    map['maxheight'] = _maxheight;
    map['panname'] = _panname;
    map['imgnum'] = _imgnum;
    return map;
  }

}