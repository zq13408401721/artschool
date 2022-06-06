/// errno : 0
/// errmsg : ""
/// data : {"uid":"23cd8a79-8b01-464f-aef9-8ea991fa3442","name":"IMG_0002","title":"teacherH","from":"1","fromid":"2954","type":"1","createtime":"2021-09-17 18:46:32","url":"http://res.yimios.com:9050/issue/16261880866162721ff/23cd8a79-8b01-464f-aef9-8ea991fa3442/167ac61a666a27290ac2aba839928ee2.JPG","width":"214","height":"142","id":1}

class CollectAddBean {
  int _errno;
  String _errmsg;
  Data _data;

  int get errno => _errno;
  String get errmsg => _errmsg;
  Data get data => _data;

  CollectAddBean({
      int errno, 
      String errmsg, 
      Data data}){
    _errno = errno;
    _errmsg = errmsg;
    _data = data;
}

  CollectAddBean.fromJson(dynamic json) {
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

/// uid : "23cd8a79-8b01-464f-aef9-8ea991fa3442"
/// name : "IMG_0002"
/// title : "teacherH"
/// from : "1"
/// fromid : "2954"
/// type : "1"
/// createtime : "2021-09-17 18:46:32"
/// url : "http://res.yimios.com:9050/issue/16261880866162721ff/23cd8a79-8b01-464f-aef9-8ea991fa3442/167ac61a666a27290ac2aba839928ee2.JPG"
/// width : "214"
/// height : "142"
/// id : 1

class Data {
  String _uid;
  String _name;
  String _title;
  int _from;
  int _fromid;
  int _type;
  String _createtime;
  String _url;
  int _width;
  int _height;
  int _id;
  int _dateid;

  String get uid => _uid;
  String get name => _name;
  String get title => _title;
  int get from => _from;
  int get fromid => _fromid;
  int get type => _type;
  String get createtime => _createtime;
  String get url => _url;
  int get width => _width;
  int get height => _height;
  int get id => _id;
  int get dateid => _dateid;

  Data({
      String uid, 
      String name, 
      String title, 
      int from,
      int fromid,
      int type,
      String createtime, 
      String url, 
      int width,
      int height,
      int id,
      int dateid}){
    _uid = uid;
    _name = name;
    _title = title;
    _from = from;
    _fromid = fromid;
    _type = type;
    _createtime = createtime;
    _url = url;
    _width = width;
    _height = height;
    _id = id;
    _dateid = dateid;
}

  Data.fromJson(dynamic json) {
    _uid = json['uid'];
    _name = json['name'];
    _title = json['title'];
    _from = json['from'];
    _fromid = json['fromid'];
    _type = json['type'];
    _createtime = json['createtime'];
    _url = json['url'];
    _width = json['width'];
    _height = json['height'];
    _id = json['id'];
    _dateid = json['dateid'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['uid'] = _uid;
    map['name'] = _name;
    map['title'] = _title;
    map['from'] = _from;
    map['fromid'] = _fromid;
    map['type'] = _type;
    map['createtime'] = _createtime;
    map['url'] = _url;
    map['width'] = _width;
    map['height'] = _height;
    map['id'] = _id;
    map['dateid'] = _dateid;
    return map;
  }

}