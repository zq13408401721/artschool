/// errno : 0
/// errmsg : ""
/// data : [{"id":1,"date":"2021-09-18","uid":"23cd8a79-8b01-464f-aef9-8ea991fa3442","type":1,"collect":[{"id":11,"name":"IMG_0003","title":"teacherH","from":1,"type":1,"fromid":2952,"createtime":"2021-09-18 14:23:25","uid":"23cd8a79-8b01-464f-aef9-8ea991fa3442","url":"http://res.yimios.com:9050/issue/16261880866162721ff/23cd8a79-8b01-464f-aef9-8ea991fa3442/e038319d0ce19a2058e6862fae7cee75.JPG","width":300,"height":200,"dateid":1},{"id":10,"name":"IMG_0002","title":"teacherH","from":1,"type":1,"fromid":2954,"createtime":"2021-09-18 14:10:31","uid":"23cd8a79-8b01-464f-aef9-8ea991fa3442","url":"http://res.yimios.com:9050/issue/16261880866162721ff/23cd8a79-8b01-464f-aef9-8ea991fa3442/167ac61a666a27290ac2aba839928ee2.JPG","width":214,"height":142,"dateid":1}]}]

class CollectListBean {
  int _errno;
  String _errmsg;
  List<Data> _data;

  int get errno => _errno;
  String get errmsg => _errmsg;
  List<Data> get data => _data;

  CollectListBean({
      int errno, 
      String errmsg, 
      List<Data> data}){
    _errno = errno;
    _errmsg = errmsg;
    _data = data;
}

  CollectListBean.fromJson(dynamic json) {
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

/// id : 1
/// date : "2021-09-18"
/// uid : "23cd8a79-8b01-464f-aef9-8ea991fa3442"
/// type : 1
/// collect : [{"id":11,"name":"IMG_0003","title":"teacherH","from":1,"type":1,"fromid":2952,"createtime":"2021-09-18 14:23:25","uid":"23cd8a79-8b01-464f-aef9-8ea991fa3442","url":"http://res.yimios.com:9050/issue/16261880866162721ff/23cd8a79-8b01-464f-aef9-8ea991fa3442/e038319d0ce19a2058e6862fae7cee75.JPG","width":300,"height":200,"dateid":1},{"id":10,"name":"IMG_0002","title":"teacherH","from":1,"type":1,"fromid":2954,"createtime":"2021-09-18 14:10:31","uid":"23cd8a79-8b01-464f-aef9-8ea991fa3442","url":"http://res.yimios.com:9050/issue/16261880866162721ff/23cd8a79-8b01-464f-aef9-8ea991fa3442/167ac61a666a27290ac2aba839928ee2.JPG","width":214,"height":142,"dateid":1}]

class Data {
  int _id;
  String _date;
  String _uid;
  int _type;
  List<Collect> _collect;
  bool _pushState=false;

  int get id => _id;
  String get date => _date;
  String get uid => _uid;
  int get type => _type;
  List<Collect> get collect => _collect;
  bool get pushState => _pushState;
  set pushState(value){
    _pushState = value;
  }

  Data({
      int id, 
      String date, 
      String uid, 
      int type, 
      List<Collect> collect}){
    _id = id;
    _date = date;
    _uid = uid;
    _type = type;
    _collect = collect;
}

  Data.fromJson(dynamic json) {
    _id = json['id'];
    _date = json['date'];
    _uid = json['uid'];
    _type = json['type'];
    if (json['collect'] != null) {
      _collect = [];
      json['collect'].forEach((v) {
        _collect.add(Collect.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['id'] = _id;
    map['date'] = _date;
    map['uid'] = _uid;
    map['type'] = _type;
    if (_collect != null) {
      map['collect'] = _collect.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// id : 11
/// name : "IMG_0003"
/// title : "teacherH"
/// from : 1
/// type : 1
/// fromid : 2952
/// createtime : "2021-09-18 14:23:25"
/// uid : "23cd8a79-8b01-464f-aef9-8ea991fa3442"
/// url : "http://res.yimios.com:9050/issue/16261880866162721ff/23cd8a79-8b01-464f-aef9-8ea991fa3442/e038319d0ce19a2058e6862fae7cee75.JPG"
/// width : 300
/// height : 200
/// dateid : 1

class Collect {
  int _id;
  String _name;
  String _title;
  int _from;
  int _type;
  int _fromid;
  String _createtime;
  String _uid;
  String _url;
  int _width;
  int _height;
  int _dateid;
  bool _select=false;

  int get id => _id;
  String get name => _name;
  String get title => _title;
  int get from => _from;
  int get type => _type;
  int get fromid => _fromid;
  String get createtime => _createtime;
  String get uid => _uid;
  String get url => _url;
  int get width => _width;
  int get height => _height;
  int get dateid => _dateid;
  bool get select => _select;
  set select(value){
    _select = value;
  }

  Collect({
      int id, 
      String name, 
      String title, 
      int from, 
      int type, 
      int fromid, 
      String createtime, 
      String uid, 
      String url, 
      int width, 
      int height, 
      int dateid}){
    _id = id;
    _name = name;
    _title = title;
    _from = from;
    _type = type;
    _fromid = fromid;
    _createtime = createtime;
    _uid = uid;
    _url = url;
    _width = width;
    _height = height;
    _dateid = dateid;
}

  Collect.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _title = json['title'];
    _from = json['from'];
    _type = json['type'];
    _fromid = json['fromid'];
    _createtime = json['createtime'];
    _uid = json['uid'];
    _url = json['url'];
    _width = json['width'];
    _height = json['height'];
    _dateid = json['dateid'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['title'] = _title;
    map['from'] = _from;
    map['type'] = _type;
    map['fromid'] = _fromid;
    map['createtime'] = _createtime;
    map['uid'] = _uid;
    map['url'] = _url;
    map['width'] = _width;
    map['height'] = _height;
    map['dateid'] = _dateid;
    return map;
  }

}