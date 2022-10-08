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
      dynamic deletedate, 
      num size, 
      dynamic path, 
      dynamic width, 
      dynamic height,}){
    _id = id;
    _name = name;
    _url = url;
    _suffix = suffix;
    _date = date;
    _state = state;
    _deletedate = deletedate;
    _size = size;
    _path = path;
    _width = width;
    _height = height;
}

  Data.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _url = json['url'];
    _suffix = json['suffix'];
    _date = json['date'];
    _state = json['state'];
    _deletedate = json['deletedate'];
    _size = json['size'];
    _path = json['path'];
    _width = json['width'];
    _height = json['height'];
  }
  num _id;
  String _name;
  String _url;
  String _suffix;
  String _date;
  num _state;
  dynamic _deletedate;
  num _size;
  dynamic _path;
  dynamic _width;
  dynamic _height;

  num get id => _id;
  String get name => _name;
  String get url => _url;
  String get suffix => _suffix;
  String get date => _date;
  num get state => _state;
  dynamic get deletedate => _deletedate;
  num get size => _size;
  dynamic get path => _path;
  dynamic get width => _width;
  dynamic get height => _height;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['url'] = _url;
    map['suffix'] = _suffix;
    map['date'] = _date;
    map['state'] = _state;
    map['deletedate'] = _deletedate;
    map['size'] = _size;
    map['path'] = _path;
    map['width'] = _width;
    map['height'] = _height;
    return map;
  }

}