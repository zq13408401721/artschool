class PanListBean {
  PanListBean({
      num errno, 
      String errmsg, 
      List<Data> data,}){
    _errno = errno;
    _errmsg = errmsg;
    _data = data;
}

  PanListBean.fromJson(dynamic json) {
    _errno = json['errno'];
    _errmsg = json['errmsg'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data.add(Data.fromJson(v));
      });
    }
  }
  num _errno;
  String _errmsg;
  List<Data> _data;

  num get errno => _errno;
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
      num id, 
      String panid, 
      String name, 
      String date, 
      String uid, 
      num classifyid, 
      num state, 
      String schoolid, 
      num visible, 
      num isself,
      num top,
      int fileid,
      String imagename, 
      String url, 
      num width, 
      num height,
      String username,
      String nickname,
      String avater,
      num imagenum,
      num role,}){
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
    _top = top;
    _fileid = fileid;
    _imagename = imagename;
    _url = url;
    _width = width;
    _height = height;
    _imagenum = imagenum;
    _username = username;
    _nickname = nickname;
    _avater = avater;
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
    _top = json['top'];
    _fileid = json['fileid'];
    _imagename = json['imagename'];
    _url = json['url'];
    _width = json['width'];
    _height = json['height'];
    _imagenum = json['imagenum'];
    _username = json['username'];
    _nickname = json['nickname'];
    _avater = json['avater'];
    _role = json['role'];

  }
  num _id;
  String _panid;
  String _name;
  String _date;
  String _uid;
  num _classifyid;
  num _state;
  String _schoolid;
  num _visible;
  num _isself;
  num _top;
  int _fileid;
  String _imagename;
  String _url;
  num _width;
  num _height;
  num _imagenum;
  String _username;
  String _nickname;
  String _avater;
  int _role;

  num get id => _id;
  String get panid => _panid;
  String get name => _name;
  String get date => _date;
  String get uid => _uid;
  num get classifyid => _classifyid;
  num get state => _state;
  String get schoolid => _schoolid;
  num get visible => _visible;
  num get isself => _isself;
  num get top => _top;
  void set top(int value){
    _top = value;
  }
  int get fileid => _fileid;
  String get imagename => _imagename;
  String get url => _url;
  num get width => _width;
  num get height => _height;
  num get imagenum => _imagenum;
  void set imagenum(int value){
    _imagenum = value;
  }
  String get username => _username;
  String get nickname => _nickname;
  String get avater => _avater;
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
    map['fileid'] = _fileid;
    map['imagename'] = _imagename;
    map['url'] = _url;
    map['width'] = _width;
    map['height'] = _height;
    map['imagenum'] = _imagenum;
    map['username'] = _username;
    map['nickname'] = _nickname;
    map['avater'] = _avater;
    map['role'] = _role;
    return map;
  }

}