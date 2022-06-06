/// errno : 0
/// errmsg : ""
/// data : [{"id":100,"name":"IMG_0221","title":"H老师","from":3,"fromid":88,"createtime":"2021-11-11 13:59:57","uid":"23cd8a79-8b01-464f-aef9-8ea991fa3442","url":"http://res.yimios.com:9050/column/24/IMG_0221.JPG","width":270,"height":360,"dateid":33,"maxwidth":0,"maxheight":0},{"id":99,"name":"H老师","title":"H老师","from":1,"fromid":3805,"createtime":"2021-11-11 13:59:42","uid":"23cd8a79-8b01-464f-aef9-8ea991fa3442","url":"http://res.yimios.com:9050/issue/16261880866162721ff/23cd8a79-8b01-464f-aef9-8ea991fa3442/ad2f9c2f001f734ba7b44987bf6841a2.JPG","width":270,"height":388,"dateid":33,"maxwidth":0,"maxheight":0},{"id":98,"name":"H老师","title":"H老师","from":1,"fromid":3712,"createtime":"2021-11-11 13:50:17","uid":"23cd8a79-8b01-464f-aef9-8ea991fa3442","url":"http://res.yimios.com:9050/issue/16261880866162721ff/23cd8a79-8b01-464f-aef9-8ea991fa3442/8b42dd8f89457b584c564c04cf5bf03e.JPG","width":270,"height":360,"dateid":33,"maxwidth":0,"maxheight":0},{"id":97,"name":"H老师","title":"H老师","from":1,"fromid":3713,"createtime":"2021-11-11 11:55:26","uid":"23cd8a79-8b01-464f-aef9-8ea991fa3442","url":"http://res.yimios.com:9050/issue/16261880866162721ff/23cd8a79-8b01-464f-aef9-8ea991fa3442/0e952106a429041fad0e6f3aa3af93b4.JPG","width":270,"height":360,"dateid":33,"maxwidth":0,"maxheight":0},{"id":96,"name":"H老师","title":"H老师","from":1,"fromid":3714,"createtime":"2021-11-11 11:50:04","uid":"23cd8a79-8b01-464f-aef9-8ea991fa3442","url":"http://res.yimios.com:9050/issue/16261880866162721ff/23cd8a79-8b01-464f-aef9-8ea991fa3442/910b1cd3cd5e1562420317ecf6c82a70.JPG","width":270,"height":360,"dateid":33,"maxwidth":0,"maxheight":0},{"id":95,"name":"H老师","title":"H老师","from":1,"fromid":3716,"createtime":"2021-11-11 11:50:00","uid":"23cd8a79-8b01-464f-aef9-8ea991fa3442","url":"http://res.yimios.com:9050/issue/16261880866162721ff/23cd8a79-8b01-464f-aef9-8ea991fa3442/cae649d5932307209e05647612ce0aa7.JPG","width":270,"height":360,"dateid":33,"maxwidth":0,"maxheight":0},{"id":94,"name":"H老师","title":"H老师","from":1,"fromid":3717,"createtime":"2021-11-11 11:49:55","uid":"23cd8a79-8b01-464f-aef9-8ea991fa3442","url":"http://res.yimios.com:9050/issue/16261880866162721ff/23cd8a79-8b01-464f-aef9-8ea991fa3442/bc29a6ef25d291563939b4eaf0d40742.JPG","width":240,"height":480,"dateid":33,"maxwidth":0,"maxheight":0},{"id":93,"name":"于明素描 (2).jpg","title":"H老师","from":2,"fromid":13646,"createtime":"2021-11-11 11:49:47","uid":"23cd8a79-8b01-464f-aef9-8ea991fa3442","url":"http://res.yimios.com:9050/1/1/于明素描 (2)_yd8t3jq1x38.jpg","width":240,"height":320,"dateid":33,"maxwidth":0,"maxheight":0},{"id":92,"name":"于明素描 (3).jpg","title":"H老师","from":2,"fromid":13647,"createtime":"2021-11-11 11:00:33","uid":"23cd8a79-8b01-464f-aef9-8ea991fa3442","url":"http://res.yimios.com:9050/1/1/于明素描 (3)_um60irr8wv.jpg","width":240,"height":320,"dateid":33,"maxwidth":0,"maxheight":0},{"id":91,"name":"于明素描 (1).jpg","title":"H老师","from":2,"fromid":13645,"createtime":"2021-11-11 10:59:04","uid":"23cd8a79-8b01-464f-aef9-8ea991fa3442","url":"http://res.yimios.com:9050/1/1/于明素描 (1)_nc4cm2xu0wg.jpg","width":240,"height":320,"dateid":33,"maxwidth":0,"maxheight":0}]

class CollectBean {
  int _errno;
  String _errmsg;
  List<Data> _data;

  int get errno => _errno;
  String get errmsg => _errmsg;
  List<Data> get data => _data;

  CollectBean({
      int errno, 
      String errmsg, 
      List<Data> data}){
    _errno = errno;
    _errmsg = errmsg;
    _data = data;
}

  CollectBean.fromJson(dynamic json) {
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

/// id : 100
/// name : "IMG_0221"
/// title : "H老师"
/// from : 3
/// fromid : 88
/// createtime : "2021-11-11 13:59:57"
/// uid : "23cd8a79-8b01-464f-aef9-8ea991fa3442"
/// url : "http://res.yimios.com:9050/column/24/IMG_0221.JPG"
/// width : 270
/// height : 360
/// dateid : 33
/// maxwidth : 0
/// maxheight : 0

class Data {
  int _id;
  String _name;
  String _title;
  int _from;
  int _fromid;
  String _createtime;
  String _uid;
  String _url;
  int _width;
  int _height;
  int _dateid;
  int _maxwidth;
  int _maxheight;

  int get id => _id;
  String get name => _name;
  String get title => _title;
  int get from => _from;
  int get fromid => _fromid;
  String get createtime => _createtime;
  String get uid => _uid;
  String get url => _url;
  int get width => _width;
  int get height => _height;
  int get dateid => _dateid;
  int get maxwidth => _maxwidth;
  int get maxheight => _maxheight;

  Data({
      int id, 
      String name, 
      String title, 
      int from, 
      int fromid, 
      String createtime, 
      String uid, 
      String url, 
      int width, 
      int height, 
      int dateid, 
      int maxwidth, 
      int maxheight}){
    _id = id;
    _name = name;
    _title = title;
    _from = from;
    _fromid = fromid;
    _createtime = createtime;
    _uid = uid;
    _url = url;
    _width = width;
    _height = height;
    _dateid = dateid;
    _maxwidth = maxwidth;
    _maxheight = maxheight;
}

  Data.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _title = json['title'];
    _from = json['from'];
    _fromid = json['fromid'];
    _createtime = json['createtime'];
    _uid = json['uid'];
    _url = json['url'];
    _width = json['width'];
    _height = json['height'];
    _dateid = json['dateid'];
    _maxwidth = json['maxwidth'];
    _maxheight = json['maxheight'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['title'] = _title;
    map['from'] = _from;
    map['fromid'] = _fromid;
    map['createtime'] = _createtime;
    map['uid'] = _uid;
    map['url'] = _url;
    map['width'] = _width;
    map['height'] = _height;
    map['dateid'] = _dateid;
    map['maxwidth'] = _maxwidth;
    map['maxheight'] = _maxheight;
    return map;
  }

}