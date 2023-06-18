class BookListBean {
  BookListBean({
      int errno, 
      String errmsg, 
      List<Data> data,}){
    _errno = errno;
    _errmsg = errmsg;
    _data = data;
}

  BookListBean.fromJson(dynamic json) {
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
      String createtime, 
      int pages, 
      int tabid, 
      int sort, 
      String schoolid, 
      String name, 
      int ptabid, 
      String url,
      int width,
      int height,
      String word,
      int bookid,}){
    _id = id;
    _createtime = createtime;
    _pages = pages;
    _tabid = tabid;
    _sort = sort;
    _schoolid = schoolid;
    _name = name;
    _ptabid = ptabid;
    _url = url;
    _width = width;
    _height = height;
    _word = word;
    _bookid = bookid;
}

  Data.fromJson(dynamic json) {
    _id = json['id'];
    _createtime = json['createtime'];
    _pages = json['pages'];
    _tabid = json['tabid'];
    _sort = json['sort'];
    _schoolid = json['schoolid'];
    _name = json['name'];
    _ptabid = json['ptabid'];
    _url = json['url'];
    _width = json['width'];
    _height = json['height'];
    _word = json['word'];
    _bookid = json['bookid'];
  }
  int _id;
  String _createtime;
  int _pages;
  int _tabid;
  int _sort;
  String _schoolid;
  String _name;
  int _ptabid;
  String _url;
  int _width;
  int _height;
  String _word;
  int _bookid;


  int get id => _id;
  String get createtime => _createtime;
  int get pages => _pages;
  int get tabid => _tabid;
  int get sort => _sort;
  String get schoolid => _schoolid;
  String get name => _name;
  int get ptabid => _ptabid;
  String get url => _url;
  int get width => _width;
  int get height => _height;
  String get word => _word;
  int get bookid => _bookid;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['createtime'] = _createtime;
    map['pages'] = _pages;
    map['tabid'] = _tabid;
    map['sort'] = _sort;
    map['schoolid'] = _schoolid;
    map['name'] = _name;
    map['ptabid'] = _ptabid;
    map['url'] = _url;
    map['width'] = _width;
    map['height'] = _height;
    map['word'] = _word;
    map['bookid'] = _bookid;
    return map;
  }

}