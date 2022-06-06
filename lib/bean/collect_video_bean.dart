/// errno : 0
/// errmsg : ""
/// data : [{"id":1,"categoryid":94,"uid":"23cd8a79-8b01-464f-aef9-8ea991fa3442","createtime":"2021-11-11 21:45:40","name":"素描透视原理","cover":"http://res.yimios.com:9050/videos/cover/透视.jpg"}]

class CollectVideoBean {
  int _errno;
  String _errmsg;
  List<Data> _data;

  int get errno => _errno;
  String get errmsg => _errmsg;
  List<Data> get data => _data;

  CollectVideoBean({
      int errno, 
      String errmsg, 
      List<Data> data}){
    _errno = errno;
    _errmsg = errmsg;
    _data = data;
}

  CollectVideoBean.fromJson(dynamic json) {
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
/// categoryid : 94
/// uid : "23cd8a79-8b01-464f-aef9-8ea991fa3442"
/// createtime : "2021-11-11 21:45:40"
/// name : "素描透视原理"
/// cover : "http://res.yimios.com:9050/videos/cover/透视.jpg"

class Data {
  int _id;
  int _categoryid;
  String _uid;
  String _createtime;
  String _name;
  String _cover;
  String _subject;
  String _section;
  String _description;

  int get id => _id;
  int get categoryid => _categoryid;
  String get uid => _uid;
  String get createtime => _createtime;
  String get name => _name;
  String get cover => _cover;
  String get subject => _subject;
  String get section => _section;
  String get description => _description;

  Data({
      int id, 
      int categoryid, 
      String uid, 
      String createtime, 
      String name, 
      String cover,
      String subject,
      String section,
      String description}){
    _id = id;
    _categoryid = categoryid;
    _uid = uid;
    _createtime = createtime;
    _name = name;
    _cover = cover;
    _subject = subject;
    _section = section;
    _description = description;
}

  Data.fromJson(dynamic json) {
    _id = json['id'];
    _categoryid = json['categoryid'];
    _uid = json['uid'];
    _createtime = json['createtime'];
    _name = json['name'];
    _cover = json['cover'];
    _subject = json['subject'];
    _section = json['section'];
    _description = json['description'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['id'] = _id;
    map['categoryid'] = _categoryid;
    map['uid'] = _uid;
    map['createtime'] = _createtime;
    map['name'] = _name;
    map['cover'] = _cover;
    map['subject'] = _subject;
    map['section'] = _section;
    map['description'] = _description;
    return map;
  }

}