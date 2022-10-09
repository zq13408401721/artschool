class UserSearch {
  UserSearch({
      int errno, 
      String errmsg, 
      Data data,}){
    _errno = errno;
    _errmsg = errmsg;
    _data = data;
}

  UserSearch.fromJson(dynamic json) {
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
      String username, 
      dynamic nickname, 
      dynamic avater, 
      int role, 
      int follow, 
      int fansnum,}){
    _username = username;
    _nickname = nickname;
    _avater = avater;
    _role = role;
    _follow = follow;
    _fansnum = fansnum;
}

  Result.fromJson(dynamic json) {
    _username = json['username'];
    _nickname = json['nickname'];
    _avater = json['avater'];
    _role = json['role'];
    _follow = json['follow'];
    _fansnum = json['fansnum'];
  }
  String _username;
  dynamic _nickname;
  dynamic _avater;
  int _role;
  int _follow;
  int _fansnum;

  String get username => _username;
  dynamic get nickname => _nickname;
  dynamic get avater => _avater;
  int get role => _role;
  int get follow => _follow;
  int get fansnum => _fansnum;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['username'] = _username;
    map['nickname'] = _nickname;
    map['avater'] = _avater;
    map['role'] = _role;
    map['follow'] = _follow;
    map['fansnum'] = _fansnum;
    return map;
  }

}