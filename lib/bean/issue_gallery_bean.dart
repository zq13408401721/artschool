/// errno : 0
/// errmsg : ""
/// data : {"gallery":[{"id":2085,"date_id":131,"name":"teacherH","tid":"23cd8a79-8b01-464f-aef9-8ea991fa3442","date":"2021-08-30 14:03:46","url":"http://res.yimios.com:9050/issue/16261880866162721ff/23cd8a79-8b01-464f-aef9-8ea991fa3442/8a2067c8d4ddc92f3ca98bf5f616b1b6.jpg","sort":1630303663851,"width":237,"height":330,"filename":"0704素描头像 (21)_kikx2mi2g1","markid":1,"galleryid":2085,"mark":1,"markname":"课堂作业","comments":"优秀作品"},{"id":2086,"date_id":131,"name":"teacherH","tid":"23cd8a79-8b01-464f-aef9-8ea991fa3442","date":"2021-08-30 14:03:52","url":"http://res.yimios.com:9050/issue/16261880866162721ff/23cd8a79-8b01-464f-aef9-8ea991fa3442/da049d5fef75615415a81ae1d2fd250f.jpg","sort":1630303663852,"width":279,"height":206,"filename":"042马奈-年轻的女人","markid":null,"galleryid":null,"mark":null,"markname":null,"comments":null},{"id":2088,"date_id":131,"name":"teacherH","tid":"23cd8a79-8b01-464f-aef9-8ea991fa3442","date":"2021-08-30 14:05:53","url":"http://res.yimios.com:9050/issue/16261880866162721ff/23cd8a79-8b01-464f-aef9-8ea991fa3442/9f983c17891ff2ed1bcf363017ff170b.jpg","sort":1630303788237,"width":209,"height":254,"filename":"031马奈-乔治摩尔在皮克斯的动画花园","markid":null,"galleryid":null,"mark":null,"markname":null,"comments":null},{"id":2087,"date_id":131,"name":"teacherH","tid":"23cd8a79-8b01-464f-aef9-8ea991fa3442","date":"2021-08-30 14:05:53","url":"http://res.yimios.com:9050/issue/16261880866162721ff/23cd8a79-8b01-464f-aef9-8ea991fa3442/b7ca8530049e774c15928547a71a335e.jpg","sort":1630303788238,"width":279,"height":206,"filename":"042马奈-年轻的女人","markid":null,"galleryid":null,"mark":null,"markname":null,"comments":null},{"id":2089,"date_id":131,"name":"teacherH","tid":"23cd8a79-8b01-464f-aef9-8ea991fa3442","date":"2021-08-30 14:08:30","url":"http://res.yimios.com:9050/issue/16261880866162721ff/23cd8a79-8b01-464f-aef9-8ea991fa3442/311c07b4e88451374fa5dcf3b1467dac.jpg","sort":1630303945538,"width":237,"height":330,"filename":"0704素描头像 (18)_oz4vx9sbpc9","markid":null,"galleryid":null,"mark":null,"markname":null,"comments":null},{"id":2093,"date_id":131,"name":"teacherH","tid":"23cd8a79-8b01-464f-aef9-8ea991fa3442","date":"2021-08-30 14:08:35","url":"http://res.yimios.com:9050/issue/16261880866162721ff/23cd8a79-8b01-464f-aef9-8ea991fa3442/685e6d51f7c94d1b5c2dbc26f81cdf44.jpg","sort":1630303945539,"width":332,"height":251,"filename":"012马奈-划船","markid":null,"galleryid":null,"mark":null,"markname":null,"comments":null},{"id":2091,"date_id":131,"name":"teacherH","tid":"23cd8a79-8b01-464f-aef9-8ea991fa3442","date":"2021-08-30 14:08:30","url":"http://res.yimios.com:9050/issue/16261880866162721ff/23cd8a79-8b01-464f-aef9-8ea991fa3442/6a641a1f537c26f0b82d33a04a9a677d.jpg","sort":1630303945540,"width":237,"height":330,"filename":"0704素描头像 (21)_kikx2mi2g1","markid":null,"galleryid":null,"mark":null,"markname":null,"comments":null},{"id":2096,"date_id":131,"name":"teacherH","tid":"23cd8a79-8b01-464f-aef9-8ea991fa3442","date":"2021-08-30 14:08:36","url":"http://res.yimios.com:9050/issue/16261880866162721ff/23cd8a79-8b01-464f-aef9-8ea991fa3442/0450a7b76176ada905a8831e03021b4e.jpg","sort":1630303945541,"width":319,"height":397,"filename":"051马奈-粉红女士","markid":null,"galleryid":null,"mark":null,"markname":null,"comments":null},{"id":2090,"date_id":131,"name":"teacherH","tid":"23cd8a79-8b01-464f-aef9-8ea991fa3442","date":"2021-08-30 14:08:30","url":"http://res.yimios.com:9050/issue/16261880866162721ff/23cd8a79-8b01-464f-aef9-8ea991fa3442/e9dc709fcba5c47dc2e458233a340bc9.jpg","sort":1630303945542,"width":237,"height":327,"filename":"0704素描头像 (23)_k0tvcb12ceb","markid":null,"galleryid":null,"mark":null,"markname":null,"comments":null},{"id":2092,"date_id":131,"name":"teacherH","tid":"23cd8a79-8b01-464f-aef9-8ea991fa3442","date":"2021-08-30 14:08:32","url":"http://res.yimios.com:9050/issue/16261880866162721ff/23cd8a79-8b01-464f-aef9-8ea991fa3442/a36a0f9590b27f0dde516f39e676f269.jpg","sort":1630303945543,"width":215,"height":279,"filename":"049马奈-洛杉矶欢跃女神的惊喜","markid":null,"galleryid":null,"mark":null,"markname":null,"comments":null}]}

class IssueGalleryBean {
  int _errno;
  String _errmsg;
  Data _data;

  int get errno => _errno;
  String get errmsg => _errmsg;
  Data get data => _data;

  IssueGalleryBean({
      int errno, 
      String errmsg, 
      Data data}){
    _errno = errno;
    _errmsg = errmsg;
    _data = data;
}

  IssueGalleryBean.fromJson(dynamic json) {
    _errno = json['errno'];
    _errmsg = json['errmsg'];
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['errno'] = _errno;
    map['errmsg'] = _errmsg;
    if (_data != null) {
      map['data'] = _data.toJson();
    }
    return map;
  }

}

/// gallery : [{"id":2085,"date_id":131,"name":"teacherH","tid":"23cd8a79-8b01-464f-aef9-8ea991fa3442","date":"2021-08-30 14:03:46","url":"http://res.yimios.com:9050/issue/16261880866162721ff/23cd8a79-8b01-464f-aef9-8ea991fa3442/8a2067c8d4ddc92f3ca98bf5f616b1b6.jpg","sort":1630303663851,"width":237,"height":330,"filename":"0704素描头像 (21)_kikx2mi2g1","markid":1,"galleryid":2085,"mark":1,"markname":"课堂作业","comments":"优秀作品"},{"id":2086,"date_id":131,"name":"teacherH","tid":"23cd8a79-8b01-464f-aef9-8ea991fa3442","date":"2021-08-30 14:03:52","url":"http://res.yimios.com:9050/issue/16261880866162721ff/23cd8a79-8b01-464f-aef9-8ea991fa3442/da049d5fef75615415a81ae1d2fd250f.jpg","sort":1630303663852,"width":279,"height":206,"filename":"042马奈-年轻的女人","markid":null,"galleryid":null,"mark":null,"markname":null,"comments":null},{"id":2088,"date_id":131,"name":"teacherH","tid":"23cd8a79-8b01-464f-aef9-8ea991fa3442","date":"2021-08-30 14:05:53","url":"http://res.yimios.com:9050/issue/16261880866162721ff/23cd8a79-8b01-464f-aef9-8ea991fa3442/9f983c17891ff2ed1bcf363017ff170b.jpg","sort":1630303788237,"width":209,"height":254,"filename":"031马奈-乔治摩尔在皮克斯的动画花园","markid":null,"galleryid":null,"mark":null,"markname":null,"comments":null},{"id":2087,"date_id":131,"name":"teacherH","tid":"23cd8a79-8b01-464f-aef9-8ea991fa3442","date":"2021-08-30 14:05:53","url":"http://res.yimios.com:9050/issue/16261880866162721ff/23cd8a79-8b01-464f-aef9-8ea991fa3442/b7ca8530049e774c15928547a71a335e.jpg","sort":1630303788238,"width":279,"height":206,"filename":"042马奈-年轻的女人","markid":null,"galleryid":null,"mark":null,"markname":null,"comments":null},{"id":2089,"date_id":131,"name":"teacherH","tid":"23cd8a79-8b01-464f-aef9-8ea991fa3442","date":"2021-08-30 14:08:30","url":"http://res.yimios.com:9050/issue/16261880866162721ff/23cd8a79-8b01-464f-aef9-8ea991fa3442/311c07b4e88451374fa5dcf3b1467dac.jpg","sort":1630303945538,"width":237,"height":330,"filename":"0704素描头像 (18)_oz4vx9sbpc9","markid":null,"galleryid":null,"mark":null,"markname":null,"comments":null},{"id":2093,"date_id":131,"name":"teacherH","tid":"23cd8a79-8b01-464f-aef9-8ea991fa3442","date":"2021-08-30 14:08:35","url":"http://res.yimios.com:9050/issue/16261880866162721ff/23cd8a79-8b01-464f-aef9-8ea991fa3442/685e6d51f7c94d1b5c2dbc26f81cdf44.jpg","sort":1630303945539,"width":332,"height":251,"filename":"012马奈-划船","markid":null,"galleryid":null,"mark":null,"markname":null,"comments":null},{"id":2091,"date_id":131,"name":"teacherH","tid":"23cd8a79-8b01-464f-aef9-8ea991fa3442","date":"2021-08-30 14:08:30","url":"http://res.yimios.com:9050/issue/16261880866162721ff/23cd8a79-8b01-464f-aef9-8ea991fa3442/6a641a1f537c26f0b82d33a04a9a677d.jpg","sort":1630303945540,"width":237,"height":330,"filename":"0704素描头像 (21)_kikx2mi2g1","markid":null,"galleryid":null,"mark":null,"markname":null,"comments":null},{"id":2096,"date_id":131,"name":"teacherH","tid":"23cd8a79-8b01-464f-aef9-8ea991fa3442","date":"2021-08-30 14:08:36","url":"http://res.yimios.com:9050/issue/16261880866162721ff/23cd8a79-8b01-464f-aef9-8ea991fa3442/0450a7b76176ada905a8831e03021b4e.jpg","sort":1630303945541,"width":319,"height":397,"filename":"051马奈-粉红女士","markid":null,"galleryid":null,"mark":null,"markname":null,"comments":null},{"id":2090,"date_id":131,"name":"teacherH","tid":"23cd8a79-8b01-464f-aef9-8ea991fa3442","date":"2021-08-30 14:08:30","url":"http://res.yimios.com:9050/issue/16261880866162721ff/23cd8a79-8b01-464f-aef9-8ea991fa3442/e9dc709fcba5c47dc2e458233a340bc9.jpg","sort":1630303945542,"width":237,"height":327,"filename":"0704素描头像 (23)_k0tvcb12ceb","markid":null,"galleryid":null,"mark":null,"markname":null,"comments":null},{"id":2092,"date_id":131,"name":"teacherH","tid":"23cd8a79-8b01-464f-aef9-8ea991fa3442","date":"2021-08-30 14:08:32","url":"http://res.yimios.com:9050/issue/16261880866162721ff/23cd8a79-8b01-464f-aef9-8ea991fa3442/a36a0f9590b27f0dde516f39e676f269.jpg","sort":1630303945543,"width":215,"height":279,"filename":"049马奈-洛杉矶欢跃女神的惊喜","markid":null,"galleryid":null,"mark":null,"markname":null,"comments":null}]

class Data {
  List<Gallery> _gallery;

  List<Gallery> get gallery => _gallery;

  Data({
      List<Gallery> gallery}){
    _gallery = gallery;
}

  Data.fromJson(dynamic json) {
    if (json['gallery'] != null) {
      _gallery = [];
      json['gallery'].forEach((v) {
        _gallery.add(Gallery.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    if (_gallery != null) {
      map['gallery'] = _gallery.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// id : 2085
/// date_id : 131
/// name : "teacherH"
/// tid : "23cd8a79-8b01-464f-aef9-8ea991fa3442"
/// date : "2021-08-30 14:03:46"
/// url : "http://res.yimios.com:9050/issue/16261880866162721ff/23cd8a79-8b01-464f-aef9-8ea991fa3442/8a2067c8d4ddc92f3ca98bf5f616b1b6.jpg"
/// sort : 1630303663851
/// width : 237
/// height : 330
/// filename : "0704素描头像 (21)_kikx2mi2g1"
/// markid : 1
/// galleryid : 2085
/// mark : 1
/// markname : "课堂作业"
/// comments : "优秀作品"

class Gallery {
  int _id;
  int _dateId;
  String _name;
  String _tid;
  String _date;
  String _url;
  int _sort;
  int _width;
  int _height;
  int _maxwidth;
  int _maxheight;
  String _filename;
  int _markid;
  int _galleryid;
  int _mark;
  String _markname;
  String _comments;
  String _editorurl;

  int get id => _id;
  int get dateId => _dateId;
  String get name => _name;
  String get tid => _tid;
  String get date => _date;
  String get url => _url;
  int get sort => _sort;
  int get width => _width;
  int get height => _height;
  int get maxwidth => _maxwidth;
  int get maxheight => _maxheight;
  String get filename => _filename;
  String get eidtorurl => _editorurl;
  set editorurl(value){
    _editorurl = value;
  }
  int get markid => _markid;
  set markid(int value){
    _markid = value;
  }
  int get galleryid => _galleryid;
  set galleryid(value){
    _galleryid = value;
  }
  int get mark => _mark;
  set mark(int value){
    _mark = value;
  }
  String get markname => _markname;
  set markname(String value){
    _markname = value;
  }
  String get comments => _comments;
  set comments(String value){
    _comments = value;
  }

  Gallery({
      int id, 
      int dateId, 
      String name, 
      String tid, 
      String date, 
      String url, 
      int sort, 
      int width,
      int height,
      int maxwidth,
      int maxheight,
      String filename, 
      int markid, 
      int galleryid, 
      int mark, 
      String markname, 
      String comments,
      String editorurl}){
    _id = id;
    _dateId = dateId;
    _name = name;
    _tid = tid;
    _date = date;
    _url = url;
    _sort = sort;
    _width = width;
    _height = height;
    _maxwidth = maxwidth;
    _maxheight = maxheight;
    _filename = filename;
    _markid = markid;
    _galleryid = galleryid;
    _mark = mark;
    _markname = markname;
    _comments = comments;
    _editorurl = editorurl;
}

  Gallery.fromJson(dynamic json) {
    _id = json['id'];
    _dateId = json['date_id'];
    _name = json['name'];
    _tid = json['tid'];
    _date = json['date'];
    _url = json['url'];
    _sort = json['sort'];
    _width = json['width'];
    _height = json['height'];
    _maxwidth = json['maxwidth'];
    _maxheight = json['maxheight'];
    _filename = json['filename'];
    _markid = json['markid'];
    _galleryid = json['galleryid'];
    _mark = json['mark'];
    _markname = json['markname'];
    _comments = json['comments'];
    _editorurl = json['editorurl'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['id'] = _id;
    map['date_id'] = _dateId;
    map['name'] = _name;
    map['tid'] = _tid;
    map['date'] = _date;
    map['url'] = _url;
    map['sort'] = _sort;
    map['width'] = _width;
    map['height'] = _height;
    map['maxwidth'] = _maxwidth;
    map['maxheight'] = _maxheight;
    map['filename'] = _filename;
    map['markid'] = _markid;
    map['galleryid'] = _galleryid;
    map['mark'] = _mark;
    map['markname'] = _markname;
    map['comments'] = _comments;
    map['editorurl'] = _editorurl;
    return map;
  }

}