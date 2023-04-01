class BookImageBean {
  BookImageBean({
      int errno, 
      String errmsg, 
      List<Data> data,}){
    _errno = errno;
    _errmsg = errmsg;
    _data = data;
}

  BookImageBean.fromJson(dynamic json) {
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
      int bookid, 
      String name, 
      String path, 
      String url, 
      String createtime, 
      int width, 
      int height, 
      int maxwidth, 
      int maxheight,}){
    _id = id;
    _bookid = bookid;
    _name = name;
    _path = path;
    _url = url;
    _createtime = createtime;
    _width = width;
    _height = height;
    _maxwidth = maxwidth;
    _maxheight = maxheight;
}

  Data.fromJson(dynamic json) {
    _id = json['id'];
    _bookid = json['bookid'];
    _name = json['name'];
    _path = json['path'];
    _url = json['url'];
    _createtime = json['createtime'];
    _width = json['width'];
    _height = json['height'];
    _maxwidth = json['maxwidth'];
    _maxheight = json['maxheight'];
  }
  int _id;
  int _bookid;
  String _name;
  String _path;
  String _url;
  String _createtime;
  int _width;
  int _height;
  int _maxwidth;
  int _maxheight;

  int get id => _id;
  int get bookid => _bookid;
  String get name => _name;
  String get path => _path;
  String get url => _url;
  String get createtime => _createtime;
  int get width => _width;
  int get height => _height;
  int get maxwidth => _maxwidth;
  int get maxheight => _maxheight;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['bookid'] = _bookid;
    map['name'] = _name;
    map['path'] = _path;
    map['url'] = _url;
    map['createtime'] = _createtime;
    map['width'] = _width;
    map['height'] = _height;
    map['maxwidth'] = _maxwidth;
    map['maxheight'] = _maxheight;
    return map;
  }

}