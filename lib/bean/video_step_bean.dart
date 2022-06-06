/// errno : 0
/// errmsg : ""
/// data : [{"id":1478,"url":"http://res.yimios.com:9050/videos/steps/素描/18酒瓶鲜肉西红柿/1.jpg","categoryid":200,"width":400,"height":640,"maxwidth":1600,"maxheight":2560,"sort":0},{"id":1479,"url":"http://res.yimios.com:9050/videos/steps/素描/18酒瓶鲜肉西红柿/2.jpg","categoryid":200,"width":275,"height":325,"maxwidth":2200,"maxheight":2600,"sort":1},{"id":1480,"url":"http://res.yimios.com:9050/videos/steps/素描/18酒瓶鲜肉西红柿/3.jpg","categoryid":200,"width":275,"height":325,"maxwidth":2200,"maxheight":2600,"sort":2},{"id":1481,"url":"http://res.yimios.com:9050/videos/steps/素描/18酒瓶鲜肉西红柿/4.jpg","categoryid":200,"width":275,"height":325,"maxwidth":2200,"maxheight":2600,"sort":3},{"id":1482,"url":"http://res.yimios.com:9050/videos/steps/素描/18酒瓶鲜肉西红柿/5.jpg","categoryid":200,"width":275,"height":325,"maxwidth":2200,"maxheight":2600,"sort":4},{"id":1483,"url":"http://res.yimios.com:9050/videos/steps/素描/18酒瓶鲜肉西红柿/6.jpg","categoryid":200,"width":275,"height":325,"maxwidth":2200,"maxheight":2600,"sort":5},{"id":1484,"url":"http://res.yimios.com:9050/videos/steps/素描/18酒瓶鲜肉西红柿/7.jpg","categoryid":200,"width":275,"height":325,"maxwidth":2200,"maxheight":2600,"sort":6},{"id":1485,"url":"http://res.yimios.com:9050/videos/steps/素描/18酒瓶鲜肉西红柿/8.jpg","categoryid":200,"width":275,"height":325,"maxwidth":2200,"maxheight":2600,"sort":7}]

class VideoStepBean {
  int _errno;
  String _errmsg;
  List<Data> _data;

  int get errno => _errno;
  String get errmsg => _errmsg;
  List<Data> get data => _data;

  VideoStepBean({
      int errno, 
      String errmsg, 
      List<Data> data}){
    _errno = errno;
    _errmsg = errmsg;
    _data = data;
}

  VideoStepBean.fromJson(dynamic json) {
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

/// id : 1478
/// url : "http://res.yimios.com:9050/videos/steps/素描/18酒瓶鲜肉西红柿/1.jpg"
/// categoryid : 200
/// width : 400
/// height : 640
/// maxwidth : 1600
/// maxheight : 2560
/// sort : 0

class Data {
  int _id;
  String _url;
  int _categoryid;
  int _width;
  int _height;
  int _maxwidth;
  int _maxheight;
  int _sort;

  int get id => _id;
  String get url => _url;
  int get categoryid => _categoryid;
  int get width => _width;
  int get height => _height;
  int get maxwidth => _maxwidth;
  int get maxheight => _maxheight;
  int get sort => _sort;

  Data({
      int id, 
      String url, 
      int categoryid, 
      int width, 
      int height, 
      int maxwidth, 
      int maxheight, 
      int sort}){
    _id = id;
    _url = url;
    _categoryid = categoryid;
    _width = width;
    _height = height;
    _maxwidth = maxwidth;
    _maxheight = maxheight;
    _sort = sort;
}

  Data.fromJson(dynamic json) {
    _id = json['id'];
    _url = json['url'];
    _categoryid = json['categoryid'];
    _width = json['width'];
    _height = json['height'];
    _maxwidth = json['maxwidth'];
    _maxheight = json['maxheight'];
    _sort = json['sort'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['id'] = _id;
    map['url'] = _url;
    map['categoryid'] = _categoryid;
    map['width'] = _width;
    map['height'] = _height;
    map['maxwidth'] = _maxwidth;
    map['maxheight'] = _maxheight;
    map['sort'] = _sort;
    return map;
  }

}