class HomeBannerBean {
  HomeBannerBean({
      int errno, 
      String errmsg, 
      List<Data> data,}){
    _errno = errno;
    _errmsg = errmsg;
    _data = data;
}

  HomeBannerBean.fromJson(dynamic json) {
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
      dynamic name, 
      String url, 
      String weburl, 
      dynamic sort, 
      String createtime, 
      String schoolid,}){
    _id = id;
    _name = name;
    _url = url;
    _weburl = weburl;
    _sort = sort;
    _createtime = createtime;
    _schoolid = schoolid;
}

  Data.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _url = json['url'];
    _weburl = json['weburl'];
    _sort = json['sort'];
    _createtime = json['createtime'];
    _schoolid = json['schoolid'];
  }
  int _id;
  dynamic _name;
  String _url;
  String _weburl;
  dynamic _sort;
  String _createtime;
  String _schoolid;

  int get id => _id;
  dynamic get name => _name;
  String get url => _url;
  String get weburl => _weburl;
  dynamic get sort => _sort;
  String get createtime => _createtime;
  String get schoolid => _schoolid;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['url'] = _url;
    map['weburl'] = _weburl;
    map['sort'] = _sort;
    map['createtime'] = _createtime;
    map['schoolid'] = _schoolid;
    return map;
  }

}