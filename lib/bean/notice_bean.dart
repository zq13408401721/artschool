/// errno : 0
/// errmsg : ""
/// data : {"id":6,"uid":"b4e4909f-6cf3-497e-981b-13449e438ea3","schoolid":"1372445644860735500","title":"guanyu1","createtime":"2021-10-15 09:16:05","content":"guanyufangjiatongzhi11"}

class NoticeBean {
  int _errno;
  String _errmsg;
  Data _data;

  int get errno => _errno;
  String get errmsg => _errmsg;
  Data get data => _data;

  NoticeBean({
      int errno, 
      String errmsg, 
      Data data}){
    _errno = errno;
    _errmsg = errmsg;
    _data = data;
}

  NoticeBean.fromJson(dynamic json) {
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

/// id : 6
/// uid : "b4e4909f-6cf3-497e-981b-13449e438ea3"
/// schoolid : "1372445644860735500"
/// title : "guanyu1"
/// createtime : "2021-10-15 09:16:05"
/// content : "guanyufangjiatongzhi11"

class Data {
  int _id;
  String _uid;
  String _schoolid;
  String _title;
  String _createtime;
  String _content;
  String _username;
  String _nickname;

  int get id => _id;
  String get uid => _uid;
  String get schoolid => _schoolid;
  String get title => _title;
  String get createtime => _createtime;
  String get content => _content;
  String get username => _username;
  String get nickname => _nickname;

  Data({
      int id, 
      String uid, 
      String schoolid, 
      String title, 
      String createtime, 
      String content,
      String username,
      String nickname}){
    _id = id;
    _uid = uid;
    _schoolid = schoolid;
    _title = title;
    _createtime = createtime;
    _content = content;
    _username = username;
    _nickname = nickname;
  }

  Data.fromJson(dynamic json) {
    _id = json['id'];
    _uid = json['uid'];
    _schoolid = json['schoolid'];
    _title = json['title'];
    _createtime = json['createtime'];
    _content = json['content'];
    _username = json['username'];
    _nickname = json['nickname'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['id'] = _id;
    map['uid'] = _uid;
    map['schoolid'] = _schoolid;
    map['title'] = _title;
    map['createtime'] = _createtime;
    map['content'] = _content;
    map['username'] = _username;
    map['nickname'] = _nickname;
    return map;
  }

}