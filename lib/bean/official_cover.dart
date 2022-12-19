class OfficialCover {
  OfficialCover({
      int errno, 
      String errmsg, 
      List<Data> data,}){
    _errno = errno;
    _errmsg = errmsg;
    _data = data;
}

  OfficialCover.fromJson(dynamic json) {
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
      int pid, 
      int sort, 
      String schoolid, 
      dynamic cover, 
      dynamic description, 
      dynamic date, 
      dynamic isfinal, 
      dynamic book,
      int width,
      int height}){
    _id = id;
    _name = name;
    _pid = pid;
    _sort = sort;
    _schoolid = schoolid;
    _cover = cover;
    _description = description;
    _date = date;
    _isfinal = isfinal;
    _book = book;
    _width = width;
    _height = height;
}

  Data.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _pid = json['pid'];
    _sort = json['sort'];
    _schoolid = json['schoolid'];
    _cover = json['cover'];
    _description = json['description'];
    _date = json['date'];
    _isfinal = json['isfinal'];
    _book = json['book'];
    _width = json['width'];
    _height = json['height'];
  }
  int _id;
  String _name;
  int _pid;
  int _sort;
  String _schoolid;
  dynamic _cover;
  dynamic _description;
  dynamic _date;
  dynamic _isfinal;
  dynamic _book;
  int _width;
  int _height;

  int get id => _id;
  String get name => _name;
  int get pid => _pid;
  int get sort => _sort;
  String get schoolid => _schoolid;
  dynamic get cover => _cover;
  dynamic get description => _description;
  dynamic get date => _date;
  dynamic get isfinal => _isfinal;
  dynamic get book => _book;
  int get width => _width;
  int get height => _height;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['pid'] = _pid;
    map['sort'] = _sort;
    map['schoolid'] = _schoolid;
    map['cover'] = _cover;
    map['description'] = _description;
    map['date'] = _date;
    map['isfinal'] = _isfinal;
    map['book'] = _book;
    map['width'] = _width;
    map['height'] = _height;
    return map;
  }

}