/// errno : 0
/// errmsg : ""
/// data : [{"id":19,"uid":"e82cf39e-dfa1-45db-90dc-f5a6035a3b15","createtime":"2021-10-13 21:59:25","url":"http://res.yimios.com:9050/work/3/e82cf39e-dfa1-45db-90dc-f5a6035a3b15/IMG_0065(1)(1).JPG","correct":"http://res.yimios.com:9050/work/correct/3/e82cf39e-dfa1-45db-90dc-f5a6035a3b15/IMG_0065(1)(1)_correct(1).png","grade":0,"dateid":4,"width":344,"height":270,"name":"IMG_0065(1)(1)","maxwidth":1379,"maxheight":1080,"correct_uid":"b4e4909f-6cf3-497e-981b-13449e438ea3","correct_time":"2021-10-14 09:04:00","username":"test00014","nickname":"李老师"},{"id":20,"uid":"e82cf39e-dfa1-45db-90dc-f5a6035a3b15","createtime":"2021-10-13 22:08:58","url":"http://res.yimios.com:9050/work/3/e82cf39e-dfa1-45db-90dc-f5a6035a3b15/IMG_0046(1)(1).JPG","correct":null,"grade":0,"dateid":4,"width":360,"height":544,"name":"IMG_0046(1)(1)","maxwidth":720,"maxheight":1088,"correct_uid":null,"correct_time":null,"username":"test00014","nickname":"李老师"},{"id":21,"uid":"e82cf39e-dfa1-45db-90dc-f5a6035a3b15","createtime":"2021-10-14 09:42:38","url":"http://res.yimios.com:9050/work/3/e82cf39e-dfa1-45db-90dc-f5a6035a3b15/IMG_0004.JPG","correct":"http://res.yimios.com:9050/work/correct/3/e82cf39e-dfa1-45db-90dc-f5a6035a3b15/IMG_0004_correct(1).png","grade":0,"dateid":5,"width":333,"height":500,"name":"IMG_0004","maxwidth":1335,"maxheight":2000,"correct_uid":"e82cf39e-dfa1-45db-90dc-f5a6035a3b15","correct_time":"2021-10-14 09:51:03","username":"test00014","nickname":"李老师"}]

class MyWorkBean {
  int _errno;
  String _errmsg;
  List<Data> _data;

  int get errno => _errno;
  String get errmsg => _errmsg;
  List<Data> get data => _data;

  MyWorkBean({
      int errno, 
      String errmsg, 
      List<Data> data}){
    _errno = errno;
    _errmsg = errmsg;
    _data = data;
}

  MyWorkBean.fromJson(dynamic json) {
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

/// id : 19
/// uid : "e82cf39e-dfa1-45db-90dc-f5a6035a3b15"
/// createtime : "2021-10-13 21:59:25"
/// url : "http://res.yimios.com:9050/work/3/e82cf39e-dfa1-45db-90dc-f5a6035a3b15/IMG_0065(1)(1).JPG"
/// correct : "http://res.yimios.com:9050/work/correct/3/e82cf39e-dfa1-45db-90dc-f5a6035a3b15/IMG_0065(1)(1)_correct(1).png"
/// grade : 0
/// dateid : 4
/// width : 344
/// height : 270
/// name : "IMG_0065(1)(1)"
/// maxwidth : 1379
/// maxheight : 1080
/// correct_uid : "b4e4909f-6cf3-497e-981b-13449e438ea3"
/// correct_time : "2021-10-14 09:04:00"
/// username : "test00014"
/// nickname : "李老师"

class Data {
  int _id;
  String _uid;
  String _createtime;
  String _url;
  String _correct;
  int _grade;
  int _dateid;
  int _width;
  int _height;
  String _name;
  int _maxwidth;
  int _maxheight;
  String _correctUid;
  String _correctTime;
  String _username;
  String _nickname;

  int get id => _id;
  String get uid => _uid;
  String get createtime => _createtime;
  String get url => _url;
  String get correct => _correct;
  int get grade => _grade;
  int get dateid => _dateid;
  int get width => _width;
  int get height => _height;
  String get name => _name;
  int get maxwidth => _maxwidth;
  int get maxheight => _maxheight;
  String get correctUid => _correctUid;
  String get correctTime => _correctTime;
  String get username => _username;
  String get nickname => _nickname;

  Data({
      int id, 
      String uid, 
      String createtime, 
      String url, 
      String correct, 
      int grade, 
      int dateid, 
      int width, 
      int height, 
      String name, 
      int maxwidth, 
      int maxheight, 
      String correctUid, 
      String correctTime, 
      String username, 
      String nickname}){
    _id = id;
    _uid = uid;
    _createtime = createtime;
    _url = url;
    _correct = correct;
    _grade = grade;
    _dateid = dateid;
    _width = width;
    _height = height;
    _name = name;
    _maxwidth = maxwidth;
    _maxheight = maxheight;
    _correctUid = correctUid;
    _correctTime = correctTime;
    _username = username;
    _nickname = nickname;
}

  Data.fromJson(dynamic json) {
    _id = json['id'];
    _uid = json['uid'];
    _createtime = json['createtime'];
    _url = json['url'];
    _correct = json['correct'];
    _grade = json['grade'];
    _dateid = json['dateid'];
    _width = json['width'];
    _height = json['height'];
    _name = json['name'];
    _maxwidth = json['maxwidth'];
    _maxheight = json['maxheight'];
    _correctUid = json['correct_uid'];
    _correctTime = json['correct_time'];
    _username = json['username'];
    _nickname = json['nickname'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['id'] = _id;
    map['uid'] = _uid;
    map['createtime'] = _createtime;
    map['url'] = _url;
    map['correct'] = _correct;
    map['grade'] = _grade;
    map['dateid'] = _dateid;
    map['width'] = _width;
    map['height'] = _height;
    map['name'] = _name;
    map['maxwidth'] = _maxwidth;
    map['maxheight'] = _maxheight;
    map['correct_uid'] = _correctUid;
    map['correct_time'] = _correctTime;
    map['username'] = _username;
    map['nickname'] = _nickname;
    return map;
  }

}