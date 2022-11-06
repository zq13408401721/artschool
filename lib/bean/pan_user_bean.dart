class PanUserBean {
  PanUserBean({
      int errno, 
      String errmsg, 
      List<Data> data,}){
    _errno = errno;
    _errmsg = errmsg;
    _data = data;
}

  PanUserBean.fromJson(dynamic json) {
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
      String panid, 
      String name, 
      String date, 
      String uid, 
      int classifyid, 
      int state, 
      String schoolid, 
      int visible, 
      int isself, 
      String topdate, 
      int top, 
      String imagename, 
      String url, 
      dynamic width, 
      dynamic height, 
      int imagenum,
      String avater,
      String nickname,
      String username,
      int role,}){
    _id = id;
    _panid = panid;
    _name = name;
    _date = date;
    _uid = uid;
    _classifyid = classifyid;
    _state = state;
    _schoolid = schoolid;
    _visible = visible;
    _isself = isself;
    _topdate = topdate;
    _top = top;
    _imagename = imagename;
    _url = url;
    _width = width;
    _height = height;
    _imagenum = imagenum;
    _avater = avater;
    _username = username;
    _nickname = nickname;
    _role = role;
}

  Data.fromJson(dynamic json) {
    _id = json['id'];
    _panid = json['panid'];
    _name = json['name'];
    _date = json['date'];
    _uid = json['uid'];
    _classifyid = json['classifyid'];
    _state = json['state'];
    _schoolid = json['schoolid'];
    _visible = json['visible'];
    _isself = json['isself'];
    _topdate = json['topdate'];
    _top = json['top'];
    _imagename = json['imagename'];
    _url = json['url'];
    _width = json['width'];
    _height = json['height'];
    _imagenum = json['imagenum'];
    _avater = json['avater'];
    _username = json['username'];
    _nickname = json['nickname'];
    _role = json['role'];
  }
  int _id;
  String _panid;
  String _name;
  String _date;
  String _uid;
  int _classifyid;
  int _state;
  String _schoolid;
  int _visible;
  int _isself;
  String _topdate;
  int _top;
  String _imagename;
  String _url;
  dynamic _width;
  dynamic _height;
  int _imagenum;
  String _avater;
  String _nickname;
  String _username;
  int _role;

  int get id => _id;
  String get panid => _panid;
  String get name => _name;
  String get date => _date;
  String get uid => _uid;
  int get classifyid => _classifyid;
  int get state => _state;
  String get schoolid => _schoolid;
  int get visible => _visible;
  int get isself => _isself;
  String get topdate => _topdate;
  int get top => _top;
  String get imagename => _imagename;
  String get url => _url;
  dynamic get width => _width;
  dynamic get height => _height;
  int get imagenum => _imagenum;
  String get avater => _avater;
  String get nickname => _nickname;
  String get username => _username;
  int get role => _role;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['panid'] = _panid;
    map['name'] = _name;
    map['date'] = _date;
    map['uid'] = _uid;
    map['classifyid'] = _classifyid;
    map['state'] = _state;
    map['schoolid'] = _schoolid;
    map['visible'] = _visible;
    map['isself'] = _isself;
    map['topdate'] = _topdate;
    map['top'] = _top;
    map['imagename'] = _imagename;
    map['url'] = _url;
    map['width'] = _width;
    map['height'] = _height;
    map['imagenum'] = _imagenum;
    map['avater'] = _avater;
    map['username'] = _username;
    map['nickname'] = _nickname;
    map['role'] = _role;
    return map;
  }

}