class UserFansBean {
  UserFansBean({
      int errno, 
      String errmsg, 
      List<Data> data,}){
    _errno = errno;
    _errmsg = errmsg;
    _data = data;
}

  UserFansBean.fromJson(dynamic json) {
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
      String username, 
      String nickname, 
      String avater, 
      int num,
      String uid,
      int role,}){
    _username = username;
    _nickname = nickname;
    _avater = avater;
    _num = num;
    _uid = uid;
    _role = role;
}

  Data.fromJson(dynamic json) {
    _username = json['username'];
    _nickname = json['nickname'];
    _avater = json['avater'];
    _num = json['num'];
    _uid = json['uid'];
    _role = json['role'];
  }
  String _username;
  String _nickname;
  String _avater;
  int _num;
  String _uid;
  int _role;

  String get username => _username;
  String get nickname => _nickname;
  String get avater => _avater;
  int get num => _num;
  String get uid => _uid;
  int get role => _role;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['username'] = _username;
    map['nickname'] = _nickname;
    map['avater'] = _avater;
    map['num'] = _num;
    map['uid'] = _uid;
    map['role'] = _role;
    return map;
  }

}