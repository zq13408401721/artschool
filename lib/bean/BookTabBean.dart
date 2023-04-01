class BookTabBean {
  BookTabBean({
      int errno, 
      String errmsg, 
      List<Data> data,}){
    _errno = errno;
    _errmsg = errmsg;
    _data = data;
}

  BookTabBean.fromJson(dynamic json) {
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
      String name,
      int sort,
      int pid,
      String schoolid,
      dynamic width,
      dynamic height,
      dynamic maxWidth,
      dynamic maxHeight,}){
    _id = id;
    _name = name;
    _sort = sort;
    _pid = pid;
    _schoolid = schoolid;
    _width = width;
    _height = height;
    _maxWidth = maxWidth;
    _maxHeight = maxHeight;
}

  Data.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _sort = json['sort'];
    _pid = json['pid'];
    _schoolid = json['schoolid'];
    _width = json['width'];
    _height = json['height'];
    _maxWidth = json['maxWidth'];
    _maxHeight = json['maxHeight'];
  }
  int _id;
  String _name;
  int _sort;
  int _pid;
  String _schoolid;
  dynamic _width;
  dynamic _height;
  dynamic _maxWidth;
  dynamic _maxHeight;

  int get id => _id;
  String get name => _name;
  int get sort => _sort;
  int get pid => _pid;
  String get schoolid => _schoolid;
  dynamic get width => _width;
  dynamic get height => _height;
  dynamic get maxWidth => _maxWidth;
  dynamic get maxHeight => _maxHeight;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['sort'] = _sort;
    map['pid'] = _pid;
    map['schoolid'] = _schoolid;
    map['width'] = _width;
    map['height'] = _height;
    map['maxWidth'] = _maxWidth;
    map['maxHeight'] = _maxHeight;
    return map;
  }

}