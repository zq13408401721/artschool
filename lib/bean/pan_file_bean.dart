class PanFileBean {
  PanFileBean({
      num errno, 
      String errmsg, 
      List<Data> data,}){
    _errno = errno;
    _errmsg = errmsg;
    _data = data;
}

  PanFileBean.fromJson(dynamic json) {
    _errno = json['errno'];
    _errmsg = json['errmsg'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data.add(Data.fromJson(v));
      });
    }
  }
  num _errno;
  String _errmsg;
  List<Data> _data;

  num get errno => _errno;
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
      num id, 
      String name, 
      String url, 
      String suffix, 
      String date, 
      num state, 
      num size,
      num width,
      num height,
      num maxwidth,
      num maxheight,
      String panname,
      num imgnum,
      num like,}){
    _id = id;
    _name = name;
    _url = url;
    _suffix = suffix;
    _date = date;
    _size = size;
    _width = width;
    _height = height;
    _maxwidth = maxwidth;
    _maxheight = maxheight;
    _panname = panname;
    _imgnum = imgnum;
    _like = like;
}

  Data.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _url = json['url'];
    _suffix = json['suffix'];
    _date = json['date'];
    _size = json['size'];
    _width = json['width'];
    _height = json['height'];
    _maxwidth = json['maxwidth'];
    _maxheight = json['maxheight'];
    _panname = json['panname'];
    _imgnum = json['imgnum'];
    _like = json['like'];
  }
  num _id;
  String _name;
  String _url;
  String _suffix;
  String _date;
  num _size;
  num _width;
  num _height;
  num _maxwidth;
  num _maxheight;
  String _panname;
  num _imgnum;
  num _like;

  num get id => _id;
  String get name => _name;
  String get url => _url;
  String get suffix => _suffix;
  String get date => _date;
  num get size => _size;
  num get width => _width;
  num get height => _height;
  num get maxwidth => _maxwidth;
  num get maxheight => _maxheight;
  String get panname => _panname;
  num get imgnum => _imgnum;
  num get like => _like;
  void set like(value){
    _like = value;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['url'] = _url;
    map['suffix'] = _suffix;
    map['date'] = _date;
    map['size'] = _size;
    map['width'] = _width;
    map['height'] = _height;
    map['maxwidth'] = _maxwidth;
    map['maxheight'] = _maxheight;
    map['panname'] = _panname;
    map['imgnum'] = _imgnum;
    map['like'] = _like;
    return map;
  }

}