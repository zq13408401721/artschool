class PanSearch {
  PanSearch({
      int errno, 
      String errmsg, 
      Data data,}){
    _errno = errno;
    _errmsg = errmsg;
    _data = data;
}

  PanSearch.fromJson(dynamic json) {
    _errno = json['errno'];
    _errmsg = json['errmsg'];
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
  int _errno;
  String _errmsg;
  Data _data;

  int get errno => _errno;
  String get errmsg => _errmsg;
  Data get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['errno'] = _errno;
    map['errmsg'] = _errmsg;
    if (_data != null) {
      map['data'] = _data.toJson();
    }
    return map;
  }

}

class Data {
  Data({
      int total, 
      List<Result> result,}){
    _total = total;
    _result = result;
}

  Data.fromJson(dynamic json) {
    _total = json['total'];
    if (json['result'] != null) {
      _result = [];
      json['result'].forEach((v) {
        _result.add(Result.fromJson(v));
      });
    }
  }
  int _total;
  List<Result> _result;

  int get total => _total;
  List<Result> get result => _result;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['total'] = _total;
    if (_result != null) {
      map['result'] = _result.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class Result {
  Result({
      String panid, 
      String name, 
      dynamic url, 
      dynamic width, 
      dynamic height, 
      dynamic nickname, 
      String username,
      String uid,
      String avater,
      String date,
      int num,}){
    _panid = panid;
    _name = name;
    _url = url;
    _width = width;
    _height = height;
    _nickname = nickname;
    _username = username;
    _uid = uid;
    _avater = avater;
    _num = num;
    _date = date;
}

  Result.fromJson(dynamic json) {
    _panid = json['panid'];
    _name = json['name'];
    _url = json['url'];
    _width = json['width'];
    _height = json['height'];
    _nickname = json['nickname'];
    _username = json['username'];
    _uid = json['uid'];
    _avater = json['avater'];
    _num = json['num'];
    _date = json['date'];
  }
  String _panid;
  String _name;
  dynamic _url;
  dynamic _width;
  dynamic _height;
  dynamic _nickname;
  String _username;
  String _uid;
  String _avater;
  String _date;
  int _num;

  String get panid => _panid;
  String get name => _name;
  dynamic get url => _url;
  dynamic get width => _width;
  dynamic get height => _height;
  dynamic get nickname => _nickname;
  String get username => _username;
  String get uid => _uid;
  String get avater => _avater;
  int get num => _num;
  String get date => _date;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['panid'] = _panid;
    map['name'] = _name;
    map['url'] = _url;
    map['width'] = _width;
    map['height'] = _height;
    map['nickname'] = _nickname;
    map['username'] = _username;
    map['uid'] = _uid;
    map['avater'] = _avater;
    map['num'] = _num;
    map['date'] = _date;
    return map;
  }

}