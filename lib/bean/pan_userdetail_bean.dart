class PanUserdetailBean {
  PanUserdetailBean({
      int errno, 
      String errmsg, 
      List<Data> data,}){
    _errno = errno;
    _errmsg = errmsg;
    _data = data;
}

  PanUserdetailBean.fromJson(dynamic json) {
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
      int pannum, 
      int imagenum, 
      int likenum, 
      int follownum, 
      int fansnum, 
      String username, 
      dynamic nickname, 
      int role, 
      dynamic avater, 
      int isfollow, 
      List<Classes> classes,}){
    _pannum = pannum;
    _imagenum = imagenum;
    _likenum = likenum;
    _follownum = follownum;
    _fansnum = fansnum;
    _username = username;
    _nickname = nickname;
    _role = role;
    _avater = avater;
    _isfollow = isfollow;
    _classes = classes;
}

  Data.fromJson(dynamic json) {
    _pannum = json['pannum'];
    _imagenum = json['imagenum'];
    _likenum = json['likenum'];
    _follownum = json['follownum'];
    _fansnum = json['fansnum'];
    _username = json['username'];
    _nickname = json['nickname'];
    _role = json['role'];
    _avater = json['avater'];
    _isfollow = json['isfollow'];
    if (json['classes'] != null) {
      _classes = [];
      json['classes'].forEach((v) {
        _classes.add(Classes.fromJson(v));
      });
    }
  }
  int _pannum;
  int _imagenum;
  int _likenum;
  int _follownum;
  int _fansnum;
  String _username;
  dynamic _nickname;
  int _role;
  dynamic _avater;
  int _isfollow;
  List<Classes> _classes;

  int get pannum => _pannum;
  int get imagenum => _imagenum;
  int get likenum => _likenum;
  int get follownum => _follownum;
  int get fansnum => _fansnum;
  String get username => _username;
  dynamic get nickname => _nickname;
  int get role => _role;
  dynamic get avater => _avater;
  int get isfollow => _isfollow;
  void set isfollow(value){
    _isfollow = value;
  }
  List<Classes> get classes => _classes;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['pannum'] = _pannum;
    map['imagenum'] = _imagenum;
    map['likenum'] = _likenum;
    map['follownum'] = _follownum;
    map['fansnum'] = _fansnum;
    map['username'] = _username;
    map['nickname'] = _nickname;
    map['role'] = _role;
    map['avater'] = _avater;
    map['isfollow'] = _isfollow;
    if (_classes != null) {
      map['classes'] = _classes.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class Classes {
  Classes({
      int id, 
      String name, 
      String date, 
      int maxnum,}){
    _id = id;
    _name = name;
    _date = date;
    _maxnum = maxnum;
}

  Classes.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _date = json['date'];
    _maxnum = json['maxnum'];
  }
  int _id;
  String _name;
  String _date;
  int _maxnum;

  int get id => _id;
  String get name => _name;
  String get date => _date;
  int get maxnum => _maxnum;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['date'] = _date;
    map['maxnum'] = _maxnum;
    return map;
  }

}