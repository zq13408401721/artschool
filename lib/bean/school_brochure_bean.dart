/// errno : 0
/// errmsg : ""
/// data : [{"id":1,"schoolid":"16261880866162721ff","title":"艺画学校招生简章","label":"学校介绍","icon":"http://res.yimios.com:9050/videos/%E7%AE%80%E7%AB%A0.png","sort":1,"url":"https://www.baidu.com"}]

class SchoolBrochureBean {
  int _errno;
  String _errmsg;
  List<Data> _data;

  int get errno => _errno;
  String get errmsg => _errmsg;
  List<Data> get data => _data;

  SchoolBrochureBean({
      int errno, 
      String errmsg, 
      List<Data> data}){
    _errno = errno;
    _errmsg = errmsg;
    _data = data;
}

  SchoolBrochureBean.fromJson(dynamic json) {
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
/// schoolid : "16261880866162721ff"
/// title : "艺画学校招生简章"
/// label : "学校介绍"
/// icon : "http://res.yimios.com:9050/videos/%E7%AE%80%E7%AB%A0.png"
/// sort : 1
/// url : "https://www.baidu.com"

class Data {
  int _id;
  String _schoolid;
  String _title;
  String _label;
  String _icon;
  int _sort;
  String _url;

  int get id => _id;
  String get schoolid => _schoolid;
  String get title => _title;
  String get label => _label;
  String get icon => _icon;
  int get sort => _sort;
  String get url => _url;

  Data({
      int id, 
      String schoolid, 
      String title, 
      String label, 
      String icon, 
      int sort, 
      String url}){
    _id = id;
    _schoolid = schoolid;
    _title = title;
    _label = label;
    _icon = icon;
    _sort = sort;
    _url = url;
}

  Data.fromJson(dynamic json) {
    _id = json['id'];
    _schoolid = json['schoolid'];
    _title = json['title'];
    _label = json['label'];
    _icon = json['icon'];
    _sort = json['sort'];
    _url = json['url'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['id'] = _id;
    map['schoolid'] = _schoolid;
    map['title'] = _title;
    map['label'] = _label;
    map['icon'] = _icon;
    map['sort'] = _sort;
    map['url'] = _url;
    return map;
  }

}