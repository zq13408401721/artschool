class SchoolVideoListBean {
  SchoolVideoListBean({
      int errno, 
      String errmsg, 
      List<Data> data,}){
    _errno = errno;
    _errmsg = errmsg;
    _data = data;
}

  SchoolVideoListBean.fromJson(dynamic json) {
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
      int groupid, 
      String url, 
      String type, 
      String createtime, 
      int size, 
      dynamic sort, 
      int visible, 
      int width, 
      int height, 
      String cover, 
      String path,}){
    _id = id;
    _name = name;
    _groupid = groupid;
    _url = url;
    _type = type;
    _createtime = createtime;
    _size = size;
    _sort = sort;
    _visible = visible;
    _width = width;
    _height = height;
    _cover = cover;
    _path = path;
}

  Data.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _groupid = json['groupid'];
    _url = json['url'];
    _type = json['type'];
    _createtime = json['createtime'];
    _size = json['size'];
    _sort = json['sort'];
    _visible = json['visible'];
    _width = json['width'];
    _height = json['height'];
    _cover = json['cover'];
    _path = json['path'];
  }
  int _id;
  String _name;
  int _groupid;
  String _url;
  String _type;
  String _createtime;
  int _size;
  dynamic _sort;
  int _visible;
  int _width;
  int _height;
  String _cover;
  String _path;

  int get id => _id;
  String get name => _name;
  int get groupid => _groupid;
  String get url => _url;
  String get type => _type;
  String get createtime => _createtime;
  int get size => _size;
  dynamic get sort => _sort;
  int get visible => _visible;
  int get width => _width;
  int get height => _height;
  String get cover => _cover;
  String get path => _path;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['groupid'] = _groupid;
    map['url'] = _url;
    map['type'] = _type;
    map['createtime'] = _createtime;
    map['size'] = _size;
    map['sort'] = _sort;
    map['visible'] = _visible;
    map['width'] = _width;
    map['height'] = _height;
    map['cover'] = _cover;
    map['path'] = _path;
    return map;
  }

}